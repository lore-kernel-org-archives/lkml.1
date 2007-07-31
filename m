Return-Path: <linux-kernel-owner+w=401wt.eu-S938014AbXGaCVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938014AbXGaCVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937625AbXGaCRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:52753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966809AbXGaCRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:05 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:50 +1000
Message-Id: <1070731021650.25255@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 012 of 35] Share code between init_request_from_bio and blk_rq_bio_prep
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These have very similar functions and should share code where
possible.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:56.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:57.000000000 +1000
@@ -2905,17 +2905,10 @@ static void init_request_from_bio(struct
 
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
-	req->hard_nr_sectors = req->nr_sectors = bio_sectors(bio);
-	req->bio = req->biotail = bio;
-	req->first_offset = 0;
-	req->current_nr_sectors = req->hard_cur_sectors =
-		blk_rq_cur_sectors(req);
-	req->nr_phys_segments = bio_phys_segments(req->q, bio);
-	req->nr_hw_segments = bio_hw_segments(req->q, bio);
-	req->buffer = blk_rq_data(req);	/* see ->buffer comment above */
 	req->ioprio = bio_prio(bio);
-	req->rq_disk = bio->bi_bdev->bd_disk;
 	req->start_time = jiffies;
+
+	blk_rq_bio_prep(req->q, req, bio);
 }
 
 static int __make_request(struct request_queue *q, struct bio *bio)
