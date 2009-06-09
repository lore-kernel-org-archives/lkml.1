Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZFIXYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZFIXYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZFIXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:24:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZFIXYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:24:23 -0400
Date: Wed, 10 Jun 2009 01:23:41 +0200
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
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/8] [GIT PULL] simplify the print fmt in the event
	format files
Message-ID: <20090609232341.GB23846@elte.hu>
References: <20090609215211.307980196@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609215211.307980196@goodmis.org>
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

> Ingo,
> 
> Changes since my RFC:
> 
>  - Rebased against my last tip/tracing/ftrace push
>  - Added ifmask and uint (will be adding more tags soon)
>  - Added memory clean up on error
>  - Added locking for module unload
>  - Added memory clean up of formats on module unload
>  - Added lockdep update
>  - Add entry size to iterator (will be used soon)
> 
> Please pull the latest tip/tracing/event-print-format tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/event-print-format
> 
> 
> Steven Rostedt (8):
>       tracing: add trace_seq_vprint interface
>       tracing: add protection around module events unload
>       tracing/events: nicer print format for parsing
>       tracing/events: modify irq print to new format
>       tracing/events: modify sched print to new format
>       tracing/events: modify kmem print to new format
>       tracing/events: modify lockdep print to new format
>       tracing: add entry size to iterator
> 
> ----
>  include/linux/ftrace_event.h     |   12 +
>  include/linux/trace_seq.h        |    2 +
>  include/trace/events/irq.h       |   38 +-
>  include/trace/events/kmem.h      |   98 +++---
>  include/trace/events/lockdep.h   |   12 +-
>  include/trace/events/sched.h     |   49 +--
>  include/trace/ftrace.h           |   22 +-
>  kernel/trace/Makefile            |    1 +
>  kernel/trace/trace.c             |   39 ++-
>  kernel/trace/trace_events.c      |    5 +-
>  kernel/trace/trace_output.c      |   47 +++-
>  kernel/trace/trace_output.h      |    4 +
>  kernel/trace/trace_read_binary.c |  766 ++++++++++++++++++++++++++++++++++++++
>  13 files changed, 962 insertions(+), 133 deletions(-)

This looks quite nice - albeit a bit large so late. I've pulled it, 
hopefully it tests fine :)

	Ingo
