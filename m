Return-Path: <linux-kernel-owner+w=401wt.eu-S965392AbXA3NYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392AbXA3NYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965383AbXA3NYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:24:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41159 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365AbXA3NYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:24:02 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] dma-mapping.h stubs fix
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HBsxs-0002Oc-VZ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:24:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


do { } while(0) is not a good imitation of function returning void;
use ((void)0) instead.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-alpha/dma-mapping.h   |    6 +++---
 include/asm-powerpc/dma-mapping.h |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-alpha/dma-mapping.h b/include/asm-alpha/dma-mapping.h
index 1919d72..75a1aff 100644
--- a/include/asm-alpha/dma-mapping.h
+++ b/include/asm-alpha/dma-mapping.h
@@ -41,9 +41,9 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 #define dma_map_single(dev, va, size, dir)	virt_to_phys(va)
 #define dma_map_page(dev, page, off, size, dir)	(page_to_pa(page) + off)
 
-#define dma_unmap_single(dev, addr, size, dir)	do { } while (0)
-#define dma_unmap_page(dev, addr, size, dir)	do { } while (0)
-#define dma_unmap_sg(dev, sg, nents, dir)	do { } while (0)
+#define dma_unmap_single(dev, addr, size, dir)	((void)0)
+#define dma_unmap_page(dev, addr, size, dir)	((void)0)
+#define dma_unmap_sg(dev, sg, nents, dir)	((void)0)
 
 #define dma_mapping_error(addr)  (0)
 
diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 7c7de87..a19a6f1 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -37,9 +37,9 @@ extern void __dma_sync_page(struct page *page, unsigned long offset,
  */
 
 #define __dma_alloc_coherent(gfp, size, handle)	NULL
-#define __dma_free_coherent(size, addr)		do { } while (0)
-#define __dma_sync(addr, size, rw)		do { } while (0)
-#define __dma_sync_page(pg, off, sz, rw)	do { } while (0)
+#define __dma_free_coherent(size, addr)		((void)0)
+#define __dma_sync(addr, size, rw)		((void)0)
+#define __dma_sync_page(pg, off, sz, rw)	((void)0)
 
 #endif /* ! CONFIG_NOT_COHERENT_CACHE */
 
@@ -251,7 +251,7 @@ dma_map_single(struct device *dev, void *ptr, size_t size,
 }
 
 /* We do nothing. */
-#define dma_unmap_single(dev, addr, size, dir)	do { } while (0)
+#define dma_unmap_single(dev, addr, size, dir)	((void)0)
 
 static inline dma_addr_t
 dma_map_page(struct device *dev, struct page *page,
@@ -266,7 +266,7 @@ dma_map_page(struct device *dev, struct page *page,
 }
 
 /* We do nothing. */
-#define dma_unmap_page(dev, handle, size, dir)	do { } while (0)
+#define dma_unmap_page(dev, handle, size, dir)	((void)0)
 
 static inline int
 dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
@@ -286,7 +286,7 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 }
 
 /* We don't do anything here. */
-#define dma_unmap_sg(dev, sg, nents, dir)	do { } while (0)
+#define dma_unmap_sg(dev, sg, nents, dir)	((void)0)
 
 #endif /* CONFIG_PPC64 */
 
-- 
1.5.0-rc2.GIT

