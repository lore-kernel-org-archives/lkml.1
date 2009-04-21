Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbZDUBob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbZDUBob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZDUBoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:44:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40721 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZDUBoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:44:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 01/25] Replace __alloc_pages_internal() with __alloc_pages_nodemask()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-2-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421104346.F119.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 10:44:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  include/linux/gfp.h |   12 ++----------
>  mm/page_alloc.c     |    4 ++--
>  2 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 0bbc15f..556c840 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -169,24 +169,16 @@ static inline void arch_alloc_page(struct page *page, int order) { }
>  #endif
>  
>  struct page *
> -__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
> +__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  		       struct zonelist *zonelist, nodemask_t *nodemask);
>  
>  static inline struct page *
>  __alloc_pages(gfp_t gfp_mask, unsigned int order,
>  		struct zonelist *zonelist)
>  {
> -	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
> +	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
>  }
>  
> -static inline struct page *
> -__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> -		struct zonelist *zonelist, nodemask_t *nodemask)
> -{
> -	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
> -}
> -
> -
>  static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
>  						unsigned int order)
>  {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e4ea469..dcc4f05 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1462,7 +1462,7 @@ try_next_zone:
>   * This is the 'heart' of the zoned buddy allocator.
>   */
>  struct page *
> -__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
> +__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  			struct zonelist *zonelist, nodemask_t *nodemask)
>  {

sorry, late review.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



