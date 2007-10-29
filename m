Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXJ2Oav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXJ2Oav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbXJ2OaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:30:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39812 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbXJ2O3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:29:44 -0400
Message-Id: <20071029142938.491677638@polymtl.ca>
References: <20071029142646.699058449@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 29 Oct 2007 10:26:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 01/10] Create instrumentation directory
Content-Disposition: inline; filename=create-instrumentation-dir.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 29 Oct 2007 14:29:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we already have the Instrumentation menu in
kernel/Kconfig.instrumentation and instrumentation code all over the
kernel tree:

arch/*/oprofile/*.c
kernel/kprobes.c
arch/*/kernel/kprobes.c
kernel/marker.c
kernel/profile.c
kernel/lockdep.c
vm/vmstat.c
block/blktrace.c

We could move them to

instrumentation/
arch/*/instrumentation/

Therefore, we could also move the kprobes and marker samples under

instrumentation/samples/

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Randy Dunlap <rdunlap@xenotime.net>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/alpha/Kconfig             |    2 -
 arch/arm/Kconfig               |    2 -
 arch/blackfin/Kconfig          |    2 -
 arch/cris/Kconfig              |    2 -
 arch/frv/Kconfig               |    2 -
 arch/h8300/Kconfig             |    2 -
 arch/i386/Kconfig              |    2 -
 arch/ia64/Kconfig              |    2 -
 arch/m32r/Kconfig              |    2 -
 arch/m68k/Kconfig              |    2 -
 arch/m68knommu/Kconfig         |    2 -
 arch/mips/Kconfig              |    2 -
 arch/parisc/Kconfig            |    2 -
 arch/powerpc/Kconfig           |    2 -
 arch/ppc/Kconfig               |    2 -
 arch/s390/Kconfig              |    2 -
 arch/sh/Kconfig                |    2 -
 arch/sh64/Kconfig              |    2 -
 arch/sparc/Kconfig             |    2 -
 arch/sparc64/Kconfig           |    2 -
 arch/um/Kconfig                |    2 -
 arch/v850/Kconfig              |    2 -
 arch/x86_64/Kconfig            |    2 -
 arch/xtensa/Kconfig            |    2 -
 instrumentation/Kconfig        |   49 +++++++++++++++++++++++++++++++++++++++++
 instrumentation/Makefile       |    3 ++
 kernel/Kconfig.instrumentation |   49 -----------------------------------------
 27 files changed, 76 insertions(+), 73 deletions(-)

Index: linux-2.6-lttng.stable/instrumentation/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/instrumentation/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -0,0 +1,49 @@
+menuconfig INSTRUMENTATION
+	bool "Instrumentation Support"
+	default y
+	---help---
+	  Say Y here to get to see options related to performance measurement,
+	  system-wide debugging, and testing. This option alone does not add any
+	  kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled. If you're trying to debug the kernel itself, go see the
+	  Kernel Hacking menu.
+
+if INSTRUMENTATION
+
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
+endif # INSTRUMENTATION
Index: linux-2.6-lttng.stable/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.stable.orig/kernel/Kconfig.instrumentation	2007-10-29 09:51:10.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,49 +0,0 @@
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  system-wide debugging, and testing. This option alone does not add any
-	  kernel code.
-
-	  If you say N, all options in this submenu will be skipped and
-	  disabled. If you're trying to debug the kernel itself, go see the
-	  Kernel Hacking menu.
-
-if INSTRUMENTATION
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION
Index: linux-2.6-lttng.stable/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/alpha/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/alpha/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -654,7 +654,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/alpha/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/arm/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/arm/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -1068,7 +1068,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/arm/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/blackfin/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/blackfin/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -1062,7 +1062,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 menu "Kernel hacking"
 
Index: linux-2.6-lttng.stable/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/cris/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/cris/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -196,7 +196,7 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/cris/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/frv/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/frv/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -375,7 +375,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/frv/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/h8300/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/h8300/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -223,7 +223,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/h8300/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/i386/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/i386/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -1270,7 +1270,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/i386/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ia64/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ia64/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -592,7 +592,7 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/ia64/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/m32r/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/m32r/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -426,7 +426,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/m32r/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/m68k/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/m68k/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -683,7 +683,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/m68k/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/m68knommu/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/m68knommu/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -707,7 +707,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/m68knommu/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/mips/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/mips/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -2009,7 +2009,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/mips/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/parisc/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/parisc/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -267,7 +267,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/parisc/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/powerpc/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/powerpc/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -669,7 +669,7 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/powerpc/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ppc/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ppc/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -1317,7 +1317,7 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/ppc/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/s390/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/s390/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -529,7 +529,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/s390/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sh/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sh/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -758,7 +758,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/sh/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sh64/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sh64/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -284,7 +284,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/sh64/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sparc/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sparc/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -320,7 +320,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/sparc/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sparc64/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sparc64/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -462,7 +462,7 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/sparc64/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/um/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/um/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -289,6 +289,6 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng.stable/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/v850/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/v850/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -331,7 +331,7 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/v850/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86_64/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86_64/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -833,7 +833,7 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/x86_64/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/xtensa/Kconfig	2007-10-29 09:51:10.000000000 -0400
+++ linux-2.6-lttng.stable/arch/xtensa/Kconfig	2007-10-29 09:51:12.000000000 -0400
@@ -251,7 +251,7 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
+source "instrumentation/Kconfig"
 
 source "arch/xtensa/Kconfig.debug"
 
Index: linux-2.6-lttng.stable/instrumentation/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng.stable/instrumentation/Makefile	2007-10-29 09:51:12.000000000 -0400
@@ -0,0 +1,3 @@
+#
+# Makefile for the linux kernel instrumentation
+#

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
