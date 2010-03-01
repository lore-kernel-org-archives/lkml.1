Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab0CAJ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:56:59 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55056 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0CAJ46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:56:58 -0500
Date: Mon, 1 Mar 2010 10:56:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: don't access jiffies when initialising
	io_context
Message-ID: <20100301095656.GV5768@kernel.dk>
References: <1267437213.2127.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267437213.2127.18.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01 2010, Richard Kennedy wrote:
> As the comment says the initial value of last_waited is never used, so
> there is no need to initialise it with the current jiffies. Jiffies is
> hot enough without accessing it for no reason.

Applied, though it will not make a huge difference in any way.
alloc_io_context() only gets called the first time a process does IO, so
it's not a hot path.

> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ---
> patch against 2.6.33
> compiled & tested on x86_64
> 
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 98e6bf6..3f65c8a 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -91,7 +91,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
>  		spin_lock_init(&ret->lock);
>  		ret->ioprio_changed = 0;
>  		ret->ioprio = 0;
> -		ret->last_waited = jiffies; /* doesn't matter... */
> +		ret->last_waited = 0; /* doesn't matter... */
>  		ret->nr_batch_requests = 0; /* because this is 0 */
>  		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
>  		INIT_HLIST_HEAD(&ret->cic_list);
> 
> 

-- 
Jens Axboe

