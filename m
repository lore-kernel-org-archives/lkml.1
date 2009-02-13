Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZBMJwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZBMJwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZBMJwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:52:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZBMJwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:52:44 -0500
Date: Fri, 13 Feb 2009 10:52:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Can request_irq be called under spinlock?
Message-ID: <20090213095231.GD17774@elte.hu>
References: <499481B9.4090202@goop.org> <alpine.LFD.2.00.0902122326100.16972@localhost.localdomain> <4994B23D.4040806@goop.org> <20090213033803.GA13631@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213033803.GA13631@cmpxchg.org>
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


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: irq: use GFP_KERNEL for action allocation in request_irq()
> 
> request_irq() calls into proc code via __setup_irq() which is not safe
> in an atomic context, so request_irq() can itself use the more
> reliable GFP_KERNEL allocation for the action descriptor.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 291f036..0f2b3b6 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -709,7 +709,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
>  	if (!handler)
>  		return -EINVAL;
>  
> -	action = kmalloc(sizeof(struct irqaction), GFP_ATOMIC);
> +	action = kmalloc(sizeof(struct irqaction), GFP_KERNEL);
>  	if (!action)
>  		return -ENOMEM;

Good catch - applied to tip:irq/genirq, thanks Johannes!

	Ingo
