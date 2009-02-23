Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZBWPMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZBWPMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZBWPKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:10:34 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51050 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755703AbZBWPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:10:32 -0500
Date: Mon, 23 Feb 2009 10:01:35 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 03/20] Do not check NUMA node ID when the caller knows
 the node is valid
In-Reply-To: <1235344649-18265-4-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902230958440.7298@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-4-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, Mel Gorman wrote:

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 75f49d3..6566c9e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1318,11 +1318,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	for (i = 0; i < area->nr_pages; i++) {
>  		struct page *page;
>
> -		if (node < 0)
> -			page = alloc_page(gfp_mask);
> -		else
> -			page = alloc_pages_node(node, gfp_mask, 0);
> -
> +		page = alloc_pages_node(node, gfp_mask, 0);
>  		if (unlikely(!page)) {
>  			/* Successfully allocated i pages, free them in __vunmap() */
>  			area->nr_pages = i;
>

That wont work. alloc_pages() obeys memory policies. alloc_pages_node()
does not.


