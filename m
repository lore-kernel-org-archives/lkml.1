Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZCZCKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZCZCKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZCZCKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:10:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZCZCKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:10:20 -0400
Message-ID: <49CAE425.5050009@kernel.org>
Date: Thu, 26 Mar 2009 11:10:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-4-git-send-email-tj@kernel.org> <49CA4B4B.50408@panasas.com>
In-Reply-To: <49CA4B4B.50408@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 26 Mar 2009 02:10:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> I have a similar, totally unrelated patch queued, perhaps we can unify
> the efforts, to satisfy both our needs in one stone.
> 
> I've sent this patch:
> http://www.spinics.net/lists/linux-scsi/msg34082.html
> 
> In an effort to un-export blk_rq_append_bio().
> 
> Perhaps you could reorder the code below a bit?
> 
> My proposal is:
> * blk_rq_map_kern_prealloc => is simplified to be
>     int blk_rq_map_bio(struct request_queue *q, struct request *rq,
> 		       struct bio *bio);
> 
> * The extra checks currently inside blk_rq_map_kern_prealloc are moved
>   to bio_map_kern_prealloc()
> 
> * Users call bio_map_kern_prealloc() directly and then use blk_rq_map_bio()
>   in a two stage process.
> 
> So blk_rq_map_bio becomes a BLOCK_PC command's way of a
> pre-allocated bio the way FS_PC commands use generic_make_request.

Sounds good.  I'll make the change.

> Thanks for doing all this. BTW' how close are we to remove req->data
> and req->buffer

Those patches will be going out later today.  It will also kill
rq->hard_* and rq->*nr_sectors.  Single byte-granual data length for
all along with single way to carray data via bio! :-)

Thanks.

-- 
tejun
