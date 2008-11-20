Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYKTPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYKTPwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYKTPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:06 -0500
Received: from mail05.svc.cra.dublin.eircom.net ([159.134.118.21]:42262 "HELO
	mail05.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754924AbYKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:01 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/8] intel-iommu: move DMA_32/64BIT_PFN into intel-iommu.c
Date: Thu, 20 Nov 2008 15:49:43 +0000
Message-Id: <1227196190-488-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227191861.4901.24.camel@macbook.infradead.org>
References: <1227191861.4901.24.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |    3 +++
 include/linux/dma_remapping.h |    5 -----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 5721196..a9032e6 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -53,6 +53,9 @@
 
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
+#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
+#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
+#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
 
 static void flush_unmaps_timeout(unsigned long data);
 
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index cf92c49..2e5a5c0 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -9,11 +9,6 @@
 #define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
 #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAGE_MASK)
 
-#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
-#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
-#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
-
-
 /*
  * 0: Present
  * 1-11: Reserved
-- 
1.5.4.3

