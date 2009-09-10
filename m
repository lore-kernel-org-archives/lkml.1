Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZIJADK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZIJADK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZIJADJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:03:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44917 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZIJADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:03:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090909093144.GD24614@csn.ul.ie>
References: <20090909175036.0D06.A69D9226@jp.fujitsu.com> <20090909093144.GD24614@csn.ul.ie>
Message-Id: <20090910090141.9CC0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 09:02:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /me slaps self
> 
> I think I see the problem. Can you try this patch please?

After the patch apply, the system boot successful.

Thanks, Mel!

Andrew, Could you please pick this patch?


> ---
> Calculate the number of pageblocks within a range properly
> 
> Patch
> page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback
> is meant to change the pageblock ownership of each pageblock within a
> given range. This is necessary when the buddy to be split is of higher
> order than the pageblock_order. However, the calculation was wrong
> leading to crashes on ia-64 and slightly incorrect behaviour on x86.
> This patch corrects the calculation.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4e0ec94..4326280 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -830,7 +830,7 @@ static int move_freepages_block(struct zone *zone, struct page *page,
>  static void change_pageblock_range(struct page *pageblock_page,
>  					int start_order, int migratetype)
>  {
> -	int nr_pageblocks = 1 << (MAX_ORDER - 1 - start_order);
> +	int nr_pageblocks = 1 << (start_order - pageblock_order);
>  
>  	while (nr_pageblocks--) {
>  		set_pageblock_migratetype(pageblock_page, migratetype);



