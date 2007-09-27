Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXI0L3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXI0L3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXI0L3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:29:07 -0400
Received: from www.osadl.org ([213.239.205.134]:60518 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754066AbXI0L3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:29:06 -0400
Subject: Re: [PATCH] Compile handle_percpu_irq even for uniprocessor kernels
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Molnar Ingo <mingo@elte.hu>,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
In-Reply-To: <20070927112448.GA16909@linux-mips.org>
References: <20070927112448.GA16909@linux-mips.org>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 13:28:59 +0200
Message-Id: <1190892539.23376.90.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-09-27 at 12:24 +0100, Ralf Baechle wrote:
> Compiling handle_percpu_irq only on uniprocessor generates an artificial
> special case so a typical use like:
> 
>   set_irq_chip_and_handler(irq, &some_irq_type, handle_percpu_irq);
> 
> needs to be conditionally compiled only on SMP systems as well and an
> alternative UP construct is usually needed - for no good reason.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Makes sense.

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> This fixes uniprocessor configurations for some MIPS SMP systems.
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index f1a73f0..9b5dff6 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -503,7 +503,6 @@ out_unlock:
>  	spin_unlock(&desc->lock);
>  }
>  
> -#ifdef CONFIG_SMP
>  /**
>   *	handle_percpu_IRQ - Per CPU local irq handler
>   *	@irq:	the interrupt number
> @@ -529,8 +528,6 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
>  		desc->chip->eoi(irq);
>  }
>  
> -#endif /* CONFIG_SMP */
> -
>  void
>  __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
>  		  const char *name)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

