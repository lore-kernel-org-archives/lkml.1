Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXERGwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXERGwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbXERGwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:52:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60793 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbXERGwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:52:01 -0400
Date: Fri, 18 May 2007 08:52:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 05/14] all-archs: consolidate .data section definition in asm-generic
Message-ID: <20070518065257.GE12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 653bc43c6c2c292e6abc98860fd241eb12e2c80f Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 17 May 2007 13:38:44 +0200
Subject: [PATCH 05/14] all-archs: consolidate .data section definition in asm-generic

With this consolidation we can now modify the .data
section definition in one spot for all archs.

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
 arch/ia64/kernel/vmlinux.lds.S             |    7 ++++++-
 arch/m32r/kernel/vmlinux.lds.S             |    2 +-
 arch/m68k/kernel/vmlinux-std.lds           |    2 +-
 arch/m68k/kernel/vmlinux-sun3.lds          |    2 +-
 arch/m68knommu/kernel/vmlinux.lds.S        |    2 +-
 arch/mips/kernel/vmlinux.lds.S             |    2 +-
 arch/parisc/kernel/vmlinux.lds.S           |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S          |    2 +-
 arch/ppc/kernel/vmlinux.lds.S              |    2 +-
 arch/s390/kernel/vmlinux.lds.S             |    2 +-
 arch/sh/kernel/vmlinux.lds.S               |    2 +-
 arch/sh64/kernel/vmlinux.lds.S             |    2 +-
 arch/sparc/kernel/vmlinux.lds.S            |    2 +-
 arch/sparc64/kernel/vmlinux.lds.S          |    2 +-
 arch/um/kernel/dyn.lds.S                   |    3 ++-
 arch/um/kernel/uml.lds.S                   |    2 +-
 arch/v850/kernel/vmlinux.lds.S             |    2 +-
 arch/x86_64/kernel/vmlinux.lds.S           |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S           |    3 ++-
 include/asm-generic/vmlinux.lds.h          |    4 ++++
 29 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index ab60e81..449e76f 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -89,7 +89,7 @@ SECTIONS
 
   _data = .;
   .data : {					/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
   }
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 8d4e248..2b7a8f5 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -158,7 +158,7 @@ SECTIONS
 		/*
 		 * and the usual data section
 		 */
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		_edata = .;
diff --git a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
index 89c806a..4ec715c 100644
--- a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
@@ -111,7 +111,7 @@ SECTIONS
 		/*
 		 * and the usual data section
 		 */
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		*(.init.data)
diff --git a/arch/arm26/kernel/vmlinux-arm26.lds.in b/arch/arm26/kernel/vmlinux-arm26.lds.in
index e3f9b18..6c44f6a 100644
--- a/arch/arm26/kernel/vmlinux-arm26.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26.lds.in
@@ -106,7 +106,7 @@ SECTIONS
 		/*
 		 * and the usual data section
 		 */
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		_edata = .;
diff --git a/arch/avr32/kernel/vmlinux.lds.c b/arch/avr32/kernel/vmlinux.lds.c
index dbba391..db0438f 100644
--- a/arch/avr32/kernel/vmlinux.lds.c
+++ b/arch/avr32/kernel/vmlinux.lds.c
@@ -112,7 +112,7 @@ SECTIONS
 
 		/* And the rest... */
 		*(.data.rel*)
-		*(.data)
+		DATA_DATA
 		CONSTRUCTORS
 
 		_edata = .;
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 36fcc77..86fe679 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -200,7 +200,7 @@ SECTIONS
 		 __sdata = .;
 		. = ALIGN(0x2000);
 		*(.data.init_task)
-		*(.data)
+		DATA_DATA
 
 		. = ALIGN(32);
 		*(.data.cacheline_aligned)
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 7e0998f..481dc13 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -136,7 +136,8 @@ SECTIONS
 
   _sdata = .;
   .data : {			/* Data */
-	*(.data .data.*)
+	DATA_DATA
+	*(.data.*)
 	*(.exit.data)
 	CONSTRUCTORS
 	}
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 4365162..a2e72d4 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -103,7 +103,7 @@ SECTIONS
 	. = ALIGN(0x2000) ;
 		*(.data.init_task)
 	. = ALIGN(0x4) ;
-		*(.data)
+		DATA_DATA
 	. = ALIGN(0x4) ;
 		*(.data.*)	
 
diff --git a/arch/i386/kernel/vmlinux.lds.S b/arch/i386/kernel/vmlinux.lds.S
index dfc439a..aa87b06 100644
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -74,7 +74,7 @@ SECTIONS
   /* writeable */
   . = ALIGN(4096);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	} :data
 
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 19108d0..5a65965 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -214,7 +214,12 @@ SECTIONS
 
   data : { } :data
   .data : AT(ADDR(.data) - LOAD_OFFSET)
-	{ *(.data) *(.data1) *(.gnu.linkonce.d*) CONSTRUCTORS }
+	{
+		DATA_DATA
+		*(.data1)
+		*(.gnu.linkonce.d*)
+		CONSTRUCTORS
+	}
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
   .got : AT(ADDR(.got) - LOAD_OFFSET)
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index bb1a2f5..4e2d5b9 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -50,7 +50,7 @@ SECTIONS
   .data : {			/* Data */
 	*(.spu)
 	*(.spi)
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index a65cef8..78f1392 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -28,7 +28,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index fa44d6c..c8999b2 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -23,7 +23,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 6d4585e..07a0055 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -133,7 +133,7 @@ SECTIONS {
 	.data DATA_ADDR : {
 		. = ALIGN(4);
 		_sdata = . ;
-		*(.data)
+		DATA_DATA
 		. = ALIGN(8192) ;
 		*(.data.init_task)
 		_edata = . ;
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index cfe4b67..9b9992c 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -62,7 +62,7 @@ SECTIONS
     . = ALIGN(_PAGE_SIZE);
     *(.data.init_task)
 
-    *(.data)
+    DATA_DATA
 
     CONSTRUCTORS
   }
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 321de82..4d96ba4 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -91,7 +91,7 @@ SECTIONS
 
   . = ALIGN(L1_CACHE_BYTES);
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index f266209..f7d7bf1 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -168,7 +168,7 @@ SECTIONS
 #ifdef CONFIG_PPC32
 	.data    :
 	{
-		*(.data)
+		DATA_DATA
 		*(.sdata)
 		*(.got.plt) *(.got)
 	}
diff --git a/arch/ppc/kernel/vmlinux.lds.S b/arch/ppc/kernel/vmlinux.lds.S
index 419ef7e..19db874 100644
--- a/arch/ppc/kernel/vmlinux.lds.S
+++ b/arch/ppc/kernel/vmlinux.lds.S
@@ -67,7 +67,7 @@ SECTIONS
   . = ALIGN(4096);
   .data    :
   {
-    *(.data)
+    DATA_DATA
     *(.data1)
     *(.sdata)
     *(.sdata2)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 89c2ec5..7158a80 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -48,7 +48,7 @@ SECTIONS
   BUG_TABLE
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 2367869..4c5b57e 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -41,7 +41,7 @@ SECTIONS
   BUG_TABLE
 
   .data : {			/* Data */
-	*(.data)
+	DATA_DATA
 
  	 /* Align the initial ramdisk image (INITRD) on page boundaries. */
  	 . = ALIGN(PAGE_SIZE);
diff --git a/arch/sh64/kernel/vmlinux.lds.S b/arch/sh64/kernel/vmlinux.lds.S
index fdf72ce..02aea86 100644
--- a/arch/sh64/kernel/vmlinux.lds.S
+++ b/arch/sh64/kernel/vmlinux.lds.S
@@ -78,7 +78,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : C_PHYS(.data) {			/* Data */
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	}
 
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 5cb600e..f75a1b8 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -22,7 +22,7 @@ SECTIONS
   RODATA
   .data    :
   {
-    *(.data)
+    DATA_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index f06da20..fb648de 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
 
   .data    :
   {
-    *(.data)
+    DATA_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index ec8477d..2454774 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -99,7 +99,8 @@ SECTIONS
     *(.data.init_task)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
-    *(.data .data.* .gnu.linkonce.d.*)
+    DATA_DATA
+    *(.data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
   }
   .data1          : { *(.data1) }
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 8435105..307b937 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -61,7 +61,7 @@ SECTIONS
     *(.data.init_task)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
-    *(.data)
+    DATA_DATA
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
   }
diff --git a/arch/v850/kernel/vmlinux.lds.S b/arch/v850/kernel/vmlinux.lds.S
index 9e2b4bc..6172599 100644
--- a/arch/v850/kernel/vmlinux.lds.S
+++ b/arch/v850/kernel/vmlinux.lds.S
@@ -113,7 +113,7 @@
 /* Kernel data segment.  */
 #define DATA_CONTENTS							      \
 		__sdata = . ;						      \
-        	*(.data)						      \
+		DATA_DATA						      \
 			*(.exit.data)	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
 		. = ALIGN (16) ;					      \
diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index c77142d..dbccfda 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -55,7 +55,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
-	*(.data)
+	DATA_DATA
 	CONSTRUCTORS
 	} :data
 
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 7d2dfb2..4b7b4ff 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -145,7 +145,8 @@ SECTIONS
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    DATA_DATA
+    CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a464227..52e2d69 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,6 +9,10 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/* .data section */
+#define DATA_DATA							\
+	*(.data)
+
 #define RODATA								\
 	. = ALIGN(4096);						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
-- 
1.5.1.rc3.20.gaa453

