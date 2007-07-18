Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbXGRK5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbXGRK5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXGRK5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:57:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:1117 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXGRK5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Hl6smih8SGvmwm0Y3X7t/JL+S0cM9wUrRNKL8paGJa8v8pjhvVKdY1JAwTwLmosM4qslNDFRrq+P541BH1EKWvgzOJ1SBFveF/RKH92EUtOcyJqijxpwBQK9x7e46VVEB6LByZ1Ay5N1CFEUkbhiEvmknUxHIHD/0agwwaCbevQ=
Date: Wed, 18 Jul 2007 19:56:55 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] block: cosmetic changes
Message-ID: <20070718105655.GB22374@htj.dyndns.org>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530093503.GA15559@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic changes.  This is taken from Jens' zero-length barrier patch.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jes.axboe@oracle.com>
---
 block/ll_rw_blk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: work/block/ll_rw_blk.c
===================================================================
--- work.orig/block/ll_rw_blk.c
+++ work/block/ll_rw_blk.c
@@ -443,7 +443,8 @@ static inline struct request *start_orde
 	rq_init(q, rq);
 	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
 		rq->cmd_flags |= REQ_RW;
-	rq->cmd_flags |= q->ordered & QUEUE_ORDERED_FUA ? REQ_FUA : 0;
+	if (q->ordered & QUEUE_ORDERED_FUA)
+		rq->cmd_flags |= REQ_FUA;
 	rq->elevator_private = NULL;
 	rq->elevator_private2 = NULL;
 	init_request_from_bio(rq, q->orig_bar_rq->bio);
@@ -3167,7 +3168,7 @@ end_io:
 			break;
 		}
 
-		if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
+		if (unlikely(nr_sectors > q->max_hw_sectors)) {
 			printk("bio too big device %s (%u > %u)\n", 
 				bdevname(bio->bi_bdev, b),
 				bio_sectors(bio),
