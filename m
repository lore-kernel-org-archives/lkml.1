Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0BDDPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:15:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:55529 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0BDDPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:15:31 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
Subject: [PATCH -mm 3/4] alpha: remove dma_sync_single_range
Date: Thu,  4 Feb 2010 12:13:24 +0900
Message-Id: <1265253206-17744-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 12:14:51 +0900 (JST)
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
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/include/asm/dma-mapping.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index 04eb568..f514ede 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -59,7 +59,6 @@ int dma_set_mask(struct device *dev, u64 mask);
 
 #define dma_sync_single_for_cpu(dev, addr, size, dir)	  ((void)0)
 #define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
-#define dma_sync_single_range(dev, addr, off, size, dir)  ((void)0)
 #define dma_sync_sg_for_cpu(dev, sg, nents, dir)	  ((void)0)
 #define dma_sync_sg_for_device(dev, sg, nents, dir)	  ((void)0)
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
-- 
1.5.6.5

