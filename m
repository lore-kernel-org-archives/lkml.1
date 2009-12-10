Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZLJIim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZLJIim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZLJIil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:38:41 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51293 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZLJIil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:38:41 -0500
Date: Thu, 10 Dec 2009 09:38:46 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Remove wait_request flag when idle time is being
	deleted
Message-ID: <20091210083846.GF8742@kernel.dk>
References: <4B208DD3.8040500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B208DD3.8040500@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10 2009, Gui Jianfeng wrote:
> Hi Jens,
> 
> I post this patch a few month ago, it seems to get missing, repost again.
> 
> Remove wait_request flag when idle time is being deleted.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 69ecee7..96f59ae 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3202,6 +3202,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
>  			    cfqd->busy_queues > 1) {
>  				del_timer(&cfqd->idle_slice_timer);
> +				cfq_clear_cfqq_wait_request(cfqq);
>  				__blk_run_queue(cfqd->queue);
>  			} else
>  				cfq_mark_cfqq_must_dispatch(cfqq);

Hmm weird, I think it may have gone missing in a badly done merge. I'll
add it, thanks.

-- 
Jens Axboe

