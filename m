Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZDUBp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZDUBp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZDUBpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:45:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40791 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZDUBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:45:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/25] Do not sanity check order in the fast path
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
In-Reply-To: <1240266011-11140-3-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421104445.F11C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 10:45:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -182,9 +182,6 @@ __alloc_pages(gfp_t gfp_mask, unsigned int order,
>  static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
>  						unsigned int order)
>  {
> -	if (unlikely(order >= MAX_ORDER))
> -		return NULL;
> -
>  	/* Unknown node is current node */
>  	if (nid < 0)
>  		nid = numa_node_id();
> @@ -198,9 +195,6 @@ extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
>  static inline struct page *
>  alloc_pages(gfp_t gfp_mask, unsigned int order)
>  {
> -	if (unlikely(order >= MAX_ORDER))
> -		return NULL;
> -
>  	return alloc_pages_current(gfp_mask, order);
>  }
>  extern struct page *alloc_page_vma(gfp_t gfp_mask,
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dcc4f05..5028f40 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1405,6 +1405,8 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
>  
>  	classzone_idx = zone_idx(preferred_zone);
>  
> +	VM_BUG_ON(order >= MAX_ORDER);
> +

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




