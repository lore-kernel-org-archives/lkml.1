Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbYF2Bj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbYF2Bj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 21:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYF2BjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 21:39:17 -0400
Received: from [194.117.236.238] ([194.117.236.238]:51299 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYF2BjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 21:39:16 -0400
Date: Sun, 29 Jun 2008 04:38:27 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] block: GFP_ATOMIC is __GFP_HIGH
Message-ID: <20080629043827.135f39d7@linux360.ro>
In-Reply-To: <Pine.LNX.4.64.0806290052350.18327@blonde.site>
References: <Pine.LNX.4.64.0806290052350.18327@blonde.site>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 00:54:27 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> GFP_ATOMIC is __GFP_HIGH: no need for alloc_io_context() to add that.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  block/blk-ioc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next/block/blk-ioc.c	2008-05-12 02:01:05.000000000
> +0100 +++ linux/block/blk-ioc.c	2008-06-27 14:08:00.000000000
> +0100 @@ -98,7 +98,7 @@ struct io_context *alloc_io_context(gfp_
>  		ret->last_waited = jiffies; /* doesn't matter... */
>  		ret->nr_batch_requests = 0; /* because this is 0 */
>  		ret->aic = NULL;
> -		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC |
> __GFP_HIGH);
> +		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC);
>  		INIT_HLIST_HEAD(&ret->cic_list);
>  		ret->ioc_data = NULL;
>  	}

Hi,

I'm not sure this is a good idea: GFP_ATOMIC and __GFP_HIGH are
semantically different, even though they are equivalent at the moment.
Have you seen GFP_NOWAIT's definition?
/* This equals 0, but use constants in case they ever change */
#define GFP_NOWAIT      (GFP_ATOMIC & ~__GFP_HIGH)

I think it's best to look at what that code intends to do, not at what
it does at the moment. Definitions for gfp flags might change in the
future.

If the code does not _semantically_ need __GFP_HIGH, then your commit
message should indicate so, rather than comparing it with GFP_ATOMIC.


	Cheers,
	Eduard
