Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0BDDPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:15:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:55526 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab0BDDP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:15:27 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH -mm 4/4] um: remove dma_sync_single_range
Date: Thu,  4 Feb 2010 12:13:25 +0900
Message-Id: <1265253206-17744-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 12:14:52 +0900 (JST)
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
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/include/asm/dma-mapping.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dma-mapping.h
index 378de4b..b948c14 100644
--- a/arch/um/include/asm/dma-mapping.h
+++ b/arch/um/include/asm/dma-mapping.h
@@ -104,14 +104,6 @@ dma_get_cache_alignment(void)
 }
 
 static inline void
-dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
-		      unsigned long offset, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG();
-}
-
-static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
 {
-- 
1.5.6.5

