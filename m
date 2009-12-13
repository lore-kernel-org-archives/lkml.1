Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZLNAYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZLNAYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZLNAYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:24:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbZLMX5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:33 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, mingo@elte.hu, akpm@linux-foundation.org,
       benh@kernel.crashing.org, torvalds@linux-foundation.org
Subject: [PATCH 01/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:16 +0100
Message-Id: <3cf86bd92313600c9954b13b799b6a6682b73be4.1260662996.git.re.emese@gmail.com>
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
 include/linux/dma-mapping.h |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 91b7618..fc9996f 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -16,50 +16,50 @@ enum dma_data_direction {
 };
 
 struct dma_map_ops {
-	void* (*alloc_coherent)(struct device *dev, size_t size,
+	void* (* const alloc_coherent)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
-	void (*free_coherent)(struct device *dev, size_t size,
+	void (* const free_coherent)(struct device *dev, size_t size,
 			      void *vaddr, dma_addr_t dma_handle);
-	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+	dma_addr_t (* const map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
 			       struct dma_attrs *attrs);
-	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+	void (* const unmap_page)(struct device *dev, dma_addr_t dma_handle,
 			   size_t size, enum dma_data_direction dir,
 			   struct dma_attrs *attrs);
-	int (*map_sg)(struct device *dev, struct scatterlist *sg,
+	int (* const map_sg)(struct device *dev, struct scatterlist *sg,
 		      int nents, enum dma_data_direction dir,
 		      struct dma_attrs *attrs);
-	void (*unmap_sg)(struct device *dev,
+	void (* const unmap_sg)(struct device *dev,
 			 struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir,
 			 struct dma_attrs *attrs);
-	void (*sync_single_for_cpu)(struct device *dev,
+	void (* const sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction dir);
-	void (*sync_single_for_device)(struct device *dev,
+	void (* const sync_single_for_device)(struct device *dev,
 				       dma_addr_t dma_handle, size_t size,
 				       enum dma_data_direction dir);
-	void (*sync_single_range_for_cpu)(struct device *dev,
+	void (* const sync_single_range_for_cpu)(struct device *dev,
 					  dma_addr_t dma_handle,
 					  unsigned long offset,
 					  size_t size,
 					  enum dma_data_direction dir);
-	void (*sync_single_range_for_device)(struct device *dev,
+	void (* const sync_single_range_for_device)(struct device *dev,
 					     dma_addr_t dma_handle,
 					     unsigned long offset,
 					     size_t size,
 					     enum dma_data_direction dir);
-	void (*sync_sg_for_cpu)(struct device *dev,
+	void (* const sync_sg_for_cpu)(struct device *dev,
 				struct scatterlist *sg, int nents,
 				enum dma_data_direction dir);
-	void (*sync_sg_for_device)(struct device *dev,
+	void (* const sync_sg_for_device)(struct device *dev,
 				   struct scatterlist *sg, int nents,
 				   enum dma_data_direction dir);
-	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
-	int (*dma_supported)(struct device *dev, u64 mask);
-	int (*set_dma_mask)(struct device *dev, u64 mask);
-	int is_phys;
+	int (* const mapping_error)(struct device *dev, dma_addr_t dma_addr);
+	int (* const dma_supported)(struct device *dev, u64 mask);
+	int (* const set_dma_mask)(struct device *dev, u64 mask);
+	const int is_phys;
 };
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
-- 
1.6.5.3

