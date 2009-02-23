Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZBWLoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZBWLoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZBWLoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:44:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55289 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZBWLoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:44:21 -0500
Date: Mon, 23 Feb 2009 11:44:19 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 13/20] Inline buffered_rmqueue()
Message-ID: <20090223114419.GE6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-14-git-send-email-mel@csn.ul.ie> <84144f020902222324i38de9a63hd112b90742c2ca8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <84144f020902222324i38de9a63hd112b90742c2ca8c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:24:19AM +0200, Pekka Enberg wrote:
> On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > buffered_rmqueue() is in the fast path so inline it. This incurs text
> > bloat as there is now a copy in the fast and slow paths but the cost of
> > the function call was noticeable in profiles of the fast path.
> >
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  mm/page_alloc.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d8a6828..2383147 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1080,7 +1080,8 @@ void split_page(struct page *page, unsigned int order)
> >  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
> >  * or two.
> >  */
> > -static struct page *buffered_rmqueue(struct zone *preferred_zone,
> > +static inline
> > +struct page *buffered_rmqueue(struct zone *preferred_zone,
> >                        struct zone *zone, int order, gfp_t gfp_flags,
> >                        int migratetype)
> >  {
> 
> I'm not sure if this is changed now but at least in the past, you had
> to use __always_inline to force GCC to do the inlining for all
> configurations.
> 

Hmm, as there is only one call-site, I would expect gcc to inline it. I
can force it though. Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
