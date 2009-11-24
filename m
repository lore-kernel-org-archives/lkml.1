Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbZKXOpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbZKXOpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933121AbZKXOph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:45:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108AbZKXOph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:45:37 -0500
Date: Tue, 24 Nov 2009 15:45:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liuweni <qingshenlwy@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xgr178 <xgr178@163.com>,
       Jiri Kosina <jkosina@suse.cz>, qingshenlwy <qingshenlwy@tom.com>
Subject: Re: [PATCH]irq/core:Add a length limitation
Message-ID: <20091124144530.GB17934@elte.hu>
References: <200911242147508598860@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911242147508598860@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Liuweni <qingshenlwy@gmail.com> wrote:

> In the register_handler_proc(), the max length of irqaction->name is 
> MAX_NAMELEN. And this function will call name_unique() to compare name 
> with other irqs'.
>
> There is no any code for limitation the length. I add a warning in the 
> function to notice that the irqaction->name is too long.
> 
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> ---
> diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
> index 0832145..9ab6e04 100644
> --- a/kernel/irq/proc.c
> +++ b/kernel/irq/proc.c
> @@ -196,6 +196,9 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
>  	char name [MAX_NAMELEN];
>  	struct irq_desc *desc = irq_to_desc(irq);
>  
> +	if(strlen(action->name) >= MAX_NAMELEN)
> +		WARN_ON(1);
> +

Has this situation happened in the past that requires this check to be 
added? The current limit of 128 chars is quite generous. Also, the check 
is buggy, it's off by 1.

( Also, please use scripts/checkpatch.pl on patches and please use 
  'scripts/get_maintainer.pl -f kernel/irq/proc.c' when constructing Cc: 
  lines. )

Thanks,

	Ingo
