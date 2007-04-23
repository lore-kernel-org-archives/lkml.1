Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXDWDn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXDWDn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXDWDn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:43:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030468AbXDWDn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:43:58 -0400
Date: Mon, 23 Apr 2007 05:43:10 +0200
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
Message-ID: <20070423034310.GA19845@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <20070423025553.GA10407@elte.hu> <20070423032215.GC25162@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423032215.GC25162@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > note that CFS's "granularity" value is not directly comparable to 
> > "timeslice length":
> 
> Right, but it does introduce the kbuild regression, [...]

Note that i increased the granularity from 1msec to 5msecs after your 
kbuild report, could you perhaps retest kbuild with the default settings 
of -v5?

> [...] and as we discussed, this will be only worse on newer CPUs with 
> bigger caches or less naturally context switchy workloads.

yeah - but they'll all be quad core, so the SMP timeslice multiplicator 
should do the trick. Most of the CFS testers use single-CPU systems.

> > (in -v6 i'll scale the granularity up a bit with the number of CPUs, 
> > like SD does. That should get the right result on larger SMP boxes 
> > too.)
> 
> I don't really like the scaling with SMP thing. The cache effects are 
> still going to be significant on small systems, and there are lots of 
> non-desktop users of those (eg. clusters).

CFS using clusters will want to tune the granularity up drastically 
anyway, to 1 second or more, to maximize throughput. I think a small 
default with a scale-up-on-SMP rule is pretty sane. We'll gather some 
more kbuild data and see what happens, ok?

> > while i agree it's a tad too finegrained still, I agree with Con's 
> > choice: rather err on the side of being too finegrained and lose 
> > some small amount of throughput on cache-intense workloads like 
> > compile jobs, than err on the side of being visibly too choppy for 
> > users on the desktop.
> 
> So cfs gets too choppy if you make the effective timeslice comparable 
> to mainline?

it doesnt in any test i do, but again, i'm erring on the side of it 
being more interactive.

	Ingo
