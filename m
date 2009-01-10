Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZAJWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZAJWs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZAJWsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:48:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZAJWsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:48:19 -0500
Date: Sat, 10 Jan 2009 23:47:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] irq: allocate irq_desc_ptrs array based on nr_irqs
Message-ID: <20090110224755.GC17917@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.767801000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110223818.767801000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4998]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> +++ linux-2.6-for-ingo/kernel/irq/internals.h
> @@ -16,7 +16,11 @@ extern int __irq_set_trigger(struct irq_
>  extern struct lock_class_key irq_desc_lock_class;
>  extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
>  extern spinlock_t sparse_irq_lock;
> +#ifdef CONFIG_SPARSE_IRQ
> +extern struct irq_desc **irq_desc_ptrs;
> +#else
>  extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
> +#endif

why the #ifdef? irq_desc_ptrs is only defined and used by sparseirq.

	Ingo
