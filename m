Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbXJSMii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbXJSMii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763442AbXJSMi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:38:28 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:46735 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055AbXJSMi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:38:27 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH] x86: rename iommu.h to gart.h
Date: Fri, 19 Oct 2007 14:38:11 +0200
Message-ID: <1192797491473-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 19 Oct 2007 12:38:12.0241 (UTC)
 FILETIME=[E9625810:01C8124C]
MIME-Version: 1.0
X-WSS-ID: 6B067ABC0602384072-01-01
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
 arch/x86/kernel/early-quirks_64.c   |    2 +-
 arch/x86/kernel/pci-calgary_64.c    |    2 +-
 arch/x86/kernel/pci-dma_64.c        |    2 +-
 arch/x86/kernel/pci-gart_64.c       |    2 +-
 arch/x86/kernel/pci-nommu_64.c      |    2 +-
 arch/x86/kernel/pci-swiotlb_64.c    |    2 +-
 arch/x86/kernel/reboot_64.c         |    2 +-
 arch/x86_64/Kconfig                 |    2 +-
 include/asm-x86/{iommu.h => gart.h} |    0 
 10 files changed, 9 insertions(+), 9 deletions(-)
 rename include/asm-x86/{iommu.h => gart.h} (100%)

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
diff --git a/arch/x86/kernel/early-quirks_64.c b/arch/x86/kernel/early-quirks_64.c
index 13aa4fd..8f0226e 100644
--- a/arch/x86/kernel/early-quirks_64.c
+++ b/arch/x86/kernel/early-quirks_64.c
@@ -14,7 +14,7 @@
 #include <linux/pci_ids.h>
 #include <asm/pci-direct.h>
 #include <asm/proto.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/dma.h>
 
 static void __init via_bugs(void)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 5098f58..c6d9de5 100644
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
index b2b42bd..176e87d 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -8,7 +8,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 0;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 5cdfab6..25f0c80 100644
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
index e85d436..8e768d2 100644
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
index 368db2b..ab56e02 100644
--- a/arch/x86/kernel/reboot_64.c
+++ b/arch/x86/kernel/reboot_64.c
@@ -16,7 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
-#include <asm/iommu.h>
+#include <asm/gart.h>
 
 /*
  * Power off function, if any
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 78cb68f..00d73d4 100644
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
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/gart.h
similarity index 100%
rename from include/asm-x86/iommu.h
rename to include/asm-x86/gart.h
-- 
1.5.2.5



