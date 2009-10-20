Return-Path: <linux-kernel-owner+w=401wt.eu-S1751504AbZJTMqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbZJTMqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 08:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZJTMqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 08:46:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZJTMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 08:46:17 -0400
Date: Tue, 20 Oct 2009 14:46:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org
Subject: Re: pref record question
Message-ID: <20091020124609.GA18276@elte.hu>
References: <4ADC9C2A.5020707@klingt.org> <1256012810.17774.17.camel@laptop> <20091020060043.GB8550@elte.hu> <1256030390.17774.35.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256030390.17774.35.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

> On Tue, 2009-10-20 at 08:00 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Mon, 2009-10-19 at 19:04 +0200, Tim Blechmann wrote:
> > >
> > > > i am trying to do some profiling with perf (2.6.31.4). while 
> > > > thread-level profiling works fine, i haven't been able to record 
> > > > profiling data of a whole process (i.e. main thread + child 
> > > > threads). from my understanding, this should be enabled by running 
> > > > 'perf record -i' on the main thread. this does only collect the data 
> > > > from the main thread, though.
> > > > 
> > > > is this an issue with perf or with my understanding of perf?
> > > 
> > > -i will only inherit the counters on new fork()/clone() calls, so an 
> > > existing process/task tree will not automagically get the counters.
> > 
> > Looks like something very much worth fixing.
> 
> Well, maybe.
> 
> There's two ways to go about this, either iterate the tasks in 
> userspace and attach a counter to each one (repeat until there's no 
> new ones left).
> 
> Or add a new flag in perf_event_attr to iterate the tasks on attach in 
> an atomic manner.
> 
> We cannot simply extend the current attach behaviour as that would 
> make it impossible to attach to a single thread in a thread group.

Correct.

> Also, if you extend the interface, it would make sense to allow 
> automatically attaching to a process group, not only a thread group, 
> etc.

Indeed. This more automated approach sounds like the better solution to 
me.

	Ingo
