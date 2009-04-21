Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZDUKL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZDUKL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZDUKLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:11:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51590 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZDUKLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:11:18 -0400
Date: Tue, 21 Apr 2009 11:11:15 +0100
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
Subject: Re: [PATCH 13/25] Inline __rmqueue_smallest()
Message-ID: <20090421101115.GP12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-14-git-send-email-mel@csn.ul.ie> <20090421185025.F156.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090421185025.F156.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:52:28PM +0900, KOSAKI Motohiro wrote:
> > Inline __rmqueue_smallest by altering flow very slightly so that there
> > is only one call site. This allows the function to be inlined without
> > additional text bloat.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> > ---
> >  mm/page_alloc.c |   23 ++++++++++++++++++-----
> >  1 files changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b13fc29..91a2cdb 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -665,7 +665,8 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
> >   * Go through the free lists for the given migratetype and remove
> >   * the smallest available page from the freelists
> >   */
> > -static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
> > +static inline
> > +struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
> >  						int migratetype)
> 
> "only one caller" is one of keypoint of this patch, I think.
> so, commenting is better? but it isn't blocking reason at all.
> 
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 

Is this better?

Inline __rmqueue_smallest by altering flow very slightly so that there
is only one call site. Because there is only one call-site, this
function can then be inlined without causing text bloat.

I don't see a need to add a comment into the function itself as I don't
think it would help any.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
