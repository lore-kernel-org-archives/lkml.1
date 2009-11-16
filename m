Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZKPLNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZKPLNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZKPLNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:13:46 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:50654 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZKPLNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:13:46 -0500
To: ben-linux@fluff.org, rmk+kernel@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.32-rc7] Remove kmem_cache_destroy() in s3c24xx_dma_init().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200905202258.GII65132.HMFSJFOVOFtLQO@I-love.SAKURA.ne.jp>
	<200905261942.III78639.FMOJLFtFSOHVOQ@I-love.SAKURA.ne.jp>
In-Reply-To: <200905261942.III78639.FMOJLFtFSOHVOQ@I-love.SAKURA.ne.jp>
Message-Id: <200911162013.GFC81201.OFOMOJtQLSFFHV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 16 Nov 2009 20:13:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will you send below patch to upstream?

Regards.
--------------------
[PATCH 2.6.32-rc7] Remove kmem_cache_destroy() in s3c24xx_dma_init().

kmem_cache_destroy() in s3c24xx_dma_init() triggers NULL pointer dereference
if kmem_cache_create() failed. We can remove this kmem_cache_destroy() because
it is called only when kmem_cache_create() failed.

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
