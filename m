Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZIPNZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZIPNZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZIPNZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57964 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbZIPNYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:50 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/16] writeback: remove smp_mb(), it's not needed with list_add_tail_rcu()
Date: Wed, 16 Sep 2009 15:24:51 +0200
Message-Id: <1253107494-20160-14-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

list_add_tail_rcu contains required barriers.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3475775..59c99e7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -151,10 +151,10 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 	BUG_ON(!bdi->wb_cnt);
 
 	/*
-	 * Make sure stores are seen before it appears on the list
+	 * list_add_tail_rcu() contains the necessary barriers to
+	 * make sure the above stores are seen before the item is
+	 * noticed on the list
 	 */
-	smp_mb();
-
 	spin_lock(&bdi->wb_lock);
 	list_add_tail_rcu(&work->list, &bdi->work_list);
 	spin_unlock(&bdi->wb_lock);
-- 
1.6.4.1.207.g68ea

