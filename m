Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZLMX5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZLMX5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZLMX5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbZLMX5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:39 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org, joerg.roedel@amd.com
Subject: [PATCH 02/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:17 +0100
Message-Id: <6ac06d67c073024a39a4276edda5fd44caab0f97.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/asm-generic/dma-mapping-common.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index e694263..9ffa925 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -11,7 +11,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      enum dma_data_direction dir,
 					      struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(ptr, size);
@@ -30,7 +30,7 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 					  enum dma_data_direction dir,
 					  struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
@@ -42,7 +42,7 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 				   int nents, enum dma_data_direction dir,
 				   struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	int i, ents;
 	struct scatterlist *s;
 
@@ -59,7 +59,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 				      int nents, enum dma_data_direction dir,
 				      struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
@@ -71,7 +71,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
 				      enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
@@ -85,7 +85,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 				  size_t size, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
@@ -97,7 +97,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 					   size_t size,
 					   enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
@@ -109,7 +109,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					      dma_addr_t addr, size_t size,
 					      enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
@@ -123,7 +123,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_cpu) {
@@ -140,7 +140,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_device) {
@@ -155,7 +155,7 @@ static inline void
 dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		    int nelems, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
@@ -167,7 +167,7 @@ static inline void
 dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		       int nelems, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
-- 
1.6.5.3

