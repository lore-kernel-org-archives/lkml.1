Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZDOFLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZDOFLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDOFJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:09:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZDOFJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:09:54 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/7] block: Remove code handling bio_alloc failure with __GFP_WAIT
Date: Wed, 15 Apr 2009 10:35:31 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151035.31331.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code handling bio_alloc failure with __GFP_WAIT.
GFP_KERNEL implies __GFP_WAIT.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f7dae57..20b4111 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -319,9 +319,6 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 		return -ENXIO;
 
 	bio = bio_alloc(GFP_KERNEL, 0);
-	if (!bio)
-		return -ENOMEM;
-
 	bio->bi_end_io = bio_end_empty_barrier;
 	bio->bi_private = &wait;
 	bio->bi_bdev = bdev;
diff --git a/block/ioctl.c b/block/ioctl.c
index 0f22e62..ad474d4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -146,8 +146,6 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 		struct bio *bio;
 
 		bio = bio_alloc(GFP_KERNEL, 0);
-		if (!bio)
-			return -ENOMEM;
 
 		bio->bi_end_io = blk_ioc_discard_endio;
 		bio->bi_bdev = bdev;

