Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZERCeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZERCeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZERCeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:34:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:64370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZERCeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:34:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143876769"
Date: Mon, 18 May 2009 10:34:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in
	case of no swap space V3
Message-ID: <20090518023404.GB5869@localhost>
References: <20090514231555.f52c81eb.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514231555.f52c81eb.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 11:15:55PM +0900, MinChan Kim wrote:
 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2f9d555..621708f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
>  	 * Even if we did not try to evict anon pages at all, we want to
>  	 * rebalance the anon lru active/inactive ratio.
>  	 */
> -	if (inactive_anon_is_low(zone, sc))
> +	if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);

There's another "if (inactive_anon_is_low) shrink_active_list;"
occurrence to be fixed in balance_pgdat()? Otherwise:

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
