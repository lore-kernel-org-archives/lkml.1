Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYL1GGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYL1GGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 01:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYL1GFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 01:05:34 -0500
Received: from sh.osrg.net ([192.16.179.4]:53868 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYL1GFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 01:05:33 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 3/3] swiotlb: clean up EXPORT_SYMBOL usage
Date: Sun, 28 Dec 2008 15:02:07 +0900
Message-Id: <1230444127-587-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1230444127-587-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1230444127-587-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1230444127-587-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb uses EXPORT_SYMBOL in an inconsistent way. Some functions use
EXPORT_SYMBOL at the end of functions. Some use it at the end of
swiotlb.c.

This cleans up swiotlb to use EXPORT_SYMBOL in a consistent way (at
the end of functions).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index db94378..ad6abad 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -595,6 +595,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	*dma_handle = dev_addr;
 	return ret;
 }
+EXPORT_SYMBOL(swiotlb_alloc_coherent);
 
 void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
@@ -607,6 +608,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
 		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
+EXPORT_SYMBOL(swiotlb_free_coherent);
 
 static void
 swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
@@ -679,6 +681,7 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
 {
 	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_map_single);
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
@@ -708,6 +711,8 @@ swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
 {
 	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_unmap_single);
+
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
  * after a transfer.
@@ -737,6 +742,7 @@ swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_CPU);
 }
+EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
 
 void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
@@ -744,6 +750,7 @@ swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_DEVICE);
 }
+EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 
 /*
  * Same as above, but for a sub-range of the mapping.
@@ -769,6 +776,7 @@ swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_CPU);
 }
+EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
 
 void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
@@ -777,6 +785,7 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_DEVICE);
 }
+EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
 
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
@@ -835,6 +844,7 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_map_sg);
 
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
@@ -865,6 +875,7 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_unmap_sg);
 
 /*
  * Make physical memory consistent for a set of streaming mode DMA translations
@@ -897,6 +908,7 @@ swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_CPU);
 }
+EXPORT_SYMBOL(swiotlb_sync_sg_for_cpu);
 
 void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
@@ -904,12 +916,14 @@ swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_DEVICE);
 }
+EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
 	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
 }
+EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 
 /*
  * Return whether the given device DMA address mask can be supported
@@ -922,18 +936,4 @@ swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
 	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
 }
-
-EXPORT_SYMBOL(swiotlb_map_single);
-EXPORT_SYMBOL(swiotlb_unmap_single);
-EXPORT_SYMBOL(swiotlb_map_sg);
-EXPORT_SYMBOL(swiotlb_unmap_sg);
-EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
-EXPORT_SYMBOL(swiotlb_sync_single_for_device);
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
-EXPORT_SYMBOL(swiotlb_sync_sg_for_cpu);
-EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
-EXPORT_SYMBOL(swiotlb_dma_mapping_error);
-EXPORT_SYMBOL(swiotlb_alloc_coherent);
-EXPORT_SYMBOL(swiotlb_free_coherent);
 EXPORT_SYMBOL(swiotlb_dma_supported);
-- 
1.5.5.GIT

