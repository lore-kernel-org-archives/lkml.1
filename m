Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZGOXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZGOXQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbZGOXQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:16:49 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5829 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756381AbZGOXQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:16:48 -0400
Date: Wed, 15 Jul 2009 19:16:46 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090715231646.GI14993@cs.fsu.edu>
References: <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu> <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com> <20090715223400.GF14993@cs.fsu.edu> <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1) The priority of a group seemed to be defined by the priority of
> > the highest-priority thread in the group's run-queue, which means
> > it varies dynamically according to which threads in the group are
> > contending.
> >
> 
> This is true, but it also ensures that the time allocated to the group
> is also consumed by group if it wants to.

I don't see how schedulability analysis can be done with this model,
since a single budget is being expended at varying priorities/deadlines.

> > 4) On an SMP, more than one thread could be running against
> > the same budget at the same time, resulting in budget over-charges.
> >
> 
> The rt group scheduler does split the budget per cpu. On expiring the
> budget, it tries to borrow from other CPUs if possible.

First, how is the splitting of the budget between CPU's controlled
by the application?

Second, I don't see how schedulabiliyt analysis could be done if
CPU's can "borrow" budget from other CPUs, unless there is some
mechanism in place to "pay it back".  How do you do the analysis?

Ted
