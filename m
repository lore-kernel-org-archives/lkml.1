Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYCLOFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYCLOFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYCLOEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:04:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54371 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbYCLOEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:04:52 -0400
Date: Wed, 12 Mar 2008 14:04:47 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH rc5-mm1 3/3] do_try_to_free_pages gfp_mask redundant
Message-ID: <20080312140447.GC6072@csn.ul.ie>
References: <Pine.LNX.4.64.0803112108470.17067@blonde.site> <Pine.LNX.4.64.0803112114080.17067@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803112114080.17067@blonde.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/03/08 21:16), Hugh Dickins didst pronounce:
> do_try_to_free_pages is taking both a gfp_mask and an sc->gfp_mask,
> sometimes one used and sometimes the other; at present they're always
> identical, but such duplication begs for trouble: remove gfp_mask arg.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
>  mm/vmscan.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- 2.6.25-rc5-mm1++/mm/vmscan.c	2008-03-11 20:15:47.000000000 +0000
> +++ linux/mm/vmscan.c	2008-03-11 20:21:14.000000000 +0000
> @@ -1324,7 +1324,7 @@ static unsigned long shrink_zones(int pr
>   * allocation attempt will fail.
>   */
>  static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
> -					gfp_t gfp_mask, struct scan_control *sc)
> +					struct scan_control *sc)
>  {
>  	int priority;
>  	int ret = 0;
> @@ -1334,7 +1334,7 @@ static unsigned long do_try_to_free_page
>  	unsigned long lru_pages = 0;
>  	struct zoneref *z;
>  	struct zone *zone;
> -	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> +	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
>  
>  	if (scan_global_lru(sc))
>  		count_vm_event(ALLOCSTALL);
> @@ -1363,7 +1363,7 @@ static unsigned long do_try_to_free_page
>  		 * over limit cgroups
>  		 */
>  		if (scan_global_lru(sc)) {
> -			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
> +			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
>  			if (reclaim_state) {
>  				nr_reclaimed += reclaim_state->reclaimed_slab;
>  				reclaim_state->reclaimed_slab = 0;
> @@ -1435,7 +1435,7 @@ unsigned long try_to_free_pages(struct z
>  		.isolate_pages = isolate_pages_global,
>  	};
>  
> -	return do_try_to_free_pages(zonelist, gfp_mask, &sc);
> +	return do_try_to_free_pages(zonelist, &sc);
>  }
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> @@ -1457,7 +1457,7 @@ unsigned long try_to_free_mem_cgroup_pag
>  	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>  			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
>  	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
> -	return do_try_to_free_pages(zonelist, sc.gfp_mask, &sc);
> +	return do_try_to_free_pages(zonelist, &sc);
>  }
>  #endif
>  
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
