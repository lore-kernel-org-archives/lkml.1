Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbZJaSlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbZJaSlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932898AbZJaSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:41:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55070 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbZJaSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:40:59 -0400
Date: Sat, 31 Oct 2009 19:40:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
	ALLOC_HARDER
Message-ID: <20091031184054.GB1475@ucw.cz>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-27 14:12:36, David Rientjes wrote:
> On Tue, 27 Oct 2009, Andrew Morton wrote:
> 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index dfa4362..7f2aa3e 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> > >  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> > >  		 */
> > >  		alloc_flags &= ~ALLOC_CPUSET;
> > > -	} else if (unlikely(rt_task(p)))
> > > +	} else if (unlikely(rt_task(p)) && !in_interrupt())
> > >  		alloc_flags |= ALLOC_HARDER;
> > >  
> > >  	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> > 
> > What are the runtime-observeable effects of this change?
> > 
> 
> Giving rt tasks access to memory reserves is necessary to reduce latency, 
> the privilege does not apply to interrupts that subsequently get run on 
> the same cpu.

If rt task needs to allocate memory like that, then its broken,
anyway...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
