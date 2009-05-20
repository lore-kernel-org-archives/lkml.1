Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZETH0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZETH0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZETH0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:26:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53022 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbZETH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:26:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] add inactive ratio calculation function of each zone
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20090520161936.c86a0e38.minchan.kim@barrios-desktop>
References: <20090520161936.c86a0e38.minchan.kim@barrios-desktop>
Message-Id: <20090520162527.7449.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 May 2009 16:26:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch divides setup_per_zone_inactive_ratio with
> per zone inactive ratio calculaton.
> 
> CC: Rik van Riel <riel@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

looks good.
  Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  include/linux/mm.h |    1 +
>  mm/page_alloc.c    |   14 +++++++++-----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1b2cb16..cede957 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1059,6 +1059,7 @@ extern void set_dma_reserve(unsigned long new_dma_reserve);
>  extern void memmap_init_zone(unsigned long, int, unsigned long,
>  				unsigned long, enum memmap_context);
>  extern void setup_per_zone_wmark_min(void);
> +extern void calculate_per_zone_inactive_ratio(struct zone* zone);
>  extern void mem_init(void);
>  extern void __init mmap_init(void);
>  extern void show_mem(void);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 273526b..4601ba0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4552,11 +4552,8 @@ void setup_per_zone_wmark_min(void)
>   *    1TB     101        10GB
>   *   10TB     320        32GB
>   */
> -static void __init setup_per_zone_inactive_ratio(void)
> +void calculate_per_zone_inactive_ratio(struct zone* zone)
>  {
> -	struct zone *zone;
> -
> -	for_each_zone(zone) {
>  		unsigned int gb, ratio;
>  
>  		/* Zone size in gigabytes */
> @@ -4567,7 +4564,14 @@ static void __init setup_per_zone_inactive_ratio(void)
>  			ratio = 1;
>  
>  		zone->inactive_ratio = ratio;
> -	}
> +}
> +
> +static void __init setup_per_zone_inactive_ratio(void)
> +{
> +	struct zone *zone;
> +
> +	for_each_zone(zone) 
> +		calculate_per_zone_inactive_ratio(zone);
>  }
>  
>  /*
> -- 
> 1.5.4.3
> 
> 
> 
> -- 
> Kinds Regards
> Minchan Kim



