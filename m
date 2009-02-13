Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbZBMDPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbZBMDPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 22:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZBMDPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:15:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38412 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBMDPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:15:00 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [patch 2/2 v2] vmscan: clip swap_cluster_max in shrink_all_memory()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham-lkml@crca.org.au>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090213091615.28e6a689.minchan.kim@barrios-desktop>
References: <20090213091615.28e6a689.minchan.kim@barrios-desktop>
Message-Id: <20090213121412.0A67.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 13 Feb 2009 12:14:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: MinChan Kim <minchan.kim@gmail.com>
> Acked-by: Nigel Cunningham <ncunningham@crca.org.au>
> Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> 
> 
> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 172e394..ed329c4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2114,7 +2114,6 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>  	struct scan_control sc = {
>  		.gfp_mask = GFP_KERNEL,
>  		.may_unmap = 0,
> -		.swap_cluster_max = nr_pages,
>  		.may_writepage = 1,
>  		.isolate_pages = isolate_pages_global,
>  	};
> @@ -2156,6 +2155,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>  			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
>  
>  			sc.nr_scanned = 0;
> +			sc.swap_cluster_max = nr_to_scan;
>  			shrink_all_zones(nr_to_scan, prio, pass, &sc);
>  			if (sc.nr_reclaimed >= nr_pages) 
>  				goto out;

good catch.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



