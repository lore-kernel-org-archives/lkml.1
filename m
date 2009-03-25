Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbZCYJvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbZCYJvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbZCYJuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:50:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbZCYJuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:50:51 -0400
Date: Wed, 25 Mar 2009 10:50:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/5][RFC] [RFC] function profiler
Message-ID: <20090325095024.GF2341@elte.hu>
References: <20090325035646.662994901@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325035646.662994901@goodmis.org>
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

> The following patches are RFC, and to discuss is this work would 
> be useful.
> 
> This patch series adds a function profiler hook to the function 
> tracer and function graph tracer. That is, it uses the mcount 
> calls to track the functions being called. Now with the function 
> graph tracer it also keeps track of the times the functions have 
> been executing.
> 
> Note, this is similar to oprofile, but is not a sampling approach, 
> but a true recorder. Of course, by recording every function the 
> overhead compared to oprofile is higher. With the use of dynamic 
> ftrace, you could just trace certain functions, or just a certain 
> module. The flexibility is a bit greater with this profiling.

Also, with the built-in user-defined filter code in the latest 
tracing tree this can also be used to only trace a given PID, or a 
range of PIDs.

Or we can trace preempt-disabled functions only, via this filter 
expression:

  echo 'common_preempt_count != 0' > /debug/tracing/events/ftrace/function/filter

Or (future planned) we can profile functions only taking longer than 
100 microseconds:

  echo 'duration >= 0' > /debug/tracing/events/ftrace/function/filter

There are other possibilities as well.

	Ingo
