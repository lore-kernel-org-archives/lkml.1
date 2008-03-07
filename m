Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbYCGLOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbYCGLOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbYCGLOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:14:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56374 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbYCGLOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:14:01 -0500
Date: Fri, 7 Mar 2008 11:13:55 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 03/10] Pageflags: Convert to the use of new macros
Message-ID: <20080307111355.GB26229@csn.ul.ie>
References: <20080301040534.797979115@sgi.com> <20080301040620.520359881@sgi.com> <20080303102435.GD19485@csn.ul.ie> <Pine.LNX.4.64.0803031001440.6010@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803031001440.6010@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/03/08 10:03), Christoph Lameter didst pronounce:
> On Mon, 3 Mar 2008, Mel Gorman wrote:
> 
> > > +PAGEFLAG(Checked, owner_priv_1)		/* Used by some filesystems */
> > > +PAGEFLAG(Pinned, owner_priv_1)		/* Xen pinned pagetable */
> > 
> > This is what I was on about earlier with some flag comments being in a
> > separate place. Someone grepping for PG_pinned to see what it is for
> > would have a bad day.
> 
> These aliases seem to be not a good thing. PG_pinned etc are never used. 
> Greeping for SetPagePinned etc may be better.
> 

I guess it's a question of taste. I would prefer all the flags that
exist to be named in the one place so all the comments are there.
However, functionally it's identical no harm.

> > > +#ifdef CONFIG_HIGHMEM
> > > +#define PageHighMem(page)	is_highmem(page_zone(page))
> > > +#else
> > > +#define PageHighMem(page)	0 /* needed to optimize away at compile time */
> > > +#endif
> > > +
> > 
> > Seems to be a tiny inconsistency here. PageSwapCache below is a static
> > inline returning 0 that you fixed up as part of the shuffling where as
> > PageHighMem is #defined to 0. Care to fix it up too?
> 
> Ok.
> 
> > > -#define SetPagePrivate(page)	set_bit(PG_private, &(page)->flags)
> > > -#define ClearPagePrivate(page)	clear_bit(PG_private, &(page)->flags)
> > > -#define PagePrivate(page)	test_bit(PG_private, &(page)->flags)
> > > -#define __SetPagePrivate(page)  __set_bit(PG_private, &(page)->flags)
> > > -#define __ClearPagePrivate(page) __clear_bit(PG_private, &(page)->flags)
> > > +static inline void set_page_writeback(struct page *page)
> > > +{
> > > +	test_set_page_writeback(page);
> > > +}
> > 
> > It's been around for ages and unrelated to your patch series but it
> > looks odd that set_page_writeback() is simply a function alias that
> > ignores return values :/
> 
> Yes its strange. Is there a set_page_writeback function?
> 

Other than this inline, none that I spotted. It has a number of call-sites
though so I guess the intention was to implicitly document that ignoring
the return value was deliberate. Might as well leave it.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
