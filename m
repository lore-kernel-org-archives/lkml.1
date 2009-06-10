Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZFJUsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZFJUsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbZFJUsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:48:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbZFJUsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:48:47 -0400
Date: Wed, 10 Jun 2009 22:48:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH][GIT PULL] tracing: do not translate event helper
	macros in print format
Message-ID: <20090610204801.GB8147@elte.hu>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org> <20090610101124.GA25042@elte.hu> <alpine.DEB.2.00.0906100812370.30552@gandalf.stny.rr.com> <20090610171648.GD31096@elte.hu> <alpine.DEB.2.00.0906101353200.30552@gandalf.stny.rr.com> <alpine.DEB.2.00.0906101436340.30552@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906101436340.30552@gandalf.stny.rr.com>
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
> This looks like it changed more than it really did, I only moved 
> the one macro above another and added a few lines:
> 
>  +#undef __print_symbolic
>  +#undef __get_dynamic_array
>  +#undef __get_str
>  +
> 
> Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-1
> 
> 
> Steven Rostedt (1):
>       tracing: do not translate event helper macros in print format
> 
> ----
>  include/trace/ftrace.h |  158 ++++++++++++++++++++++++-----------------------
>  1 files changed, 81 insertions(+), 77 deletions(-)
> ---------------------------
> commit 6ff9a64d2aaa6eae396adc95e9c91c0cbfa6dbe4
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Jun 10 14:28:34 2009 -0400
> 
>     tracing: do not translate event helper macros in print format
>     
>     By moving the macro that creates the print format code above the
>     defining of the event macro helpers (__get_str, __print_symbolic,
>     and __get_dynamic_array), we get a little cleaner print format.
>     
>     Instead of:
>     
>       (char *)((void *)REC + REC->__data_loc_name)
>     
>     we get:
>     
>        __get_str(name)
>     
>     Instead of:
>     
>        ({ static const struct trace_print_flags symbols[] = { { HI_SOFTIRQ, "HI" }, {
>     
>     we get:
>     
>        __print_symbolic(REC->vec, { HI_SOFTIRQ, "HI" }, {

Yeah, that's really nice! Pulled, thanks Steve!

	Ingo
