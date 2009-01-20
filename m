Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbZATPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbZATPEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZATPEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:04:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58776 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbZATPEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:04:41 -0500
Date: Tue, 20 Jan 2009 16:04:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, Avi Kivity <avi@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090120150408.GD21931@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au> <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu> <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 20 Jan 2009, Ingo Molnar wrote:
> > Another test would be to build the scheduler latency tracer into your 
> > kernel:
> > 
> >     CONFIG_SCHED_TRACER=y
> > 
> > And enable it via:
> > 
> >     echo wakeup > /debug/tracing/current_tracer
> > 
> > and you should be seeing the worst-case scheduling latency traces in 
> > /debug/tracing/trace, and the largest observed latency will be in 
> > /debug/tracing/tracing_max_latency [in microseconds].
> 
> Note, the wakeup latency only tests realtime threads, since other 
> threads can have other issues for wakeup. I could change the wakeup 
> tracer as wakeup_rt, and make a new "wakeup" that tests all threads, but 
> it may be difficult to get something accurate.

hm, that's a significant regression then. The latency tracer used to 
measure the highest-prio task in the system - be that RT or non-rt.

	Ingo
