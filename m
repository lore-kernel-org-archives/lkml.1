Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZGPHkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZGPHkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZGPHkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:40:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55121 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZGPHkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:40:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: update alloc_flags after oom killer has been called
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0907151332320.24006@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907151332320.24006@chino.kir.corp.google.com>
Message-Id: <20090716163926.9D40.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 16:39:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is possible for the oom killer to select current as the task to kill.  
> When this happens, alloc_flags needs to be updated accordingly to set 
> ALLOC_NO_WATERMARKS so the subsequent allocation attempt may use memory 
> reserves as the result of its thread having TIF_MEMDIE set if the 
> allocation is not __GFP_NOMEMALLOC.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1756,6 +1756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  
>  	wake_all_kswapd(order, zonelist, high_zoneidx);
>  
> +restart:
>  	/*
>  	 * OK, we're below the kswapd watermark and have kicked background
>  	 * reclaim. Now things get more complex, so set up alloc_flags according
> @@ -1763,7 +1764,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	 */
>  	alloc_flags = gfp_to_alloc_flags(gfp_mask);
>  
> -restart:
>  	/* This is the last chance, in general, before the goto nopage. */
>  	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
>  			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,

Looks good. thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




