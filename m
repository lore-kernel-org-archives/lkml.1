Return-Path: <linux-kernel-owner+w=401wt.eu-S965378AbXA3NZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbXA3NZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965372AbXA3NYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:24:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41157 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374AbXA3NX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:56 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] missing dma_sync_single_range_for{cpu,device} on alpha
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HBsxn-0002OQ-VN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


no-op as all dma_sync_... there.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-alpha/dma-mapping.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/asm-alpha/dma-mapping.h b/include/asm-alpha/dma-mapping.h
index 57e09f5..1919d72 100644
--- a/include/asm-alpha/dma-mapping.h
+++ b/include/asm-alpha/dma-mapping.h
@@ -55,12 +55,14 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 int dma_set_mask(struct device *dev, u64 mask);
 
-#define dma_sync_single_for_cpu(dev, addr, size, dir)	  do { } while (0)
-#define dma_sync_single_for_device(dev, addr, size, dir)  do { } while (0)
-#define dma_sync_single_range(dev, addr, off, size, dir)  do { } while (0)
-#define dma_sync_sg_for_cpu(dev, sg, nents, dir)	  do { } while (0)
-#define dma_sync_sg_for_device(dev, sg, nents, dir)	  do { } while (0)
-#define dma_cache_sync(dev, va, size, dir)		  do { } while (0)
+#define dma_sync_single_for_cpu(dev, addr, size, dir)	  ((void)0)
+#define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
+#define dma_sync_single_range(dev, addr, off, size, dir)  ((void)0)
+#define dma_sync_sg_for_cpu(dev, sg, nents, dir)	  ((void)0)
+#define dma_sync_sg_for_device(dev, sg, nents, dir)	  ((void)0)
+#define dma_cache_sync(dev, va, size, dir)		  ((void)0)
+#define dma_sync_single_range_for_cpu(dev, addr, offset, size, dir)	((void)0)
+#define dma_sync_single_range_for_device(dev, addr, offset, size, dir)	((void)0)
 
 #define dma_get_cache_alignment()			  L1_CACHE_BYTES
 
-- 
1.5.0-rc2.GIT


