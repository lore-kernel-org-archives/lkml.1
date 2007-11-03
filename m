Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbXKCXw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbXKCXw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761181AbXKCXtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:49:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52693 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179AbXKCXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:49:44 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 06/10] x86: copy x86_64 specific Kconfig symbols to Kconifg.i386
Date: Sun,  4 Nov 2007 00:51:16 +0100
Message-Id: <11941338813125-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11941338802646-git-send-email-sam@ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <11941338802525-git-send-email-sam@ravnborg.org> <11941338802646-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.
A prepatory step towards full unification.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig.i386 |  124 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index af72240..890c258 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -218,6 +218,14 @@ config X86_ES7000
 	  Only choose this option if you have such a system, otherwise you
 	  should say N here.
 
+config X86_VSMP
+	bool "Support for ScaleMP vSMP"
+	depends on X86_64 && PCI
+	 help
+	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
+	  supposed to run on these EM64T-based machines.  Only choose this option
+	  if you have one of these machines.
+
 endchoice
 
 config SCHED_NO_NO_OMIT_FRAME_POINTER
@@ -313,6 +321,54 @@ config HPET_EMULATE_RTC
 	depends on HPET_TIMER && RTC=y
 	default y
 
+# Mark as embedded because too many people got it wrong.
+# The code disables itself when not needed.
+config GART_IOMMU
+	bool "GART IOMMU support" if EMBEDDED
+	default y
+	select SWIOTLB
+	select AGP
+	depends on X86_64 && PCI
+	help
+	  Support for full DMA access of devices with 32bit memory access only
+	  on systems with more than 3GB. This is usually needed for USB,
+	  sound, many IDE/SATA chipsets and some other devices.
+	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
+	  based hardware IOMMU and a software bounce buffer based IOMMU used
+	  on Intel systems and as fallback.
+	  The code is only active when needed (enough memory and limited
+	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
+	  too.
+
+config CALGARY_IOMMU
+	bool "IBM Calgary IOMMU support"
+	select SWIOTLB
+	depends on X86_64 && PCI && EXPERIMENTAL
+	help
+	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
+	  systems. Needed to run systems with more than 3GB of memory
+	  properly with 32-bit PCI devices that do not support DAC
+	  (Double Address Cycle). Calgary also supports bus level
+	  isolation, where all DMAs pass through the IOMMU.  This
+	  prevents them from going anywhere except their intended
+	  destination. This catches hard-to-find kernel bugs and
+	  mis-behaving drivers and devices that do not use the DMA-API
+	  properly to set up their DMA buffers.  The IOMMU can be
+	  turned off at boot time with the iommu=off parameter.
+	  Normally the kernel will make the right choice by itself.
+	  If unsure, say Y.
+
+config CALGARY_IOMMU_ENABLED_BY_DEFAULT
+	bool "Should Calgary be enabled by default?"
+	default y
+	depends on CALGARY_IOMMU
+	help
+	  Should Calgary be enabled by default? if you choose 'y', Calgary
+	  will be used (if it exists). If you choose 'n', Calgary will not be
+	  used even if it exists. If you choose 'n' and would like to use
+	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
+	  If unsure, say Y.
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-255)"
 	range 2 255
@@ -424,6 +480,22 @@ config X86_MCE_P4THERMAL
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
 
+config X86_MCE_INTEL
+	bool "Intel MCE features"
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	default y
+	help
+	   Additional support for intel specific MCE features such as
+	   the thermal monitor.
+
+config X86_MCE_AMD
+	bool "AMD MCE features"
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	default y
+	help
+	   Additional support for AMD specific MCE features such as
+	   the DRAM Error Threshold.
+
 config VM86
 	bool "Enable VM86 support" if EMBEDDED
 	default y
@@ -661,6 +733,34 @@ config NUMA
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
 
+config K8_NUMA
+       bool "Old style AMD Opteron NUMA detection"
+       depends on X86_64 && NUMA && PCI
+       default y
+       help
+	 Enable K8 NUMA node topology detection.  You should say Y here if
+	 you have a multi processor AMD K8 system. This uses an old
+	 method to read the NUMA configuration directly from the builtin
+	 Northbridge of Opteron. It is recommended to use X86_64_ACPI_NUMA
+	 instead, which also takes priority if both are compiled in.
+
+# Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
+config X86_64_ACPI_NUMA
+	bool "ACPI NUMA detection"
+	depends on X86_64 && NUMA && ACPI && PCI
+	select ACPI_NUMA
+	default y
+	help
+	  Enable ACPI SRAT based node topology detection.
+
+config NUMA_EMU
+	bool "NUMA emulation"
+	depends on X86_64 && NUMA
+	help
+	  Enable NUMA emulation. A flat machine will be split
+	  into virtual nodes when booted with "numa=fake=N", where N is the
+	  number of nodes. This is only useful for debugging.
+
 config NODES_SHIFT
 	int
 	default "4" if X86_NUMAQ
@@ -832,6 +932,30 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
+config CC_STACKPROTECTOR
+	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
+	depends on X86_64 && EXPERIMENTAL
+	help
+         This option turns on the -fstack-protector GCC feature. This
+	  feature puts, at the beginning of critical functions, a canary
+	  value on the stack just before the return address, and validates
+	  the value just before actually returning.  Stack based buffer
+	  overflows (that need to overwrite this return address) now also
+	  overwrite the canary, which gets detected and the attack is then
+	  neutralized via a kernel panic.
+
+	  This feature requires gcc version 4.2 or above, or a distribution
+	  gcc with the feature backported. Older versions are automatically
+	  detected and for those versions, this configuration option is ignored.
+
+config CC_STACKPROTECTOR_ALL
+	bool "Use stack-protector for all functions"
+	depends on CC_STACKPROTECTOR
+	help
+	  Normally, GCC only inserts the canary value protection for
+	  functions that use large-ish on-stack buffers. By enabling
+	  this option, GCC will be asked to do this for ALL functions.
+
 source kernel/Kconfig.hz
 
 config KEXEC
-- 
1.5.3.4.1157.g0e74-dirty

