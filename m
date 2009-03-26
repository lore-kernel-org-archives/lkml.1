Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZCZIIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZCZIIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZCZII1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:08:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbZCZIIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:08:20 -0400
Date: Thu, 26 Mar 2009 09:07:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2] [GIT PULL] function profiler updates
Message-ID: <20090326080757.GA616@elte.hu>
References: <20090326010737.611522983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326010737.611522983@goodmis.org>
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

> 
> Ingo,
> 
> Please pull the latest rfc/tip/tracing/function-profiler tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> rfc/tip/tracing/function-profiler
> 
> 
> Steven Rostedt (2):
>       tracing: remove on the fly allocator from function profiler
>       tracing: add average time in function to function profiler
> 
> ----
>  kernel/trace/ftrace.c |   97 +++++++++++++++++++++++++++++--------------------
>  1 files changed, 57 insertions(+), 40 deletions(-)
> -- 

Pulled, thanks Steve. The on-the-fly allocator was my main 
conceptual worry about this.

How useful this kind of profiling will end up being in practice 
remains to be seen - but it does have a handful of unique properties 
that cannot be dismissed.

It's main downside is its overhead - sampling based profilers are a 
lot more lightweight and allow unintrusive inspection of workloads.

The upside of it are all the things that this profiling overhead 
allows us to do:

 - 100% precise, non-sampling profiling

 - accurate profiles possible with very short, bursty workloads too

 - filtering capabilities of the tracing subsystem allow the 
   flexible shaping of the set of functions and the set of 
   conditions that are profiled: there's the regex filter and 
   there's also the tracepoint based filter expressions.

 - it also allowsuser-space driven filtering: if user-space wants to 
   profile just one specific functionality (say the function calls 
   of one specific library), they can use /debug/tracing/enabled
   fast toggle to turn profiling on/off runtime. This can be done at 
   a very high frequency as well.

 - developers can switch between profiling and tracing mode 
   seemlessly. This allows multiple 'dimensions' of the same 
   workload to be observed, via the same set of facilities.

	Ingo
