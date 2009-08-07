Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbZHGLAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbZHGLAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbZHGLAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:00:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39725 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbZHGLAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:00:04 -0400
Date: Fri, 7 Aug 2009 12:00:05 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] tracing, page-allocator: Add trace event for page
	traffic related to the buddy lists
Message-ID: <20090807110004.GC18134@csn.ul.ie>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-4-git-send-email-mel@csn.ul.ie> <4A7BE015.6030002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A7BE015.6030002@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 04:04:37PM +0800, Li Zefan wrote:
> > +TRACE_EVENT(mm_page_alloc_zone_locked,
> > +
> > +	TP_PROTO(struct page *page, unsigned int order,
> > +				int migratetype, int percpu_refill),
> > +
> > +	TP_ARGS(page, order, migratetype, percpu_refill),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	struct page *,	page		)
> > +		__field(	unsigned int,	order		)
> > +		__field(	int,		migratetype	)
> > +		__field(	int,		percpu_refill	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->page		= page;
> > +		__entry->order		= order;
> > +		__entry->migratetype	= migratetype;
> > +		__entry->percpu_refill	= percpu_refill;
> > +	),
> > +
> > +	TP_printk("page=%p pfn=%lu order=%u migratetype=%d cpu=%d percpu_refill=%d",
> > +		__entry->page,
> > +		page_to_pfn(__entry->page),
> > +		__entry->order,
> > +		__entry->migratetype,
> > +		smp_processor_id(),
> 
> This is the cpu when printk() is called, but not the cpu when
> this event happens.
> 
> And this information has already been stored, and is printed
> if context-info option is set, which is set by default.
> 

/me slaps self

I even know the CPU column was there in the trace output. What was I
thinking :/

Thanks

> > +		__entry->percpu_refill)
> > +);
> > +
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
> 
> ditto
> 
> > +		__entry->migratetype)
> > +);
> > +
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
