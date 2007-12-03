Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXLCKd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXLCKd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLCKdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:33:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXLCKdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:33:49 -0500
Date: Mon, 3 Dec 2007 11:33:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203103326.GD30050@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200712032017.19661.nickpiggin@yahoo.com.au> <20071203095719.GA23106@elte.hu> <200712032115.43275.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712032115.43275.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > > I was just talking about the default because I didn't know the 
> > > reason for the way it was set -- now that I do, we should talk 
> > > about trying to improve the actual code so we don't need 2 
> > > defaults.
> >
> > I've got the patch below queued up: it uses the more agressive yield 
> > implementation for SCHED_BATCH tasks. SCHED_BATCH is a natural 
> > differentiator, it's a "I dont care about latency, it's all about 
> > throughput for me" signal from the application.
> 
> First and foremost, do you realize that I'm talking about existing 
> userspace working well on future kernels right? (ie. backwards 
> compatibility).

given how poorly sched_yield() is/was defined the only "compatible" 
solution would be to go back to the old yield code. (And note that you 
are rehashing arguments that were covered on lkml months ago already.)

> > But first and foremost, do you realize that there will be no easy 
> > solutions to this topic, that it's not just about 'flipping a 
> > default'?
> 
> Of course ;) I already answered that in the email that you're replying 
> to:
> 
> > > I was just talking about the default because I didn't know the 
> > > reason for the way it was set -- now that I do, we should talk 
> > > about trying to improve the actual code so we don't need 2 
> > > defaults.

well, in case you were wondering why i was a bit pointy about this, this 
topic of yield has been covered on lkml quite extensively a couple of 
months ago. I assumed you knew about that already, but perhaps not?

> Anyway, I'd hope it can actually be improved and even the sysctl 
> removed completely.

i think the sanest long-term solution is to strongly discourage the use 
of SCHED_OTHER::yield, because there's just no sane definition for yield 
that apps could rely upon. (well Linus suggested a pretty sane 
definition but that would necessiate the burdening of the scheduler 
fastpath - we dont want to do that.) New ideas are welcome of course.

[ also, actual technical feedback on the SCHED_BATCH patch i sent (which
  was the only "forward looking" moment in this thread so far ;-) would
  be nice too. ]

	Ingo
