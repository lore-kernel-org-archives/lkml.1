Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbZCTSmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbZCTSmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZCTSmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:42:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZCTSmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:42:36 -0400
Date: Fri, 20 Mar 2009 19:42:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320184215.GA4024@elte.hu>
References: <20090318031423.981603258@goodmis.org> <20090318055924.GA24627@elte.hu> <20090318073903.GA31341@elte.hu> <20090319073357.GA14615@elte.hu> <20090320170548.GC5937@nowhere> <20090320175758.GA5936@nowhere> <alpine.DEB.2.00.0903201420020.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903201420020.13615@gandalf.stny.rr.com>
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

> > Now I've tested on x86-64 SMP and still nothing. Note that I've 
> > not only tested the selftests but also the function graph 
> > tracer. But nothing weird appeared.
> 
> I have not been able to trigger it either. I tested on three 
> different boxes, with various x86_64/32 configs as well.
> 
> One thing that seems to be common in these crashes is that they 
> all have rcu_torture running. Perhaps the function tracer is 
> widening a race window that is too small to trigger without the 
> tracing?

It's a highly elusive bug that seems to trigger only after hundreds 
of random kernel builds + reboots. Minor (and provably irrelevant) 
changes in .config details can make the bug go away, so it's not 
bisectabe.

But it only triggered on SMP kernels and on SMP systems so far, so 
the hotplug-race theory has a chance to be relevant.

> Paul suggested something about Lai's rcu_barrier fix?

I'm looking at that now. The function-tracer self-test will trigger 
stop_machine_run(), which brings CPUs down, correct? That would 
indeed make sense. Will know in 1-2 days whether the hangs go away.

	Ingo
