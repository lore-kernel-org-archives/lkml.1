Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYGKBZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYGKBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbYGKBYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:24:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:48436 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbYGKBYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:24:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] x86: make only GART code include gart.h
Date: Fri, 11 Jul 2008 10:23:42 +0900
Message-Id: <1215739425-28399-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gart.h has only GART-specific stuff. Only GART code needs it. Other
IOMMU stuff should include iommu.h instead of gart.h.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 arch/x86/kernel/aperture_64.c    |    1 +
 arch/x86/kernel/early-quirks.c   |    5 +----
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 arch/x86/kernel/pci-dma.c        |    2 +-
 arch/x86/kernel/pci-gart_64.c    |    1 +
 arch/x86/kernel/pci-nommu.c      |    2 +-
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 arch/x86/kernel/setup.c          |    2 +-
 drivers/pci/intel-iommu.c        |    2 +-
 include/asm-x86/gart.h           |    1 -
 12 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f2766d8..cf2f74b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -23,7 +23,7 @@
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
 #include <asm/proto.h>
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index bb02800..00de43d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -25,7 +25,7 @@
 #include <asm/pci-direct.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
-#include <asm/gart.h>
+#include <asm/iommu.h>
 
 /*
  * definitions for the ACPI scanning code
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 9f90780..44e2182 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -21,6 +21,7 @@
 #include <linux/suspend.h>
 #include <asm/e820.h>
 #include <asm/io.h>
+#include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index a4665f3..510b8e3 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -16,10 +16,7 @@
 #include <asm/dma.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
-
-#ifdef CONFIG_GART_IOMMU
-#include <asm/gart.h>
-#endif
+#include <asm/iommu.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 4035759..d9e804d 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -36,7 +36,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
 #include <asm/pci-direct.h>
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b7dd70f..6eb7470 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -5,7 +5,7 @@
 
 #include <asm/proto.h>
 #include <asm/dma.h>
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index d0d18db..949ca98 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -32,6 +32,7 @@
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index aec43d5..792b917 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -7,7 +7,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 82299cd..20df839 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 098208d..fef7d0a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -96,7 +96,7 @@
 #include <asm/smp.h>
 #include <asm/desc.h>
 #include <asm/dma.h>
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index bb06423..7868065 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -37,7 +37,7 @@
 #include "intel-iommu.h"
 #include <asm/proto.h> /* force_iommu in this header in x86-64*/
 #include <asm/cacheflush.h>
-#include <asm/gart.h>
+#include <asm/iommu.h>
 #include "pci.h"
 
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 33b9aee..3f62a83 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -2,7 +2,6 @@
 #define _ASM_X8664_GART_H 1
 
 #include <asm/e820.h>
-#include <asm/iommu.h>
 
 extern void set_up_gart_resume(u32, u32);
 
-- 
1.5.5.GIT

