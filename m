Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbYBBUMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbYBBUMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbYBBUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:12:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44526 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934242AbYBBUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:12:21 -0500
Message-Id: <20080202201201.134048008@polymtl.ca>
References: <20080202201031.860344390@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:10:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, <linux-arch@vger.kernel.org>
Subject: [patch 5/5] Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
Content-Disposition: inline; filename=move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:12:02 +0000
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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
Cc: <linux-arch@vger.kernel.org>
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

Index: linux-2.6-lttng/arch/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/Kconfig	2008-02-02 14:37:03.000000000 -0500
+++ linux-2.6-lttng/arch/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -1,3 +1,31 @@
 #
 # General architecture dependent options
 #
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
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
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2008-02-02 14:37:03.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -665,6 +665,18 @@ config SLOB
 
 endchoice
 
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
Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/alpha/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -650,8 +650,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -1147,8 +1147,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -974,8 +974,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/blackfin/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/cris/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -213,8 +213,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/frv/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -375,8 +375,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/h8300/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -223,8 +223,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -602,8 +602,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/m32r/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -427,8 +427,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/m68k/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -678,8 +678,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -711,8 +711,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/mips/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -2096,8 +2096,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/parisc/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -273,8 +273,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -715,8 +715,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -1258,8 +1258,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/s390/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -528,8 +528,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/sh/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -897,8 +897,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2008-02-02 14:37:04.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -321,8 +321,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -467,8 +467,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/um/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -289,6 +289,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/v850/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -331,8 +331,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2008-02-02 14:36:21.000000000 -0500
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -246,8 +246,6 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2008-02-02 14:37:07.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2008-02-02 14:37:08.000000000 -0500
@@ -1595,8 +1595,6 @@ source "drivers/firmware/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2008-02-02 14:37:07.000000000 -0500
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
-	depends on KALLSYMS && MODULES && !UML
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
