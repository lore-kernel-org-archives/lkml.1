Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYFZLH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYFZLH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYFZLGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:06:51 -0400
Received: from mail.suse.de ([195.135.220.2]:40548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbYFZLGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:06:50 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-aio@kvack.org
Subject: [PATCH]  aio: remove unused function aio_run_iocbs()
Date: Thu, 26 Jun 2008 16:40:26 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806261640.27048.knikanth@suse.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unused function aio_run_iocbs()

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/aio.c b/fs/aio.c
index 0fb3117..e27f611 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -797,26 +797,6 @@ static void aio_queue_work(struct kioctx * ctx)
 	queue_delayed_work(aio_wq, &ctx->wq, timeout);
 }
 
-
-/*
- * aio_run_iocbs:
- * 	Process all pending retries queued on the ioctx
- * 	run list.
- * Assumes it is operating within the aio issuer's mm
- * context.
- */
-static inline void aio_run_iocbs(struct kioctx *ctx)
-{
-	int requeue;
-
-	spin_lock_irq(&ctx->ctx_lock);
-
-	requeue = __aio_run_iocbs(ctx);
-	spin_unlock_irq(&ctx->ctx_lock);
-	if (requeue)
-		aio_queue_work(ctx);
-}
-
 /*
  * just like aio_run_iocbs, but keeps running them until
  * the list stays empty

