Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZGXMCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZGXMCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 08:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZGXMCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 08:02:04 -0400
Received: from cmpxchg.org ([85.214.51.133]:35550 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZGXMCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 08:02:04 -0400
Date: Fri, 24 Jul 2009 14:00:04 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee.Schermerhorn@hp.com, penberg@cs.helsinki.fi, jirislaby@gmail.com
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set V2
Message-ID: <20090724120004.GA2874@cmpxchg.org>
References: <20090715125822.GB29749@csn.ul.ie> <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090722160649.61176c61.akpm@linux-foundation.org> <20090723102938.GA27731@csn.ul.ie> <20090723102316.b94a2e4f.akpm@linux-foundation.org> <20090724103656.GA18074@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724103656.GA18074@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 11:36:56AM +0100, Mel Gorman wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b8283e8..d3d0707 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -488,6 +488,11 @@ static inline void __free_one_page(struct page *page,
>   */
>  static inline void free_page_mlock(struct page *page)
>  {
> +	WARN_ONCE(1, KERN_WARNING
> +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> +		"page:%p flags:%#lx\n",
> +		current->comm, page_to_pfn(page),
> +		page, page->flags|__PG_MLOCKED);

I don't think printing page->flags is all too useful after they have
been cleared by free_pages_check().

But it's probably a reasonable trade-off for not having it in the
fast-path.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
