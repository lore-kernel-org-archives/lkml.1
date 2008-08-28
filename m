Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYH1Kyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYH1Kyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYH1Kyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:54:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49133 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYH1Kyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:54:36 -0400
Date: Thu, 28 Aug 2008 12:54:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828105408.GA4488@elte.hu>
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org> <200808272008.16106.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808272008.16106.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 27 August 2008 08:49, Andi Kleen wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> > > Well, we might have a public opinion poll, whether a system is
> > > declared frozen after 1, 10 or 100 seconds. Even a one second
> > > unresponsivness shows up on the kernel bugzilla and you request that
> > > unlimited unresponsivness w/o a chance to debug it is the sane
> > > default.
> >
> > That assumes single CPU. With multiple CPUs and not
> > all hogged the system should be still responsive?
> 
> Right.

Wrong.

Even if the system has multiple CPUs, and even if just a single CPU is 
fully utilized by an RT task, without the rt-limit the system will still 
lock up in practice due to various other factors: workqueues and tasks 
being 'stuck' on CPUs that host an RT hog. While there's obviously CPU 
time available on other CPUs, you cannot run 'top', the desktop will 
freeze, work flows of the system can be stuck, etc, etc..

With the rt limit in place, it's all pretty smooth and debuggable. Even 
with all CPUs hogged by SCHED_FIFO prio 99 the system is laggy but 
debuggable - the user can run 'top' and can resolve the situation.

Really, this reply of yours shows something startling: that despite this 
many mails you still have never actually tried to run the scenario you 
are complaining about: you have never tried to run a CPU hog high-prio 
RT task on a Linux system before, and you have never observed the 
effects it has on general system stability and debuggability.

This fundamental lack of experience weakens all your arguments and i 
dont even know why you are arguing about it. Do you perhaps have some 
customer application/workload you are worried about? If you have then 
please tell us about the exact specifics - this handwaving about 
compliance really makes little sense.

In other words: in our car the air-bag continues to be enabled by 
default, and if someone wants to use the car for stunts the air-bag can 
be disabled via that handy sysctl.

In any case i think i'm going to ignore this thread from now on, nothing 
new has been said really, just the general tone of discussion is 
deteriorating. You are also very late with raising objections in any 
case - the rt-limit feature has been posted 10 months ago and went 
upstream 8 months ago - two full kernel cycles have been completed with 
this change in place and a third one has almost been finished.

        Ingo
