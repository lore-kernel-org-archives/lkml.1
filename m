Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZESEAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZESEAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 00:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbZESEAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 00:00:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:32837 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZESEAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 00:00:42 -0400
Date: Tue, 19 May 2009 13:00:37 +0900
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mark dma_sync_single and dma_sync_sg as deprecated
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090519125630Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 19 May 2009 13:00:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_sync_single() and dma_sync_sg() have been described as "Backwards
compat, remove in 2.7.x" for a long time (since 2.6.5).

This marks dma_sync_single() and dma_sync_sg() as deprecated so the
users get notified before removing them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 8083b6a..197ddc4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -107,9 +107,20 @@ static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
 #include <asm-generic/dma-mapping-broken.h>
 #endif
 
-/* Backwards compat, remove in 2.7.x */
-#define dma_sync_single		dma_sync_single_for_cpu
-#define dma_sync_sg		dma_sync_sg_for_cpu
+/* for backwards compatibility, removed soon */
+static inline void __deprecated dma_sync_single(struct device *dev,
+						dma_addr_t addr, size_t size,
+						enum dma_data_direction dir)
+{
+	dma_sync_single_for_cpu(dev, addr, size, dir);
+}
+
+static inline void __deprecated dma_sync_sg(struct device *dev,
+					    struct scatterlist *sg, int nelems,
+					    enum dma_data_direction dir)
+{
+	dma_sync_sg_for_cpu(dev, sg, nelems, dir);
+}
 
 static inline u64 dma_get_mask(struct device *dev)
 {
-- 
1.6.0.6

