Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZHGKtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZHGKtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbZHGKtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:49:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39684 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbZHGKtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:49:05 -0400
Date: Fri, 7 Aug 2009 11:49:06 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] tracing, page-allocator: Add trace events for page
	allocation and page freeing
Message-ID: <20090807104905.GA18134@csn.ul.ie>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-2-git-send-email-mel@csn.ul.ie> <20090807075030.GB20292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090807075030.GB20292@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:50:30AM +0200, Ingo Molnar wrote:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > +TRACE_EVENT(mm_pagevec_free,
> 
> > +	TP_fast_assign(
> > +		__entry->page		= page;
> > +		__entry->order		= order;
> > +		__entry->cold		= cold;
> > +	),
> 
> > -	while (--i >= 0)
> > +	while (--i >= 0) {
> > +		trace_mm_pagevec_free(pvec->pages[i], 0, pvec->cold);
> >  		free_hot_cold_page(pvec->pages[i], pvec->cold);
> > +	}
> 
> Pagevec freeing has order 0 implicit, so you can further optimize 
> this by leaving out the 'order' field and using this format string:
> 
> +	TP_printk("page=%p pfn=%lu order=0 cold=%d",
> +                       __entry->page,
> +                       page_to_pfn(__entry->page),
> +                       __entry->cold)
> 
> the trace record becomes smaller by 4 bytes and the tracepoint 
> fastpath becomes shorter as well.
> 

Good point. It's fixed now.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
