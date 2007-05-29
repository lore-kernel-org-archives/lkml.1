Return-Path: <linux-kernel-owner+w=401wt.eu-S1764382AbXE2SmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764382AbXE2SmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXE2SiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:38:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43952 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbXE2SiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:38:15 -0400
Message-Id: <20070529183758.910835109@polymtl.ca>
References: <20070529183725.179570071@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:37:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       <linux-arch@vger.kernel.org>
Subject: [patch 1/6] Use EXTRA_RWDATA in architectures
Content-Disposition: inline; filename=use-extra_rwdata-in-architectures.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a place to declare rw data that will not be far from the .data content,
therefore limiting the impact on cache of data declared in sections part of the
EXTRA_RWDATA.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <linux-arch@vger.kernel.org>
---

 arch/alpha/kernel/vmlinux.lds.S            |    1 +
 arch/arm/kernel/vmlinux.lds.S              |    1 +
 arch/arm26/kernel/vmlinux-arm26-xip.lds.in |    1 +
 arch/arm26/kernel/vmlinux-arm26.lds.in     |    1 +
 arch/avr32/kernel/vmlinux.lds.c            |    1 +
 arch/cris/arch-v10/vmlinux.lds.S           |    1 +
 arch/cris/arch-v32/vmlinux.lds.S           |    1 +
 arch/frv/kernel/vmlinux.lds.S              |    1 +
 arch/h8300/kernel/vmlinux.lds.S            |    4 +++-
 arch/i386/kernel/vmlinux.lds.S             |    1 +
 arch/ia64/kernel/vmlinux.lds.S             |    2 +-
 arch/m32r/kernel/vmlinux.lds.S             |    1 +
 arch/m68k/kernel/vmlinux-std.lds           |    1 +
 arch/m68k/kernel/vmlinux-sun3.lds          |    1 +
 arch/m68knommu/kernel/vmlinux.lds.S        |    1 +
 arch/mips/kernel/vmlinux.lds.S             |    2 ++
 arch/parisc/kernel/vmlinux.lds.S           |    1 +
 arch/powerpc/kernel/vmlinux.lds.S          |    2 ++
 arch/ppc/kernel/vmlinux.lds.S              |    1 +
 arch/s390/kernel/vmlinux.lds.S             |    1 +
 arch/sh/kernel/vmlinux.lds.S               |    1 +
 arch/sh64/kernel/vmlinux.lds.S             |    1 +
 arch/sparc/kernel/vmlinux.lds.S            |    1 +
 arch/sparc64/kernel/vmlinux.lds.S          |    1 +
 arch/um/kernel/dyn.lds.S                   |    1 +
 arch/um/kernel/uml.lds.S                   |    1 +
 arch/v850/kernel/vmlinux.lds.S             |    1 +
 arch/x86_64/kernel/vmlinux.lds.S           |    1 +
 arch/xtensa/kernel/vmlinux.lds.S           |    2 +-
 include/asm-generic/vmlinux.lds.h          |    2 ++
 30 files changed, 35 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -90,6 +90,7 @@
   _data = .;
   .data : {					/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
   }
 
Index: linux-2.6-lttng/arch/arm/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -159,6 +159,7 @@
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
Index: linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/kernel/vmlinux-arm26-xip.lds.in	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26-xip.lds.in	2007-05-15 18:44:20.000000000 -0400
@@ -112,6 +112,7 @@
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		*(.init.data)
Index: linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26.lds.in
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/kernel/vmlinux-arm26.lds.in	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26.lds.in	2007-05-15 18:44:20.000000000 -0400
@@ -107,6 +107,7 @@
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
Index: linux-2.6-lttng/arch/avr32/kernel/vmlinux.lds.c
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/kernel/vmlinux.lds.c	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/kernel/vmlinux.lds.c	2007-05-15 18:44:20.000000000 -0400
@@ -113,6 +113,7 @@
 		/* And the rest... */
 		*(.data.rel*)
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
Index: linux-2.6-lttng/arch/cris/arch-v10/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v10/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v10/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -45,6 +45,7 @@
 	__Sdata = . ;
 	.data : {                     /* Data */
 		*(.data)
+		EXTRA_RWDATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
Index: linux-2.6-lttng/arch/cris/arch-v32/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v32/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v32/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -50,6 +50,7 @@
 	__Sdata = . ;
 	.data : {                     /* Data */
 		*(.data)
+		EXTRA_RWDATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
Index: linux-2.6-lttng/arch/frv/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/frv/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/frv/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -137,6 +137,7 @@
   .data : {			/* Data */
 	*(.data .data.*)
 	*(.exit.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/h8300/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -105,7 +105,9 @@
 	. = ALIGN(0x4) ;
 		*(.data)
 	. = ALIGN(0x4) ;
-		*(.data.*)	
+		*(.data.*)
+	. = ALIGN(0x4) ;
+	EXTRA_RWDATA
 
 	. = ALIGN(0x4) ;
 	___init_begin = .;
Index: linux-2.6-lttng/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -77,6 +77,7 @@
   . = ALIGN(4096);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	} :data
 
Index: linux-2.6-lttng/arch/ia64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -214,7 +214,7 @@
 
   data : { } :data
   .data : AT(ADDR(.data) - LOAD_OFFSET)
-	{ *(.data) *(.data1) *(.gnu.linkonce.d*) CONSTRUCTORS }
+	{ *(.data) *(.data1) *(.gnu.linkonce.d*) EXTRA_RWDATA CONSTRUCTORS }
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
   .got : AT(ADDR(.got) - LOAD_OFFSET)
Index: linux-2.6-lttng/arch/m32r/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -51,6 +51,7 @@
 	*(.spu)
 	*(.spi)
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/m68k/kernel/vmlinux-std.lds
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/kernel/vmlinux-std.lds	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/kernel/vmlinux-std.lds	2007-05-15 18:44:20.000000000 -0400
@@ -29,6 +29,7 @@
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/m68k/kernel/vmlinux-sun3.lds
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/kernel/vmlinux-sun3.lds	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/kernel/vmlinux-sun3.lds	2007-05-15 18:44:20.000000000 -0400
@@ -24,6 +24,7 @@
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
Index: linux-2.6-lttng/arch/m68knommu/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -134,6 +134,7 @@
 		. = ALIGN(4);
 		_sdata = . ;
 		*(.data)
+		EXTRA_RWDATA
 		. = ALIGN(8192) ;
 		*(.data.init_task)
 		_edata = . ;
Index: linux-2.6-lttng/arch/mips/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/mips/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -64,6 +64,8 @@
 
     *(.data)
 
+    EXTRA_RWDATA
+
     CONSTRUCTORS
   }
   _gp = . + 0x8000;
Index: linux-2.6-lttng/arch/parisc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -92,6 +92,7 @@
   . = ALIGN(L1_CACHE_BYTES);
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -170,11 +170,13 @@
 		*(.data)
 		*(.sdata)
 		*(.got.plt) *(.got)
+		EXTRA_RWDATA
 	}
 #else
 	.data : {
 		*(.data .data.rel* .toc1)
 		*(.branch_lt)
+		EXTRA_RWDATA
 	}
 
 	.opd : {
Index: linux-2.6-lttng/arch/ppc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -73,6 +73,7 @@
     *(.sdata2)
     *(.got.plt) *(.got)
     *(.dynamic)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
 
Index: linux-2.6-lttng/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/s390/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -49,6 +49,7 @@
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/sh/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/sh/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -42,6 +42,7 @@
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 
  	 /* Align the initial ramdisk image (INITRD) on page boundaries. */
  	 . = ALIGN(PAGE_SIZE);
Index: linux-2.6-lttng/arch/sh64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -79,6 +79,7 @@
 
   .data : C_PHYS(.data) {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/sparc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -23,6 +23,7 @@
   .data    :
   {
     *(.data)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
Index: linux-2.6-lttng/arch/sparc64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -28,6 +28,7 @@
   .data    :
   {
     *(.data)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
Index: linux-2.6-lttng/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/um/kernel/dyn.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/um/kernel/dyn.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -98,6 +98,7 @@
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
     *(.data.init_task)
     *(.data .data.* .gnu.linkonce.d.*)
+    EXTRA_RWDATA
     SORT(CONSTRUCTORS)
   }
   .data1          : { *(.data1) }
Index: linux-2.6-lttng/arch/um/kernel/uml.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/um/kernel/uml.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/um/kernel/uml.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -61,6 +61,7 @@
     *(.data.init_task)
     *(.data)
     *(.gnu.linkonce.d*)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
Index: linux-2.6-lttng/arch/v850/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/v850/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/v850/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -116,6 +116,7 @@
         	*(.data)						      \
 			*(.exit.data)	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
+		EXTRA_RWDATA						      \
 		. = ALIGN (16) ;					      \
 		*(.data.cacheline_aligned)				      \
 		. = ALIGN (0x2000) ;					      \
Index: linux-2.6-lttng/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -56,6 +56,7 @@
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	} :data
 
Index: linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/kernel/vmlinux.lds.S	2007-05-15 18:41:05.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S	2007-05-15 18:44:20.000000000 -0400
@@ -144,7 +144,7 @@
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    *(.data) EXTRA_RWDATA CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-15 18:44:11.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-15 18:44:20.000000000 -0400
@@ -143,6 +143,8 @@
 									\
 	. = ALIGN(4096);
 
+#define EXTRA_RWDATA
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
