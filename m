Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZIHAz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZIHAz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZIHAz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:55:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:31183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbZIHAz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:55:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185011766"
Date: Tue, 8 Sep 2009 08:55:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] trace bio queueing trial only when it occurs
Message-ID: <20090908005520.GA7967@localhost>
References: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan,

I tend to agree with the change, but somehow confused by blkparse(1):

        Q -- queued   This notes *intent* to queue i/o at the given location.  No real requests exists yet.

Li Zefan has been working on blktrace and he can tell more.

Thanks,
Fengguang

On Tue, Sep 08, 2009 at 08:34:16AM +0800, Minchan Kim wrote:
> 
> It got lost in LKML mail storm.
> I resend this.
> Wu, Could you review this patch, please?
> 
> == CUT_HERE ==
> 
> If BIO is discarded or cross over end of device,
> BIO queueing trial doesn't occur.
> 
> Let's trace it only when it happens.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  block/blk-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5b59592..1a0cfd5 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1463,8 +1463,6 @@ static inline void __generic_make_request(struct bio *bio)
>  		if (old_sector != -1)
>  			trace_block_remap(q, bio, old_dev, old_sector);
> 
> -		trace_block_bio_queue(q, bio);
> -
>  		old_sector = bio->bi_sector;
>  		old_dev = bio->bi_bdev->bd_dev;
> 
> @@ -1477,6 +1475,8 @@ static inline void __generic_make_request(struct bio *bio)
>  			goto end_io;
>  		}
> 
> +		trace_block_bio_queue(q, bio);
> +
>  		ret = q->make_request_fn(q, bio);
>  	} while (ret);
> 
> --
> 1.6.4
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
