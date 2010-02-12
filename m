Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0BLGFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 01:05:35 -0500
Received: from sh.osrg.net ([192.16.179.4]:58382 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0BLGFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 01:05:31 -0500
Date: Fri, 12 Feb 2010 15:04:55 +0900
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com
Subject: [PATCH -mm] mn10300: remove the obsolete and unnecessary DMA API
 comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100212150419D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 15:04:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_dma_sync_single was obsoleted long ago.

All the comments are generic, not architecture specific, simply
describes some of the DMA-API (and the same comments are in other
files). Documentation/DMA-API.txt have more detailed descriptions.

This removes the above obsolete and unnecessary DMA API
comments. Let's describe the DMA API in only
Documentation/DMA-API.txt.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/include/asm/dma-mapping.h |   60 --------------------------------
 1 files changed, 0 insertions(+), 60 deletions(-)

diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index ccae8f6..517d3b6 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -26,13 +26,6 @@ extern void dma_free_coherent(struct device *dev, size_t size,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
 #define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.  The
- * 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory until
- * either pci_unmap_single or pci_dma_sync_single is performed.
- */
 static inline
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
@@ -42,14 +35,6 @@ dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 	return virt_to_bus(ptr);
 }
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size must
- * match what was provided for in a previous pci_map_single call.  All other
- * usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
 static inline
 void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		      enum dma_data_direction direction)
@@ -57,20 +42,6 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 	BUG_ON(direction == DMA_NONE);
 }
 
-/*
- * Map a set of buffers described by scatterlist in streaming mode for DMA.
- * This is the scather-gather version of the above pci_map_single interface.
- * Here the scatter gather list elements are each tagged with the appropriate
- * dma address and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of DMA
- *       address/length pairs than there are SG table elements.  (for example
- *       via virtual mapping capabilities) The routine returns the number of
- *       addr/length pairs actually used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are the same
- * here.
- */
 static inline
 int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	       enum dma_data_direction direction)
@@ -91,11 +62,6 @@ int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	return nents;
 }
 
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
 static inline
 void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 		  enum dma_data_direction direction)
@@ -103,10 +69,6 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-/*
- * pci_{map,unmap}_single_page maps a kernel page to a dma_addr_t. identical
- * to pci_map_single, but takes a struct page instead of a virtual address
- */
 static inline
 dma_addr_t dma_map_page(struct device *dev, struct page *page,
 			unsigned long offset, size_t size,
@@ -123,15 +85,6 @@ void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
 	BUG_ON(direction == DMA_NONE);
 }
 
-/*
- * Make physical memory consistent for a single streaming mode DMA translation
- * after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the buffer using
- * the cpu, yet do not wish to teardown the PCI dma mapping, you must call this
- * function before doing so.  At the next point you give the PCI dma address
- * back to the card, the device again owns the buffer.
- */
 static inline
 void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 			     size_t size, enum dma_data_direction direction)
@@ -161,13 +114,6 @@ dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
 }
 
 
-/*
- * Make physical memory consistent for a set of streaming mode DMA translations
- * after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list, same rules
- * and usage.
- */
 static inline
 void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			 int nelems, enum dma_data_direction direction)
@@ -187,12 +133,6 @@ int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return 0;
 }
 
-/*
- * Return whether the given PCI device DMA address mask can be supported
- * properly.  For example, if your device can only drive the low 24-bits during
- * PCI bus mastering, then you would pass 0x00ffffff as the mask to this
- * function.
- */
 static inline
 int dma_supported(struct device *dev, u64 mask)
 {
-- 
1.5.6.5

