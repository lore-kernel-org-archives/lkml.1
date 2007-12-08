Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbXLHPkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbXLHPkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXLHPjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:39:49 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34735 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbXLHPjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:39:47 -0500
Message-Id: <20071208153935.058016100@polymtl.ca>
References: <20071208153255.078261362@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 08 Dec 2007 10:32:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 4/4] Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
Content-Disposition: inline; filename=move-kconfig-instrumentation-to-arch.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  8 Dec 2007 15:39:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the instrumentation Kconfig to

arch/Kconfig for architecture dependent options
  - oprofile
  - kprobes

and

init/Kconfig for architecture independent options
  - profiling
  - markers

Remove the "Instrumentation Support" menu. Everything moves to "General setup".
Delete the kernel/Kconfig.instrumentation file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/Kconfig                   |   28 ++++++++++++++++++++
 arch/alpha/Kconfig             |    2 -
 arch/arm/Kconfig               |    2 -
 arch/blackfin/Kconfig          |    2 -
 arch/cris/Kconfig              |    2 -
 arch/frv/Kconfig               |    2 -
 arch/h8300/Kconfig             |    2 -
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
 arch/sparc/Kconfig             |    2 -
 arch/sparc64/Kconfig           |    2 -
 arch/um/Kconfig                |    2 -
 arch/v850/Kconfig              |    2 -
 arch/x86/Kconfig               |    2 -
 arch/xtensa/Kconfig            |    2 -
 init/Kconfig                   |   12 ++++++++
 kernel/Kconfig.instrumentation |   55 -----------------------------------------
 25 files changed, 40 insertions(+), 99 deletions(-)

Index: linux-2.6-lttng.mm/arch/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/Kconfig	2007-12-08 09:57:15.000000000 -0500
+++ linux-2.6-lttng.mm/arch/Kconfig	2007-12-08 10:10:53.000000000 -0500
@@ -1,3 +1,31 @@
 #
 # General architecture dependent options
 #
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING && !UML
+	depends on HAVE_OPROFILE
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config HAVE_OPROFILE
+	def_bool n
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on HAVE_KPROBES
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config HAVE_KPROBES
+	def_bool n
Index: linux-2.6-lttng.mm/init/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/init/Kconfig	2007-12-08 09:57:15.000000000 -0500
+++ linux-2.6-lttng.mm/init/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -701,6 +701,18 @@ config PROC_PAGE_MONITOR
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
 
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
 source "arch/Kconfig"
 
 endmenu		# General setup
Index: linux-2.6-lttng.mm/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/alpha/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/alpha/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -658,8 +658,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
Index: linux-2.6-lttng.mm/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/arm/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/arm/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -1077,8 +1077,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/blackfin/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/blackfin/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -995,8 +995,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/blackfin/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/cris/Kconfig	2007-12-08 09:54:05.000000000 -0500
+++ linux-2.6-lttng.mm/arch/cris/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -214,8 +214,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/frv/Kconfig	2007-12-08 09:53:59.000000000 -0500
+++ linux-2.6-lttng.mm/arch/frv/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -384,8 +384,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/h8300/Kconfig	2007-12-08 09:54:47.000000000 -0500
+++ linux-2.6-lttng.mm/arch/h8300/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -226,8 +226,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/ia64/Kconfig	2007-12-08 10:07:28.000000000 -0500
+++ linux-2.6-lttng.mm/arch/ia64/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -594,8 +594,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/m32r/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/m32r/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -430,8 +430,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/m68k/Kconfig	2007-12-08 09:54:47.000000000 -0500
+++ linux-2.6-lttng.mm/arch/m68k/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -672,8 +672,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/m68knommu/Kconfig	2007-12-08 09:54:47.000000000 -0500
+++ linux-2.6-lttng.mm/arch/m68knommu/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -710,8 +710,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/mips/Kconfig	2007-12-08 10:07:16.000000000 -0500
+++ linux-2.6-lttng.mm/arch/mips/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -2072,8 +2072,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/parisc/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/parisc/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -271,8 +271,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/powerpc/Kconfig	2007-12-08 10:07:28.000000000 -0500
+++ linux-2.6-lttng.mm/arch/powerpc/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -682,8 +682,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/ppc/Kconfig	2007-12-08 10:07:28.000000000 -0500
+++ linux-2.6-lttng.mm/arch/ppc/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -1319,8 +1319,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/s390/Kconfig	2007-12-08 10:07:28.000000000 -0500
+++ linux-2.6-lttng.mm/arch/s390/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -531,8 +531,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/sh/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/sh/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -892,8 +892,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/sparc/Kconfig	2007-12-08 09:57:56.000000000 -0500
+++ linux-2.6-lttng.mm/arch/sparc/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -324,8 +324,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/sparc64/Kconfig	2007-12-08 10:07:28.000000000 -0500
+++ linux-2.6-lttng.mm/arch/sparc64/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -467,8 +467,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/um/Kconfig	2007-12-08 09:54:06.000000000 -0500
+++ linux-2.6-lttng.mm/arch/um/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -288,6 +288,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng.mm/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/v850/Kconfig	2007-12-08 09:54:47.000000000 -0500
+++ linux-2.6-lttng.mm/arch/v850/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -334,8 +334,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/xtensa/Kconfig	2007-12-08 09:22:45.000000000 -0500
+++ linux-2.6-lttng.mm/arch/xtensa/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -251,8 +251,6 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.mm.orig/arch/x86/Kconfig	2007-12-08 10:07:28.000000000 -0500
+++ linux-2.6-lttng.mm/arch/x86/Kconfig	2007-12-08 10:08:17.000000000 -0500
@@ -1582,8 +1582,6 @@ source "drivers/firmware/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.mm/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.mm.orig/kernel/Kconfig.instrumentation	2007-12-08 10:07:28.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,55 +0,0 @@
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
-	depends on PROFILING && !UML
-	depends on HAVE_OPROFILE
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config HAVE_OPROFILE
-	def_bool n
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	depends on HAVE_KPROBES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-config HAVE_KPROBES
-	def_bool n
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
