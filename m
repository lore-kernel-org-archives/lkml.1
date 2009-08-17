Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbZHQMad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbZHQMad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZHQMac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:30:32 -0400
Received: from bu3sch.de ([62.75.166.246]:44734 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZHQMab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:30:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupt handlers broken?
Date: Mon, 17 Aug 2009 14:30:31 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200908161153.14081.mb@bu3sch.de> <200908171337.58713.mb@bu3sch.de> <alpine.LFD.2.00.0908171411410.2782@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908171411410.2782@localhost.localdomain>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171430.32146.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 August 2009 14:14:01 Thomas Gleixner wrote:
> Michael,
> 
> On Mon, 17 Aug 2009, Michael Buesch wrote:
> > This fixes it :)
> 
> can you please test the final version of the fix ?
> 
> Thanks,
> 
> 	tglx
> ---
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -607,7 +607,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  		 */
>  		get_task_struct(t);
>  		new->thread = t;
> -		wake_up_process(t);
>  	}
>  
>  	/*
> @@ -690,6 +689,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  				(int)(new->flags & IRQF_TRIGGER_MASK));
>  	}
>  
> +	new->irq = irq;
>  	*old_ptr = new;
>  
>  	/* Reset broken irq detection when installing new handler */
> @@ -707,7 +707,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  
>  	spin_unlock_irqrestore(&desc->lock, flags);
>  
> -	new->irq = irq;
>  	register_irq_proc(irq, desc);
>  	new->dir = NULL;
>  	register_handler_proc(irq, new);
> 
> 

Also works. Thanks.

Tested-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings, Michael.
