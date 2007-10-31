Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXJaAed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXJaAed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXJaAeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:34:10 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42685 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbXJaAeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:34:09 -0400
Message-Id: <20071031003330.255163971@polymtl.ca>
References: <20071031003140.904670073@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 20:31:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 3/4] Add ARCH_SUPPORTS_KPROBES
Content-Disposition: inline; filename=add-arch-supports-kprobes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 00:33:30 +0000
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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/avr32/Kconfig             |    4 ++++
 arch/ia64/Kconfig              |    4 ++++
 arch/powerpc/Kconfig           |    4 ++++
 arch/ppc/Kconfig               |    4 ++++
 arch/s390/Kconfig              |    4 ++++
 arch/sparc64/Kconfig           |    4 ++++
 arch/x86/Kconfig.i386          |    4 ++++
 arch/x86/Kconfig.x86_64        |    4 ++++
 kernel/Kconfig.instrumentation |    2 +-
 9 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng.stable/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/avr32/Kconfig	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/avr32/Kconfig	2007-10-30 20:19:08.000000000 -0400
@@ -70,6 +70,10 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 source "init/Kconfig"
 
 menu "System Type and features"
Index: linux-2.6-lttng.stable/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ia64/Kconfig	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ia64/Kconfig	2007-10-30 20:19:08.000000000 -0400
@@ -103,6 +103,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
Index: linux-2.6-lttng.stable/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/powerpc/Kconfig	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/powerpc/Kconfig	2007-10-30 20:19:08.000000000 -0400
@@ -167,6 +167,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
Index: linux-2.6-lttng.stable/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/ppc/Kconfig	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/ppc/Kconfig	2007-10-30 20:19:08.000000000 -0400
@@ -73,6 +73,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 source "init/Kconfig"
 
 menu "Processor"
Index: linux-2.6-lttng.stable/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/s390/Kconfig	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/s390/Kconfig	2007-10-30 20:19:08.000000000 -0400
@@ -56,6 +56,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 source "init/Kconfig"
 
 menu "Base setup"
Index: linux-2.6-lttng.stable/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/sparc64/Kconfig	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/sparc64/Kconfig	2007-10-30 20:19:08.000000000 -0400
@@ -80,6 +80,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
Index: linux-2.6-lttng.stable/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/Kconfig.i386	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/Kconfig.i386	2007-10-30 20:19:08.000000000 -0400
@@ -95,6 +95,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6-lttng.stable/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86/Kconfig.x86_64	2007-10-30 20:18:38.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86/Kconfig.x86_64	2007-10-30 20:19:08.000000000 -0400
@@ -137,6 +137,10 @@ config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
 
+config ARCH_SUPPORTS_KPROBES
+	bool
+	default y
+
 source "init/Kconfig"
 
 
Index: linux-2.6-lttng.stable/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.stable.orig/kernel/Kconfig.instrumentation	2007-10-30 20:19:10.000000000 -0400
+++ linux-2.6-lttng.stable/kernel/Kconfig.instrumentation	2007-10-30 20:19:20.000000000 -0400
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
