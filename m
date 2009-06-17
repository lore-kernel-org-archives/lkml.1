Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZFQRQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZFQRQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZFQRQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:16:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45310 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZFQRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:16:14 -0400
Date: Wed, 17 Jun 2009 19:16:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>,
       Arve Hj??nnev??g <arve@google.com>
Subject: HTC Dream keymap (was Re: HTC Dream aka. t-mobile g1 support)
Message-ID: <20090617171605.GC11590@elf.ucw.cz>
References: <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com> <20090615170103.GE25040@elf.ucw.cz> <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com> <20090617091139.GA4536@elf.ucw.cz> <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906170240w631cdfbfq52647d1c438647cb@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > One more question... do you have keymap.map to make console usable? By
> > default, keyboard lacks any special characters...
> 
> I don't think we ever put together a full keymap for the console,
> since we don't use it much.  Arve might have done something with
> setkey once upon a time.

Maybe not "full", but very usable. F1..F10 are missing, but there's
still place where to map them.

---

Keymap suitable for HTC Dream.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
commit abde64fc50078f6b5fa3773c652eef8d3079225f
tree d2fe81626af1922cff8a924e7e5aa193d817fd7e
parent a7571e0d1492573d67a999efb9acf30781a471e8
author Pavel <pavel@ucw.cz> Wed, 17 Jun 2009 19:15:29 +0200
committer Pavel <pavel@ucw.cz> Wed, 17 Jun 2009 19:15:29 +0200

 drivers/char/Makefile      |    2 
 drivers/char/defkeymap.map |  381 +++++++++++++++++++++++++-------------------
 2 files changed, 214 insertions(+), 169 deletions(-)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 5ab656b..1bcbd9e 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -126,7 +126,7 @@ $(obj)/defkeymap.o:  $(obj)/defkeymap.c
 # Uncomment if you're changing the keymap and have an appropriate
 # loadkeys version for the map. By default, we'll use the shipped
 # versions.
-# GENERATE_KEYMAP := 1
+GENERATE_KEYMAP := 1
 
 ifdef GENERATE_KEYMAP
 
diff --git a/drivers/char/defkeymap.map b/drivers/char/defkeymap.map
index 50b30ca..a89bcfd 100644
--- a/drivers/char/defkeymap.map
+++ b/drivers/char/defkeymap.map
@@ -1,7 +1,6 @@
 # Default kernel keymap. This uses 7 modifier combinations.
-keymaps 0-2,4-5,8,12
-# Change the above line into
-#	keymaps 0-2,4-6,8,12
+keymaps 0-2,4-6,8,12
+#
 # in case you want the entries
 #	altgr   control keycode  83 = Boot            
 #	altgr   control keycode 111 = Boot            
@@ -11,8 +10,26 @@ keymaps 0-2,4-5,8,12
 # be saved by mapping AltGr to Alt (and adapting a few entries):
 # keycode 100 = Alt
 #
-keycode   1 = Escape           Escape          
-	alt     keycode   1 = Meta_Escape     
+
+# Keymap for HTC Dream
+# Pavel Machek <pavel@ucw.cz>
+#
+# What is labeled "alt" on device is AltGr in keymap.
+# Button with search icon and home button near ball serve as Alt.
+# Both menu buttons should serve as control.
+# "alt" + azxc serve as arrow keys.
+#
+# Menu near left shift is F1, ouch.
+#
+# Special keys are mapped like this:
+#			139 - ctrl
+#			  [menu]
+#    [green]      [home]     o	   [back]	[red]
+#	231	 102 - alt	     158	 107
+
+
+#keycode   1 = Escape           Escape          
+#	alt     keycode   1 = Meta_Escape     
 keycode   2 = one              exclam          
 	alt     keycode   2 = Meta_one        
 keycode   3 = two              at               at              
@@ -41,177 +58,196 @@ keycode  10 = nine             parenleft        bracketright
 	alt     keycode  10 = Meta_nine       
 keycode  11 = zero             parenright       braceright      
 	alt     keycode  11 = Meta_zero       
-keycode  12 = minus            underscore       backslash       
-	control	keycode  12 = Control_underscore
-	shift	control	keycode  12 = Control_underscore
-	alt	keycode  12 = Meta_minus      
-keycode  13 = equal            plus            
-	alt     keycode  13 = Meta_equal      
+#keycode  12 = minus            underscore       backslash       
+#	control	keycode  12 = Control_underscore
+#	shift	control	keycode  12 = Control_underscore
+#	alt	keycode  12 = Meta_minus      
+#keycode  13 = equal            plus            
+#	alt     keycode  13 = Meta_equal      
 keycode  14 = Delete           Delete          
 	control keycode  14 = BackSpace
 	alt     keycode  14 = Meta_Delete     
-keycode  15 = Tab              Tab             
-	alt     keycode  15 = Meta_Tab        
+#keycode  15 = Tab              Tab             
+#	alt     keycode  15 = Meta_Tab        
 keycode  16 = q               
+	altgr	keycode	 16 = Tab
 keycode  17 = w               
+	altgr	keycode	 17 = grave
 keycode  18 = e
-	altgr   keycode  18 = Hex_E   
+	altgr   keycode  18 = underscore
 keycode  19 = r               
 keycode  20 = t               
 keycode  21 = y               
 keycode  22 = u               
 keycode  23 = i               
+	altgr   keycode  23 = minus
 keycode  24 = o               
+	altgr   keycode  24 = plus
 keycode  25 = p               
-keycode  26 = bracketleft      braceleft       
-	control keycode  26 = Escape          
-	alt     keycode  26 = Meta_bracketleft
-keycode  27 = bracketright     braceright       asciitilde      
-	control keycode  27 = Control_bracketright
-	alt     keycode  27 = Meta_bracketright
+	altgr   keycode  25 = equal
+#keycode  26 = bracketleft      braceleft       
+#	control keycode  26 = Escape          
+#	alt     keycode  26 = Meta_bracketleft
+#keycode  27 = bracketright     braceright       asciitilde      
+#	control keycode  27 = Control_bracketright
+#	alt     keycode  27 = Meta_bracketright
 keycode  28 = Return          
 	alt     keycode  28 = Meta_Control_m  
-keycode  29 = Control         
+#keycode  29 = Control         
 keycode  30 = a
-	altgr   keycode  30 = Hex_A
+	altgr   keycode  30 = Up
 keycode  31 = s               
+	altgr   keycode  31 = bar
 keycode  32 = d
-	altgr   keycode  32 = Hex_D   
+	altgr   keycode  32 = backslash
 keycode  33 = f
-	altgr   keycode  33 = Hex_F               
+	altgr   keycode  33 = bracketleft               
 keycode  34 = g               
+	altgr   keycode  34 = bracketright               
 keycode  35 = h               
+	altgr   keycode  35 = colon               
 keycode  36 = j               
+	altgr   keycode  36 = semicolon               
 keycode  37 = k               
+	altgr   keycode  37 = quotedbl               
 keycode  38 = l               
-keycode  39 = semicolon        colon           
-	alt     keycode  39 = Meta_semicolon  
-keycode  40 = apostrophe       quotedbl        
-	control keycode  40 = Control_g       
-	alt     keycode  40 = Meta_apostrophe 
-keycode  41 = grave            asciitilde      
-	control keycode  41 = nul             
-	alt     keycode  41 = Meta_grave      
+	altgr   keycode  38 = apostrophe               
+#keycode  39 = semicolon        colon           
+#	alt     keycode  39 = Meta_semicolon  
+#keycode  40 = apostrophe       quotedbl        
+#	control keycode  40 = Control_g       
+#	alt     keycode  40 = Meta_apostrophe 
+#keycode  41 = grave            asciitilde      
+#	control keycode  41 = nul             
+#	alt     keycode  41 = Meta_grave      
 keycode  42 = Shift           
-keycode  43 = backslash        bar             
-	control keycode  43 = Control_backslash
-	alt     keycode  43 = Meta_backslash  
+#keycode  43 = backslash        bar             
+#	control keycode  43 = Control_backslash
+#	alt     keycode  43 = Meta_backslash  
 keycode  44 = z               
+	altgr   keycode  44 = Left               
 keycode  45 = x               
+	altgr   keycode  45 = Down               
 keycode  46 = c
-	altgr   keycode  46 = Hex_C   
+	altgr   keycode  46 = Right
 keycode  47 = v               
+	altgr   keycode  47 = bracketleft
 keycode  48 = b
-	altgr   keycode  48 = Hex_B
+	altgr   keycode  48 = bracketright
 keycode  49 = n               
+	altgr   keycode  49 = less
 keycode  50 = m               
-keycode  51 = comma            less            
+	altgr   keycode  50 = greater
+keycode  51 = comma            
+	altgr	keycode  51 = question
 	alt     keycode  51 = Meta_comma      
-keycode  52 = period           greater         
+keycode  52 = period                    
 	control keycode  52 = Compose         
 	alt     keycode  52 = Meta_period     
-keycode  53 = slash            question        
-	control keycode  53 = Delete          
-	alt     keycode  53 = Meta_slash      
+	altgr	keycode  52 = slash         
+#keycode  53 = slash            question        
+#	control keycode  53 = Delete          
+#	alt     keycode  53 = Meta_slash      
 keycode  54 = Shift           
-keycode  55 = KP_Multiply     
-keycode  56 = Alt             
+#keycode  55 = KP_Multiply     
+keycode  56 = AltGr             
 keycode  57 = space            space           
 	control keycode  57 = nul             
 	alt     keycode  57 = Meta_space      
-keycode  58 = Caps_Lock       
-keycode  59 = F1               F11              Console_13      
-	control keycode  59 = F1              
-	alt     keycode  59 = Console_1       
-	control alt     keycode  59 = Console_1       
-keycode  60 = F2               F12              Console_14      
-	control keycode  60 = F2              
-	alt     keycode  60 = Console_2       
-	control alt     keycode  60 = Console_2       
-keycode  61 = F3               F13              Console_15      
-	control keycode  61 = F3              
-	alt     keycode  61 = Console_3       
-	control alt     keycode  61 = Console_3       
-keycode  62 = F4               F14              Console_16      
-	control keycode  62 = F4              
-	alt     keycode  62 = Console_4       
-	control alt     keycode  62 = Console_4       
-keycode  63 = F5               F15              Console_17      
-	control keycode  63 = F5              
-	alt     keycode  63 = Console_5       
-	control alt     keycode  63 = Console_5       
-keycode  64 = F6               F16              Console_18      
-	control keycode  64 = F6              
-	alt     keycode  64 = Console_6       
-	control alt     keycode  64 = Console_6       
-keycode  65 = F7               F17              Console_19      
-	control keycode  65 = F7              
-	alt     keycode  65 = Console_7       
-	control alt     keycode  65 = Console_7       
-keycode  66 = F8               F18              Console_20      
-	control keycode  66 = F8              
-	alt     keycode  66 = Console_8       
-	control alt     keycode  66 = Console_8       
-keycode  67 = F9               F19              Console_21      
-	control keycode  67 = F9              
-	alt     keycode  67 = Console_9       
-	control alt     keycode  67 = Console_9       
-keycode  68 = F10              F20              Console_22      
-	control keycode  68 = F10             
-	alt     keycode  68 = Console_10      
-	control alt     keycode  68 = Console_10      
-keycode  69 = Num_Lock
-	shift   keycode  69 = Bare_Num_Lock
-keycode  70 = Scroll_Lock      Show_Memory      Show_Registers  
-	control keycode  70 = Show_State      
-	alt     keycode  70 = Scroll_Lock     
-keycode  71 = KP_7            
-	alt     keycode  71 = Ascii_7         
-	altgr   keycode  71 = Hex_7         
-keycode  72 = KP_8            
-	alt     keycode  72 = Ascii_8         
-	altgr   keycode  72 = Hex_8         
-keycode  73 = KP_9            
-	alt     keycode  73 = Ascii_9         
-	altgr   keycode  73 = Hex_9         
-keycode  74 = KP_Subtract     
-keycode  75 = KP_4            
-	alt     keycode  75 = Ascii_4         
-	altgr   keycode  75 = Hex_4         
-keycode  76 = KP_5            
-	alt     keycode  76 = Ascii_5         
-	altgr   keycode  76 = Hex_5         
-keycode  77 = KP_6            
-	alt     keycode  77 = Ascii_6         
-	altgr   keycode  77 = Hex_6         
-keycode  78 = KP_Add          
-keycode  79 = KP_1            
-	alt     keycode  79 = Ascii_1         
-	altgr   keycode  79 = Hex_1         
-keycode  80 = KP_2            
-	alt     keycode  80 = Ascii_2         
-	altgr   keycode  80 = Hex_2         
-keycode  81 = KP_3            
-	alt     keycode  81 = Ascii_3         
-	altgr   keycode  81 = Hex_3         
-keycode  82 = KP_0            
-	alt     keycode  82 = Ascii_0         
-	altgr   keycode  82 = Hex_0         
-keycode  83 = KP_Period       
-#	altgr   control keycode  83 = Boot            
-	control alt     keycode  83 = Boot            
-keycode  84 = Last_Console    
+	altgr	keycode	 59 = Escape
+#keycode  58 = Caps_Lock       
+# menu key near left shift
+keycode  59 = Control
+#	control keycode  59 = F1              
+#	alt     keycode  59 = Console_1       
+#	control alt     keycode  59 = Console_1       
+#keycode  60 = F2               F12              Console_14      
+#	control keycode  60 = F2              
+#	alt     keycode  60 = Console_2       
+#	control alt     keycode  60 = Console_2       
+#keycode  61 = F3               F13              Console_15      
+#	control keycode  61 = F3              
+#	alt     keycode  61 = Console_3       
+#	control alt     keycode  61 = Console_3       
+#keycode  62 = F4               F14              Console_16      
+#	control keycode  62 = F4              
+#	alt     keycode  62 = Console_4       
+#	control alt     keycode  62 = Console_4       
+#keycode  63 = F5               F15              Console_17      
+#	control keycode  63 = F5              
+#	alt     keycode  63 = Console_5       
+#	control alt     keycode  63 = Console_5       
+#keycode  64 = F6               F16              Console_18      
+#	control keycode  64 = F6              
+#	alt     keycode  64 = Console_6       
+#	control alt     keycode  64 = Console_6       
+#keycode  65 = F7               F17              Console_19      
+#	control keycode  65 = F7              
+#	alt     keycode  65 = Console_7       
+#	control alt     keycode  65 = Console_7       
+#keycode  66 = F8               F18              Console_20      
+#	control keycode  66 = F8              
+#	alt     keycode  66 = Console_8       
+#	control alt     keycode  66 = Console_8       
+#keycode  67 = F9               F19              Console_21      
+#	control keycode  67 = F9              
+#	alt     keycode  67 = Console_9       
+#	control alt     keycode  67 = Console_9       
+#keycode  68 = F10              F20              Console_22      
+#	control keycode  68 = F10             
+#	alt     keycode  68 = Console_10      
+#	control alt     keycode  68 = Console_10      
+#keycode  69 = Num_Lock
+#	shift   keycode  69 = Bare_Num_Lock
+#keycode  70 = Scroll_Lock      Show_Memory      Show_Registers  
+#	control keycode  70 = Show_State      
+#	alt     keycode  70 = Scroll_Lock     
+#keycode  71 = KP_7            
+#	alt     keycode  71 = Ascii_7         
+#	altgr   keycode  71 = Hex_7         
+#keycode  72 = KP_8            
+#	alt     keycode  72 = Ascii_8         
+#	altgr   keycode  72 = Hex_8         
+#keycode  73 = KP_9            
+#	alt     keycode  73 = Ascii_9         
+#	altgr   keycode  73 = Hex_9         
+#keycode  74 = KP_Subtract     
+#keycode  75 = KP_4            
+#	alt     keycode  75 = Ascii_4         
+#	altgr   keycode  75 = Hex_4         
+#keycode  76 = KP_5            
+#	alt     keycode  76 = Ascii_5         
+#	altgr   keycode  76 = Hex_5         
+#keycode  77 = KP_6            
+#	alt     keycode  77 = Ascii_6         
+#	altgr   keycode  77 = Hex_6         
+#keycode  78 = KP_Add          
+#keycode  79 = KP_1            
+#	alt     keycode  79 = Ascii_1         
+#	altgr   keycode  79 = Hex_1         
+#keycode  80 = KP_2            
+#	alt     keycode  80 = Ascii_2         
+#	altgr   keycode  80 = Hex_2         
+#keycode  81 = KP_3            
+#	alt     keycode  81 = Ascii_3         
+#	altgr   keycode  81 = Hex_3         
+#keycode  82 = KP_0            
+#	alt     keycode  82 = Ascii_0         
+#	altgr   keycode  82 = Hex_0         
+#keycode  83 = KP_Period       
+#	control alt     keycode  83 = Boot            
+#keycode  84 = Last_Console    
 keycode  85 =
-keycode  86 = less             greater          bar             
-	alt     keycode  86 = Meta_less       
-keycode  87 = F11              F11              Console_23      
-	control keycode  87 = F11             
-	alt     keycode  87 = Console_11      
-	control alt     keycode  87 = Console_11      
-keycode  88 = F12              F12              Console_24      
-	control keycode  88 = F12             
-	alt     keycode  88 = Console_12      
-	control alt     keycode  88 = Console_12      
+#keycode  86 = less             greater          bar             
+#	alt     keycode  86 = Meta_less       
+#keycode  87 = F11              F11              Console_23      
+#	control keycode  87 = F11             
+#	alt     keycode  87 = Console_11      
+#	control alt     keycode  87 = Console_11      
+#keycode  88 = F12              F12              Console_24      
+#	control keycode  88 = F12             
+#	alt     keycode  88 = Console_12      
+#	control alt     keycode  88 = Console_12      
 keycode  89 =
 keycode  90 =
 keycode  91 =
@@ -219,38 +255,38 @@ keycode  92 =
 keycode  93 =
 keycode  94 =
 keycode  95 =
-keycode  96 = KP_Enter        
-keycode  97 = Control         
-keycode  98 = KP_Divide       
-keycode  99 = Control_backslash
-	control keycode  99 = Control_backslash
-	alt     keycode  99 = Control_backslash
+#keycode  96 = KP_Enter        
+#keycode  97 = Control         
+#keycode  98 = KP_Divide       
+#keycode  99 = Control_backslash
+#	control keycode  99 = Control_backslash
+#	alt     keycode  99 = Control_backslash
 keycode 100 = AltGr           
-keycode 101 = Break           
-keycode 102 = Find            
-keycode 103 = Up              
-keycode 104 = Prior           
-	shift   keycode 104 = Scroll_Backward 
-keycode 105 = Left            
-	alt     keycode 105 = Decr_Console
-keycode 106 = Right           
-	alt     keycode 106 = Incr_Console
-keycode 107 = Select          
-keycode 108 = Down            
-keycode 109 = Next            
-	shift   keycode 109 = Scroll_Forward  
-keycode 110 = Insert          
-keycode 111 = Remove          
-#	altgr   control keycode 111 = Boot            
-	control alt     keycode 111 = Boot            
-keycode 112 = Macro           
-keycode 113 = F13             
-keycode 114 = F14             
-keycode 115 = Help            
-keycode 116 = Do              
-keycode 117 = F17             
-keycode 118 = KP_MinPlus      
-keycode 119 = Pause           
+#keycode 101 = Break           
+# Button with icon of home
+keycode 102 = Alt            
+#keycode 103 = Up              
+#keycode 104 = Prior           
+#	shift   keycode 104 = Scroll_Backward 
+#keycode 105 = Left            
+#	alt     keycode 105 = Decr_Console
+#keycode 106 = Right           
+#	alt     keycode 106 = Incr_Console
+#keycode 107 = Select          
+#keycode 108 = Down            
+#keycode 109 = Next            
+#	shift   keycode 109 = Scroll_Forward  
+#keycode 110 = Insert          
+#keycode 111 = Remove          
+#	control alt     keycode 111 = Boot            
+#keycode 112 = Macro           
+#keycode 113 = F13             
+#keycode 114 = F14             
+#keycode 115 = Help            
+#keycode 116 = Do              
+#keycode 117 = F17             
+#keycode 118 = KP_MinPlus      
+#keycode 119 = Pause           
 keycode 120 =
 keycode 121 =
 keycode 122 =
@@ -258,7 +294,16 @@ keycode 123 =
 keycode 124 =
 keycode 125 =
 keycode 126 =
-keycode 127 =
+# O   find key
+#  \
+keycode 127 = Alt
+
+# Menu in buttons
+keycode 139 = Control
+# @~
+keycode 215 = at
+	altgr   keycode  215 = asciitilde
+
 string F1 = "\033[[A"
 string F2 = "\033[[B"
 string F3 = "\033[[C"


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
