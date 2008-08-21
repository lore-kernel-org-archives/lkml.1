Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYHUKXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYHUKXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYHUKXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:23:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34758 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYHUKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:23:07 -0400
Date: Thu, 21 Aug 2008 19:22:11 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com, travis <travis@sgi.com>
In-Reply-To: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <1219311154.8651.96.camel@twins> <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080821192130.22B5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, following patch is crap.
please forget it.

I'll respin it soon.


> 
> ---
>  mm/quicklist.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: b/mm/quicklist.c
> ===================================================================
> --- a/mm/quicklist.c
> +++ b/mm/quicklist.c
> @@ -26,7 +26,10 @@ DEFINE_PER_CPU(struct quicklist, quickli
>  static unsigned long max_pages(unsigned long min_pages)
>  {
>  	unsigned long node_free_pages, max;
> -	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
> +	int node = numa_node_id();
> +	struct zone *zones = NODE_DATA(node)->node_zones;
> +	int num_cpus_on_node;
> +	node_to_cpumask_ptr(cpumask_on_node, node);
>  
>  	node_free_pages =
>  #ifdef CONFIG_ZONE_DMA
> @@ -38,6 +41,10 @@ static unsigned long max_pages(unsigned 
>  		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
>  
>  	max = node_free_pages / FRACTION_OF_NODE_MEM;
> +
> +	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
> +	max /= num_cpus_on_node;
> +
>  	return max(max, min_pages);
>  }





