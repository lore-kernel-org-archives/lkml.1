Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYHKWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYHKWLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYHKWLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:11:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44928 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYHKWLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:11:12 -0400
Date: Tue, 12 Aug 2008 00:10:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Message-ID: <20080811221041.GA17634@elte.hu>
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com> <20080811123020.GB10082@elte.hu> <alpine.LFD.1.10.0808111500330.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808111500330.3462@nehalem.linux-foundation.org>
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

* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 11 Aug 2008, Ingo Molnar wrote:
> > 
> > i've queued up the fix below in tip/sched/urgent.
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index e202a68..c977c33 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
> >  		goto out_notify;
> >  	BUG_ON(!cpu_online(cpu));
> >  
> > +	cpu_set(cpu, cpu_active_map);
> > +
> >  	/* Now call notifier in preparation. */
> >  	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
> >  
> > @@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)
> >  
> >  	err = _cpu_up(cpu, 0);
> >  
> > -	if (cpu_online(cpu))
> > -		cpu_set(cpu, cpu_active_map);
> > -
> 
> Ok, not only does that fix the bug, but it simplifies the code and 
> looks obviously ok. However, I don't have it in my tree yet, and I'd 
> like to do an -rc3 that has this fixes (so that along with the PCI MSI 
> thing, we hopefully have most of the suspend/resume regressions 
> fixed).
> 
> And I was hoping to do -rc3 today. Can I please have pull-requests for 
> the appropriate urgent scheduler/x86 fixes? Or should I just take 
> these as patches?

i'll send pull requests for all pending patches. I wanted to send them 
tomorrow originally but will do them now.

	Ingo
