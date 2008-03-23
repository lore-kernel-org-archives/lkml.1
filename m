Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbYCWItm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbYCWItm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbYCWILc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:32 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2332 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760075AbYCWILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:30 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 027/148] include/asm-x86/dma-mapping_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:02 -0700
Message-Id: <1206259443-13210-28-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/dma-mapping_64.h |  117 +++++++++++++++++++------------------
 1 files changed, 60 insertions(+), 57 deletions(-)

diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index ecd0f61..c3723ec 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -13,45 +13,49 @@
 struct dma_mapping_ops {
 	int             (*mapping_error)(dma_addr_t dma_addr);
 	void*           (*alloc_coherent)(struct device *dev, size_t size,
-                                dma_addr_t *dma_handle, gfp_t gfp);
+					  dma_addr_t *dma_handle, gfp_t gfp);
 	void            (*free_coherent)(struct device *dev, size_t size,
-                                void *vaddr, dma_addr_t dma_handle);
+					 void *vaddr, dma_addr_t dma_handle);
 	dma_addr_t      (*map_single)(struct device *hwdev, void *ptr,
-                                size_t size, int direction);
+				      size_t size, int direction);
 	/* like map_single, but doesn't check the device mask */
 	dma_addr_t      (*map_simple)(struct device *hwdev, char *ptr,
-                                size_t size, int direction);
+				      size_t size, int direction);
 	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-		                size_t size, int direction);
+					size_t size, int direction);
 	void            (*sync_single_for_cpu)(struct device *hwdev,
-		                dma_addr_t dma_handle, size_t size,
-				int direction);
+					       dma_addr_t dma_handle,
+					       size_t size, int direction);
 	void            (*sync_single_for_device)(struct device *hwdev,
-                                dma_addr_t dma_handle, size_t size,
-				int direction);
+						  dma_addr_t dma_handle,
+						  size_t size, int direction);
 	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-                                dma_addr_t dma_handle, unsigned long offset,
-		                size_t size, int direction);
+						     dma_addr_t dma_handle,
+						     unsigned long offset,
+						     size_t size,
+						     int direction);
 	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-		                size_t size, int direction);
+							dma_addr_t dma_handle,
+							unsigned long offset,
+							size_t size,
+							int direction);
 	void            (*sync_sg_for_cpu)(struct device *hwdev,
-                                struct scatterlist *sg, int nelems,
-				int direction);
+					   struct scatterlist *sg,
+					   int nelems, int direction);
 	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
+					      struct scatterlist *sg,
+					      int nelems, int direction);
 	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-		                int nents, int direction);
+				  int nents, int direction);
 	void            (*unmap_sg)(struct device *hwdev,
-				struct scatterlist *sg, int nents,
-				int direction);
+				    struct scatterlist *sg, int nents,
+				    int direction);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
 	int		is_phys;
 };
 
 extern dma_addr_t bad_dma_address;
-extern const struct dma_mapping_ops* dma_ops;
+extern const struct dma_mapping_ops *dma_ops;
 extern int iommu_merge;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
@@ -73,30 +77,29 @@ extern void *dma_alloc_coherent(struct device *dev, size_t size,
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 			      dma_addr_t dma_handle);
 
-static inline dma_addr_t
-dma_map_single(struct device *hwdev, void *ptr, size_t size,
+static inline dma_addr_t dma_map_single(struct device *hwdev, void *ptr,
+					size_t size,
 	       int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	return dma_ops->map_single(hwdev, ptr, size, direction);
 }
 
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
-		 int direction)
+static inline void dma_unmap_single(struct device *dev, dma_addr_t addr,
+				    size_t size, int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	dma_ops->unmap_single(dev, addr, size, direction);
 }
 
-#define dma_map_page(dev,page,offset,size,dir) \
-	dma_map_single((dev), page_address(page)+(offset), (size), (dir))
+#define dma_map_page(dev, page, offset, size, dir)			\
+	dma_map_single((dev), page_address(page) + (offset), (size), (dir))
 
 #define dma_unmap_page dma_unmap_single
 
-static inline void
-dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			size_t size, int direction)
+static inline void dma_sync_single_for_cpu(struct device *hwdev,
+					   dma_addr_t dma_handle, size_t size,
+					   int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	if (dma_ops->sync_single_for_cpu)
@@ -105,9 +108,9 @@ dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
+static inline void dma_sync_single_for_device(struct device *hwdev,
+					      dma_addr_t dma_handle,
+					      size_t size, int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	if (dma_ops->sync_single_for_device)
@@ -116,21 +119,24 @@ dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size, int direction)
+static inline void dma_sync_single_range_for_cpu(struct device *hwdev,
+						 dma_addr_t dma_handle,
+						 unsigned long offset,
+						 size_t size, int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	if (dma_ops->sync_single_range_for_cpu) {
-		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle, offset, size, direction);
+		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle,
+						   offset, size, direction);
 	}
 
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size, int direction)
+static inline void dma_sync_single_range_for_device(struct device *hwdev,
+						    dma_addr_t dma_handle,
+						    unsigned long offset,
+						    size_t size, int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	if (dma_ops->sync_single_range_for_device)
@@ -140,9 +146,9 @@ dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-		    int nelems, int direction)
+static inline void dma_sync_sg_for_cpu(struct device *hwdev,
+				       struct scatterlist *sg, int nelems,
+				       int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	if (dma_ops->sync_sg_for_cpu)
@@ -150,28 +156,26 @@ dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
+static inline void dma_sync_sg_for_device(struct device *hwdev,
+					  struct scatterlist *sg, int nelems,
+					  int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_device) {
+	if (dma_ops->sync_sg_for_device)
 		dma_ops->sync_sg_for_device(hwdev, sg, nelems, direction);
-	}
 
 	flush_write_buffers();
 }
 
-static inline int
-dma_map_sg(struct device *hwdev, struct scatterlist *sg, int nents, int direction)
+static inline int dma_map_sg(struct device *hwdev, struct scatterlist *sg,
+			     int nents, int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	return dma_ops->map_sg(hwdev, sg, nents, direction);
 }
 
-static inline void
-dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
+static inline void dma_unmap_sg(struct device *hwdev, struct scatterlist *sg,
+				int nents, int direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	dma_ops->unmap_sg(hwdev, sg, nents, direction);
@@ -189,9 +193,8 @@ static inline int dma_get_cache_alignment(void)
 
 extern int dma_set_mask(struct device *dev, u64 mask);
 
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	enum dma_data_direction dir)
+static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+				  enum dma_data_direction dir)
 {
 	flush_write_buffers();
 }
-- 
1.5.4.rc2

