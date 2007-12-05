Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbXLEKML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbXLEKML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXLEKL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:11:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:36827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXLEKL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:11:56 -0500
Date: Wed, 5 Dec 2007 11:11:55 +0100
From: Nick Piggin <npiggin@suse.de>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [PATCH] as-iosched: fix incorrect comments
Message-ID: <20071205101155.GD1114@wotan.suse.de>
References: <4756783A.5020204@gelato.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756783A.5020204@gelato.unsw.edu.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 09:06:50PM +1100, Aaron Carroll wrote:
> Two comments refer to deadlines applying to reads only.  This is
> not the case.
> 
> Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>

Acked-by: Nick Piggin <npiggin@suse.de>

> ---
>  block/as-iosched.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/as-iosched.c b/block/as-iosched.c
> index dc715a5..4513fc5 100644
> --- a/block/as-iosched.c
> +++ b/block/as-iosched.c
> @@ -880,7 +880,7 @@ static void as_remove_queued_request(struct request_queue *q,
>  }
>  
>  /*
> - * as_fifo_expired returns 0 if there are no expired reads on the fifo,
> + * as_fifo_expired returns 0 if there are no expired requests on the fifo,
>   * 1 otherwise.  It is ratelimited so that we only perform the check once per
>   * `fifo_expire' interval.  Otherwise a large number of expired requests
>   * would create a hopeless seekstorm.
> @@ -1159,7 +1159,7 @@ static void as_add_request(struct request_queue *q, struct request *rq)
>  	as_add_rq_rb(ad, rq);
>  
>  	/*
> -	 * set expire time (only used for reads) and add to fifo list
> +	 * set expire time and add to fifo list
>  	 */
>  	rq_set_fifo_time(rq, jiffies + ad->fifo_expire[data_dir]);
>  	list_add_tail(&rq->queuelist, &ad->fifo_list[data_dir]);
> -- 
