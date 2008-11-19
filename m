Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYKSPyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYKSPyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYKSPyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:54:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:3182 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYKSPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mzV42E4gflUoO/ZSG007XzMTjokuJvtA66Ais7RH4Gm4sphtrx2NTRhbcjI9U/RSVc
         eO44mgTsBDxJ6o7o8Fnh4qK/yhT54zK51y1D89Q7mqHjkwDS4HLmq4xHJLyOsQap3MJ6
         hF5u/SMPqnoQNeEz4uLSyuOlCis1Zxwc1fJhE=
From: crquan@gmail.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] kobject_add: use constant strings directly as fmt strings
Date: Wed, 19 Nov 2008 23:54:19 +0800
Message-Id: <1227110059-12529-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 block/blk-sysfs.c |    2 +-
 block/elevator.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 21e275d..0b189e9 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -342,7 +342,7 @@ int blk_register_queue(struct gendisk *disk)
 		return 0;
 
 	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
-			  "%s", "queue");
+			  "queue");
 	if (ret < 0)
 		return ret;
 
diff --git a/block/elevator.c b/block/elevator.c
index 9ac82dd..9a39f27 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1005,7 +1005,7 @@ int elv_register_queue(struct request_queue *q)
 	elevator_t *e = q->elevator;
 	int error;
 
-	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
+	error = kobject_add(&e->kobj, &q->kobj, "iosched");
 	if (!error) {
 		struct elv_fs_entry *attr = e->elevator_type->elevator_attrs;
 		if (attr) {
-- 
1.6.0.4.758.g36c05

