Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZBJKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZBJKmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZBJKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:42:47 -0500
Received: from cmpxchg.org ([85.214.51.133]:54414 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZBJKmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:42:46 -0500
Date: Tue, 10 Feb 2009 11:42:22 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: remove zone->prev_prioriy
Message-ID: <20090210104222.GB1740@cmpxchg.org>
References: <20090210184055.6FCB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210184055.6FCB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 06:42:30PM +0900, KOSAKI Motohiro wrote:
> 
> KAMEZAWA Hiroyuki sugessted to remove zone->prev_priority.
> it's because Split-LRU VM doesn't use this parameter at all.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/memcontrol.h |   27 -------------------------
>  include/linux/mmzone.h     |   15 --------------
>  mm/memcontrol.c            |   31 -----------------------------
>  mm/page_alloc.c            |    2 -
>  mm/vmscan.c                |   48 ++-------------------------------------------
>  mm/vmstat.c                |    2 -
>  6 files changed, 3 insertions(+), 122 deletions(-)

> Index: b/include/linux/memcontrol.h
> ===================================================================
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -88,14 +88,7 @@ extern void mem_cgroup_end_migration(str
>  /*
>   * For memory reclaim.
>   */
> -extern int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem);

This bit crept in from the next patch, I think.

>  extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
> -
> -extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
> -extern void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
> -							int priority);
> -extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
> -							int priority);
>  int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
>  unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
>  				       struct zone *zone,
> @@ -209,31 +202,11 @@ static inline void mem_cgroup_end_migrat
>  {
>  }
>  
> -static inline int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
> -{
> -	return 0;
> -}
> -

:)

Looks good to me otherwise.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
