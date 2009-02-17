Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZBQKmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZBQKmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZBQKmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:42:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZBQKml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:42:41 -0500
Date: Tue, 17 Feb 2009 11:42:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
Message-ID: <20090217104213.GC6602@elte.hu>
References: <20090217051227.957864159@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217051227.957864159@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This is a patch series that offers a variety of features.
> 
> The first is to add:
> 
>  #### all functions enabled ####
> 
> to set_ftrace_filter when all functions will be traced when function
> tracing is on.
> 
> The next is to add a :command: interface, and the module command:
> 
>  echo '*:mod:ext4' > set_ftrace_filter
> 
> Will select all functions in the ext4 module.
> 
>  echo '!*write*:mod:ext4' > set_ftrace_filter
> 
> will remove all functions with the characters 'write' and are
> in ext4.

Very nice feature!

I'm wondering, would it be possible to somehow extend this to 
built-in drivers too, so that we get symmetry of usage 
independently of whether something is built in or a module? I 
suspect it needs some extensions to kbuild though ...

> Next we extend the :command: interface as well as add a way to
> hook tracers to specific functions. Instead of tracing all functions
> the same, this patch series adds a hash to be able to trace different
> functions differently.

That's a nice extension too!

Small naming detail: instead of calling it a 'hook' (which 
really has a bad sound to it for various reasons), how about 
calling it a 'trigger' and/or a 'callback'?

> I implement a 'traceon' and 'traceoff' to have a function 
> start or stop tracing when it is hit. It also includes a 
> counter for the number of times to implement the trace on/off.
> 
>  echo '*_lock:traceon:4' > set_ftrace_filter
>  echo '*_unlock:traceoff:5' > set_ftrace_filter

if there's no counter specified, does it default to 1 
[single-shot trigger] or infinity?

> This will have all functions that end with _lock turn on 
> tracing and all that end with _unlock disable it, 4 times 
> each.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/ftrace
> 
> 
> Steven Rostedt (15):
>       ftrace: state that all functions are enabled in set_ftrace_filter
>       ftrace: add do_for_each_ftrace_rec and while_for_each_ftrace_rec
>       ftrace: rename ftrace_match to ftrace_match_records
>       ftrace: break up ftrace_match_records into smaller components
>       ftrace: add module command function filter selection
>       ftrace: enable filtering only when a function is filtered on
>       ftrace: add command interface for function selection
>       ftrace: convert ftrace_lock from a spinlock to mutex
>       ftrace: consolidate mutexes
>       ftrace: trace different functions with a different tracer
>       ring-buffer: add tracing_is_on to test if ring buffer is enabled
>       ftrace: add traceon traceoff commands to enable/disable the buffers
>       ftrace: show selected functions in set_ftrace_filter
>       ftrace: add pretty print to selected fuction traces
>       ftrace: add pretty print function for traceon and traceoff hooks
> 
> ----
>  include/linux/ftrace.h         |   40 ++
>  include/linux/ring_buffer.h    |    2 +
>  kernel/trace/ftrace.c          |  929 +++++++++++++++++++++++++++++++---------
>  kernel/trace/ring_buffer.c     |    9 +
>  kernel/trace/trace_functions.c |  163 +++++++
>  5 files changed, 946 insertions(+), 197 deletions(-)

Pulled into tip:tracing/ftrace, thanks Steve!

	Ingo
