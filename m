Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZECLzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZECLzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZECLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:55:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:47274 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZECLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,286,1239001200"; 
   d="scan'208";a="138623582"
Date: Sun, 3 May 2009 19:54:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] mm: Add __GFP_NO_OOM_KILL flag
Message-ID: <20090503115450.GB9661@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090502104947.2720f173.akpm@linux-foundation.org> <200905030220.57933.rjw@sisk.pl> <200905030222.07360.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905030222.07360.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 02:22:06AM +0200, Rafael J. Wysocki wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> > > Remind me: why can't we just allocate N pages at suspend-time?
> > 
> > We need half of memory free. The reason we can't "just allocate" is
> > probably OOM killer; but my memories are quite weak :-(.
> 
> hm.  You'd think that with our splendid range of __GFP_foo falgs, there
> would be some combo which would suit this requirement but I can't
> immediately spot one.
> 
> We can always add another I guess.  Something like...
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  include/linux/gfp.h |    3 ++-
>  mm/page_alloc.c     |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -1620,7 +1620,8 @@ nofail_alloc:
>  		}
>  
>  		/* The OOM killer will not help higher order allocs so fail */
> -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> +				(gfp_mask & __GFP_NO_OOM_KILL)) {
>  			clear_zonelist_oom(zonelist, gfp_mask);
>  			goto nopage;
>  		}
> Index: linux-2.6/include/linux/gfp.h
> ===================================================================
> --- linux-2.6.orig/include/linux/gfp.h
> +++ linux-2.6/include/linux/gfp.h
> @@ -51,8 +51,9 @@ struct vm_area_struct;
>  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
>  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
> +#define __GFP_NO_OOM_KILL ((__force gfp_t)0x200000u)  /* Don't invoke out_of_memory() */
>  
> -#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
> +#define __GFP_BITS_SHIFT 22	/* Number of__GFP_FOO bits */
                                            ^ missed a white space :)
