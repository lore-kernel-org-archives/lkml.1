Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXJVJko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXJVJko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbXJVJkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:40:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48463 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXJVJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:40:36 -0400
Date: Mon, 22 Oct 2007 11:40:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071022094014.GB7659@elte.hu>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org> <20071015114738.6b5a25c7.akpm@linux-foundation.org> <20071015192822.GA2267@kernel.dk> <20071022091057.GB2781@elte.hu> <20071022022319.a5988afe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022022319.a5988afe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > so lets just goddamn apply this _trivial_ patch. This isnt an 
> > intrusive 1000 line rewrite that is hard to revert. If it causes any 
> > bandwidth problems, it will be just as trivial to undo. If we do 
> > anything else we just stiffle the still young and very much 
> > under-represented "lets fix latencies that bothers people" movement. 
> > If anything we need _positive_ discrimination for latency related 
> > fixes (which treatment this fix does not need at all - all it needs 
> > is _equal_ footing with the countless bandwidth patches that go into 
> > the kernel all the time), otherwise it will never take off and 
> > become as healthy as bandwidth optimizations. Ok?
> 
> I think the situation is that we've asked for some additional 
> what-can-be-hurt-by-this testing.
>
> Yes, we could sling it out there and wait for the reports.  But often 
> that's a pretty painful process and regressions can be discovered too 
> late for us to do anything about them.

reverting this oneliner is trivial. Finding bandwidth problems and 
tracking them down to this oneliner change is relatively easy too. 
Finding latency problems and fixing them is _not_ trivial.

Boot up a Linux desktop and start OOo or firefox, and measure the time 
it takes to start the app up. 10-20 seconds on a top-of-the-line 
quad-core 3.2 GHz system - which is a shame. Same box can do in excess 
of 1GB/sec block IO. Yes, one could blame the apps but in reality most 
of the blame is mostly on the kernel side. We do not make bloat and 
latency suckage apparent enough to user-space (due to lack of 
intelligent instrumentation), we make latencies hard to fix, we have an 
acceptance bias towards bandwidth fixes (because they are easier to 
measure and justify) - and that's all what it takes to let such a 
situation get out of control.

and i can bring up the scheduler as an example. CFS broke the bandwidth 
performance of one particular app and it took only a few days to get it 
back under control. But it was months to get good latency behavior out 
of the scheduler. And that is with the help of excellent scheduler 
instrumentation. In the IO space the latency situation is much, much 
worse. Really.

	Ingo
