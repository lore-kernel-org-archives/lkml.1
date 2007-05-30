Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXE3OIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXE3OIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbXE3OH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:07:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47902 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbXE3OHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:07:22 -0400
Message-Id: <20070530140712.629796796@polymtl.ca>
References: <20070530140359.006540666@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:04:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       <linux-arch@vger.kernel.org>
Subject: [patch 1/6] Use EXTRARW_DATA in architectures
Content-Disposition: inline; filename=use-extra_rwdata-in-architectures.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:07:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EXTRARW_DATA adds a place to declare rw data that will not be mixed with the
.data content; therefore limiting data cache pollution when data is put in
the EXTRARW_DATA sections.

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
 arch/h8300/kernel/vmlinux.lds.S            |    3 ++-
 arch/i386/kernel/vmlinux.lds.S             |    1 +
 arch/ia64/kernel/vmlinux.lds.S             |    1 +
 arch/m32r/kernel/vmlinux.lds.S             |    1 +
 arch/m68k/kernel/vmlinux-std.lds           |    1 +
 arch/m68k/kernel/vmlinux-sun3.lds          |    1 +
 arch/m68knommu/kernel/vmlinux.lds.S        |    1 +
 arch/mips/kernel/vmlinux.lds.S             |    3 +--
 arch/parisc/kernel/vmlinux.lds.S           |    1 +
 arch/powerpc/kernel/vmlinux.lds.S          |    2 ++
 arch/ppc/kernel/vmlinux.lds.S              |    1 +
 arch/s390/kernel/vmlinux.lds.S             |    1 +
 arch/sh/kernel/vmlinux.lds.S               |    2 +-
 arch/sh64/kernel/vmlinux.lds.S             |    1 +
 arch/sparc/kernel/vmlinux.lds.S            |    1 +
 arch/sparc64/kernel/vmlinux.lds.S          |    1 +
 arch/um/kernel/dyn.lds.S                   |    1 +
 arch/um/kernel/uml.lds.S                   |    1 +
 arch/v850/kernel/vmlinux.lds.S             |    1 +
 arch/x86_64/kernel/vmlinux.lds.S           |    1 +
 arch/xtensa/kernel/vmlinux.lds.S           |    1 +
 include/asm-generic/vmlinux.lds.h          |    5 +++++
 30 files changed, 36 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/alpha/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/kernel/vmlinux.lds.S	2007-05-30 08:42:26.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/kernel/vmlinux.lds.S	2007-05-30 08:51:20.000000000 -0400
@@ -90,6 +90,7 @@
   _data = .;
   .data : {					/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
   }
 
Index: linux-2.6-lttng/arch/arm/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/arm/kernel/vmlinux.lds.S	2007-05-30 08:42:27.000000000 -0400
+++ linux-2.6-lttng/arch/arm/kernel/vmlinux.lds.S	2007-05-30 08:51:52.000000000 -0400
@@ -159,6 +159,7 @@
 		 * and the usual data section
 		 */
 		DATA_DATA
+		EXTRARW_DATA
 		CONSTRUCTORS
 
 		_edata = .;
Index: linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/kernel/vmlinux-arm26-xip.lds.in	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26-xip.lds.in	2007-05-30 08:52:12.000000000 -0400
@@ -112,6 +112,7 @@
 		 * and the usual data section
 		 */
 		DATA_DATA
+		EXTRARW_DATA
 		CONSTRUCTORS
 
 		*(.init.data)
Index: linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26.lds.in
===================================================================
--- linux-2.6-lttng.orig/arch/arm26/kernel/vmlinux-arm26.lds.in	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/arm26/kernel/vmlinux-arm26.lds.in	2007-05-30 08:52:28.000000000 -0400
@@ -107,6 +107,7 @@
 		 * and the usual data section
 		 */
 		DATA_DATA
+		EXTRARW_DATA
 		CONSTRUCTORS
 
 		_edata = .;
Index: linux-2.6-lttng/arch/avr32/kernel/vmlinux.lds.c
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/kernel/vmlinux.lds.c	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/avr32/kernel/vmlinux.lds.c	2007-05-30 08:52:45.000000000 -0400
@@ -113,6 +113,7 @@
 		/* And the rest... */
 		*(.data.rel*)
 		DATA_DATA
+		EXTRARW_DATA
 		CONSTRUCTORS
 
 		_edata = .;
Index: linux-2.6-lttng/arch/cris/arch-v10/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v10/vmlinux.lds.S	2007-05-30 08:27:48.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v10/vmlinux.lds.S	2007-05-30 08:53:15.000000000 -0400
@@ -45,6 +45,7 @@
 	__Sdata = . ;
 	.data : {                     /* Data */
 		*(.data)
+		EXTRARW_DATA
 	}
 	__edata = . ;                 /* End of data section */
 	_edata = . ;
Index: linux-2.6-lttng/arch/cris/arch-v32/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/cris/arch-v32/vmlinux.lds.S	2007-05-30 08:42:01.000000000 -0400
+++ linux-2.6-lttng/arch/cris/arch-v32/vmlinux.lds.S	2007-05-30 08:53:28.000000000 -0400
@@ -50,6 +50,7 @@
 	__Sdata = . ;
 	.data : {                     /* Data */
 		*(.data)
+		EXTRARW_DATA
 	}
 	__edata = . ;		/* End of data section. */
 	_edata = . ;
Index: linux-2.6-lttng/arch/frv/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/frv/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/frv/kernel/vmlinux.lds.S	2007-05-30 08:53:58.000000000 -0400
@@ -139,6 +139,7 @@
 	DATA_DATA
 	*(.data.*)
 	*(.exit.data)
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/h8300/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/kernel/vmlinux.lds.S	2007-05-30 09:01:29.000000000 -0400
@@ -105,7 +105,8 @@
 	. = ALIGN(0x4) ;
 		DATA_DATA
 	. = ALIGN(0x4) ;
-		*(.data.*)	
+		*(.data.*)
+		EXTRARW_DATA
 
 	. = ALIGN(0x4) ;
 	___init_begin = .;
Index: linux-2.6-lttng/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/vmlinux.lds.S	2007-05-30 08:42:44.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/vmlinux.lds.S	2007-05-30 08:54:39.000000000 -0400
@@ -77,6 +77,7 @@
   . = ALIGN(4096);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	} :data
 
Index: linux-2.6-lttng/arch/ia64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/kernel/vmlinux.lds.S	2007-05-30 08:54:52.000000000 -0400
@@ -216,6 +216,7 @@
   .data : AT(ADDR(.data) - LOAD_OFFSET)
 	{
 		DATA_DATA
+		EXTRARW_DATA
 		*(.data1)
 		*(.gnu.linkonce.d*)
 		CONSTRUCTORS
Index: linux-2.6-lttng/arch/m32r/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/kernel/vmlinux.lds.S	2007-05-30 08:55:06.000000000 -0400
@@ -51,6 +51,7 @@
 	*(.spu)
 	*(.spi)
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/m68k/kernel/vmlinux-std.lds
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/kernel/vmlinux-std.lds	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/kernel/vmlinux-std.lds	2007-05-30 08:55:16.000000000 -0400
@@ -29,6 +29,7 @@
 
   .data : {			/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/m68k/kernel/vmlinux-sun3.lds
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/kernel/vmlinux-sun3.lds	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/kernel/vmlinux-sun3.lds	2007-05-30 08:55:28.000000000 -0400
@@ -24,6 +24,7 @@
 
   .data : {			/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
Index: linux-2.6-lttng/arch/m68knommu/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/kernel/vmlinux.lds.S	2007-05-30 08:55:40.000000000 -0400
@@ -134,6 +134,7 @@
 		. = ALIGN(4);
 		_sdata = . ;
 		DATA_DATA
+		EXTRARW_DATA
 		. = ALIGN(8192) ;
 		*(.data.init_task)
 		_edata = . ;
Index: linux-2.6-lttng/arch/mips/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/mips/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/mips/kernel/vmlinux.lds.S	2007-05-30 08:55:59.000000000 -0400
@@ -61,9 +61,8 @@
      */
     . = ALIGN(_PAGE_SIZE);
     *(.data.init_task)
-
     DATA_DATA
-
+    EXTRARW_DATA
     CONSTRUCTORS
   }
   _gp = . + 0x8000;
Index: linux-2.6-lttng/arch/parisc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/kernel/vmlinux.lds.S	2007-05-30 08:56:12.000000000 -0400
@@ -92,6 +92,7 @@
   . = ALIGN(L1_CACHE_BYTES);
   .data : {			/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/vmlinux.lds.S	2007-05-30 08:42:29.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S	2007-05-30 08:56:54.000000000 -0400
@@ -170,11 +170,13 @@
 		DATA_DATA
 		*(.sdata)
 		*(.got.plt) *(.got)
+		EXTRARW_DATA
 	}
 #else
 	.data : {
 		*(.data .data.rel* .toc1)
 		*(.branch_lt)
+		EXTRARW_DATA
 	}
 
 	.opd : {
Index: linux-2.6-lttng/arch/ppc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/kernel/vmlinux.lds.S	2007-05-30 08:56:47.000000000 -0400
@@ -73,6 +73,7 @@
     *(.sdata2)
     *(.got.plt) *(.got)
     *(.dynamic)
+    EXTRARW_DATA
     CONSTRUCTORS
   }
 
Index: linux-2.6-lttng/arch/s390/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/s390/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/s390/kernel/vmlinux.lds.S	2007-05-30 08:57:08.000000000 -0400
@@ -49,6 +49,7 @@
 
   .data : {			/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/sh/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sh/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/sh/kernel/vmlinux.lds.S	2007-05-30 08:57:26.000000000 -0400
@@ -49,7 +49,7 @@
  	 *(.initrd)
  	 . = ALIGN(PAGE_SIZE);
  	 __rd_end = .;
-
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/sh64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/kernel/vmlinux.lds.S	2007-05-30 08:57:39.000000000 -0400
@@ -79,6 +79,7 @@
 
   .data : C_PHYS(.data) {			/* Data */
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	}
 
Index: linux-2.6-lttng/arch/sparc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/kernel/vmlinux.lds.S	2007-05-30 08:57:51.000000000 -0400
@@ -23,6 +23,7 @@
   .data    :
   {
     DATA_DATA
+    EXTRARW_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
Index: linux-2.6-lttng/arch/sparc64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/kernel/vmlinux.lds.S	2007-05-30 08:58:01.000000000 -0400
@@ -28,6 +28,7 @@
   .data    :
   {
     DATA_DATA
+    EXTRARW_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
Index: linux-2.6-lttng/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/um/kernel/dyn.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/um/kernel/dyn.lds.S	2007-05-30 08:58:15.000000000 -0400
@@ -101,6 +101,7 @@
     *(.data.init_irqstack)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
+    EXTRARW_DATA
     SORT(CONSTRUCTORS)
   }
   .data1          : { *(.data1) }
Index: linux-2.6-lttng/arch/um/kernel/uml.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/um/kernel/uml.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/um/kernel/uml.lds.S	2007-05-30 08:58:27.000000000 -0400
@@ -63,6 +63,7 @@
     *(.data.init_irqstack)
     DATA_DATA
     *(.gnu.linkonce.d*)
+    EXTRARW_DATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
Index: linux-2.6-lttng/arch/v850/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/v850/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/v850/kernel/vmlinux.lds.S	2007-05-30 08:58:45.000000000 -0400
@@ -116,6 +116,7 @@
 		DATA_DATA						      \
 			*(.exit.data)	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
+		EXTRARW_DATA						      \
 		. = ALIGN (16) ;					      \
 		*(.data.cacheline_aligned)				      \
 		. = ALIGN (0x2000) ;					      \
Index: linux-2.6-lttng/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/vmlinux.lds.S	2007-05-30 08:42:43.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/vmlinux.lds.S	2007-05-30 08:58:55.000000000 -0400
@@ -56,6 +56,7 @@
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
+	EXTRARW_DATA
 	CONSTRUCTORS
 	} :data
 
Index: linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/kernel/vmlinux.lds.S	2007-05-30 08:42:28.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/kernel/vmlinux.lds.S	2007-05-30 08:59:09.000000000 -0400
@@ -146,6 +146,7 @@
   .data :
   {
     DATA_DATA
+    EXTRARW_DATA
     CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-30 08:43:11.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-30 09:04:19.000000000 -0400
@@ -150,6 +150,11 @@
 									\
 	. = ALIGN(4096);
 
+/* EXTRARW_DATA adds a place to declare rw data that will not be mixed with the
+ * .data content; therefore limiting data cache pollution when data is put in
+ * the EXTRARW_DATA sections. */
+#define EXTRARW_DATA
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
