Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXKLU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXKLU7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXKLU67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:58:59 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39804 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXKLU65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:58:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: add X86_32 dependency to i386 specific symbols in Kconfig.i386
Date: Mon, 12 Nov 2007 22:00:27 +0100
Message-Id: <1194901236-22820-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1194901236-22820-3-git-send-email-sam@ravnborg.org>
References: <20071112205451.GA22528@uranus.ravnborg.org>
 <1194901236-22820-1-git-send-email-sam@ravnborg.org>
 <1194901236-22820-2-git-send-email-sam@ravnborg.org>
 <1194901236-22820-3-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To ease unification of Kconfig.i386 and Kconfig.x86_64
add X86_32 dependencies to all i386 specific symbols.

This patch introduce no functional changes but is one step
towards unification. This smaller step is used to ease
review of the patch set.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig.i386 |   90 +++++++++++++++++++++++++++++--------------------
 1 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 9fe63f1..174b909 100644
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
@@ -264,7 +271,7 @@ endif
 config ACPI_SRAT
 	bool
 	default y
-	depends on ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
+	depends on X86_32 && ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
 	select ACPI_NUMA
 
 config HAVE_ARCH_PARSE_SRAT
@@ -275,12 +282,12 @@ config HAVE_ARCH_PARSE_SRAT
 config X86_SUMMIT_NUMA
 	bool
 	default y
-	depends on NUMA && (X86_SUMMIT || X86_GENERICARCH)
+	depends on X86_32 && NUMA && (X86_SUMMIT || X86_GENERICARCH)
 
 config X86_CYCLONE_TIMER
 	bool
 	default y
-	depends on X86_SUMMIT || X86_GENERICARCH
+	depends on X86_32 && X86_SUMMIT || X86_GENERICARCH
 
 config ES7000_CLUSTERED_APIC
 	bool
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
@@ -366,17 +374,17 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	bool
-	depends on X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH
+	depends on X86_32 && (X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH)
 	default y
 
 config X86_IO_APIC
 	bool
-	depends on X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH
+	depends on X86_32 && (X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH)
 	default y
 
 config X86_VISWS_APIC
 	bool
-	depends on X86_VISWS
+	depends on X86_32 && X86_VISWS
 	default y
 
 config X86_MCE
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
 
@@ -617,16 +630,17 @@ config PAGE_OFFSET
 	default 0x78000000 if VMSPLIT_2G_OPT
 	default 0x40000000 if VMSPLIT_1G
 	default 0xC0000000
+	depends on X86_32
 
 config HIGHMEM
 	bool
-	depends on HIGHMEM64G || HIGHMEM4G
+	depends on X86_32 && (HIGHMEM64G || HIGHMEM4G)
 	default y
 
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
 	default n
-	depends on !HIGHMEM4G
+	depends on X86_32 && !HIGHMEM4G
 	select RESOURCES_64BIT
 	help
 	  PAE is required for NX support, and furthermore enables
@@ -637,7 +651,7 @@ config X86_PAE
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
-	depends on SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
+	depends on X86_32 && SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
 	help
@@ -646,7 +660,7 @@ config NUMA
 	  cause boot failures.
 
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
-	depends on X86_SUMMIT && (!HIGHMEM64G || !ACPI)
+	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
 
 config NODES_SHIFT
 	int
@@ -656,27 +670,27 @@ config NODES_SHIFT
 
 config HAVE_ARCH_BOOTMEM_NODE
 	bool
-	depends on NUMA
+	depends on X86_32 && NUMA
 	default y
 
 config ARCH_HAVE_MEMORY_PRESENT
 	bool
-	depends on DISCONTIGMEM
+	depends on X86_32 && DISCONTIGMEM
 	default y
 
 config NEED_NODE_MEMMAP_SIZE
 	bool
-	depends on DISCONTIGMEM || SPARSEMEM
+	depends on X86_32 && (DISCONTIGMEM || SPARSEMEM)
 	default y
 
 config HAVE_ARCH_ALLOC_REMAP
 	bool
-	depends on NUMA
+	depends on X86_32 && NUMA
 	default y
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on (ARCH_SELECT_MEMORY_MODEL && X86_PC)
+	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
@@ -689,11 +703,11 @@ config ARCH_DISCONTIGMEM_DEFAULT
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on (NUMA || (X86_PC && EXPERIMENTAL))
-	select SPARSEMEM_STATIC
+	select SPARSEMEM_STATIC if X86_32
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
-	depends on ARCH_SPARSEMEM_ENABLE
+	depends on X86_32 && ARCH_SPARSEMEM_ENABLE
 
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
@@ -702,7 +716,7 @@ source "mm/Kconfig"
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
-	depends on HIGHMEM4G || HIGHMEM64G
+	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
 	help
 	  The VM uses one page table entry for each page of physical memory.
 	  For systems with a lot of RAM, this can be wasteful of precious
@@ -710,7 +724,8 @@ config HIGHPTE
 	  entries in high memory.
 
 config MATH_EMULATION
-	bool "Math emulation"
+	bool
+	prompt "Math emulation" if X86_32
 	---help---
 	  Linux can emulate a math coprocessor (used for floating point
 	  operations) if you don't have one. 486DX and Pentium processors have
@@ -770,7 +785,7 @@ config MTRR
 
 config EFI
 	bool "Boot from EFI support"
-	depends on ACPI
+	depends on X86_32 && ACPI
 	default n
 	---help---
 	This enables the kernel to boot on EFI platforms using
@@ -788,7 +803,7 @@ config EFI
 
 config IRQBALANCE
  	bool "Enable kernel irq balancing"
-	depends on SMP && X86_IO_APIC
+	depends on X86_32 && SMP && X86_IO_APIC
 	default y
 	help
  	  The default yes will allow the kernel to do irq load balancing.
@@ -798,7 +813,7 @@ config IRQBALANCE
 # Summit needs it only when NUMA is on
 config BOOT_IOREMAP
 	bool
-	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
+	depends on X86_32 && (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
 	default y
 
 config SECCOMP
@@ -907,7 +922,8 @@ config RELOCATABLE
 	  kernel.
 
 config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned"
+	hex
+	prompt "Alignment value to which kernel should be aligned" if X86_32
 	default "0x100000"
 	range 0x2000 0x400000
 	help
@@ -940,6 +956,7 @@ config HOTPLUG_CPU
 config COMPAT_VDSO
 	bool "Compat VDSO support"
 	default y
+	depends on X86_32
 	help
 	  Map the VDSO to the predictable old-style address too.
 	---help---
@@ -974,7 +991,7 @@ config GENERIC_PENDING_IRQ
 
 config X86_SMP
 	bool
-	depends on SMP && !X86_VOYAGER
+	depends on X86_32 && SMP && !X86_VOYAGER
 	default y
 
 config X86_HT
@@ -984,7 +1001,7 @@ config X86_HT
 
 config X86_BIOS_REBOOT
 	bool
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
 	default y
 
 config X86_TRAMPOLINE
@@ -993,7 +1010,6 @@ config X86_TRAMPOLINE
 	default y
 
 config KTIME_SCALAR
-	bool
-	default y
+	def_bool X86_32
 
 source "arch/x86/Kconfig"
-- 
1.5.3.4.1157.g0e74-dirty

