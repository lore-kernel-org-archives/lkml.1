Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbZFKKWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbZFKKWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbZFKKWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:22:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280AbZFKKWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:22:14 -0400
Date: Thu, 11 Jun 2009 12:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
	trace support"
Message-ID: <20090611102159.GA31719@elte.hu>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org> <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com> <1244702183.6691.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244702183.6691.8.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-06-11 at 07:30 +0100, Metzger, Markus T wrote:
> > >-----Original Message-----
> > >From: tip-bot for Ingo Molnar [mailto:mingo@elte.hu]
> > >Sent: Thursday, June 11, 2009 1:37 AM
> > >To: linux-tip-commits@vger.kernel.org
> > >Cc: hpa@zytor.com; mingo@redhat.com; peterz@infradead.org; Metzger, Markus T; oleg@redhat.com;
> > >tglx@linutronix.de; mingo@elte.hu
> > >Subject: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
> > >
> > >Commit-ID:  511b01bdf64ad8a38414096eab283c7784aebfc4
> > >Gitweb:     http://git.kernel.org/tip/511b01bdf64ad8a38414096eab283c7784aebfc4
> > >Author:     Ingo Molnar <mingo@elte.hu>
> > >AuthorDate: Thu, 11 Jun 2009 00:32:00 +0200
> > >Committer:  Ingo Molnar <mingo@elte.hu>
> > >CommitDate: Thu, 11 Jun 2009 00:32:00 +0200
> > >
> > >Revert "x86, bts: reenable ptrace branch trace support"
> > >
> > >This reverts commit 7e0bfad24d85de7cf2202a7b0ce51de11a077b21.
> > >
> > >A late objection to the ABI has arrived:
> > >
> > >   http://lkml.org/lkml/2009/6/10/253
> > 
> > I thought that this has been resolved. See for example http://lkml.org/lkml/2009/6/10/257.
> > 
> > Peters concerns were that Debug Store details are exposed to user space, which is
> > not the case. Debug Store itself is fully in-kernel and the expectation of a 
> > user-defined buffer can be implemented on top of the Debug Store changes that
> > Peter expects are needed to support PEBS.
> > 
> > A user-defined trace buffer size is required to support 
> > different usage models. Some users only need a small amount of 
> > trace, whereas others need a big amount. The interface will have 
> > to reflect that in some way.
> 
> Right, your last email did explain how we could keep per task 
> in-kernel buffers and fill them from the DS and still have them of 
> user-specified size.
> 
> That would indeed keep the proposed ABI workable, what I'm still 
> not liking is that this buffer is in-kernel, but I guess that 
> might be something for other people to have an opinion on.

Hm. Wrt. the ABI, wouldnt it make more sense to expose this PMU 
feature via perfcounters: a sampling hw-branch-executions counter, 
with interval=1.

That would give the exact existing semantics, plus a lot lot more. 
Markus?

	Ingo
