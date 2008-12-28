Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYL1GFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYL1GFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 01:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYL1GF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 01:05:28 -0500
Received: from sh.osrg.net ([192.16.179.4]:53861 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYL1GF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 01:05:27 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/3] replace architecture-specific swiotlb.h with linux/swiotlb.h
Date: Sun, 28 Dec 2008 15:02:05 +0900
Message-Id: <1230444127-587-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces architecture-specific swiotlb.h (X86 and IA64) with
linux/swiotlb.h.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/swiotlb.h |   39 +--------------------------------------
 arch/x86/include/asm/swiotlb.h  |   38 +-------------------------------------
 2 files changed, 2 insertions(+), 75 deletions(-)

diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index fb79423..dcbaea7 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -2,44 +2,7 @@
 #define ASM_IA64__SWIOTLB_H
 
 #include <linux/dma-mapping.h>
-
-/* SWIOTLB interface */
-
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
+#include <linux/swiotlb.h>
 
 extern int swiotlb_force;
 
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 51fb2c7..b9e4e20 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -1,46 +1,10 @@
 #ifndef _ASM_X86_SWIOTLB_H
 #define _ASM_X86_SWIOTLB_H
 
-#include <asm/dma-mapping.h>
+#include <linux/swiotlb.h>
 
 /* SWIOTLB interface */
 
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
-
 extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
-- 
1.5.5.GIT

