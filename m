Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZCKCWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZCKCWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZCKCWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:22:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:42993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZCKCWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:22:04 -0400
Subject: Re: [patch 08/18] powerpc: convert obsolete irq_desc_t to struct
 irq_desc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090311003236.263019667@linutronix.de>
References: <20090311003204.592133594@linutronix.de>
	 <20090311003236.263019667@linutronix.de>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 13:19:22 +1100
Message-Id: <1236737962.7086.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 00:45 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (powerpc-convert-obsolete-irq-desc-t-typedef.patch)
> Impact: cleanup
> 
> Convert the last remaining users.

Ack. This would be more easily carried in my -next tree if that's ok
with you.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: linuxppc-dev@ozlabs.org
> ---
>  arch/powerpc/kernel/irq.c            |    4 ++--
>  arch/powerpc/platforms/iseries/irq.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/powerpc/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/kernel/irq.c
> +++ linux-2.6/arch/powerpc/kernel/irq.c
> @@ -171,7 +171,7 @@ int show_interrupts(struct seq_file *p, 
>  {
>  	int i = *(loff_t *)v, j;
>  	struct irqaction *action;
> -	irq_desc_t *desc;
> +	struct irq_desc *desc;
>  	unsigned long flags;
>  
>  	if (i == 0) {
> @@ -1038,7 +1038,7 @@ arch_initcall(irq_late_init);
>  static int virq_debug_show(struct seq_file *m, void *private)
>  {
>  	unsigned long flags;
> -	irq_desc_t *desc;
> +	struct irq_desc *desc;
>  	const char *p;
>  	char none[] = "none";
>  	int i;
> Index: linux-2.6/arch/powerpc/platforms/iseries/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/iseries/irq.c
> +++ linux-2.6/arch/powerpc/platforms/iseries/irq.c
> @@ -214,7 +214,7 @@ void __init iSeries_activate_IRQs()
>  	unsigned long flags;
>  
>  	for_each_irq (irq) {
> -		irq_desc_t *desc = get_irq_desc(irq);
> +		struct irq_desc *desc = get_irq_desc(irq);
>  
>  		if (desc && desc->chip && desc->chip->startup) {
>  			spin_lock_irqsave(&desc->lock, flags);
> 

