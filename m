Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbZIWKlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbZIWKlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZIWKlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:41:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZIWKlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:41:11 -0400
Date: Wed, 23 Sep 2009 12:41:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Chris Malley <mail@chrismalley.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf sched record hangs machine
Message-ID: <20090923104100.GA23941@elte.hu>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com> <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins> <20090923073253.GA18022@elte.hu> <20090923074028.GA3078@elte.hu> <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com> <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com> <7863dc4c0909230215u2fed3edciec84f93f24d3ae1@mail.gmail.com> <20090923092024.GA29323@elte.hu> <aa79d98a0909230248j22f05047n34e0ee97382f573f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0909230248j22f05047n34e0ee97382f573f@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 9/23/09, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Chris Malley <mail@chrismalley.co.uk> wrote:
> >
> >> 2009/9/23 Cyrill Gorcunov <gorcunov@gmail.com>:
> >> >
> >> > Btw, meanwhile Chris may try to pass lapic boot-option in attempt to
> >> > reenable apic via msr registers. Also (iirc) i feel we may be hiding
> >> > errors if complete noop apic would be used since i belive we need to
> >> > check out under which condition a particular operation is called and
> >> > when apic is disabled it's mean we're switched to UP mode and
> >> > inter-cpu interrupts are under suspicion too. Will take a look during
> >> > ~6 hours ;)
> >> >
> >>
> >> Hi Cyrill
> >>
> >> Heh, yes that just occurred to me as well.  With the lapic boot option
> >> I can't reproduce the problem, and get a good recording every time.
> >> Don't know why the BIOS had disabled it (can't see any specific
> >> option).
> >
> > Would still be important to fix the crash - there are boxes where lapics
> > are disabled permanently and cannot be re-enabled. (plus most people
> > dont touch their defaults and dont add funky boot options - so crashing
> > is not an option)
> >
> 
> Ingo, Chris, could you try Peter's patch? It seems like what we need.

It should fix the problem, but also the underlying uncleanliness should 
be fixed as well. We need an apic_none driver template with safe 
methods. Then all the scattered 'is the lapic enabled' open-coded checks 
of global flags can be removed.

	Ingo
