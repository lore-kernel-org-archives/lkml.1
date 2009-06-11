Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZFKVlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZFKVlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZFKVli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:41:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZFKVli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:41:38 -0400
Date: Thu, 11 Jun 2009 23:41:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
	trace support"
Message-ID: <20090611214124.GA4133@elte.hu>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org> <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com> <1244702183.6691.8.camel@laptop> <20090611102159.GA31719@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EBBC6555D@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBBC6555D@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Thursday, June 11, 2009 12:22 PM
> >To: Peter Zijlstra
> >Cc: Metzger, Markus T; linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com; oleg@redhat.com;
> >tglx@linutronix.de; linux-tip-commits@vger.kernel.org
> >Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
> >
> >
> >* Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> On Thu, 2009-06-11 at 07:30 +0100, Metzger, Markus T wrote:
> >> > >-----Original Message-----
> >> > >From: tip-bot for Ingo Molnar [mailto:mingo@elte.hu]
> >> > >Sent: Thursday, June 11, 2009 1:37 AM
> >> > >To: linux-tip-commits@vger.kernel.org
> >> > >Cc: hpa@zytor.com; mingo@redhat.com; peterz@infradead.org; Metzger, Markus T; oleg@redhat.com;
> >> > >tglx@linutronix.de; mingo@elte.hu
> >> > >Subject: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
> >> > >
> >> > >Commit-ID:  511b01bdf64ad8a38414096eab283c7784aebfc4
> >> > >Gitweb:     http://git.kernel.org/tip/511b01bdf64ad8a38414096eab283c7784aebfc4
> >> > >Author:     Ingo Molnar <mingo@elte.hu>
> >> > >AuthorDate: Thu, 11 Jun 2009 00:32:00 +0200
> >> > >Committer:  Ingo Molnar <mingo@elte.hu>
> >> > >CommitDate: Thu, 11 Jun 2009 00:32:00 +0200
> >> > >
> >> > >Revert "x86, bts: reenable ptrace branch trace support"
> >> > >
> >> > >This reverts commit 7e0bfad24d85de7cf2202a7b0ce51de11a077b21.
> >> > >
> >> > >A late objection to the ABI has arrived:
> >> > >
> >> > >   http://lkml.org/lkml/2009/6/10/253
> >> >
> >> > I thought that this has been resolved. See for example http://lkml.org/lkml/2009/6/10/257.
> >> >
> >> > Peters concerns were that Debug Store details are exposed to user space, which is
> >> > not the case. Debug Store itself is fully in-kernel and the expectation of a
> >> > user-defined buffer can be implemented on top of the Debug Store changes that
> >> > Peter expects are needed to support PEBS.
> >> >
> >> > A user-defined trace buffer size is required to support
> >> > different usage models. Some users only need a small amount of
> >> > trace, whereas others need a big amount. The interface will have
> >> > to reflect that in some way.
> >>
> >> Right, your last email did explain how we could keep per task
> >> in-kernel buffers and fill them from the DS and still have them of
> >> user-specified size.
> >>
> >> That would indeed keep the proposed ABI workable, what I'm still
> >> not liking is that this buffer is in-kernel, but I guess that
> >> might be something for other people to have an opinion on.
> >
> > Hm. Wrt. the ABI, wouldnt it make more sense to expose this PMU 
> > feature via perfcounters: a sampling hw-branch-executions 
> > counter, with interval=1.
> >
> > That would give the exact existing semantics, plus a lot lot 
> > more. Markus?
> 
> What more would we get?

There's numerous direct functionality advantages:

 - We will get all the sampling features of perfcounters such as 
   timed samples, CPU ID samples. Some will be approximate (timing), 
   some precise (CPU ID).

 - We will get the advanced workflow isolation features: we could
   sample on a per CPU basis (system-wide BTS), and we could sample
   child tasks automatically. The current code is limited to a
   single task.

 - We will sample other types of information into the same outgoing 
   event buffer: for example branch-miss events, intermixed with BTS
   records. This could help not just the narrow purpose of 
   debugging, but also the purpose of performance analysis.

 - There's a rich and fast/efficient VFS based APIs to wait for
   event overflows: poll(), read(), mmap().

 - Remote sampling via perfcounters is transparent, while ptrace 
   sampling can be seen by apps.

There's maintenance advantages as well from the x86 architecture and 
scheduler maintenance point of view:

 - We would have a single facility handling the Debug Store, and
   we'd have almost all pieces in place for PEBS support in
   perfcounters as well so there's good synergy.

There are performance advantages as well:

 - There's lazy-switching optimizations in perfcounters avoiding the
   DS buffer switching overhead.

> I take it that you don't want to implement branch tracing via 
> PEBS, which would be possible but rather inefficient since the BTS 
> format is much more compact than the PEBS format.

Sampling could be done via PEBS too, if someone wants to take 
advantage of the instruction latency field for example on Nehalem.

But yes, i agree that for the simple case of 
branch-executions+period=1 case we want that to use BTS, as those 
records are a lot more compact than the all-general-purpose-regs 
bloated records of PEBS.

> So we would still implement it via BTS and we would still like to 
> present a branch trace specific format to the user.
> 
> Are you suggesting to use a common ABI for sampling and branch 
> tracing?

Yes, that makes sense.

> The existing ABI is tailored towards the expected users: 
> debuggers. I do believe that a ptrace based interface makes a lot 
> of sense for this debugging-related feature, since debuggers 
> already speak ptrace.
> 
> Branch tracing and sampling are used by different classes of 
> user-mode applications. I don't think that a common ABI would 
> benefit user-mode. Since we do need different implementations in 
> the kernel, I don't see how a common ABI would help here, either.
> 
> I rather see this as two independent, unrelated hardware features 
> that happen to use the same technique to allow arbitrary-sized 
> buffers and that therefore share some hardware real-estate.

I'd rather not maintain two separate pieces of infrastructure and 
ABIs.

We had a _lot_ of problems with the BTS code, and there's still that 
unresolved crash from akpm. (i too reported crashes in the past) 

That is the problem with such rarely used ABIs: almost nobody tests 
them.

With perfcounters that dynamics changes quite profoundly: the DS and 
the overflow handling will be used for PEBS anyway, so there's good 
overlap and good sharing in facilities.

	Ingo
