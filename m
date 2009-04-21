Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZDUKId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZDUKId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZDUKIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:08:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51527 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZDUKIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:08:23 -0400
Date: Tue, 21 Apr 2009 11:08:20 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/25] Calculate the cold parameter for allocation only
	once
Message-ID: <20090421100818.GO12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-12-git-send-email-mel@csn.ul.ie> <20090421180551.F142.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090421180551.F142.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:07:24PM +0900, KOSAKI Motohiro wrote:
> > GFP mask is checked for __GFP_COLD has been specified when deciding which
> > end of the PCP lists to use. However, it is happening multiple times per
> > allocation, at least once per zone traversed. Calculate it once.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  mm/page_alloc.c |   35 ++++++++++++++++++-----------------
> >  1 files changed, 18 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 1506cd5..51e1ded 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1066,11 +1066,10 @@ void split_page(struct page *page, unsigned int order)
> >   */
> >  static struct page *buffered_rmqueue(struct zone *preferred_zone,
> >  			struct zone *zone, int order, gfp_t gfp_flags,
> > -			int migratetype)
> > +			int migratetype, int cold)
> >  {
> >  	unsigned long flags;
> >  	struct page *page;
> > -	int cold = !!(gfp_flags & __GFP_COLD);
> >  	int cpu;
> 
> Honestly, I don't like this ;-)
> 
> It seems benefit is too small. It don't win against code ugliness, I think.
> 

Ok, I'll drop it for now and then generate figures for it at a later
time. The intention is to have this first set relatively
uncontroversial.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
