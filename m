Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZGXM7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZGXM7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 08:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZGXM7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 08:59:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34658 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZGXM7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 08:59:11 -0400
Date: Fri, 24 Jul 2009 13:59:10 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee.Schermerhorn@hp.com, penberg@cs.helsinki.fi, jirislaby@gmail.com
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
	V2
Message-ID: <20090724125910.GB18074@csn.ul.ie>
References: <20090715125822.GB29749@csn.ul.ie> <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090722160649.61176c61.akpm@linux-foundation.org> <20090723102938.GA27731@csn.ul.ie> <20090723102316.b94a2e4f.akpm@linux-foundation.org> <20090724103656.GA18074@csn.ul.ie> <20090724120004.GA2874@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090724120004.GA2874@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 02:00:04PM +0200, Johannes Weiner wrote:
> On Fri, Jul 24, 2009 at 11:36:56AM +0100, Mel Gorman wrote:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b8283e8..d3d0707 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -488,6 +488,11 @@ static inline void __free_one_page(struct page *page,
> >   */
> >  static inline void free_page_mlock(struct page *page)
> >  {
> > +	WARN_ONCE(1, KERN_WARNING
> > +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> > +		"page:%p flags:%#lx\n",
> > +		current->comm, page_to_pfn(page),
> > +		page, page->flags|__PG_MLOCKED);
> 
> I don't think printing page->flags is all too useful after they have
> been cleared by free_pages_check().
> 

I considered that and was going to drop them. Then I remembered that the
node and zone linkages can also be encoded in the flags and conceivably they
could still be useful so I left it.

> But it's probably a reasonable trade-off for not having it in the
> fast-path.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
