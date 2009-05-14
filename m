Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZENPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZENPgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZENPgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:36:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZENPgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:36:08 -0400
Message-ID: <4A0C37D0.60004@redhat.com>
Date: Thu, 14 May 2009 11:25:04 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: MinChan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case
 of no swap space V3
References: <20090514231555.f52c81eb.minchan.kim@gmail.com>
In-Reply-To: <20090514231555.f52c81eb.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MinChan Kim wrote:

> This patch prevents unnecessary deactivation of anon lru pages.
> But, it don't prevent aging of anon pages to swap out.

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
>  	 * Even if we did not try to evict anon pages at all, we want to
>  	 * rebalance the anon lru active/inactive ratio.
>  	 */
> -	if (inactive_anon_is_low(zone, sc))
> +	if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>  
>  	throttle_vm_writeout(sc->gfp_mask);

Acked-by: Rik van Riel <riel@redhat.com>
