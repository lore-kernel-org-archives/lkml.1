Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0BLGFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 01:05:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:58373 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0BLGFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 01:05:09 -0500
Date: Fri, 12 Feb 2010 15:04:55 +0900
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, vapier@gentoo.org
Subject: [PATCH -mm] blackfin: remove the obsolete and unnecessary DMA API
 comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100212150027Y.fujita.tomonori@lab.ntt.co.jp>
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
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/dma-mapping.h |   36 -------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/arch/blackfin/include/asm/dma-mapping.h b/arch/blackfin/include/asm/dma-mapping.h
index f9172ff..413a303 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -65,13 +65,6 @@ _dma_sync(dma_addr_t addr, size_t size, enum dma_data_direction dir)
 	}
 }
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
 static inline dma_addr_t
 dma_map_single(struct device *dev, void *ptr, size_t size,
 	       enum dma_data_direction dir)
@@ -88,14 +81,6 @@ dma_map_page(struct device *dev, struct page *page,
 	return dma_map_single(dev, page_address(page) + offset, size, dir);
 }
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		 enum dma_data_direction dir)
@@ -110,30 +95,9 @@ dma_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 	dma_unmap_single(dev, dma_addr, size, dir);
 }
 
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
 extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		      enum dma_data_direction dir);
 
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
 static inline void
 dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 	     int nhwentries, enum dma_data_direction dir)
-- 
1.5.6.5

