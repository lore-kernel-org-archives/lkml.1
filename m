Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbZCXSCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbZCXSCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759889AbZCXSCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:02:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbZCXSCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:02:13 -0400
Date: Tue, 24 Mar 2009 19:01:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 4/9] LTTng instrumentation softirq
Message-ID: <20090324180123.GF31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.396496293@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.396496293@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Compared to Jason's patch, this patch also instruments softirq raise event.

Mind sending this on top of Jason's patch, which is already applied 
to the tracing tree?

Note, your instrumentation misses one source of softirq raise 
events:

> @@ -300,6 +306,7 @@ void irq_exit(void)
>   */
>  inline void raise_softirq_irqoff(unsigned int nr)
>  {
> +	trace_irq_softirq_raise(nr);
>  	__raise_softirq_irqoff(nr);

__raise_softirq_irqoff() is used in the networking tree. It makes 
little sense to instrument raise_softirq_irqoff() while not 
instrumenting __raise_softirq_irqoff().

	Ingo
