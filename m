Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXKMObM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXKMObM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXKMO3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:29:50 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34114 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbXKMO3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:29:47 -0500
Message-Id: <20071113142935.063097504@polymtl.ca>
References: <20071113142609.103579906@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 09:26:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 2/4] Add ARCH_SUPPORTS_OPROFILE
Content-Disposition: inline; filename=add-arch-supports-oprofile.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 14:29:38 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus:
On the per-architecture side, I do think it would be better to *not* have
internal architecture knowledge in a generic file, and as such a line like

        depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32

really shouldn't exist in a file like kernel/Kconfig.instrumentation.

It would be much better to do

        depends on ARCH_SUPPORTS_KPROBES

in that generic file, and then architectures that do support it would just
have a

        bool ARCH_SUPPORTS_KPROBES
                default y

in *their* architecture files. That would seem to be much more logical,
and is readable both for arch maintainers *and* for people who have no
clue - and don't care - about which architecture is supposed to support
which interface...

Changelog:

Actually, I know I gave this as the magic incantation, but now that I see
it, I realize that I should have told you to just use

        config ARCH_SUPPORTS_KPROBES
                def_bool y

instead, which is a bit denser.

We seem to use both kinds of syntax for these things, but this is really
what "def_bool" is there for...

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/alpha/Kconfig             |    3 +++
 arch/arm/Kconfig               |    3 +++
 arch/blackfin/Kconfig          |    3 +++
 arch/ia64/Kconfig              |    3 +++
 arch/m32r/Kconfig              |    3 +++
 arch/mips/Kconfig              |    3 +++
 arch/parisc/Kconfig            |    3 +++
 arch/powerpc/Kconfig           |    3 +++
 arch/ppc/Kconfig               |    3 +++
 arch/s390/Kconfig              |    3 +++
 arch/sh/Kconfig                |    3 +++
 arch/sh64/Kconfig              |    3 +++
 arch/sparc/Kconfig             |    3 +++
 arch/sparc64/Kconfig           |    3 +++
 arch/x86/Kconfig.i386          |    3 +++
 arch/x86/Kconfig.x86_64        |    3 +++
 kernel/Kconfig.instrumentation |    2 +-
 17 files changed, 49 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-11-02 13:20:47.000000000 -0400
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -66,6 +66,9 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-11-02 13:20:47.000000000 -0400
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -114,6 +114,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-11-02 13:20:47.000000000 -0400
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -69,6 +69,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 config IRQCHIP_DEMUX_GPIO
 	bool
 	depends on (BF52x || BF53x || BF561 || BF54x)
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-11-02 13:20:47.000000000 -0400
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -99,6 +99,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -34,6 +34,9 @@ config NO_IOPORT
 config NO_DMA
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -721,6 +721,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default n
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 #
 # Select some configuration options automatically based on user selections.
 #
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -69,6 +69,9 @@ config IRQ_PER_CPU
 	bool
 	default y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -163,6 +163,9 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -69,6 +69,9 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -52,6 +52,9 @@ mainmenu "Linux Kernel Configuration"
 config S390
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Base setup"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -93,6 +93,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System type"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -58,6 +58,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source init/Kconfig
 
 menu "System type"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -27,6 +27,9 @@ config ARCH_NO_VIRT_TO_BUS
 config OF
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "General machine setup"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-11-02 13:20:54.000000000 -0400
@@ -76,6 +76,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
Index: linux-2.6-lttng/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.i386	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/x86/Kconfig.i386	2007-11-02 13:20:54.000000000 -0400
@@ -91,6 +91,9 @@ config DMI
 	bool
 	default y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6-lttng/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.x86_64	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/arch/x86/Kconfig.x86_64	2007-11-02 13:20:54.000000000 -0400
@@ -133,6 +133,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2007-11-02 13:20:48.000000000 -0400
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-11-02 13:20:54.000000000 -0400
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	depends on ARCH_SUPPORTS_OPROFILE
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
