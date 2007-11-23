Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbXKWJTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbXKWJTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXKWJTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:19:11 -0500
Received: from brick.kernel.dk ([87.55.233.238]:12806 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbXKWJTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:19:08 -0500
Date: Fri, 23 Nov 2007 10:18:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Add missing sg_init_table() call
Message-ID: <20071123091841.GC2863@kernel.dk>
References: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22 2007, Haavard Skinnemoen wrote:
> mmc_init_queue only initializes the scatterlists with sg_init_table()
> when using a bounce buffer. This leads to a BUG() when CONFIG_DEBUG_SG
> is set.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/mmc/card/queue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 1b9c9b6..30cd13b 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -180,12 +180,13 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
>  		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
>  		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
>  
> -		mq->sg = kzalloc(sizeof(struct scatterlist) *
> +		mq->sg = kmalloc(sizeof(struct scatterlist) *
>  			host->max_phys_segs, GFP_KERNEL);
>  		if (!mq->sg) {
>  			ret = -ENOMEM;
>  			goto cleanup_queue;
>  		}
> +		sg_init_table(mq->sg, host->max_phys_segs);
>  	}
>  
>  	init_MUTEX(&mq->thread_sem);

Applied

-- 
Jens Axboe

