Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZHDUgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZHDUgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbZHDUgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:36:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbZHDUgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:36:09 -0400
Date: Tue, 4 Aug 2009 22:35:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       rostedt@goodmis.org, mel@csn.ul.ie, lwoodman@redhat.com,
       riel@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
	script for page-allocator-related ftrace events
Message-ID: <20090804203526.GA8699@elte.hu>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <20090804195717.GA5998@elte.hu> <20090804131818.ee5d4696.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804131818.ee5d4696.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 4 Aug 2009 21:57:17 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Let me demonstrate these features in action (i've applied the 
> > patches for testing to -tip):
> 
> So?  The fact that certain things can be done doesn't mean that 
> there's a demand for them, nor that anyone will _use_ this stuff.

c'mon Andrew ...

Did you never want to see whether firefox is leaking [any sort of] 
memory, and if yes, on what callsites? Try something like on an 
already running firefox context:

  perf stat -e kmem:mm_page_alloc \
            -e kmem:mm_pagevec_free \
            -e kmem:mm_page_free_direct \
     -p $(pidof firefox-bin) sleep 10

... and "perf record" for the specific callsites.

this perf stuff is immensely flexible and a very unixish 
abstraction. The perf.data contains timestamped trace entries of 
page allocations and freeing done.

[...]
> It would be nice to at least partially remove the vmstat/meminfo 
> infrastructure but I don't think we can do that?

at least meminfo is an ABI for sure - vmstat too really.

But we can stop adding new fields into obsolete, inflexible and 
clearly deficient interfaces, and we can standardize new 
instrumentation to use modern instrumentation facilities - i.e. 
tracepoints and perfcounters.

I'm not saying to put a tracepoint on every second line of the 
kernel, but obviously Mel and Rik wanted this kind of info because 
they found it useful in practice.

	Ingo
