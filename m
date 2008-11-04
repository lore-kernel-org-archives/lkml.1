Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYKDQpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYKDQpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYKDQoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:44:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYKDQoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:44:54 -0500
Date: Tue, 4 Nov 2008 17:43:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: function tracer with irqs disabled
Message-ID: <20081104164358.GB27339@elte.hu>
References: <20081104041554.605521183@goodmis.org> <20081104042203.499871423@goodmis.org> <20081104080747.GA27075@elte.hu> <20081104090405.GA507@elte.hu> <alpine.DEB.1.10.0811040919060.4140@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811040919060.4140@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > > tracing type       times            entries recorded
> > > > ------------      --------          ----------------
> > > > irq disabled      43.393            166433066
> > > >                   43.282            166172618
> > > >                   43.298            166256704
> > > > 
> > > > preempt disabled  38.969            159871710
> > > >                   38.943            159972935
> > > >                   39.325            161056510

> When we used the preempt disabled version, we lost 5 million traces, 
> as suppose to the irq disabled which was only 1,150 traces lost.
> 
> Considering that we had 166,256,704 traces total, that 5 million is 
> only 4% lost of traces. Still quite a lot. But again, this is an 
> extreme, because we are tracing hackbench.

there's about 10% difference between the two hackbench results - so 
the lack of 5% of the traces could make up for about half of that 
overhead.

anyway, that still leaves the other 5% as the _true_ overhead of IRQ 
disable.

is there some other workload that does not lose this many trace 
entries, making it easier to compare irqs-off against preempt-off?

	Ingo
