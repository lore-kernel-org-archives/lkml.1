Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215Ab0AAXUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0AAXUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 18:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668Ab0AAXUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 18:20:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0AAXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 18:20:32 -0500
Subject: Re: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim
 too
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
References: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 00:19:46 +0100
Message-ID: <1262387986.16572.234.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-01 at 18:45 +0900, KOSAKI Motohiro wrote:
> Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
> context annotation. But it didn't annotate zone reclaim. This patch do it.

And yet you didn't CC anyone involved in that patch, nor explain why you
think it necessary, massive FAIL.

The lockdep annotations cover all of kswapd() and direct reclaim through
__alloc_pages_direct_reclaim(). So why would you need an explicit
annotation in __zone_reclaim()?

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2bbee91..a039e78 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2547,6 +2547,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	 * and RECLAIM_SWAP.
>  	 */
>  	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
> +	lockdep_set_current_reclaim_state(gfp_mask);
>  	reclaim_state.reclaimed_slab = 0;
>  	p->reclaim_state = &reclaim_state;
>  
> @@ -2590,6 +2591,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  
>  	p->reclaim_state = NULL;
>  	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
> +	lockdep_clear_current_reclaim_state();
>  	return sc.nr_reclaimed >= nr_pages;
>  }
>  


