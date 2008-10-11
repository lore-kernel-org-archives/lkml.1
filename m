Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYJKHEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYJKHEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbYJKHEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:04:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51566 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYJKHEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:04:40 -0400
Date: Sat, 11 Oct 2008 09:04:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, knikanth@suse.de
Subject: Re: [PATCH] block: fix nr_phys_segments miscalculation bug
Message-ID: <20081011070402.GN19428@kernel.dk>
References: <20081011153048E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011153048E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11 2008, FUJITA Tomonori wrote:
> This is against the latest git (b922df7383749a1c0b7ea64c50fa839263d3816b).
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: fix nr_phys_segments miscalculation bug
> 
> This fixes the bug reported by Nikanth Karthikesan <knikanth@suse.de>:
> 
> http://lkml.org/lkml/2008/10/2/203
> 
> The root cause of the bug is that blk_phys_contig_segment
> miscalculates q->max_segment_size.
> 
> blk_phys_contig_segment checks:
> 
> req->biotail->bi_size + next_req->bio->bi_size > q->max_segment_size
> 
> But blk_recalc_rq_segments might expect that req->biotail and the
> previous bio in the req are supposed be merged into one
> segment. blk_recalc_rq_segments might also expect that next_req->bio
> and the next bio in the next_req are supposed be merged into one
> segment. In such case, we merge two requests that can't be merged
> here. Later, blk_rq_map_sg gives more segments than it should.
> 
> We need to keep track of segment size in blk_recalc_rq_segments and
> use it to see if two requests can be merged. This patch implements it
> in the similar way that we used to do for hw merging (virtual
> merging).

This looks really good, just like I imagined. I'll give it a fuller
review later today and do a bit of targetted testing, if it goes as
planned it'll go in soonish. Thanks a lot!

-- 
Jens Axboe

