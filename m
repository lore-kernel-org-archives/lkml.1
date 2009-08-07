Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZHGBSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZHGBSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZHGBSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:18:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46162 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZHGBSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:18:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/4] tracing, page-allocator: Add trace events for page allocation and page freeing
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <20090805094019.GB21950@csn.ul.ie>
References: <20090805165302.5BC8.A69D9226@jp.fujitsu.com> <20090805094019.GB21950@csn.ul.ie>
Message-Id: <20090807100502.5BDC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  7 Aug 2009 10:17:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index d052abb..843bdec 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1905,6 +1905,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> > >  				zonelist, high_zoneidx, nodemask,
> > >  				preferred_zone, migratetype);
> > >  
> > > +	trace_mm_page_alloc(_RET_IP_, page, order, gfp_mask, migratetype);
> > >  	return page;
> > >  }
> > 
> > In almost case, __alloc_pages_nodemask() is called from alloc_pages_current().
> > Can you add call_site argument? (likes slab_alloc)
> > 
> 
> In the NUMA case, this will be true but addressing it involves passing down
> an additional argument in the non-tracing case which I wanted to avoid.
> As the stacktrace option is available to ftrace, I think I'll drop call_site
> altogether as anyone who really needs that information has options.

Insted, can we move this tracepoint to alloc_pages_current(), alloc_pages_node() et al ?
On page tracking case, call_site information is one of most frequently used one.
if we need multiple trace combination, it become hard to use and reduce usefulness a bit.



