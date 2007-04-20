Return-Path: <linux-kernel-owner+w=401wt.eu-S2992648AbXDTImc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992648AbXDTImc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992642AbXDTImc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:42:32 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:41588 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992648AbXDTIma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:42:30 -0400
Date: Fri, 20 Apr 2007 09:42:29 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Pierre Peiffer <Pierre.Peiffer@bull.net>
cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] fix undefined symbol if CONFIG_PAGE_GROUP_BY_MOBILITY
 not set
In-Reply-To: <20070420100744.cd287042.Pierre.Peiffer@bull.net>
Message-ID: <Pine.LNX.4.64.0704200940460.6816@skynet.skynet.ie>
References: <20070420100744.cd287042.Pierre.Peiffer@bull.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Pierre Peiffer wrote:

> Hi,
>
> This is a fix against the patch
> do-not-group-pages-by-mobility-type-on-low-memory-systems.patch (include in -mm
> tree):
> The error "page_group_by_mobility_disabled undefinied" occured if
> CONFIG_PAGE_GROUP_BY_MOBILITY is not set.
>
> Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
>

Hi,

Your fix looks correct but the compile-time option 
CONFIG_PAGE_GROUP_BY_MOBILITY was removed in a patch I sent to Andrew two 
days ago. It went into mm-commits last night so this problem should no 
longer exist.

> ---
> mm/page_alloc.c |    5 +++++
> 1 file changed, 5 insertions(+)
>
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2297,6 +2297,7 @@ void __meminit build_all_zonelists(void)
> 	}
> 	vm_total_pages = nr_free_pagecache_pages();
>
> +#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
> 	/*
> 	 * Disable grouping by mobility if the number of pages in the
> 	 * system is too low to allow the mechanism to work. It would be
> @@ -2313,6 +2314,10 @@ void __meminit build_all_zonelists(void)
> 			num_online_nodes(),
> 			page_group_by_mobility_disabled ? "off" : "on",
> 			vm_total_pages);
> +#else
> +	printk("Built %i zonelists.  Total pages: %ld\n",
> +	       num_online_nodes(), vm_total_pages);
> +#endif
> }
>
> /*
>
>
> -- 
> Pierre
>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
