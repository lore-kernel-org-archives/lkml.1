Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab0BLGFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 01:05:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:58379 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0BLGFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 01:05:17 -0500
Date: Fri, 12 Feb 2010 15:04:54 +0900
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com
Subject: [PATCH -mm] frv: remove the obsolete and unnecessary DMA API
 comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100212145830I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 15:04:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_dma_sync_single was obsoleted long ago.

All the comments are generic, not architecture specific, simply
describes some of the DMA-API (and frv has the same comments in three
files). Documentation/DMA-API.txt have more detailed descriptions.

This removes the above obsolete and unnecessary DMA API
comments. Let's describe the DMA API in only
Documentation/DMA-API.txt.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/dma-mapping.h    |   36 ---------------------------------
 arch/frv/mb93090-mb00/pci-dma-nommu.c |   30 ---------------------------
 arch/frv/mb93090-mb00/pci-dma.c       |   30 ---------------------------
 3 files changed, 0 insertions(+), 96 deletions(-)

diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index b289887..20cca40 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -16,24 +16,9 @@ extern unsigned long __nongprelbss dma_coherent_mem_end;
 void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t gfp);
 void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
 extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 				 enum dma_data_direction direction);
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
 static inline
 void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		      enum dma_data_direction direction)
@@ -41,30 +26,9 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 	BUG_ON(direction == DMA_NONE);
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
 		      enum dma_data_direction direction);
 
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
 static inline
 void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	     enum dma_data_direction direction)
diff --git a/arch/frv/mb93090-mb00/pci-dma-nommu.c b/arch/frv/mb93090-mb00/pci-dma-nommu.c
index 4e1ba0b..e47857f 100644
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c
+++ b/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -106,13 +106,6 @@ void dma_free_coherent(struct device *hwdev, size_t size, void *vaddr, dma_addr_
 
 EXPORT_SYMBOL(dma_free_coherent);
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either dma_unmap_single or pci_dma_sync_single is performed.
- */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
 {
@@ -125,22 +118,6 @@ dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 
 EXPORT_SYMBOL(dma_map_single);
 
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above dma_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	       enum dma_data_direction direction)
 {
@@ -157,13 +134,6 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 EXPORT_SYMBOL(dma_map_sg);
 
-/*
- * Map a single page of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 			size_t size, enum dma_data_direction direction)
 {
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 45954f0..2c912e8 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -38,13 +38,6 @@ void dma_free_coherent(struct device *hwdev, size_t size, void *vaddr, dma_addr_
 
 EXPORT_SYMBOL(dma_free_coherent);
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
 {
@@ -57,22 +50,6 @@ dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 
 EXPORT_SYMBOL(dma_map_single);
 
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above dma_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	       enum dma_data_direction direction)
 {
@@ -103,13 +80,6 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 EXPORT_SYMBOL(dma_map_sg);
 
-/*
- * Map a single page of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 			size_t size, enum dma_data_direction direction)
 {
-- 
1.5.6.5

