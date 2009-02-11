Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZBKRQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZBKRQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZBKRQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:16:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZBKRQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:16:42 -0500
Date: Wed, 11 Feb 2009 18:16:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
Message-ID: <20090211171622.GA13239@elte.hu>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com>
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

> 
> On Wed, 11 Feb 2009, Steven Rostedt wrote:
> 
> > 
> > On Wed, 11 Feb 2009, Ingo Molnar wrote:
> > 
> > > 
> > > > > Steven Rostedt (7):
> > > > >       ring-buffer: add NMI protection for spinlocks
> > > > >       nmi: add generic nmi tracking state
> > > 
> > > hm, this commit breaks a number of non-x86 architectures the following way:
> > > 
> > > In file included from /home/mingo/tip/include/linux/interrupt.h:12,
> > >                  from /home/mingo/tip/arch/ia64/include/asm/mca.h:16,
> > >                  from /home/mingo/tip/arch/ia64/kernel/asm-offsets.c:17:
> > > /home/mingo/tip/include/linux/hardirq.h:67:2: #error PREEMPT_ACTIVE too high!
> > > make[2]: *** [arch/ia64/kernel/asm-offsets.s] Error 1
> 
> I just looked at alpha and arm, I'm now looking at ia64. And this could
> be an issue, since it has 14 bits for hard irqs.
> 
> What would be the impact to make the preempt count a long?

Assembly code has to be audited i guess, whether it's treated as an int anywhere. 
Should work i guess.

	Ingo
