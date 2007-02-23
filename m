Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXBWBWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXBWBWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXBWBWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:22:06 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4073 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXBWBWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:22:04 -0500
Date: Thu, 22 Feb 2007 19:59:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] dma-mapping-broken.h: flesh-out DMA API stubs
Message-ID: <20070223005945.GA13084@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows some drivers compile on arches that don't support DMA
(e.g. s390).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Is there any reason why this header should not cover the whole DMA API?

Compile-tested only...

 include/asm-generic/dma-mapping-broken.h |  134 ++++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/dma-mapping-broken.h b/include/asm-generic/dma-mapping-broken.h
index 29413d3..84812dd 100644
--- a/include/asm-generic/dma-mapping-broken.h
+++ b/include/asm-generic/dma-mapping-broken.h
@@ -21,4 +21,116 @@ dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
+static inline dma_addr_t
+dma_map_single(struct device *dev, void *ptr, size_t size,
+	       enum dma_data_direction direction)
+{
+	BUG();
+	return (dma_addr_t)0;
+}
+
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	   enum dma_data_direction direction)
+{
+	BUG();
+	return 0;
+}
+
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline dma_addr_t
+dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+	     size_t size, enum dma_data_direction direction)
+{
+	BUG();
+	return (dma_addr_t)0;
+}
+
+static inline void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	BUG();
+}
+
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction)
+{
+	BUG();
+}
+
+#define dma_sync_single_for_device dma_sync_single_for_cpu
+#define dma_sync_single_range_for_device dma_sync_single_range_for_cpu
+#define dma_sync_sg_for_device dma_sync_sg_for_cpu
+
+static inline int
+dma_mapping_error(dma_addr_t dma_addr)
+{
+	BUG();
+	return 1;
+}
+
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	return 0;
+}
+
+static inline int
+dma_set_mask(struct device *dev, u64 mask)
+{
+	BUG();
+	return -EIO;
+}
+
+static inline int
+dma_get_cache_alignment(void)
+{
+	BUG();
+	return 0;
+}
+
+int
+dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
+{
+	BUG();
+	return 0;
+}
+
+static inline void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	       enum dma_data_direction direction)
+{
+	BUG();
+}
+
 #endif /* _ASM_GENERIC_DMA_MAPPING_H */
-- 
1.4.4.2
