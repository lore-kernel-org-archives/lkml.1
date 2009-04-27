Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbZD3Pqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbZD3Pqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932285AbZD3PmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbZD3PmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:06 -0400
Message-Id: <55495e6ab0a8bf57ea43566bf49764a72d925364.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Apr 2009 17:38:25 +0200
Subject: [PATCH 24/27] microblaze: use generic dma-mapping.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX19v4vIwH9ckuc2jMumJfHwm1Btb7dvcElGN+Ei
 mQ60JOHD9kE9f7h/0C+cBErluN5CARZGsV2cuXVpjvjY0FmG4A
 lRdTZHWC09hBHh2DJIpyw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microblaze does not support the Linux DMA mapping API
at this point, so disable CONFIG_NO_DMA. This lets
us use the generic dma-mapping-broken.h implementation
instead of providing a different copy.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/Kconfig                   |    2 +-
 arch/microblaze/include/asm/dma-mapping.h |  130 +----------------------------
 2 files changed, 2 insertions(+), 130 deletions(-)
 rewrite arch/microblaze/include/asm/dma-mapping.h (100%)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 0651179..2508352 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -61,7 +61,7 @@ config PCI
 
 config NO_DMA
 	depends on !MMU
-	def_bool n
+	def_bool y
 
 source "init/Kconfig"
 
diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
dissimilarity index 100%
index 1733625..d00e400 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -1,129 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_DMA_MAPPING_H
-#define _ASM_MICROBLAZE_DMA_MAPPING_H
-
-#include <asm/cacheflush.h>
-#include <linux/io.h>
-#include <linux/bug.h>
-
-struct scatterlist;
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-/* FIXME */
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	return 1;
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	unsigned long offset, size_t size,
-	enum dma_data_direction direction)
-{
-	BUG();
-	return 0;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	enum dma_data_direction direction)
-{
-	BUG();
-	return 0;
-}
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	enum dma_data_direction direction)
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
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-		size_t size, enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, int flag)
-{
-	return NULL; /* consistent_alloc(flag, size, dma_handle); */
-}
-
-static inline void dma_free_coherent(struct device *dev, size_t size,
-			void *vaddr, dma_addr_t dma_handle)
-{
-	BUG();
-}
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-
-	return virt_to_bus(ptr);
-}
-
-static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-				    size_t size,
-				    enum dma_data_direction direction)
-{
-	switch (direction) {
-	case DMA_FROM_DEVICE:
-		flush_dcache_range((unsigned)dma_addr,
-			(unsigned)dma_addr + size);
-			/* Fall through */
-	case DMA_TO_DEVICE:
-		break;
-	default:
-		BUG();
-	}
-}
-
-#endif /* _ASM_MICROBLAZE_DMA_MAPPING_H */
+#include <asm-generic/dma-mapping-broken.h>
-- 
1.5.6.3


