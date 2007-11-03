Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXKCXuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXKCXuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbXKCXtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:49:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52684 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbXKCXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:49:44 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 04/10] x86: add X86_32 dependency to i386 specific symbols in Kconfig.i386
Date: Sun,  4 Nov 2007 00:51:14 +0100
Message-Id: <11941338802525-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11941338801910-git-send-email-sam@ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To ease unification of Kconfig.i386 and Kconfig.x86_64
add X86_32 dependencies to all i386 specific symbols.

This patch introduce no functional changes but is one step
towards unification. This smaller step is used to ease
review of the patch set.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig.i386 |   52 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 8f79cdd..af72240 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -137,6 +137,7 @@ config X86_PC
 
 config X86_ELAN
 	bool "AMD Elan"
+	depends on X86_32
 	help
 	  Select this for an AMD Elan processor.
 
@@ -146,6 +147,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
+	depends on X86_32
 	select SMP if !BROKEN
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
@@ -160,6 +162,7 @@ config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
 	select SMP
 	select NUMA
+	depends on X86_32
 	help
 	  This option is used for getting Linux to run on a (IBM/Sequent) NUMA
 	  multiquad box. This changes the way that processors are bootstrapped,
@@ -169,7 +172,7 @@ config X86_NUMAQ
 
 config X86_SUMMIT
 	bool "Summit/EXA (IBM x440)"
-	depends on SMP
+	depends on X86_32 && SMP
 	help
 	  This option is needed for IBM systems that use the Summit/EXA chipset.
 	  In particular, it is needed for the x440.
@@ -179,7 +182,7 @@ config X86_SUMMIT
 
 config X86_BIGSMP
 	bool "Support for other sub-arch SMP systems with more than 8 CPUs"
-	depends on SMP
+	depends on X86_32 && SMP
 	help
 	  This option is needed for the systems that have more than 8 CPUs
 	  and if the system is not of any sub-arch type above.
@@ -188,6 +191,7 @@ config X86_BIGSMP
 
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
+	depends on X86_32
 	help
 	  The SGI Visual Workstation series is an IA32-based workstation
 	  based on SGI systems chips with some legacy PC hardware attached.
@@ -199,6 +203,7 @@ config X86_VISWS
 
 config X86_GENERICARCH
        bool "Generic architecture (Summit, bigsmp, ES7000, default)"
+	depends on X86_32
        help
           This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
 	  It is intended for a generic binary kernel.
@@ -206,7 +211,7 @@ config X86_GENERICARCH
 
 config X86_ES7000
 	bool "Support for Unisys ES7000 IA32 series"
-	depends on SMP
+	depends on X86_32 && SMP
 	help
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
@@ -218,6 +223,7 @@ endchoice
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	bool "Single-depth WCHAN output"
 	default y
+	depends on X86_32
 	help
 	  Calculate simpler /proc/<PID>/wchan values. If this option
 	  is disabled then wchan values will recurse back to the
@@ -228,7 +234,7 @@ config SCHED_NO_NO_OMIT_FRAME_POINTER
 
 config PARAVIRT
 	bool
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This changes the kernel so it can modify itself when it is run
 	  under a hypervisor, potentially improving performance significantly
@@ -237,6 +243,7 @@ config PARAVIRT
 
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
+	depends on X86_32
 	help
 	  Say Y here to get to see options related to running Linux under
 	  various hypervisors.  This option alone does not add any kernel code.
@@ -290,7 +297,8 @@ config ES7000_CLUSTERED_APIC
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
-	bool "HPET Timer Support"
+	bool
+	prompt "HPET Timer Support" if X86_32
 	help
 	  This enables the use of the HPET for the kernel's internal timer.
 	  HPET is the next generation timer replacing legacy 8254s.
@@ -341,7 +349,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on !SMP && !(X86_VISWS || X86_VOYAGER || X86_GENERICARCH)
+	depends on X86_32 && !SMP && !(X86_VISWS || X86_VOYAGER || X86_GENERICARCH)
 	help
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -398,7 +406,7 @@ config X86_MCE
 
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_MCE
+	depends on X86_32 && X86_MCE
 	help
 	  Enabling this feature starts a timer that triggers every 5 seconds which
 	  will look at the machine check registers to see if anything happened.
@@ -411,14 +419,15 @@ config X86_MCE_NONFATAL
 
 config X86_MCE_P4THERMAL
 	bool "check for P4 thermal throttling interrupt."
-	depends on X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
+	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
 	help
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
 
 config VM86
-	default y
 	bool "Enable VM86 support" if EMBEDDED
+	default y
+	depends on X86_32
 	help
           This option is required by programs like DOSEMU to run 16-bit legacy
 	  code on X86 processors. It also may be needed by software like
@@ -427,6 +436,7 @@ config VM86
 
 config TOSHIBA
 	tristate "Toshiba Laptop support"
+	depends on X86_32
 	---help---
 	  This adds a driver to safely access the System Management Mode of
 	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
@@ -442,6 +452,7 @@ config TOSHIBA
 
 config I8K
 	tristate "Dell laptop support"
+	depends on X86_32
 	---help---
 	  This adds a driver to safely access the System Management Mode
 	  of the CPU on the Dell Inspiron 8000. The System Management Mode
@@ -462,7 +473,7 @@ config I8K
 
 config X86_REBOOTFIXUPS
 	bool "Enable X86 board specific fixups for reboot"
-	depends on X86
+	depends on X86_32 && X86
 	default n
 	---help---
 	  This enables chipset and/or board specific fixups to be done
@@ -521,6 +532,7 @@ choice
 	prompt "High Memory Support"
 	default HIGHMEM4G if !X86_NUMAQ
 	default HIGHMEM64G if X86_NUMAQ
+	depends on X86_32
 
 config NOHIGHMEM
 	bool "off"
@@ -580,6 +592,7 @@ choice
 	depends on EXPERIMENTAL
 	prompt "Memory split" if EMBEDDED
 	default VMSPLIT_3G
+	depends on X86_32
 	help
 	  Select the desired split between kernel and user memory.
 
@@ -626,7 +639,7 @@ config HIGHMEM
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
 	default n
-	depends on !HIGHMEM4G
+	depends on X86_32 && !HIGHMEM4G
 	select RESOURCES_64BIT
 	help
 	  PAE is required for NX support, and furthermore enables
@@ -637,7 +650,7 @@ config X86_PAE
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
-	depends on SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
+	depends on X86_32 && SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
 	help
@@ -646,7 +659,7 @@ config NUMA
 	  cause boot failures.
 
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
-	depends on X86_SUMMIT && (!HIGHMEM64G || !ACPI)
+	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
 
 config NODES_SHIFT
 	int
@@ -702,7 +715,7 @@ source "mm/Kconfig"
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
-	depends on HIGHMEM4G || HIGHMEM64G
+	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
 	help
 	  The VM uses one page table entry for each page of physical memory.
 	  For systems with a lot of RAM, this can be wasteful of precious
@@ -710,7 +723,8 @@ config HIGHPTE
 	  entries in high memory.
 
 config MATH_EMULATION
-	bool "Math emulation"
+	bool
+	prompt "Math emulation" if X86_32
 	---help---
 	  Linux can emulate a math coprocessor (used for floating point
 	  operations) if you don't have one. 486DX and Pentium processors have
@@ -770,7 +784,7 @@ config MTRR
 
 config EFI
 	bool "Boot from EFI support"
-	depends on ACPI
+	depends on X86_32 && ACPI
 	default n
 	---help---
 	This enables the kernel to boot on EFI platforms using
@@ -788,7 +802,7 @@ config EFI
 
 config IRQBALANCE
  	bool "Enable kernel irq balancing"
-	depends on SMP && X86_IO_APIC
+	depends on X86_32 && SMP && X86_IO_APIC
 	default y
 	help
  	  The default yes will allow the kernel to do irq load balancing.
@@ -907,7 +921,8 @@ config RELOCATABLE
 	  kernel.
 
 config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned"
+	hex
+	prompt "Alignment value to which kernel should be aligned" if X86_32
 	default "0x100000"
 	range 0x2000 0x400000
 	help
@@ -940,6 +955,7 @@ config HOTPLUG_CPU
 config COMPAT_VDSO
 	bool "Compat VDSO support"
 	default y
+	depends on X86_32
 	help
 	  Map the VDSO to the predictable old-style address too.
 	---help---
-- 
1.5.3.4.1157.g0e74-dirty

