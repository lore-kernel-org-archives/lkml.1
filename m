Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYJAHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYJAHl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYJAHkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:40:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24272 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYJAHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:40:11 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/7] block: gendisk integrity wrapper
Date: Wed,  1 Oct 2008 03:38:40 -0400
Message-Id: <1222846723-18213-5-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a wrapper for accessing a gendisk's integrity bits.  It allows
the integrity support in MD to be compiled with BLK_DEV_INTEGRITY off.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/blkdev.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index eec0842..ca08439 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1027,6 +1027,11 @@ static inline struct blk_integrity *bdev_get_integrity(struct block_device *bdev
 	return bdev->bd_disk->integrity;
 }
 
+static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
+{
+	return disk->integrity;
+}
+
 static inline unsigned int bdev_get_tag_size(struct block_device *bdev)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bdev);
@@ -1069,6 +1074,7 @@ static inline int blk_integrity_rq(struct request *rq)
 #define blk_rq_count_integrity_sg(a)		(0)
 #define blk_rq_map_integrity_sg(a, b)		(0)
 #define bdev_get_integrity(a)			(0)
+#define blk_get_integrity(a)			(0)
 #define bdev_get_tag_size(a)			(0)
 #define blk_integrity_compare(a, b)		(0)
 #define blk_integrity_register(a, b)		(0)
-- 
1.6.0.2

