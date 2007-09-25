Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbXIYMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbXIYMP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXIYMPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:15:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59391 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbXIYMPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:15:12 -0400
Message-Id: <20070925121251.341749498@polymtl.ca>
References: <20070925121145.262664884@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 08:11:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/5] Combine instrumentation menus in kernel/Kconfig.instrumentation
Content-Disposition: inline; filename=kconfig-instrumentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 25 Sep 2007 12:12:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Randy:

"It seems sad that this patch sources Kconfig.marker, a 7-line file,
20-something times.  Yes, you (we) don't want to put those 7 lines
into 20-something different files, so sourcing is the right thing.

However, what you did for avr32 seems more on the right track to me:
make _one_ Instrumentation support menu that includes PROFILING,
OPROFILE, KPROBES, and MARKERS and then use (source) that in all
of the arches."

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/alpha/Kconfig             |    2 -
 arch/alpha/oprofile/Kconfig    |   23 ---------------------
 arch/arm/Kconfig               |    2 -
 arch/arm/oprofile/Kconfig      |   42 ----------------------------------------
 arch/blackfin/Kconfig          |    2 -
 arch/blackfin/oprofile/Kconfig |   29 ---------------------------
 arch/cris/Kconfig              |    2 +
 arch/frv/Kconfig               |    2 +
 arch/h8300/Kconfig             |    2 +
 arch/i386/Kconfig              |   25 -----------------------
 arch/i386/oprofile/Kconfig     |   17 ----------------
 arch/ia64/Kconfig              |   15 --------------
 arch/ia64/oprofile/Kconfig     |   20 -------------------
 arch/m32r/Kconfig              |    2 -
 arch/m32r/oprofile/Kconfig     |   23 ---------------------
 arch/m68k/Kconfig              |    2 +
 arch/m68knommu/Kconfig         |    2 +
 arch/mips/Kconfig              |    2 -
 arch/mips/oprofile/Kconfig     |   23 ---------------------
 arch/parisc/Kconfig            |    2 -
 arch/parisc/oprofile/Kconfig   |   23 ---------------------
 arch/powerpc/Kconfig           |   15 --------------
 arch/powerpc/oprofile/Kconfig  |   24 ----------------------
 arch/ppc/Kconfig               |    2 -
 arch/s390/Kconfig              |   16 ---------------
 arch/s390/oprofile/Kconfig     |   22 --------------------
 arch/sh/Kconfig                |    2 -
 arch/sh/oprofile/Kconfig       |   23 ---------------------
 arch/sh64/Kconfig              |    2 -
 arch/sh64/oprofile/Kconfig     |   23 ---------------------
 arch/sparc/Kconfig             |    6 -----
 arch/sparc/oprofile/Kconfig    |   17 ----------------
 arch/sparc64/Kconfig           |   15 --------------
 arch/sparc64/oprofile/Kconfig  |   17 ----------------
 arch/um/Kconfig                |    2 +
 arch/v850/Kconfig              |    2 +
 arch/x86_64/Kconfig            |   15 --------------
 arch/x86_64/oprofile/Kconfig   |   17 ----------------
 arch/xtensa/Kconfig            |    2 +
 kernel/Kconfig.instrumentation |   43 +++++++++++++++++++++++++++++++++++++++++
 40 files changed, 75 insertions(+), 452 deletions(-)

Index: linux-2.6-lttng/arch/alpha/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/arm/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,42 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-if OPROFILE
-
-config OPROFILE_ARMV6
-	bool
-	depends on CPU_V6 && !SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_MPCORE
-	bool
-	depends on CPU_V6 && SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_ARM11_CORE
-	bool
-
-endif
-
-endmenu
-
Index: linux-2.6-lttng/arch/blackfin/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,29 +0,0 @@
-menu "Profiling support"
-depends on EXPERIMENTAL
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
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config HARDWARE_PM
-	tristate "Hardware Performance Monitor Profiling"
-	depends on PROFILING
-	help
-	  take use of hardware performance monitor to profiling the kernel
-	  and application.
-
-	  If unsure, say N.
-
-endmenu
Index: linux-2.6-lttng/arch/i386/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
Index: linux-2.6-lttng/arch/ia64/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,20 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  Due to firmware bugs, you may need to use the "nohalt" boot
-	  option if you're using OProfile with the hardware performance
-	  counters.
-
-	  If unsure, say N.
-
Index: linux-2.6-lttng/arch/m32r/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/mips/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !MIPS_MT_SMTC && EXPERIMENTAL
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/parisc/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/powerpc/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,24 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config OPROFILE_CELL
-	bool "OProfile for Cell Broadband Engine"
-	depends on (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && OPROFILE = y) || (SPU_FS = m && OPROFILE = m)
-	default y
-	help
-	  Profiling of Cell BE SPUs requires special support enabled
-	  by this option.
Index: linux-2.6-lttng/arch/s390/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,22 +0,0 @@
-
-menu "Profiling support"
-
-config PROFILING
-	bool "Profiling support"
-	help
-	  Say Y here to enable profiling support mechanisms used by
-	  profilers such as readprofile or OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/sh/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/sh64/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
Index: linux-2.6-lttng/arch/sparc/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
Index: linux-2.6-lttng/arch/sparc64/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
Index: linux-2.6-lttng/arch/x86_64/oprofile/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/oprofile/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-09-25 07:18:40.000000000 -0400
@@ -0,0 +1,43 @@
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
+endif # INSTRUMENTATION
Index: linux-2.6-lttng/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/i386/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/i386/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -1251,30 +1251,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  debugging, and testing. This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if INSTRUMENTATION
-
-source "arch/i386/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-endif # INSTRUMENTATION
+source "kernel/Kconfig.instrumentation"
 
 source "arch/i386/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -654,7 +654,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/alpha/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/alpha/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -1061,7 +1061,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "arch/arm/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/arm/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -914,7 +914,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/blackfin/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 menu "Kernel hacking"
 
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -196,6 +196,8 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -375,6 +375,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -223,6 +223,8 @@ endmenu
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -579,20 +579,7 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/ia64/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/ia64/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -426,7 +426,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/m32r/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/m32r/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -683,6 +683,8 @@ endmenu
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -696,6 +696,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -1961,7 +1961,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/mips/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/mips/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -267,7 +267,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/parisc/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/parisc/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -638,20 +638,7 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/powerpc/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on !BOOKE && !4xx && KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/powerpc/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -1307,7 +1307,7 @@ endmenu
 
 source "lib/Kconfig"
 
-source "arch/powerpc/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/ppc/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -529,21 +529,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/s390/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.	register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/s390/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -749,7 +749,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/sh/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sh/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -285,7 +285,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/sh64/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sh64/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -320,11 +320,7 @@ endmenu
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/sparc/oprofile/Kconfig"
-
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sparc/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -460,20 +460,7 @@ source "drivers/fc4/Kconfig"
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/sparc64/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sparc64/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/um/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -289,4 +289,6 @@ config INPUT
 	bool
 	default n
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -331,6 +331,8 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -833,20 +833,7 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
-menu "Instrumentation Support"
-
-source "arch/x86_64/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/x86_64/Kconfig.debug"
 
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-09-24 15:00:24.000000000 -0400
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-09-25 07:17:48.000000000 -0400
@@ -251,6 +251,8 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
