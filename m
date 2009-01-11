Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZAKBHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZAKBHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZAKBHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:07:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbZAKBHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:07:10 -0500
Date: Sun, 11 Jan 2009 02:06:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] irq: allocate irq_desc_ptrs array based on nr_irqs
Message-ID: <20090111010650.GB12885@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.767801000@polaris-admin.engr.sgi.com> <20090110224755.GC17917@elte.hu> <49692953.1020405@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49692953.1020405@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> +++ linux-2.6-for-ingo/kernel/irq/internals.h
> >> @@ -16,7 +16,11 @@ extern int __irq_set_trigger(struct irq_
> >>  extern struct lock_class_key irq_desc_lock_class;
> >>  extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
> >>  extern spinlock_t sparse_irq_lock;
> >> +#ifdef CONFIG_SPARSE_IRQ
> >> +extern struct irq_desc **irq_desc_ptrs;
> >> +#else
> >>  extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
> >> +#endif
> > 
> > why the #ifdef? irq_desc_ptrs is only defined and used by sparseirq.
> > 
> > 	Ingo
> 
> Hmm, good point.  I just modified as it was.
> 
> Should it only be:
> 
> 	#ifdef CONFIG_SPARSE_IRQ
> 	extern struct irq_desc **irq_desc_ptrs;
> 	#endif
> 
> Or do we normally declare something even though it won't be defined anywhere?

yeah, we tend to skip the #ifdefs whenever we can do so unpunished.

	Ingo
