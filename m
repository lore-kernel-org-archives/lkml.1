Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZA2A3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZA2A3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758932AbZA1Xrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:53455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbZA1Xre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:34 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 113/114] x86: rename X86_GENERICARCH to X86_32_NON_STANDARD
Date: Wed, 28 Jan 2009 23:42:59 +0000
Message-Id: <1233186180-29883-114-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_GENERICARCH is a misnomer - it contains non-PC 32-bit architectures
that are not included in the default build.

Rename it to X86_32_NON_STANDARD.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig            |   22 +++++++++++-----------
 arch/x86/kernel/acpi/boot.c |    2 +-
 arch/x86/kernel/mpparse.c   |    2 +-
 arch/x86/kernel/setup.c     |    2 +-
 arch/x86/kernel/smpboot.c   |    2 +-
 drivers/mtd/nand/Kconfig    |    2 +-
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4773f1c..1427cb1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -344,7 +344,7 @@ config X86_VOYAGER
 	  If you do not specifically know you have a Voyager based machine,
 	  say N here, otherwise the kernel you build will not be bootable.
 
-config X86_GENERICARCH
+config X86_32_NON_STANDARD
 	bool "Support non-standard 32-bit SMP architectures"
 	depends on X86_32 && SMP
 	depends on X86_NON_STANDARD
@@ -356,7 +356,7 @@ config X86_GENERICARCH
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	depends on X86_GENERICARCH
+	depends on X86_32_NON_STANDARD
 	select NUMA
 	select X86_MPPARSE
 	help
@@ -368,21 +368,21 @@ config X86_NUMAQ
 
 config X86_SUMMIT
 	bool "Summit/EXA (IBM x440)"
-	depends on X86_GENERICARCH
+	depends on X86_32_NON_STANDARD
 	help
 	  This option is needed for IBM systems that use the Summit/EXA chipset.
 	  In particular, it is needed for the x440.
 
 config X86_ES7000
 	bool "Support for Unisys ES7000 IA32 series"
-	depends on X86_GENERICARCH
+	depends on X86_32_NON_STANDARD
 	help
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
 config X86_BIGSMP
 	bool "Support for big SMP systems with more than 8 CPUs"
-	depends on X86_GENERICARCH
+	depends on X86_32_NON_STANDARD
 	help
 	  This option is needed for the systems that have more than 8 CPUs
 	  and if the system is not of any sub-arch type above.
@@ -475,11 +475,11 @@ config MEMTEST
 
 config X86_SUMMIT_NUMA
 	def_bool y
-	depends on X86_32 && NUMA && X86_GENERICARCH
+	depends on X86_32 && NUMA && X86_32_NON_STANDARD
 
 config X86_CYCLONE_TIMER
 	def_bool y
-	depends on X86_GENERICARCH
+	depends on X86_32_NON_STANDARD
 
 source "arch/x86/Kconfig.cpu"
 
@@ -651,7 +651,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !X86_GENERICARCH
+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
 	help
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -676,11 +676,11 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_GENERICARCH || X86_UP_APIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_GENERICARCH || X86_UP_APIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
 
 config X86_VISWS_APIC
 	def_bool y
@@ -1122,7 +1122,7 @@ config ARCH_SPARSEMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_GENERICARCH
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_32_NON_STANDARD
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index cb8b527..7352c60 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1335,7 +1335,7 @@ static void __init acpi_process_madt(void)
 		if (!error) {
 			acpi_lapic = 1;
 
-#ifdef CONFIG_X86_GENERICARCH
+#ifdef CONFIG_X86_32_NON_STANDARD
 			generic_bigsmp_probe();
 #endif
 			/*
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 94fe710..89aaced 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -372,7 +372,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			(*x86_quirks->mpc_record)++;
 	}
 
-#ifdef CONFIG_X86_GENERICARCH
+#ifdef CONFIG_X86_32_NON_STANDARD
        generic_bigsmp_probe();
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6abce67..f64e1a4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -936,7 +936,7 @@ void __init setup_arch(char **cmdline_p)
 	map_vsyscall();
 #endif
 
-#ifdef CONFIG_X86_GENERICARCH
+#ifdef CONFIG_X86_32_NON_STANDARD
 	generic_apic_probe();
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bc7e220..fc80bc1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1007,7 +1007,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 
 		printk(KERN_WARNING
 		       "More than 8 CPUs detected - skipping them.\n"
-		       "Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
+		       "Use CONFIG_X86_32_NON_STANDARD and CONFIG_X86_BIGSMP.\n");
 
 		nr = 0;
 		for_each_present_cpu(cpu) {
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 8b12e6e..9289236 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -273,7 +273,7 @@ config MTD_NAND_CAFE
 
 config MTD_NAND_CS553X
 	tristate "NAND support for CS5535/CS5536 (AMD Geode companion chip)"
-	depends on X86_32 && (X86_PC || X86_GENERICARCH)
+	depends on X86_32 && (X86_PC || X86_32_NON_STANDARD)
 	help
 	  The CS553x companion chips for the AMD Geode processor
 	  include NAND flash controllers with built-in hardware ECC
-- 
1.6.0.2

