Return-Path: <linux-kernel-owner+w=401wt.eu-S1750986AbXCHLBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbXCHLBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXCHLBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:01:08 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:58154 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbXCHLBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:01:07 -0500
Date: Thu, 8 Mar 2007 11:01:05 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG_ON check at move_freepages() (Re: 2.6.21-rc3-mm2)
In-Reply-To: <20070308162944.FB7F.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0703081057170.1615@skynet.skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org>
 <20070308162944.FB7F.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Yasunori Goto wrote:

>
> Hello.
>
> The BUG_ON() check at move_freepages() is wrong.
> Its end_page is start_page + MAX_ORDER_NR_PAGES. So, it can be
> next zone. BUG_ON() should check "end_page - 1".
>

You're right on all counts.

> This is fix of 2.6.21-rc3-mm2 for it.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> mm/page_alloc.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: current_test/mm/page_alloc.c
> ===================================================================
> --- current_test.orig/mm/page_alloc.c	2007-03-08 15:44:10.000000000 +0900
> +++ current_test/mm/page_alloc.c	2007-03-08 16:17:29.000000000 +0900
> @@ -707,7 +707,7 @@ int move_freepages(struct zone *zone,
> 	unsigned long order;
> 	int blocks_moved = 0;
>
> -	BUG_ON(page_zone(start_page) != page_zone(end_page));
> +	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
>
> 	for (page = start_page; page < end_page;) {
> 		if (!PageBuddy(page)) {
>
> -- 
> Yasunori Goto
>
>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
