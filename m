Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYJTFMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYJTFMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 01:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYJTFMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 01:12:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:44116 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbYJTFMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 01:12:05 -0400
Date: Mon, 20 Oct 2008 14:11:55 +0900
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove unused ll_new_mergeable()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081011153521M.fujita.tomonori@lab.ntt.co.jp>
References: <20081011153521M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081020141141L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 15:38:08 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This is against the latest git (b922df7383749a1c0b7ea64c50fa839263d3816b).
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: remove unused ll_new_mergeable()
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/blk-merge.c |   21 ---------------------
>  1 files changed, 0 insertions(+), 21 deletions(-)

Ping. Any reason to keep this function?


> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 68b0f1e..37bcfc9 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -218,27 +218,6 @@ new_segment:
>  }
>  EXPORT_SYMBOL(blk_rq_map_sg);
>  
> -static inline int ll_new_mergeable(struct request_queue *q,
> -				   struct request *req,
> -				   struct bio *bio)
> -{
> -	int nr_phys_segs = bio_phys_segments(q, bio);
> -
> -	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
> -		req->cmd_flags |= REQ_NOMERGE;
> -		if (req == q->last_merge)
> -			q->last_merge = NULL;
> -		return 0;
> -	}
> -
> -	/*
> -	 * A hw segment is just getting larger, bump just the phys
> -	 * counter.
> -	 */
> -	req->nr_phys_segments += nr_phys_segs;
> -	return 1;
> -}
> -
>  static inline int ll_new_hw_segment(struct request_queue *q,
>  				    struct request *req,
>  				    struct bio *bio)
> -- 
> 1.5.5.GIT
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
