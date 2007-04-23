Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXDWJ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXDWJ0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXDWJ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:26:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXDWJ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:26:21 -0400
Date: Mon, 23 Apr 2007 11:25:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423092502.GA7972@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <20070423025553.GA10407@elte.hu> <20070423032215.GC25162@wotan.suse.de> <20070423034310.GA19845@elte.hu> <20070423040600.GD25162@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423040600.GD25162@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > yeah - but they'll all be quad core, so the SMP timeslice 
> > multiplicator should do the trick. Most of the CFS testers use 
> > single-CPU systems.
> 
> But desktop users could have have quad thread and even 8 thread CPUs 
> soon, [...]

SMT is indeed an issue, so i think what should be used to scale 
timeslices isnt num_online_cpus(), but the sum of all CPU's ->cpu_power 
value (scaled down by SCHED_LOAD_SCALE). That way if the thread is not a 
'full CPU', then the scaling will be proportionally smaller. Can you see 
any hole in that?

	Ingo
