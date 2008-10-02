Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYJBKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYJBKEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJBKEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 06:04:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33334 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYJBKEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:04:22 -0400
Date: Thu, 02 Oct 2008 19:00:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH] setup_per_zone_pages_min(): take zone->lock instead of zone->lru_lock
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1222882772.4846.40.camel@localhost.localdomain>
References: <20080930103748.44A3.E1E9C6FF@jp.fujitsu.com> <1222882772.4846.40.camel@localhost.localdomain>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081002185250.5767.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks!

Tested-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> From: Gerald Schaefer <gerald.schaefer@de.ibm.com> 
> 
> This replaces zone->lru_lock in setup_per_zone_pages_min() with zone->lock.
> There seems to be no need for the lru_lock anymore, but there is a need for
> zone->lock instead, because that function may call move_freepages() via
> setup_zone_migrate_reserve().
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> ---
>  mm/page_alloc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -4207,7 +4207,7 @@ void setup_per_zone_pages_min(void)
>  	for_each_zone(zone) {
>  		u64 tmp;
>  
> -		spin_lock_irqsave(&zone->lru_lock, flags);
> +		spin_lock_irqsave(&zone->lock, flags);
>  		tmp = (u64)pages_min * zone->present_pages;
>  		do_div(tmp, lowmem_pages);
>  		if (is_highmem(zone)) {
> @@ -4239,7 +4239,7 @@ void setup_per_zone_pages_min(void)
>  		zone->pages_low   = zone->pages_min + (tmp >> 2);
>  		zone->pages_high  = zone->pages_min + (tmp >> 1);
>  		setup_zone_migrate_reserve(zone);
> -		spin_unlock_irqrestore(&zone->lru_lock, flags);
> +		spin_unlock_irqrestore(&zone->lock, flags);
>  	}
>  
>  	/* update totalreserve_pages */
> 
> 

-- 
Yasunori Goto 


