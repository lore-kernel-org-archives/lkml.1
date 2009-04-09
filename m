Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZDIESz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZDIESz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZDIESq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:18:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDIESq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:18:46 -0400
Date: Thu, 9 Apr 2009 06:17:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: pm-hibernate : possible circular locking dependency detected
Message-ID: <20090409041746.GF20692@elte.hu>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904081247.08712.rusty@rustcorp.com.au> <1239194906.13185.93.camel@twins> <200904090915.18644.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904090915.18644.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 08 April 2009 22:18:26 Peter Zijlstra wrote:
> > On Wed, 2009-04-08 at 12:47 +0930, Rusty Russell wrote:
> > > On Tuesday 07 April 2009 16:35:53 Peter Zijlstra wrote:
> > > > On Tue, 2009-04-07 at 13:56 +0930, Rusty Russell wrote:
> > > > > Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
> > > > > patch which I just put out the pull request for.
> > > > 
> > > > Would it make sense to teach it about a short-circuit like:
> > > > 
> > > > work_on_cpu() {
> > > > 
> > > >   if (cpumask_weight(current->cpus_allowed) == 1 && 
> > > >       smp_processor_id() == cpu)
> > > >     return do_work_right_here();
> > > 
> > > Does that happen much?  I guess put a counter in and see?
> > 
> > Ego spotted the case where cpufreq calls it from an cpu-affine
> > workqueue, it seems to me in that case its desirable to have the
> > short-cut, and currently that's needed for correctness too as it will
> > generate this circular lock thingy.
> 
> Well, the correctness issue is fixed by Andrew's 
> work_on_cpu-via-new-thread patch (hmm, which Linus hasn't taken, 
> re-xmitting).

That's now upstream as per:

 6b44003: work_on_cpu(): rewrite it to create a kernel thread on demand

So re-checking whether the warning still triggers with latest -git 
would be nice.

	Ingo
