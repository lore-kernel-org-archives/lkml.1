Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXJaBGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXJaBGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXJaBEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:04:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59420 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbXJaBEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:04:35 -0400
Message-Id: <20071031010427.191206858@polymtl.ca>
References: <20071031010345.301342580@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 21:03:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 3/4] Add ARCH_SUPPORTS_KPROBES
Content-Disposition: inline; filename=add-arch-supports-kprobes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 01:04:27 +0000
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
 arch/avr32/Kconfig             |    3 +++
 arch/ia64/Kconfig              |    3 +++
 arch/powerpc/Kconfig           |    3 +++
 arch/ppc/Kconfig               |    3 +++
 arch/s390/Kconfig              |    3 +++
 arch/sparc64/Kconfig           |    3 +++
 arch/x86/Kconfig.i386          |    3 +++
 arch/x86/Kconfig.x86_64        |    3 +++
 kernel/Kconfig.instrumentation |    2 +-
 9 files changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng.stable/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/avr32/Kconfig	2007-10-30 20:56:33.000000000 -0400
+++ linux-2.6-lttng.stable/arch/avr32/Kconfig	2007-10-30 21:02:03.000000000 -0400
@@ -70,6 +70,9 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System Type and features"
Index: linux-2.6-lttng.stable/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ia64/Kconfig	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ia64/Kconfig	2007-10-30 21:02:03.000000000 -0400
@@ -102,6 +102,9 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
Index: linux-2.6-lttng.stable/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/powerpc/Kconfig	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/powerpc/Kconfig	2007-10-30 21:02:03.000000000 -0400
@@ -166,6 +166,9 @@ config PPC_OF_PLATFORM_PCI
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
Index: linux-2.6-lttng.stable/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ppc/Kconfig	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ppc/Kconfig	2007-10-30 21:02:03.000000000 -0400
@@ -72,6 +72,9 @@ config GENERIC_BUG
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor"
Index: linux-2.6-lttng.stable/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/s390/Kconfig	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/s390/Kconfig	2007-10-30 21:02:03.000000000 -0400
@@ -55,6 +55,9 @@ config S390
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Base setup"
Index: linux-2.6-lttng.stable/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sparc64/Kconfig	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sparc64/Kconfig	2007-10-30 21:02:03.000000000 -0400
@@ -79,6 +79,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
Index: linux-2.6-lttng.stable/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/Kconfig.i386	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/Kconfig.i386	2007-10-30 21:02:03.000000000 -0400
@@ -94,6 +94,9 @@ config DMI
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6-lttng.stable/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/Kconfig.x86_64	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/Kconfig.x86_64	2007-10-30 21:02:03.000000000 -0400
@@ -136,6 +136,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 
Index: linux-2.6-lttng.stable/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.stable.orig/kernel/Kconfig.instrumentation	2007-10-30 21:02:03.000000000 -0400
+++ linux-2.6-lttng.stable/kernel/Kconfig.instrumentation	2007-10-30 21:02:03.000000000 -0400
@@ -32,7 +32,7 @@ config OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on ARCH_SUPPORTS_KPROBES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
