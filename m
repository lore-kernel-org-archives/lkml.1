Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0BDDPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:15:34 -0500
Received: from sh.osrg.net ([192.16.179.4]:55528 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0BDDP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:15:28 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH -mm 2/4] DMA-API.txt: remove dma_sync_single_range description
Date: Thu,  4 Feb 2010 12:13:23 +0900
Message-Id: <1265253206-17744-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 12:14:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_sync_single_for_cpu/for_device supports a partial sync so there is
no point to have dma_sync_single_range (also dma_sync_single was
obsoleted long ago, replaced with dma_sync_single_for_cpu/for_device).

There is no user of dma_sync_single_range() in mainline and only Alpha
architecture supports dma_sync_single_range(). So it's unlikely that
someone out of the tree uses it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 Documentation/DMA-API.txt |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index c8db3d0..364a6cb 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -528,16 +528,6 @@ into the width returned by this call.  It will also always be a power
 of two for easy alignment.
 
 void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-
-Does a partial sync, starting at offset and continuing for size.  You
-must be careful to observe the cache alignment and width when doing
-anything like this.  You must also be extra careful about accessing
-memory you intend to sync partially.
-
-void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
 
-- 
1.5.6.5

