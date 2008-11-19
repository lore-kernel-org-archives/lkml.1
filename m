Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYKSQJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYKSQJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKSQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:09:39 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:4672 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYKSQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jZr83VoN1vRGwGXe9UhI1PpjdsohiwLbN5DICT2t9bEj6bXOwToRsT9Nh3kQq14SRj
         AICSQx7uuUvGGWwTgBT66TSt6UYgfJx3fPuow+uemK/VlLiG/IwpbHTZtuQQ1JJn80Ua
         CuDsuJis7dAJsJuO2MIhF2iyoOMe0+yqA5als=
From: crquan@gmail.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [GENDISK] fix disk_part_tbl always alloced in node 0: set node_id before refered in alloc_disk
Date: Thu, 20 Nov 2008 00:09:25 +0800
Message-Id: <1227110965-12606-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

disk->node_id will be refered in allocating in disk_expand_part_tbl, so we
should set it before disk->node_id is refered.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 block/genhd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 27549e4..2f7feda 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1102,6 +1102,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			kfree(disk);
 			return NULL;
 		}
+		disk->node_id = node_id;
 		if (disk_expand_part_tbl(disk, 0)) {
 			free_part_stats(&disk->part0);
 			kfree(disk);
@@ -1116,7 +1117,6 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
-		disk->node_id = node_id;
 	}
 	return disk;
 }
-- 
1.6.0.4.758.g36c05

