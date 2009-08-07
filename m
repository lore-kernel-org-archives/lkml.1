Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZHGIGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZHGIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZHGIGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:06:12 -0400
Received: from [222.73.24.84] ([222.73.24.84]:58005 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757076AbZHGIGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:06:08 -0400
Message-ID: <4A7BE015.6030002@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 16:04:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] tracing, page-allocator: Add trace event for page
 traffic related to the buddy lists
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1249574827-18745-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +TRACE_EVENT(mm_page_alloc_zone_locked,
> +
> +	TP_PROTO(struct page *page, unsigned int order,
> +				int migratetype, int percpu_refill),
> +
> +	TP_ARGS(page, order, migratetype, percpu_refill),
> +
> +	TP_STRUCT__entry(
> +		__field(	struct page *,	page		)
> +		__field(	unsigned int,	order		)
> +		__field(	int,		migratetype	)
> +		__field(	int,		percpu_refill	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->page		= page;
> +		__entry->order		= order;
> +		__entry->migratetype	= migratetype;
> +		__entry->percpu_refill	= percpu_refill;
> +	),
> +
> +	TP_printk("page=%p pfn=%lu order=%u migratetype=%d cpu=%d percpu_refill=%d",
> +		__entry->page,
> +		page_to_pfn(__entry->page),
> +		__entry->order,
> +		__entry->migratetype,
> +		smp_processor_id(),

This is the cpu when printk() is called, but not the cpu when
this event happens.

And this information has already been stored, and is printed
if context-info option is set, which is set by default.

> +		__entry->percpu_refill)
> +);
> +
> +TRACE_EVENT(mm_page_pcpu_drain,
> +
> +	TP_PROTO(struct page *page, int order, int migratetype),
> +
> +	TP_ARGS(page, order, migratetype),
> +
> +	TP_STRUCT__entry(
> +		__field(	struct page *,	page		)
> +		__field(	int,		order		)
> +		__field(	int,		migratetype	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->page		= page;
> +		__entry->order		= order;
> +		__entry->migratetype	= migratetype;
> +	),
> +
> +	TP_printk("page=%p pfn=%lu order=%d cpu=%d migratetype=%d",
> +		__entry->page,
> +		page_to_pfn(__entry->page),
> +		__entry->order,
> +		smp_processor_id(),

ditto

> +		__entry->migratetype)
> +);
> +
