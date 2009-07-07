Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZGGImg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZGGImg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZGGIm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:42:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:44255 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbZGGIm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:42:27 -0400
Date: Tue, 7 Jul 2009 17:42:26 +0900
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] IA64: fix CONFIG_DMA_API_DEBUG support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090707171456H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 07 Jul 2009 17:42:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 9916219579d078c80377dd3988c2cc213536d868 was supposed to
add CONFIG_DMA_API_DEBUG support to IA64 however I forgot to add
dma_debug_init().

Signed-off-by: fujita <fujita@tulip.osrg.net>
---
 arch/ia64/kernel/dma-mapping.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index 086a2ae..b45e155 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -6,6 +6,14 @@ int iommu_detected __read_mostly;
 struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
+#define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
+
+static int __init dma_init(void)
+{
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+}
+fs_initcall(dma_init);
+
 struct dma_map_ops *dma_get_ops(struct device *dev)
 {
 	return dma_ops;
-- 
1.5.6.5

