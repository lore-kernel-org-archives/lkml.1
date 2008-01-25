Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbYAYIiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbYAYIiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762392AbYAYIBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:59448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763690AbYAYH7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 160/196] Kobject: convert block/ll_rw_blk.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:33:09 -0800
Message-Id: <1201246425-5058-81-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/ll_rw_blk.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3887b2a..8054b7d 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1862,9 +1862,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	init_timer(&q->unplug_timer);
 
-	kobject_set_name(&q->kobj, "%s", "queue");
-	q->kobj.ktype = &queue_ktype;
-	kobject_init(&q->kobj);
+	kobject_init_ng(&q->kobj, &queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
 
@@ -4182,9 +4180,8 @@ int blk_register_queue(struct gendisk *disk)
 	if (!q || !q->request_fn)
 		return -ENXIO;
 
-	q->kobj.parent = kobject_get(&disk->dev.kobj);
-
-	ret = kobject_add(&q->kobj);
+	ret = kobject_add_ng(&q->kobj, kobject_get(&disk->dev.kobj),
+			     "%s", "queue");
 	if (ret < 0)
 		return ret;
 
-- 
1.5.3.8

