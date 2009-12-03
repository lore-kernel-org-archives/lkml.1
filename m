Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZLCL5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZLCL5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZLCL5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:57:34 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44715 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZLCL5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:57:34 -0500
Date: Thu, 3 Dec 2009 12:57:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC]cfq-iosched: no dispatch limit for single queue
Message-ID: <20091203115740.GM8742@kernel.dk>
References: <20091203035330.GB13165@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203035330.GB13165@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03 2009, Shaohua Li wrote:
> Since commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5, each queue can send
> up to 4 * 4 requests if only one queue exists. I wonder why we have such limit.
> Device supports tag can send more requests. For example, AHCI can send 31
> requests. Test (direct aio randread) shows the limits reduce about 4% disk
> thoughput.
> On the other hand, since we send one request one time, if other queue
> pop when current is sending more than cfq_quantum requests, current queue will
> stop send requests soon after one request, so sounds there is no big latency.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index aa1e953..e05650f 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1298,9 +1298,9 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  			return false;
>  
>  		/*
> -		 * Sole queue user, allow bigger slice
> +		 * Sole queue user, no limit
>  		 */
> -		max_dispatch *= 4;
> +		max_dispatch = -1;
>  	}
>  
>  	/*

As you mention, we do dispatches in bites of 1. In reality, there's
going to be little difference when we get this far in the depth process,
so I think the patch looks good. I have applied it, thanks.

-- 
Jens Axboe

