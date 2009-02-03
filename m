Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZBCJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZBCJh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZBCJhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:37:19 -0500
Received: from sh.osrg.net ([192.16.179.4]:37743 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbZBCJhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:37:17 -0500
Date: Tue, 3 Feb 2009 18:37:06 +0900
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Subject: [PATCH] remove unused include/asm-generic/dma-mapping.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090203183259Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Feb 2009 18:37:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that we don't need include/asm-generic/dma-mapping.h anymore.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] remove unused include/asm-generic/dma-mapping.h

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-generic/dma-mapping.h |  308 -------------------------------------
 1 files changed, 0 insertions(+), 308 deletions(-)
 delete mode 100644 include/asm-generic/dma-mapping.h

diff --git a/include/asm-generic/dma-mapping.h b/include/asm-generic/dma-mapping.h
deleted file mode 100644
index 189486c..0000000
--- a/include/asm-generic/dma-mapping.h
+++ /dev/null
@@ -1,308 +0,0 @@
-/* Copyright (C) 2002 by James.Bottomley@HansenPartnership.com 
- *
- * Implements the generic device dma API via the existing pci_ one
- * for unconverted architectures
- */
-
-#ifndef _ASM_GENERIC_DMA_MAPPING_H
-#define _ASM_GENERIC_DMA_MAPPING_H
-
-
-#ifdef CONFIG_PCI
-
-/* we implement the API below in terms of the existing PCI one,
- * so include it */
-#include <linux/pci.h>
-/* need struct page definitions */
-#include <linux/mm.h>
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	return pci_dma_supported(to_pci_dev(dev), mask);
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-}
-
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	return pci_alloc_consistent(to_pci_dev(dev), size, dma_handle);
-}
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_handle)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_free_consistent(to_pci_dev(dev), size, cpu_addr, dma_handle);
-}
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	return pci_map_single(to_pci_dev(dev), cpu_addr, size, (int)direction);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_unmap_single(to_pci_dev(dev), dma_addr, size, (int)direction);
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	return pci_map_page(to_pci_dev(dev), page, offset, size, (int)direction);
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_unmap_page(to_pci_dev(dev), dma_address, size, (int)direction);
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	return pci_map_sg(to_pci_dev(dev), sg, nents, (int)direction);
-}
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_unmap_sg(to_pci_dev(dev), sg, nhwentries, (int)direction);
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_dma_sync_single_for_cpu(to_pci_dev(dev), dma_handle,
-				    size, (int)direction);
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-			   enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_dma_sync_single_for_device(to_pci_dev(dev), dma_handle,
-				       size, (int)direction);
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_dma_sync_sg_for_cpu(to_pci_dev(dev), sg, nelems, (int)direction);
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		       enum dma_data_direction direction)
-{
-	BUG_ON(dev->bus != &pci_bus_type);
-
-	pci_dma_sync_sg_for_device(to_pci_dev(dev), sg, nelems, (int)direction);
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return pci_dma_mapping_error(to_pci_dev(dev), dma_addr);
-}
-
-
-#else
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	return 0;
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	BUG();
-	return 0;
-}
-
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	BUG();
-	return NULL;
-}
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_handle)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-	return 0;
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction direction)
-{
-	BUG();
-	return 0;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	BUG();
-	return 0;
-}
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-			   enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		       enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_error(dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-#endif
-
-/* Now for the API extensions over the pci_ one */
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
-
-static inline int
-dma_get_cache_alignment(void)
-{
-	/* no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe */
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
-}
-
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-	/* could define this in terms of the dma_cache ... operations,
-	 * but if you get this on a platform, you should convert the platform
-	 * to using the generic device DMA API */
-	BUG();
-}
-
-#endif
-
-- 
1.5.4.2

