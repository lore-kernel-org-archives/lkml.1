Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZJ2NTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZJ2NTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZJ2NTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:19:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34859 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZJ2NTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:19:41 -0400
Date: Thu, 29 Oct 2009 14:19:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: simplify prio-unboost code
Message-ID: <20091029131944.GN10727@kernel.dk>
References: <200910262136.03233.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910262136.03233.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Corrado Zoccolo wrote:
> Eliminate redundant checks.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6e9b395..244bc8a 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2611,12 +2611,10 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
>  			cfqq->ioprio = IOPRIO_NORM;
>  	} else {
>  		/*
> -		 * check if we need to unboost the queue
> +		 * unboost the queue (if needed)
>  		 */
> -		if (cfqq->ioprio_class != cfqq->org_ioprio_class)
> -			cfqq->ioprio_class = cfqq->org_ioprio_class;
> -		if (cfqq->ioprio != cfqq->org_ioprio)
> -			cfqq->ioprio = cfqq->org_ioprio;
> +		cfqq->ioprio_class = cfqq->org_ioprio_class;
> +		cfqq->ioprio = cfqq->org_ioprio;
>  	}

Not sure I see much gain in that, the previous code makes it explicit
that it may not be different and avoid dirtying cfqq if it isn't.

-- 
Jens Axboe

