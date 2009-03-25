Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZCYIsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZCYIsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZCYIs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:48:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbZCYIs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:48:28 -0400
Date: Wed, 25 Mar 2009 09:47:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
Message-ID: <20090325084724.GA28171@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal> <20090324205120.GB24320@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324205120.GB24320@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > If we want to do this logically, without thinking about tracer 
> > performance impact, we could/should do :
> > 
> > trace_irq_entry(irqno, pt_regs)
> >   for_each_handler() {
> >     trace_irq_handler_entry(action)
> >     action->handler()
> >     trace_irq_handler_exit(ret)
> >   }
> > trace_irq_exit(retval)
> 
> Not really.

Put differently: we seem to agree on handler invocation entry/exit 
events (and those are handled by Jason's patch already), and that's 
good.

I dont think we need two events for physical IRQ events though. One 
is enough: entry event. What meaning does 'retval' have in your 
pseudo-code above? None typically.

	Ingo
