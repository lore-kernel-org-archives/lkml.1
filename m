Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZFJJ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZFJJ1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbZFJJ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:27:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZFJJ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:27:34 -0400
Date: Wed, 10 Jun 2009 11:26:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
Message-ID: <20090610092644.GA20889@elte.hu>
References: <20090610054206.510574695@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610054206.510574695@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/event-print-format tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/event-print-format
> 
> 
> Li Zefan (1):
>       tracing/events: convert block trace points to TRACE_EVENT(), fix
> 
> Steven Rostedt (10):
>       tracing: add nsec2sec print formats
>       tracing: convert lockdep lock_acquired trace point to use nsec2usec tag
>       tracing: add major and minor tags for print format
>       tracing: use << to print < instead of \<
>       tracing: convert the block trace points to use the new tag format
>       tracing: add test for strings in event tag format
>       tracing: add func and symfunc to tag format
>       tracing: check full name for field
>       tracing: update sample code with new tag format
>       tracing: move '>' to out of macros and into print statement
> 
> ----
>  include/linux/blktrace_api.h               |    4 +-
>  include/linux/ftrace_event.h               |    3 +-
>  include/trace/events/block.h               |  101 +++------
>  include/trace/events/irq.h                 |    8 +-
>  include/trace/events/kmem.h                |   12 +-
>  include/trace/events/lockdep.h             |    8 +-
>  include/trace/ftrace.h                     |    2 +-
>  kernel/trace/trace_output.c                |    2 +-
>  kernel/trace/trace_output.h                |    4 +
>  kernel/trace/trace_read_binary.c           |  304 +++++++++++++++++++++++-----
>  samples/trace_events/trace-events-sample.c |   21 ++-
>  samples/trace_events/trace-events-sample.h |   66 ++++++
>  12 files changed, 399 insertions(+), 136 deletions(-)

Hm, that's way too much back and forth really - trivial typo fixes, 
build failure, etc. This is really a 'oh, the merge window is 
coming' last minute scrambling and we dont want to mess up the 
squeaky-clean tracing tree history be messed up with this.

Frederic also expressed worries about the tag format. Could we have 
a wider buy-in for this format?

I've separated these bits into tip:tracing/ftrace, and kept 
tip:tracing/core on a pre-print-formats state (going back 8 
commits), so that upstream merging of the other bits does not get 
held up.

Could we try a cleaner, bisectable, consiously built up version of 
these final tracing/core..tracing/ftrace please? I think we can - 
the rest of the tree is clean. Please do a exact-same-content rebase 
so that the merge back gets obvious and that the testing we've 
injected does not get invalidated?

	Ingo
