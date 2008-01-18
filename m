Return-Path: <linux-kernel-owner+w=401wt.eu-S1764577AbYARSbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764577AbYARSbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764088AbYARSaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:30:00 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761589AbYARS3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:29:55 -0500
Message-Id: <20080118182954.056612000@sgi.com>
References: <20080118182953.748071000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jan 2008 10:29:55 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/7] percpu: Change Kconfig ARCH_SETS_UP_PER_CPU_AREA to HAVE_SETUP_PER_CPU_AREA
Content-Disposition: inline; filename=config-to-select
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "config ARCH_SETS_UP_PER_CPU_AREA" to "select
HAVE_SETUP_PER_CPU_AREA" as suggested by Sam.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

---
 arch/Kconfig                 |    3 +++
 arch/ia64/Kconfig            |    4 +---
 arch/powerpc/Kconfig         |    4 +---
 arch/sparc64/Kconfig         |    4 +---
 arch/x86/Kconfig             |    4 +---
 include/asm-generic/percpu.h |    2 +-
 init/main.c                  |    4 ++--
 7 files changed, 10 insertions(+), 15 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1,3 +1,6 @@
 #
 # General architecture dependent options
 #
+
+config HAVE_SETUP_PER_CPU_AREA
+	def_bool n
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -17,6 +17,7 @@ config IA64
 	select ARCH_SUPPORTS_MSI
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_SETUP_PER_CPU_AREA
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -82,9 +83,6 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
-config ARCH_SETS_UP_PER_CPU_AREA
-	def_bool y
-
 config DMI
 	bool
 	default y
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -42,9 +42,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config ARCH_SETS_UP_PER_CPU_AREA
-	def_bool PPC64
-
 config IRQ_PER_CPU
 	bool
 	default y
@@ -89,6 +86,7 @@ config PPC
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_SETUP_PER_CPU_AREA if PPC64
 
 config EARLY_PRINTK
 	bool
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -10,6 +10,7 @@ config SPARC
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_SETUP_PER_CPU_AREA
 
 config SPARC64
 	bool
@@ -68,9 +69,6 @@ config AUDIT_ARCH
 	bool
 	default y
 
-config ARCH_SETS_UP_PER_CPU_AREA
-	def_bool y
-
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_SETUP_PER_CPU_AREA if X86_64
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -106,9 +107,6 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
-config ARCH_SETS_UP_PER_CPU_AREA
-	def_bool X86_64
-
 config ARCH_SUPPORTS_OPROFILE
 	bool
 	default y
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -59,7 +59,7 @@ extern unsigned long __per_cpu_offset[NR
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
 
 
-#ifdef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
 #endif
 
--- a/init/main.c
+++ b/init/main.c
@@ -363,7 +363,7 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#ifndef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
 EXPORT_SYMBOL(__per_cpu_offset);
@@ -384,7 +384,7 @@ static void __init setup_per_cpu_areas(v
 		ptr += size;
 	}
 }
-#endif /* CONFIG_ARCH_SETS_UP_CPU_AREA */
+#endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
 
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)

-- 
