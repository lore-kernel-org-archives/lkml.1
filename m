Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbYCCSEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbYCCSEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCCSD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:03:59 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40148 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753527AbYCCSD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:03:58 -0500
Date: Mon, 3 Mar 2008 10:03:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 03/10] Pageflags: Convert to the use of new macros
In-Reply-To: <20080303102435.GD19485@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0803031001440.6010@schroedinger.engr.sgi.com>
References: <20080301040534.797979115@sgi.com> <20080301040620.520359881@sgi.com>
 <20080303102435.GD19485@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Mel Gorman wrote:

> > +PAGEFLAG(Checked, owner_priv_1)		/* Used by some filesystems */
> > +PAGEFLAG(Pinned, owner_priv_1)		/* Xen pinned pagetable */
> 
> This is what I was on about earlier with some flag comments being in a
> separate place. Someone grepping for PG_pinned to see what it is for
> would have a bad day.

These aliases seem to be not a good thing. PG_pinned etc are never used. 
Greeping for SetPagePinned etc may be better.

> > +#ifdef CONFIG_HIGHMEM
> > +#define PageHighMem(page)	is_highmem(page_zone(page))
> > +#else
> > +#define PageHighMem(page)	0 /* needed to optimize away at compile time */
> > +#endif
> > +
> 
> Seems to be a tiny inconsistency here. PageSwapCache below is a static
> inline returning 0 that you fixed up as part of the shuffling where as
> PageHighMem is #defined to 0. Care to fix it up too?

Ok.

> > -#define SetPagePrivate(page)	set_bit(PG_private, &(page)->flags)
> > -#define ClearPagePrivate(page)	clear_bit(PG_private, &(page)->flags)
> > -#define PagePrivate(page)	test_bit(PG_private, &(page)->flags)
> > -#define __SetPagePrivate(page)  __set_bit(PG_private, &(page)->flags)
> > -#define __ClearPagePrivate(page) __clear_bit(PG_private, &(page)->flags)
> > +static inline void set_page_writeback(struct page *page)
> > +{
> > +	test_set_page_writeback(page);
> > +}
> 
> It's been around for ages and unrelated to your patch series but it
> looks odd that set_page_writeback() is simply a function alias that
> ignores return values :/

Yes its strange. Is there a set_page_writeback function?
