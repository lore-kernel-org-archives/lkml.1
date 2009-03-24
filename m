Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZCXUww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZCXUww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZCXUwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45320 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZCXUwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:52:42 -0400
Date: Tue, 24 Mar 2009 21:51:20 +0100
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
Message-ID: <20090324205120.GB24320@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324201146.GA4350@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> If we want to do this logically, without thinking about tracer 
> performance impact, we could/should do :
> 
> trace_irq_entry(irqno, pt_regs)
>   for_each_handler() {
>     trace_irq_handler_entry(action)
>     action->handler()
>     trace_irq_handler_exit(ret)
>   }
> trace_irq_exit(retval)

Not really.

As i said, the handler invocation should be thought of separately 
from vectored IRQs. A device IRQ handler can be invoked in a number 
of non-vectored ways: it can be called in an IRQ thread for example. 
(there are other invocation modes possible too)

For IRQ vectors, the 'retval' makes little sense - so the exit event 
can be left out.

Which leaves us with what i suggested: to add an IRQ vector entry 
event on top of Jason's (already integrated) patches.

Hm?

	Ingo
