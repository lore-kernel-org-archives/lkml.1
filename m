Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXJXKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXJXKvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbXJXKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:50:16 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:30895 "EHLO
	mail72-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbXJXKuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:50:09 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 2/4] x86 gart: rename CONFIG_IOMMU to CONFIG_GART_IOMMU
Date: Wed, 24 Oct 2007 12:49:48 +0200
Message-ID: <11932229901757-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11932229902428-git-send-email-joerg.roedel@amd.com>
References: <11932229902428-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Oct 2007 10:49:50.0899 (UTC)
 FILETIME=[9A590830:01C8162B]
MIME-Version: 1.0
X-WSS-ID: 6B01FCD90QK73691-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the IOMMU config option to GART_IOMMU because in fact it
means the GART and not general support for an IOMMU on x86.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86/kernel/Makefile_64    |    2 +-
 arch/x86/kernel/early-quirks.c |    4 ++--
 arch/x86/kernel/pci-dma_64.c   |    6 +++---
 arch/x86_64/Kconfig            |    4 ++--
 arch/x86_64/Kconfig.debug      |    2 +-
 arch/x86_64/defconfig          |    2 +-
 drivers/char/agp/Kconfig       |    4 ++--
 drivers/char/agp/amd64-agp.c   |    2 +-
 drivers/usb/core/message.c     |    2 +-
 include/asm-x86/gart.h         |    2 +-
 include/asm-x86/pci_64.h       |    2 +-
 11 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 466337a..24671c3 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -25,7 +25,7 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_64.o
 obj-$(CONFIG_PM)		+= suspend_64.o
 obj-$(CONFIG_HIBERNATION)	+= suspend_asm_64.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_IOMMU)		+= pci-gart_64.o aperture_64.o
+obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes_64.o
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4770273..5330745 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -17,13 +17,13 @@
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 #include <asm/gart.h>
 #endif
 
 static void __init via_bugs(void)
 {
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
 	    !iommu_aperture_allowed) {
 		printk(KERN_INFO
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 730339f..66b3dc5 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -275,7 +275,7 @@ __init int iommu_setup(char *p)
 			swiotlb = 1;
 #endif
 
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 		gart_parse_options(p);
 #endif
 
@@ -298,7 +298,7 @@ void __init pci_iommu_alloc(void)
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
 	 */
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 	iommu_hole_init();
 #endif
 
@@ -321,7 +321,7 @@ static int __init pci_iommu_init(void)
 
 	intel_iommu_init();
 
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 	gart_iommu_init();
 #endif
 
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 3fc9e37..a5b4356 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -479,7 +479,7 @@ config HPET_EMULATE_RTC
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
-config IOMMU
+config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
@@ -687,7 +687,7 @@ source kernel/Kconfig.hz
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || IOMMU || (PCI && NUMA)
+	depends on AGP_AMD64 || GART_IOMMU || (PCI && NUMA)
 
 endmenu
 
diff --git a/arch/x86_64/Kconfig.debug b/arch/x86_64/Kconfig.debug
index 775d211..6035468 100644
--- a/arch/x86_64/Kconfig.debug
+++ b/arch/x86_64/Kconfig.debug
@@ -17,7 +17,7 @@ config DEBUG_RODATA
 	 If in doubt, say "N".
 
 config IOMMU_DEBUG
-       depends on IOMMU && DEBUG_KERNEL
+       depends on GART_IOMMU && DEBUG_KERNEL
        bool "Enable IOMMU debugging"
        help
          Force the IOMMU to on even when you have less than 4GB of
diff --git a/arch/x86_64/defconfig b/arch/x86_64/defconfig
index b091c5e..38a83f9 100644
--- a/arch/x86_64/defconfig
+++ b/arch/x86_64/defconfig
@@ -170,7 +170,7 @@ CONFIG_HOTPLUG_CPU=y
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 CONFIG_HPET_TIMER=y
 CONFIG_HPET_EMULATE_RTC=y
-CONFIG_IOMMU=y
+CONFIG_GART_IOMMU=y
 # CONFIG_CALGARY_IOMMU is not set
 CONFIG_SWIOTLB=y
 CONFIG_X86_MCE=y
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index f22c253..ccb1fa8 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -56,9 +56,9 @@ config AGP_AMD
 	  X on AMD Irongate, 761, and 762 chipsets.
 
 config AGP_AMD64
-	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !IOMMU
+	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !GART_IOMMU
 	depends on AGP && X86
-	default y if IOMMU
+	default y if GART_IOMMU
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d95662e..d8200ac 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -787,7 +787,7 @@ static void __exit agp_amd64_cleanup(void)
 
 /* On AMD64 the PCI driver needs to initialize this driver early
    for the IOMMU, so it has to be called via a backdoor. */
-#ifndef CONFIG_IOMMU
+#ifndef CONFIG_GART_IOMMU
 module_init(agp_amd64_init);
 module_exit(agp_amd64_cleanup);
 #endif
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 8bdaa15..fbdc6a9 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -434,7 +434,7 @@ int usb_sg_init (
 		if (dma) {
 			io->urbs [i]->transfer_dma = sg_dma_address (sg + i);
 			len = sg_dma_len (sg + i);
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_IOMMU)
+#if defined(CONFIG_HIGHMEM) || defined(CONFIG_GART_IOMMU)
 			io->urbs[i]->transfer_buffer = NULL;
 #else
 			io->urbs[i]->transfer_buffer = sg_virt(&sg[i]);
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 07862fd..cb7e989 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -5,7 +5,7 @@ extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 extern void gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
diff --git a/include/asm-x86/pci_64.h b/include/asm-x86/pci_64.h
index 9baa46d..ef54226 100644
--- a/include/asm-x86/pci_64.h
+++ b/include/asm-x86/pci_64.h
@@ -37,7 +37,7 @@ extern int iommu_setup(char *opt);
  */
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
+#if defined(CONFIG_GART_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
 
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
-- 
1.5.2.5



