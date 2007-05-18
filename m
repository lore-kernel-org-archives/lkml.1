Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbXERGvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbXERGvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbXERGvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:51:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52852 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbXERGvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:51:00 -0400
Date: Fri, 18 May 2007 08:51:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 04/14] all-archs: consolidate .text section definition in asm-generic
Message-ID: <20070518065156.GD12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From abe82ff8e73db114634b38ef1cd24e121643a2e9 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 13 May 2007 00:31:33 +0200
Subject: [PATCH 04/14] all-archs: consolidate .text section definition in asm-generic

Move definition of .text section to asm-generic.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/alpha/kernel/vmlinux.lds.S            |    2 +-
 arch/arm/kernel/vmlinux.lds.S              |    2 +-
 arch/arm26/kernel/vmlinux-arm26-xip.lds.in |    2 +-
 arch/arm26/kernel/vmlinux-arm26.lds.in     |    2 +-
 arch/avr32/kernel/vmlinux.lds.c            |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S         |    2 +-
 arch/frv/kernel/vmlinux.lds.S              |    3 ++-
 arch/h8300/kernel/vmlinux.lds.S            |    2 +-
 arch/i386/kernel/vmlinux.lds.S             |    2 +-
 arch/ia64/kernel/vmlinux.lds.S             |    2 +-
 arch/m32r/kernel/vmlinux.lds.S             |    2 +-
 arch/m68k/kernel/vmlinux-std.lds           |    2 +-
 arch/m68k/kernel/vmlinux-sun3.lds          |    2 +-
 arch/m68knommu/kernel/vmlinux.lds.S        |    2 +-
 arch/mips/kernel/vmlinux.lds.S             |    2 +-
 arch/parisc/kernel/vmlinux.lds.S           |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S          |    3 ++-
 arch/ppc/kernel/vmlinux.lds.S              |    2 +-
 arch/s390/kernel/vmlinux.lds.S             |    2 +-
 arch/sh/kernel/vmlinux.lds.S               |    2 +-
 arch/sh64/kernel/vmlinux.lds.S             |    2 +-
 arch/sparc/kernel/vmlinux.lds.S            |    2 +-
 arch/sparc64/kernel/vmlinux.lds.S          |    2 +-
 arch/um/kernel/dyn.lds.S                   |    2 +-
 arch/um/kernel/uml.lds.S                   |    2 +-
 arch/v850/kernel/vmlinux.lds.S             |    2 +-
 arch/x86_64/kernel/vmlinux.lds.S           |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S           |    3 ++-
 include/asm-generic/vmlinux.lds.h          |    6 ++++++
 29 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index cf1e6fc..ab60e81 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -15,7 +15,7 @@ SECTIONS
 
   _text = .;					/* Text and read-only data */
   .text : { 
-	*(.text) 
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index e4156e7..8d4e248 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -90,7 +90,7 @@ SECTIONS
 			__exception_text_start = .;
 			*(.exception.text)
 			__exception_text_end = .;
-			*(.text)
+			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
 #ifdef CONFIG_MMU
diff --git a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
index 046a850..89c806a 100644
--- a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
@@ -64,7 +64,7 @@ SECTIONS
 
 	.text : {			/* Real text segment		*/
 		_text = .;		/* Text and read-only data	*/
-			*(.text)
+			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT       /* FIXME - borrowed from arm32 - check*/
 			*(.fixup)
diff --git a/arch/arm26/kernel/vmlinux-arm26.lds.in b/arch/arm26/kernel/vmlinux-arm26.lds.in
index 1d2949e..e3f9b18 100644
--- a/arch/arm26/kernel/vmlinux-arm26.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26.lds.in
@@ -65,7 +65,7 @@ SECTIONS
 
 	.text : {			/* Real text segment		*/
 		_text = .;		/* Text and read-only data	*/
-			*(.text)
+			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
 			*(.fixup)
diff --git a/arch/avr32/kernel/vmlinux.lds.c b/arch/avr32/kernel/vmlinux.lds.c
index e7f72c9..dbba391 100644
--- a/arch/avr32/kernel/vmlinux.lds.c
+++ b/arch/avr32/kernel/vmlinux.lds.c
@@ -76,7 +76,7 @@ SECTIONS
 		. = 0x100;
 		*(.scall.text)
 		*(.irq.text)
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 6ae9ebb..36fcc77 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
 	{
 		 _text = .;
 		 __stext = .;
-		*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
 		*(.text.lock)
 		. = ALIGN(16);
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 28eae97..7e0998f 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -101,13 +101,14 @@ SECTIONS
   _stext = .;
   .text : {
 	*(
-		.text.start .text .text.*
+		.text.start .text.*
 #ifdef CONFIG_DEBUG_INFO
 	.init.text
 	.exit.text
 	.exitcall.exit
 #endif
 	)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 65f1cdc..4365162 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -75,7 +75,7 @@ SECTIONS
 	*(.int_redirect)
 #endif
 	__stext = . ;
-        	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	__etext = . ;
diff --git a/arch/i386/kernel/vmlinux.lds.S b/arch/i386/kernel/vmlinux.lds.S
index 80bec66..dfc439a 100644
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 6923826..19108d0 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -44,7 +44,7 @@ SECTIONS
   .text : AT(ADDR(.text) - LOAD_OFFSET)
     {
 	IVT_TEXT
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 6c73bca..bb1a2f5 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .boot : { *(.boot) } = 0
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 437b4f8..a65cef8 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -11,7 +11,7 @@ SECTIONS
   . = 0x1000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index 2868e20..fa44d6c 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -12,7 +12,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .text : {
 	*(.head)
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index c86a1bf..6d4585e 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -62,7 +62,7 @@ SECTIONS {
 	.text : {
 		_text = .;
 		_stext = . ;
-        	*(.text)
+		TEXT_TEXT
 		SCHED_TEXT
         	*(.text.lock)
 
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 043f637..cfe4b67 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
   /* read-only */
   _text = .;			/* Text and read-only data */
   .text : {
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index c745859..321de82 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@ SECTIONS
 
   _text = .;			/* Text and read-only data */
   .text ALIGN(16) : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.text.do_softirq)
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 1320673..f266209 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -34,7 +34,8 @@ SECTIONS
 	/* Text and gots */
 	.text : {
 		_text = .;
-		*(.text .text.*)
+		*(.text.*)
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
diff --git a/arch/ppc/kernel/vmlinux.lds.S b/arch/ppc/kernel/vmlinux.lds.S
index 44cd128..419ef7e 100644
--- a/arch/ppc/kernel/vmlinux.lds.S
+++ b/arch/ppc/kernel/vmlinux.lds.S
@@ -32,7 +32,7 @@ SECTIONS
   .text      :
   {
     _text = .;
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index e9d3432..89c2ec5 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -21,7 +21,7 @@ SECTIONS
   . = 0x00000000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index d83143c..2367869 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -22,7 +22,7 @@ SECTIONS
 	*(.empty_zero_page)
 	} = 0
   .text : {
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	*(.fixup)
diff --git a/arch/sh64/kernel/vmlinux.lds.S b/arch/sh64/kernel/vmlinux.lds.S
index 4f9616f..fdf72ce 100644
--- a/arch/sh64/kernel/vmlinux.lds.S
+++ b/arch/sh64/kernel/vmlinux.lds.S
@@ -54,7 +54,7 @@ SECTIONS
 	} = 0
 
   .text : C_PHYS(.text) {
-	*(.text)
+	TEXT_TEXT
 	*(.text64)
         *(.text..SHmedia32)
 	SCHED_TEXT
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index f0bb6e6..5cb600e 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -12,7 +12,7 @@ SECTIONS
   .text 0xf0004000 :
   {
     _text = .;
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.gnu.warning)
diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index 13fa2a2..f06da20 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -14,7 +14,7 @@ SECTIONS
   .text 0x0000000000404000 :
   {
     _text = .;
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     KPROBES_TEXT
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 87a4e44..ec8477d 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -62,7 +62,7 @@ SECTIONS
   } =0x90909090
   .plt            : { *(.plt) }
   .text           : {
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index bc59f97..8435105 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -37,7 +37,7 @@ SECTIONS
 
   .text      :
   {
-    *(.text)
+    TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
     *(.fixup)
diff --git a/arch/v850/kernel/vmlinux.lds.S b/arch/v850/kernel/vmlinux.lds.S
index 3563082..9e2b4bc 100644
--- a/arch/v850/kernel/vmlinux.lds.S
+++ b/arch/v850/kernel/vmlinux.lds.S
@@ -92,7 +92,7 @@
 #define TEXT_CONTENTS							      \
 		_text = .;						      \
 		__stext = . ;						      \
-        	*(.text)						      \
+		TEXT_TEXT						      \
 		SCHED_TEXT						      \
 			*(.exit.text)	/* 2.5 convention */		      \
 			*(.text.exit)	/* 2.4 convention */		      \
diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index 88cfa50..c77142d 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -31,7 +31,7 @@ SECTIONS
 	*(.bootstrap.text)
 	_stext = .;
 	/* Then the rest */
-	*(.text)
+	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 4fbd66a..7d2dfb2 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -84,7 +84,8 @@ SECTIONS
   {
     /* The .head.text section must be the first section! */
     *(.head.text)
-    *(.literal .text)
+    *(.literal)
+    TEXT_TEXT
     *(.srom.text)
     VMLINUX_SYMBOL(__sched_text_start) = .;
     *(.sched.literal .sched.text)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f3806a7..a464227 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -139,6 +139,12 @@
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
 	}
 
+/* .text section. Map to function alignment to avoid address changes
+ * during second ld run in second ld pass when generating System.map */
+#define TEXT_TEXT							\
+		ALIGN_FUNCTION();					\
+		*(.text)
+
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
 #define SCHED_TEXT							\
-- 
1.5.1.rc3.20.gaa453

