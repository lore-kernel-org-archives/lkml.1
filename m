Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZHGLJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZHGLJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbZHGLJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:09:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44141 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbZHGLJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:09:16 -0400
Date: Fri, 7 Aug 2009 12:09:15 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] tracing, page-allocator: Add trace event for page
	traffic related to the buddy lists
Message-ID: <20090807110915.GD18134@csn.ul.ie>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-4-git-send-email-mel@csn.ul.ie> <20090807075317.GC20292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090807075317.GC20292@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:53:17AM +0200, Ingo Molnar wrote:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > +TRACE_EVENT(mm_page_pcpu_drain,
> > +
> > +	TP_PROTO(struct page *page, int order, int migratetype),
> > +
> > +	TP_ARGS(page, order, migratetype),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	struct page *,	page		)
> > +		__field(	int,		order		)
> > +		__field(	int,		migratetype	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->page		= page;
> > +		__entry->order		= order;
> > +		__entry->migratetype	= migratetype;
> > +	),
> > +
> > +	TP_printk("page=%p pfn=%lu order=%d cpu=%d migratetype=%d",
> > +		__entry->page,
> > +		page_to_pfn(__entry->page),
> > +		__entry->order,
> > +		smp_processor_id(),
> > +		__entry->migratetype)
> 
> > +	trace_mm_page_alloc_zone_locked(page, order, migratetype, order == 0);
> 
> This can be optimized further by omitting the migratetype field and 
> adding something like this:
> 
> 	TP_printk("page=%p pfn=%lu order=%d cpu=%d migratetype=%d",
> 		__entry->page,
> 		page_to_pfn(__entry->page),
> 		__entry->order,
> 		smp_processor_id(),
> 		__entry->order == 0);
> 
> The advantage is 4 bytes less in the record and a shorter tracepoint 
> fast-path - while still having the same output.
> 

Knowing you meant percpu_refill, it's now been figured out in TP_printk
instead of in the code.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
