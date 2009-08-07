Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZHGBDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZHGBDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZHGBDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:03:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42020 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZHGBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:03:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/4] tracing, page-allocator: Add trace event for page traffic related to the buddy lists
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <20090805094346.GC21950@csn.ul.ie>
References: <20090805182034.5BCD.A69D9226@jp.fujitsu.com> <20090805094346.GC21950@csn.ul.ie>
Message-Id: <20090807095937.5BD9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  7 Aug 2009 10:03:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >  	TP_PROTO(const void *page,
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index c2c90cd..35b92a9 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -535,6 +535,7 @@ static void free_pages_bulk(struct zone *zone, int count,
> > >  		page = list_entry(list->prev, struct page, lru);
> > >  		/* have to delete it as __free_one_page list manipulates */
> > >  		list_del(&page->lru);
> > > +		trace_mm_page_pcpu_drain(page, order, page_private(page));
> > 
> > pcp refill (trace_mm_page_alloc_zone_locked) logged migratetype, but
> > this tracepoint doesn't. why?
> > 
> 
> It does log migratetype as migratetype is in page_private(page) in this
> context.

sorry, my fault.
thanks correct me.



> > >  		__free_one_page(page, zone, order, page_private(page));
> > >  	}
> > >  	spin_unlock(&zone->lock);
> > > @@ -878,6 +879,7 @@ retry_reserve:
> > >  		}
> > >  	}
> > >  
> > > +	trace_mm_page_alloc_zone_locked(page, order, migratetype, order == 0);
> > >  	return page;
> > >  }
> > 
> > Umm, Can we assume order-0 always mean pcp refill?
> 
> Right now, that assumption is accurate. Which callpath ends up here with
> order == 0 and it's not a PCP refill?

you are right.



