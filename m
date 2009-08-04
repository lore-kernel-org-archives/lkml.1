Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbZHDUzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbZHDUzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbZHDUzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:55:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932569AbZHDUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:55:00 -0400
Date: Tue, 4 Aug 2009 13:53:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       rostedt@goodmis.org, mel@csn.ul.ie, lwoodman@redhat.com,
       riel@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
 script for page-allocator-related ftrace events
Message-Id: <20090804135315.b2678e11.akpm@linux-foundation.org>
In-Reply-To: <20090804203526.GA8699@elte.hu>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie>
	<1249409546-6343-5-git-send-email-mel@csn.ul.ie>
	<20090804112246.4e6d0ab1.akpm@linux-foundation.org>
	<20090804195717.GA5998@elte.hu>
	<20090804131818.ee5d4696.akpm@linux-foundation.org>
	<20090804203526.GA8699@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 22:35:26 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Did you never want to see whether firefox is leaking [any sort of] 
> memory, and if yes, on what callsites? Try something like on an 
> already running firefox context:
> 
>   perf stat -e kmem:mm_page_alloc \
>             -e kmem:mm_pagevec_free \
>             -e kmem:mm_page_free_direct \
>      -p $(pidof firefox-bin) sleep 10
> 
> ... and "perf record" for the specific callsites.

OK, that would be useful.  What does the output look like?

In what way is it superior to existing ways of finding leaks?

> this perf stuff is immensely flexible and a very unixish 
> abstraction. The perf.data contains timestamped trace entries of 
> page allocations and freeing done.
> 
> [...]
> > It would be nice to at least partially remove the vmstat/meminfo 
> > infrastructure but I don't think we can do that?
> 
> at least meminfo is an ABI for sure - vmstat too really.
> 
> But we can stop adding new fields into obsolete, inflexible and 
> clearly deficient interfaces, and we can standardize new 
> instrumentation to use modern instrumentation facilities - i.e. 
> tracepoints and perfcounters.

That's bad.  Is there really no way in which we can consolidate _any_
of that infrastructure?  We just pile in new stuff alongside the old?

The worst part is needing two unrelated sets of userspace tools to
access basically-identical things.


