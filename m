Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZHTKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZHTKSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZHTKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:18:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60176 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbZHTKRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:55 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/6] aio: use lazy workqueues
Date: Thu, 20 Aug 2009 12:17:44 +0200
Message-Id: <1250763466-24282-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-9-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-6-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-7-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-8-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-9-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/aio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index d065b2c..4103b59 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -72,7 +72,7 @@ static int __init aio_setup(void)
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
-	aio_wq = create_workqueue("aio");
+	aio_wq = create_lazy_workqueue("aio");
 
 	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
 
-- 
1.6.4.173.g3f189

