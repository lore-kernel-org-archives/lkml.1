Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYCKIS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYCKIS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYCKISN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:18:13 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:51881 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYCKISM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:18:12 -0400
Message-ID: <47D64041.7050903@tiscali.nl>
Date: Tue, 11 Mar 2008 09:18:09 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
References: <47D5E1ED.3020804@tiscali.nl> <20080311061148.GC17940@kernel.dk>
In-Reply-To: <20080311061148.GC17940@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Mar 11 2008, Roel Kluin wrote:
>> In my likely profile it appears this one is inverted.
> 
> Depends entirely on the workload, it should be removed rather than
> inverted.
> 
---
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0f58616..7651c3b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -305,7 +305,7 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 	}
 	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
 		blk_recount_segments(q, req->biotail);
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
+	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
 	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))

