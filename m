Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXIRWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXIRWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXIRWun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:50:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbXIRWum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:50:42 -0400
Date: Wed, 19 Sep 2007 00:46:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070918224656.GA26719@elte.hu>
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F00417.7080301@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> On 09/14/2007 11:32 AM, Ingo Molnar wrote:
> > * Antoine Martin <antoine@nagafix.co.uk> wrote:
> > 
> >>>> have an impact) Keep CONFIG_SCHED_DEBUG=y to be able to twiddle the
> >>>> sysctl.
> >> It looks good now! Updated results here:
> >> http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests5-10msYield-noload.png
> >> http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests5-10msYield.png
> >> Compared with more kernels here - a bit more cluttered:
> >> http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests4-10msYield-noload.png
> >>
> >> Thanks Ingo!
> >> Does this mean that I'll have to keep doing:
> >> echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
> >> Or are you planning on finding a more elegant solution?
> > 
> > just to make sure - can you get it to work fast with the 
> > -rc6+yield-patch solution too? (i.e. not CFS-devel) We need a (tested) 
> > solution for 2.6.23 and the CFS-devel patches are not for 2.6.23. I've 
> > attached below the latest version of the -rc6 yield patch - the switch 
> > is not dependent on SCHED_DEBUG anymore but always available.
> > 
> 
> Is this going to be merged? And will you be making the default == 1 or 
> just leaving it at 0, which forces people who want the older behavior 
> to modify the default?

not at the moment - Antoine suggested that the workload is probably fine 
and the patch against -rc6 would have no clear effect anyway so we have 
nothing to merge right now. (Note that there's no "older behavior" 
possible, unless we want to emulate all of the O(1) scheduler's 
behavior.) But ... we could still merge something like that patch, but a 
clearer testcase is needed. The JVM's i have access to work fine.

	Ingo
