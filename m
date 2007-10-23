Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbXJWRnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbXJWRnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXJWRnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:43:08 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:57125 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbXJWRnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:43:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 1/4] x86 gart: rename iommu.h to gart.h
Date: Tue, 23 Oct 2007 19:41:30 +0200
Message-ID: <11931612934151-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11931612933917-git-send-email-joerg.roedel@amd.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 23 Oct 2007 17:41:33.0696 (UTC)
 FILETIME=[F3F2F800:01C8159B]
MIME-Version: 1.0
X-WSS-ID: 6B00EDDA0QK8073-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the include file asm-x86/iommu.h to asm-x86/gart.h to make
clear to which IOMMU implementation it belongs. The patch also adds "GART" to
the Kconfig line.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/aperture_64.c       |    2 +-
 arch/x86/kernel/early-quirks.c      |    4 ++--
 arch/x86/kernel/pci-calgary_64.c    |    2 +-
 arch/x86/kernel/pci-dma_64.c        |    2 +-
 arch/x86/kernel/pci-gart_64.c       |    2 +-
 arch/x86/kernel/pci-nommu_64.c      |    2 +-
 arch/x86/kernel/pci-swiotlb_64.c    |    2 +-
 arch/x86/kernel/reboot_64.c         |    2 +-
 arch/x86_64/Kconfig                 |    2 +-
 drivers/pci/intel-iommu.c           |    2 +-
 include/asm-x86/{iommu.h => gart.h} |    4 ++--
 11 files changed, 13 insertions(+), 13 deletions(-)
 rename include/asm-x86/{iommu.h => gart.h} (92%)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 8f681ca..70c854f 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -20,7 +20,7 @@
 #include <linux/ioport.h>
 #include <asm/e820.h>
 #include <asm/io.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index dc34acb..d6e6e83 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -17,8 +17,8 @@
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 
-#ifdef CONFIG_IOMMU
-#include <asm/iommu.h>
+#ifdef CONFIG_GART_IOMMU
+#include <asm/gart.h>
 #endif
 
 static void __init via_bugs(void)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 1a20fe3..6bf1f71 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -36,7 +36,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
 #include <asm/pci-direct.h>
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 393e272..730339f 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 #include <linux/dmar.h>
 #include <asm/io.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 1;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c56e9ee..0e72abf 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -30,7 +30,7 @@
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index faf70bd..ab08e18 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -7,7 +7,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index b2f405e..102866d 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86/kernel/reboot_64.c b/arch/x86/kernel/reboot_64.c
index 776eb06..71b13c5 100644
--- a/arch/x86/kernel/reboot_64.c
+++ b/arch/x86/kernel/reboot_64.c
@@ -17,7 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 
 /*
  * Power off function, if any
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index c2d2499..198adad 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -480,7 +480,7 @@ config HPET_EMULATE_RTC
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
 config IOMMU
-	bool "IOMMU support" if EMBEDDED
+	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
 	select AGP
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b3d7031..10712b9 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -34,7 +34,7 @@
 #include "intel-iommu.h"
 #include <asm/proto.h> /* force_iommu in this header in x86-64*/
 #include <asm/cacheflush.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include "pci.h"
 
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/gart.h
similarity index 92%
rename from include/asm-x86/iommu.h
rename to include/asm-x86/gart.h
index 5af471f..07862fd 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/gart.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X8664_IOMMU_H
-#define _ASM_X8664_IOMMU_H 1
+#ifndef _ASM_X8664_GART_H
+#define _ASM_X8664_GART_H 1
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
-- 
1.5.2.5



