Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZETN6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZETN6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZETN6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:58:40 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59553 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZETN6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:58:39 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.30-rc6] Remove kmem_cache_destroy() in s3c24xx_dma_init().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200905202258.GII65132.HMFSJFOVOFtLQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 20 May 2009 22:58:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c24xx_dma_init() is passing NULL to kmem_cache_destroy() if
kmem_cache_create() failed. 
We can remove this kmem_cache_destroy() because it is called only when
kmem_cache_create() failed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 arch/arm/plat-s3c24xx/dma.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.30-rc6.orig/arch/arm/plat-s3c24xx/dma.c
+++ linux-2.6.30-rc6/arch/arm/plat-s3c24xx/dma.c
@@ -1396,7 +1396,6 @@ int __init s3c24xx_dma_init(unsigned int
 	return 0;
 
  err:
-	kmem_cache_destroy(dma_kmem);
 	iounmap(dma_base);
 	dma_base = NULL;
 	return ret;
