Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZLNAOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZLNAOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZLMX54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbZLMX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:46 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, lethal@linux-sh.org, damm@opensource.se,
       matt@console-pimps.org, torvalds@linux-foundation.org
Subject: [PATCH 07/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:22 +0100
Message-Id: <0b7ff7b7eed063c944688061ba51e7f510edd0e0.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/sh/include/asm/dma-mapping.h |   14 +++++++-------
 arch/sh/kernel/dma-nommu.c        |    2 +-
 arch/sh/mm/consistent.c           |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
index 87ced13..b28e1d9 100644
--- a/arch/sh/include/asm/dma-mapping.h
+++ b/arch/sh/include/asm/dma-mapping.h
@@ -1,10 +1,10 @@
 #ifndef __ASM_SH_DMA_MAPPING_H
 #define __ASM_SH_DMA_MAPPING_H
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 extern void no_iommu_init(void);
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	return dma_ops;
 }
@@ -14,7 +14,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (ops->dma_supported)
 		return ops->dma_supported(dev, mask);
@@ -24,7 +24,7 @@ static inline int dma_supported(struct device *dev, u64 mask)
 
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (!dev->dma_mask || !dma_supported(dev, mask))
 		return -EIO;
@@ -59,7 +59,7 @@ static inline int dma_get_cache_alignment(void)
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
@@ -70,7 +70,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t gfp)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	void *memory;
 
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
@@ -87,7 +87,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t dma_handle)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	WARN_ON(irqs_disabled());	/* for portability */
 
diff --git a/arch/sh/kernel/dma-nommu.c b/arch/sh/kernel/dma-nommu.c
index 3c55b87..92ccab3 100644
--- a/arch/sh/kernel/dma-nommu.c
+++ b/arch/sh/kernel/dma-nommu.c
@@ -62,7 +62,7 @@ static void nommu_sync_sg(struct device *dev, struct scatterlist *sg,
 }
 #endif
 
-struct dma_map_ops nommu_dma_ops = {
+const struct dma_map_ops nommu_dma_ops = {
 	.alloc_coherent		= dma_generic_alloc_coherent,
 	.free_coherent		= dma_generic_free_coherent,
 	.map_page		= nommu_map_page,
diff --git a/arch/sh/mm/consistent.c b/arch/sh/mm/consistent.c
index 902967e..904d1ce 100644
--- a/arch/sh/mm/consistent.c
+++ b/arch/sh/mm/consistent.c
@@ -21,7 +21,7 @@
 
 #define PREALLOC_DMA_DEBUG_ENTRIES	4096
 
-struct dma_map_ops *dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int __init dma_init(void)
-- 
1.6.5.3

