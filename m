Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbXKIXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbXKIXTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXKIXTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:19:10 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60643 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbXKIXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:19:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 05/11] x86: add X86_64 dependency to x86_64 specific symbols in Kconfig.x86_64
Date: Sat, 10 Nov 2007 00:20:39 +0100
Message-Id: <11946504462035-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To ease unification of Kconfig.i386 and Kconfig.x86_64
add X86_64 dependencies to all x86_64 specific symbols.

This patch introduce no functional changes but is one step
towards unification. This smaller step is used to ease
review of the patch set.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig.x86_64 |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index cdd1458..36bb856 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -18,7 +18,7 @@ config X86_64
 	  <http://www.x86-64.org/>.
 
 config 64BIT
-	def_bool y
+	def_bool X86_64
 
 config X86
 	bool
@@ -129,7 +129,7 @@ config X86_PC
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on PCI
+	depends on X86_64 && PCI
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -275,7 +275,7 @@ config NUMA
 
 config K8_NUMA
        bool "Old style AMD Opteron NUMA detection"
-       depends on NUMA && PCI
+       depends on X86_64 && NUMA && PCI
        default y
        help
 	 Enable K8 NUMA node topology detection.  You should say Y here if
@@ -286,14 +286,14 @@ config K8_NUMA
 
 config NODES_SHIFT
 	int
-	default "6"
+	default "6" if X86_64
 	depends on NEED_MULTIPLE_NODES
 
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
-       depends on NUMA
+       depends on X86_64 && NUMA
        select ACPI 
 	select PCI
        select ACPI_NUMA
@@ -303,7 +303,7 @@ config X86_64_ACPI_NUMA
 
 config NUMA_EMU
 	bool "NUMA emulation"
-	depends on NUMA
+	depends on X86_64 && NUMA
 	help
 	  Enable NUMA emulation. A flat machine will be split
 	  into virtual nodes when booted with "numa=fake=N", where N is the
@@ -324,7 +324,7 @@ config ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_MEMORY_PROBE
-	def_bool y
+	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
 config ARCH_FLATMEM_ENABLE
@@ -334,15 +334,15 @@ config ARCH_FLATMEM_ENABLE
 source "mm/Kconfig"
 
 config MEMORY_HOTPLUG_RESERVE
-	def_bool y
+	def_bool X86_64
 	depends on (MEMORY_HOTPLUG && DISCONTIGMEM)
 
 config HAVE_ARCH_EARLY_PFN_TO_NID
-	def_bool y
+	def_bool X86_64
 	depends on NUMA
 
 config OUT_OF_LINE_PFN_TO_PAGE
-	def_bool y
+	def_bool X86_64
 	depends on DISCONTIGMEM
 
 config NR_CPUS
@@ -360,7 +360,7 @@ config NR_CPUS
 
 config PHYSICAL_ALIGN
 	hex
-	default "0x200000"
+	default "0x200000" if X86_64
 
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
@@ -399,7 +399,7 @@ config GART_IOMMU
 	default y
 	select SWIOTLB
 	select AGP
-	depends on PCI
+	depends on X86_64 && PCI
 	help
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -414,7 +414,7 @@ config GART_IOMMU
 config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
 	select SWIOTLB
-	depends on PCI && EXPERIMENTAL
+	depends on X86_64 && PCI && EXPERIMENTAL
 	help
 	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
 	  systems. Needed to run systems with more than 3GB of memory
@@ -461,7 +461,7 @@ config X86_MCE
 
 config X86_MCE_INTEL
 	bool "Intel MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
 	default y
 	help
 	   Additional support for intel specific MCE features such as
@@ -469,7 +469,7 @@ config X86_MCE_INTEL
 
 config X86_MCE_AMD
 	bool "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
 	default y
 	help
 	   Additional support for AMD specific MCE features such as
@@ -576,7 +576,7 @@ config SECCOMP
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on X86_64 && EXPERIMENTAL
 	help
          This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of critical functions, a canary
@@ -601,7 +601,7 @@ config CC_STACKPROTECTOR_ALL
 source kernel/Kconfig.hz
 
 config K8_NB
-	def_bool y
+	def_bool X86_64
 	depends on AGP_AMD64 || GART_IOMMU || (PCI && NUMA)
 
 endmenu
-- 
1.5.3.4.1157.g0e74-dirty

