Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbZLOWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbZLOWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761355AbZLOWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:16:25 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46344 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761353AbZLOWQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:24 -0500
Date: Tue, 15 Dec 2009 23:16:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Heinz Diehl <htd@fancy-poultry.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
	mapper warnings
Message-ID: <20091215221623.GH28252@kernel.dk>
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209212516.GA6206@fancy-poultry.org> <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk> <alpine.DEB.2.01.0912151354350.3483@bogon.housecafe.de> <20091215220249.GG28252@kernel.dk> <yq14onrubyq.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq14onrubyq.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> I'll revert the bad commit tomorrow so that -rc1 wont be affected,
> Jens> at least.
> 
> I'm pretty close to having a new stacking algorithm that works.  If I
> don't have it ready by tomorrow maybe we should commit the following
> patch instead of reverting the discard changes wholesale?
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index dd1f1e0..65ae861 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -555,10 +555,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	}
>  
>  	if (offset &&
> -	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
> +	    (offset & (b->discard_granularity - 1)) != b->discard_alignment)
>  		t->discard_misaligned = 1;
> -		ret = -1;
> -	}
>  
>  	/* If top has no alignment offset, inherit from bottom */
>  	if (!t->alignment_offset)

I guess we could do that, as long as it gets really fixed before 2.6.33.
It's a bit ugly to be exporting the device as misaligned, when it's
really just a fudged internally.

-- 
Jens Axboe

