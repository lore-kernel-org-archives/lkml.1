Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZF1Ojc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZF1Ojc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZF1OjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:39:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:61816 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZF1OjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=daMgOWtZqM/dsdCezeR/So7cGQn5pXVaS5i/AvwF7tcoKuCeE4GbFw2OPfCUldxvYx
         evXnnBGOLmQ9/4NaqgTgXjv7kdwMalzn/87Veuc47rKO/cEJEtbXzqNojHW5LYnlMWX4
         vqyzR4sB7mgyMCsi4oC+Hih4NK1AI9BWdPuyE=
From: tom.leiming@gmail.com
To: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Sun, 28 Jun 2009 22:39:19 +0800
Message-Id: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
dma transfer is over, it seems there is nothing to do with cpu write buffer,
so remove it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/asm-generic/dma-mapping-common.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 5406a60..73411ab 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -103,7 +103,6 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_for_device(struct device *dev,
@@ -132,7 +131,6 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_cpu(dev, addr, size, dir);
 }
@@ -165,7 +163,6 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-	flush_write_buffers();
 }
 
 static inline void
-- 
1.6.0.GIT

