Return-Path: <linux-kernel-owner+w=401wt.eu-S1763450AbYD3QWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763450AbYD3QWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbYD3QWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:22:35 -0400
Received: from nebensachen.de ([195.34.83.29]:39818 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbYD3QWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:22:34 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Reenforce consistent queue_flags handling
Date: Wed, 30 Apr 2008 18:20:14 +0200
Message-ID: <87od7rjow1.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:080430:jens.axboe@oracle.com::iMvMER7dNn/SWy/L:00000000000000000000000000000000000000001R3f
X-Hashcash: 1:20:080430:linux-kernel@vger.kernel.org::Rh7DJH5jdNDXTqAa:0000000000000000000000000000000000cmU
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just make the tree comply with the rules introduced in
commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 block/blk-core.c  |    2 +-
 block/blk-sysfs.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5d09f8c..17ba427 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -201,7 +201,7 @@ void blk_plug_device(struct request_queue *q)
 		return;
 
 	if (!test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
-		__set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
 		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
 	}
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e85c401..775e736 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -147,9 +147,9 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&nm, page, count);
 
 	if (nm)
-	       set_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+		queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, q);
 	else
-	       clear_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+		queue_flag_clear_unlocked(QUEUE_FLAG_NOMERGES, q);
 
 	return ret;
 }
