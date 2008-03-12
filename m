Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYCLN67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYCLN67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYCLN6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:58:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57947 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYCLN6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:58:50 -0400
Date: Wed, 12 Mar 2008 13:58:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH rc5-mm1 2/3] just return do_try_to_free_pages
Message-ID: <20080312135846.GB6072@csn.ul.ie>
References: <Pine.LNX.4.64.0803112108470.17067@blonde.site> <Pine.LNX.4.64.0803112112310.17067@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803112112310.17067@blonde.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/03/08 21:14), Hugh Dickins didst pronounce:
> do_try_to_free_pages returns 0 or 1, and try_to_free_mem_cgroup_pages
> returns 0 or 1 accordingly: let's accomplish that in the obvious way.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Looks right, it means it's behaviour closer matches try_to_free_pages()
which is a bonus.

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
>  mm/vmscan.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- 2.6.25-rc5-mm1+/mm/vmscan.c	2008-03-11 20:09:05.000000000 +0000
> +++ linux/mm/vmscan.c	2008-03-11 20:15:47.000000000 +0000
> @@ -1457,9 +1457,7 @@ unsigned long try_to_free_mem_cgroup_pag
>  	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>  			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
>  	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
> -	if (do_try_to_free_pages(zonelist, sc.gfp_mask, &sc))
> -		return 1;
> -	return 0;
> +	return do_try_to_free_pages(zonelist, sc.gfp_mask, &sc);
>  }
>  #endif
>  
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
