Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZCVUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZCVUm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZCVUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:42:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbZCVUmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:42:17 -0400
Date: Sun, 22 Mar 2009 21:41:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090322204156.GA27113@elte.hu>
References: <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <20090322194153.GA10112@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322194153.GA10112@elte.hu>
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

> found another, unrelated lockup with the event tracer:
> 
> europe:/debug/tracing/events/sched/sched_wakeup_new> cat enable 
> 0
> europe:/debug/tracing/events/sched/sched_wakeup_new> echo 1 > enable
> europe:/debug/tracing/events/sched/sched_wakeup_new> sync
> europe:/debug/tracing/events/sched/sched_wakeup_new> cat 
> ../../../trace_pipe 
>            <...>-2870  [000]   688.730160: sched_wakeup_new: task 
> bash:2898 [120] success=1
>            <...>-2870  [001]   689.945375: sched_wakeup_new: task 
> bash:2899 [120] success=1
> 
> [hard lockup]

ok, tracked it down - it's the new trace_wake_up() from within 
wake_up_new_task() => bad idea.

I think this was introduced via:

6eaaa5d: tracing/core: use appropriate waiting on trace_pipe

	Ingo
