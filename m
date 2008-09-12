Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYILKrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYILKrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYILKrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:47:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:37424 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYILKrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:47:06 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/3] add dma_get_mask helper function
Date: Fri, 12 Sep 2008 19:42:34 +0900
Message-Id: <1221216155-17640-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1221216155-17640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1221216155-17640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several IOMMUs do the same thing to get the dma_mask of a device. This
adds a helper function to do the same thing to sweep them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 6ed50c1..0dba743 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -63,6 +63,13 @@ static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
 #define dma_sync_single		dma_sync_single_for_cpu
 #define dma_sync_sg		dma_sync_sg_for_cpu
 
+static inline u64 dma_get_mask(struct device *dev)
+{
+	if (dev->dma_mask && *dev->dma_mask)
+		return *dev->dma_mask;
+	return DMA_32BIT_MASK;
+}
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
-- 
1.5.5.GIT

