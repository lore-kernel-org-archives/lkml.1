Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZFZAcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZFZAcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZFZAc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:32:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59197 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZFZAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:32:27 -0400
Message-Id: <200906260032.n5Q0WRLE093696@www262.sakura.ne.jp>
Subject: [PATCH 2.6.30-rc6] Remove kmem_cache_destroy() in s3c24xx_dma_init().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Jun 2009 09:32:27 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25062009 #2160977, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would somebody catch this patch?
Maybe it's better to check for NULL inside kmem_cache_destroy()
to avoid NULL pointer dereference at kmem_cache_destroy()...
----------
[PATCH 2.6.30-rc6] Remove kmem_cache_destroy() in s3c24xx_dma_init().

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
