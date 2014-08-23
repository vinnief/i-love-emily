;;; λ - Code that has been translated to Haskell already

                   ;;;;;COMPUTER MODELS OF MUSICAL CREATIVITY;;;;;
                   ;;;;;            By David Cope            ;;;;;
                   ;;;;;     Chorale Function/Chapter 4      ;;;;;
                   ;;;;;             COMMON LISP             ;;;;;
                   ;;;;;           platform dependent        ;;;;;
                   ;;;;;          code to run chorale        ;;;;;
                   ;;;;;               function              ;;;;;
                   ;;;;;COMPUTER MODELS OF MUSICAL CREATIVITY;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:: Mutable variables
;; λ - Most of them are actually local variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defVar *RULES-STORAGE* ()) ; local variable for GET-RULES recursive call

(defVar DAVIDCOPE ())       ; local variable for splash page
(defVar COPE-TEXT ())
(defVar DAVIDCOPE1 ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:: Splash window
;; λ - no need to translate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defClass ALL-ABOUT-WINDOW (window)
  nil
  (:default-initargs :window-type :double-edge-box 
    :window-title "Chorale"
    :view-position #@(40 40)
    :view-size #@(300 180)
    :close-box-p ()
    :auto-position :centermainscreen))

;;;; λ - splash window
(defMethod INITIALIZE-INSTANCE ((window ALL-ABOUT-WINDOW) &rest initargs)
  (apply #'call-next-method window initargs)
  (add-subviews window 
    (setq davidcope (make-instance 'static-text-dialog-item
                      :dialog-item-text "Chorale"
                      :view-position '#@(77 26)
                      :view-size #@(322 54)
                      :view-font '("times" 46)))
    (setq davidcope (make-instance 'static-text-dialog-item
                      :dialog-item-text "Please be patient."
                      :view-position '#@(97 76)
                      :view-size #@(322 54)
                      :view-font '("times" 16)))
    (setq davidcope1 (make-instance 'static-text-dialog-item
                       :dialog-item-text "Lots of data must be loaded."
                       :view-position '#@(62 96)
                       :view-size #@(322 54)
                       :view-font '("times" 16)))
    (setq Cope-text (make-instance 'static-text-dialog-item
                      :dialog-item-text "© David Cope 1992 -"
                      :view-position '#@(80 140)
                      :view-size #@(334 54)
                      :view-font '("times" 16 :bold))))
  (set-part-color davidcope :text *red-color*)
  (set-part-color davidcope1 :text *red-color*)
  (set-part-color Cope-text :text *dark-green-color*))

(defVar *ABOUT-WINDOW* (make-instance 'ALL-ABOUT-WINDOW))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:: Building database from pieces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;
#| Calling (set-to-zero ((31000 60 1000 4 96) (31000 67 1000 3 96) (31000 72 1000 2 96) (31000 76 1000 1 96))) 
 set-to-zero returned ((0 60 1000 4 96) (0 67 1000 3 96) (0 72 1000 2 96) (0 76 1000 1 96))|#
;;;;;

(defun SET-TO-ZERO (events &optional (subtract (very-first events)))
  "Sets the events to zero."
  (if (null events)()
      (cons (cons (- (very-first events) subtract)
                  (rest (first events)))
            (set-to-zero (rest events) subtract))))

;;;;;
#| Calling (thousandp 5000) 
 thousandp returned t|#
;;;;;

(defun THOUSANDP (number)
  "Returns the number under 1000."
  (if (zerop (mod number 1000)) t))

;;;;;
#|  Calling (GET-RULES1 (57 60 69 76) (59 62 67 79) B206B-1) 
  GET-RULES1 returned ((3 2 2 B206B-1) (12 2 -2 B206B-1) (7 2 3 B206B-1) (9 2 -2 B206B-1) (4 2 3 B206B-1) (7 -2 3 B206B-1))|#
;;;;;

(defun GET-RULES1 (start-notes destination-notes name)
  "Does the grunt work for get-rules."
  (if (or (null (rest start-notes))(null (rest destination-notes)))
    (reverse *rules-storage*)
    (progn
      (setq *rules-storage* (append (reverse (get-rule (- (first destination-notes) (first start-notes)) 
                                                       (first start-notes) start-notes destination-notes name)) *rules-storage*))
      (get-rules1 (rest start-notes) (rest destination-notes) name))))

;;;;;
#|   Calling (GET-RULE 2 57 (57 60 69 76) (59 62 67 79) B206B-1) 
   GET-RULE returned ((7 -2 3 B206B-1))|#
;;;;;
; λ - The comment seems to be wrong, it only displays the last rule.

(defun GET-RULE (voice start-note start-notes destination-notes name)
  "Gets the rule between first two args."
  (if (or (null (rest start-notes))(null destination-notes))()
      (cons (list (reduce-interval (- (second start-notes) start-note))
                  voice
                  (- (second destination-notes) (second start-notes))
                  name)
            (get-rule voice start-note (rest start-notes)(rest destination-notes) name))))

;;;;;
#|  Calling (MAKE-LISTS-EQUAL ((57 60 69 76) (59 62 67 79))) 
  MAKE-LISTS-EQUAL returned ((57 60 69 76) (59 62 67 79))|#
;;;;;

(defun MAKE-LISTS-EQUAL (lists)
  "Ensures the two lists are equal in length."
  (cond ((> (length (first lists))(length (second lists)))
         (list (firstn (length (second lists)) (first lists))(second lists)))
        ((> (length (second lists))(length (first lists)))
         (list (first lists)(firstn (length (first lists)) (second lists))))
        (t lists)))

;;;;;
#|Calling (REDUCE-INTERVAL 3) 
    REDUCE-INTERVAL returned 3|#
;;;;;

(defun REDUCE-INTERVAL (interval)
  "Reduces the interval mod 12."
  (cond ((<= (abs interval) 12) interval)
        ((minusp interval)(reduce-interval (+ interval 12)))
        (t (reduce-interval (- interval 12)))))

;;;;;
#| Calling (GET-ONSET-NOTES ((0 57 1000 4 96) (0 60 1000 3 96) (0 69 1000 2 96) (0 76 1000 1 96))) 
 GET-ONSET-NOTES returned (57 60 69 76)|#
;;;;;

(defun GET-ONSET-NOTES (events)
  "Gets the onset pitches for its arg."
  (let ((onbeat (very-first events)))
    (loop for event in events
          if (equal (first event) onbeat)
          collect (second event))))


;;;;;;;
#|  Calling (COLLECT-BEATS ((0 57 1000 4 96) (0 60 1000 3 96) . . .
 COLLECT-BEATS returned (((0 57 1000 4 96) (0 60 1000 3 96)  . . .|#
;;;;;;;

(defun COLLECT-BEATS (events)
  "(collect-beats (sortcar #'< b4003))"
  (if (null events)()
      (let* ((test (collect-by-timing (first-place-where-all-together events) events))
             (reduced-test (nthcdr (length test) events)))
        (cons test 
              (collect-beats reduced-test)))))

;;;;;
#|  Calling (COLLECT-BY-TIMING 1000 ((0 57 1000 4 96) (0 60 1000 3 96) . . .
  COLLECT-BY-TIMING returned ((0 57 1000 4 96) (0 60 1000 3 96) (0 69 1000 2 96) (0 76 1000 1 96))|#
;;;;;

(defun COLLECT-BY-TIMING (timing events)
  "Collects the events accoring to timing."
  (cond ((null events)())
        ((<= (+ (first (first events))(fourth (first events))) timing)
         (cons (first events)
               (collect-by-timing timing (rest events))))
        (t (collect-by-timing timing (rest events)))))

;;;;;
#|  Calling (FIRST-PLACE-WHERE-ALL-TOGETHER ((0 57 1000 4 96) (0 60 1000 3 96) (0 69 1000 2 96) . . .
FIRST-PLACE-WHERE-ALL-TOGETHER returned 1000|#
;;;;;
; 
; λ -
; It appears that this function looks at the first notes of a piece and
; returns the time on which all channels end simultaneously.
; This time has to be on the beat, i.e. it must be a multiple of 1000.
;

(defun FIRST-PLACE-WHERE-ALL-TOGETHER (events)
  "This looks ahead to get the first time they end together"
  (let* ((test (plot-timings events))
         
         (channels (get-channel-numbers-from-events events))
         
         (ordered-timings-by-channel (loop for channel in channels 
                                           collect (collect-timings-by-channel test channel))))
    
    (all-together (first ordered-timings-by-channel)
                  (rest ordered-timings-by-channel))))

;;;;;
#|   Calling (ALL-TOGETHER ((1 1000) (1 2000) (1 2500) (1 3000) . . .
   ALL-TOGETHER returned 1000|#
;;;;;

(defun ALL-TOGETHER (channel channels)
  "Returns the appropriate channel timing."
  (cond ((null channel) (second (my-last (my-last channels)))) ;;; here is our remaining problem!!!!!
        ((find-alignment-in-all-channels (second (first channel)) channels) )
        (t (all-together (rest channel) channels))))

;;;;;
#|    Calling (FIND-ALIGNMENT-IN-ALL-CHANNELS 1000 (((2 1000) (2 2000) (2 2500) . . .
FIND-ALIGNMENT-IN-ALL-CHANNELS returned 1000|#
;;;;;

(defun FIND-ALIGNMENT-IN-ALL-CHANNELS (point channels)
  "run this on the channels of the channel-point-lists"
  (cond ((null channels) point)
        ((null point) point)
        ((find-alignment point (first channels))
         (find-alignment-in-all-channels point (rest channels)))
        (t ())
        ))

;;;;;
#|     Calling (FIND-ALIGNMENT 1000 ((2 1000) (2 2000) (2 2500) (2 3000) (2 3500) (2 4000) (2 4 . . .
     FIND-ALIGNMENT returned T|#
;;;;;

(defun FIND-ALIGNMENT (point channel)
  "? (find-alignment 1000 '((4 1000) (4 1000) (4 5000)))
   t this finds the timing point in the channel"
  (cond ((null channel)())
        ((and (thousandp point)
              (assoc point (mapcar #'reverse channel) :test #'equal))
         t)
        (t (find-alignment point (rest channel)))))

;;;;;
#|   Calling (GET-CHANNEL-NUMBERS-FROM-EVENTS ((0 57 1000 4 96) (0 60 1000 3 96) . . .
GET-CHANNEL-NUMBERS-FROM-EVENTS returned (1 2 3 4)|#
;;;;;

(defun GET-CHANNEL-NUMBERS-FROM-EVENTS (events &optional (channels ()))
  "simply gets the channel numbers from the music"
  (cond ((null events) channels)
        ((not (member (fourth (first events)) channels :test #'equal))
         (get-channel-numbers-from-events (rest events) (cons (fourth (first events)) channels)))
        (t (get-channel-numbers-from-events (rest events) channels))))

;;;;;
#|Calling (COLLECT-TIMINGS-BY-CHANNEL ((4 1000) (3 1000) (2 1000)  . . .
   COLLECT-TIMINGS-BY-CHANNEL returned ((1 1000) (1 2000) (1 2500) (1 3000) (1 3500) (1 4000) . . .|#
;;;;;

(defun COLLECT-TIMINGS-BY-CHANNEL (timings channel)
  "collects the timings of the channel indicated in second arg"
  (cond ((null timings)())
        ((equal (very-first timings) channel)
         (cons (first timings)
               (collect-timings-by-channel (rest timings) channel)))
        (t (collect-timings-by-channel (rest timings) channel))))

;;;;;
#| Calling (PLOT-TIMINGS ((0 57 1000 4 96) (0 60 1000 3 96)  . . .
PLOT-TIMINGS returned ((4 1000) (3 1000) (2 1000) (1 1000) . . .|#
;;;;;

(defun PLOT-TIMINGS (events)
  "Plots out the times of each beat."
  (if (null events)()
      (cons (list (fourth (first events))(+ (very-first events)(third (first events))))
            (plot-timings (rest events)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:: Close splash window
;; λ - no need to translate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-menu-items *apple-menu* 
                (make-instance 'menu-item 
                  :menu-item-title "About Chorale..." 
                  :menu-item-action 
                  #'(lambda nil (make-instance 'all-about-window)
                                        ))
                (make-instance 'menu-item 
                  :menu-item-title "-"
                  :menu-item-action 
                  #'(lambda nil)))

(window-close *about-window*)