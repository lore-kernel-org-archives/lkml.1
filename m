Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbZHUNgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbZHUNgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZHUNgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:36:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40606 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbZHUNgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:36:11 -0400
Date: Fri, 21 Aug 2009 15:36:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ: clear wait_request flag if needed
Message-ID: <20090821133612.GL12579@kernel.dk>
References: <4A8DFDF1.5030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8DFDF1.5030904@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21 2009, Gui Jianfeng wrote:
> Hi Jens,
> 
> IMHO wait_request flag should be cleared if a request goes in
> and idle timer needs to shut down. Otherwise, it will walk into
> that path every time when a request is enqueued.

That looks correct, deletion of the timer should always be paired with
the clearing of that flag. Applied, thanks!

> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index fd7080e..67f1910 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2093,6 +2093,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
>  			    cfqd->busy_queues > 1) {
>  				del_timer(&cfqd->idle_slice_timer);
> +				cfq_clear_cfqq_wait_request(cfqq);
>  			__blk_run_queue(cfqd->queue);
>  			}
>  			cfq_mark_cfqq_must_dispatch(cfqq);
> -- 
> 1.5.4.rc3
> 

-- 
Jens Axboe

