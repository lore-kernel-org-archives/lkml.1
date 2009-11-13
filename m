Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZKMN4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZKMN4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZKMN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:56:15 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53953 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZKMN4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:56:14 -0500
Date: Fri, 13 Nov 2009 13:56:16 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 2/5] page allocator: Do not allow interrupts to use
	ALLOC_HARDER
Message-ID: <20091113135616.GH29804@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <1258054235-3208-3-git-send-email-mel@csn.ul.ie> <20091113142328.33B0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091113142328.33B0.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:24:13PM +0900, KOSAKI Motohiro wrote:
> > Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> > slightly by allowing rt_tasks that are handling an interrupt to set
> > ALLOC_HARDER. This patch brings the watermark logic more in line with
> > 2.6.30.
> 
> ditto.
> afaik, this patch have been sent to linus.
> 

And ditto, it's there for testers, particularly when patching against
2.6.31.

> 
> > 
> > [rientjes@google.com: Spotted the problem]
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/page_alloc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 250d055..2bc2ac6 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> >  		 */
> >  		alloc_flags &= ~ALLOC_CPUSET;
> > -	} else if (unlikely(rt_task(p)))
> > +	} else if (unlikely(rt_task(p)) && !in_interrupt())
> >  		alloc_flags |= ALLOC_HARDER;
> >  
> >  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> > -- 
> > 1.6.5
> > 
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
