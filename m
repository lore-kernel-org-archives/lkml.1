Return-Path: <linux-kernel-owner+w=401wt.eu-S935171AbXHPLX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbXHPLX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934182AbXHPLVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:21:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:47900 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765AbXHPLVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:21:34 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:21:27 +1000
Message-Id: <1070816112127.12245@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 006 of 6] Share code between init_request_from_bio and blk_rq_bio_prep
References: <20070816211551.11839.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These have very similar functions and should share code where
possible.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 21:10:55.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 21:11:03.000000000 +1000
@@ -2932,15 +2932,9 @@ static void init_request_from_bio(struct
 
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
-	req->hard_nr_sectors = req->nr_sectors = bio_sectors(bio);
-	req->current_nr_sectors = req->hard_cur_sectors = bio_cur_sectors(bio);
-	req->nr_phys_segments = bio_phys_segments(req->q, bio);
-	req->nr_hw_segments = bio_hw_segments(req->q, bio);
-	req->buffer = bio_data(bio);	/* see ->buffer comment above */
-	req->bio = req->biotail = bio;
 	req->ioprio = bio_prio(bio);
-	req->rq_disk = bio->bi_bdev->bd_disk;
 	req->start_time = jiffies;
+	blk_rq_bio_prep(req->q, req, bio);
 }
 
 static int __make_request(struct request_queue *q, struct bio *bio)
