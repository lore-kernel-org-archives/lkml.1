Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZBRI5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZBRI5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZBRI5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:57:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZBRI5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:57:45 -0500
Date: Wed, 18 Feb 2009 09:57:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
Message-ID: <20090218085719.GA31049@elte.hu>
References: <20090217182048.233060814@goodmis.org> <20090218000952.GD12714@elte.hu> <20090218084041.GA27540@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218084041.GA27540@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Steve, Frederic,
> 
> the function-graph-tracer started locking up since the last 
> batch of changes:
> 
>  Testing tracer sysprof: .. no entries found ..FAILED!
>  initcall 0xffffffff812e91d1 returned -1 after 101562 usecs
>  initcall 0xffffffff812e91d1 returned with error code -1 
>  calling  0xffffffff812e91e3 @ 1
>  Testing tracer function: PASSED
>  Testing dynamic ftrace: 
>  [hard lockup]
> 
> Config attached.

it's one of these recent commits:

 fa7c7f6: tracing/core: remove unused parameter in tracing_fill_pipe_page()
 6eaaa5d: tracing/core: use appropriate waiting on trace_pipe
 35ebf1c: ftrace: show unlimited when traceon or traceoff has no counter
 73d8b8b: tracing: fix typing mistake in hint message and comments
 d2ef7c2: tracing: fix the return value of trace selftest
 af51309: tracing: use the more proper parameter
 b6887d7: ftrace: rename _hook to _probe
 6a24a24: ftrace: clean up coding style

Have not bisected it any further, excluded them from tip:master 
for the time being.

	Ingo
