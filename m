Return-Path: <linux-kernel-owner+w=401wt.eu-S933398AbXG0Nez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbXG0Nez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbXG0Neq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:34:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57604 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758585AbXG0Neq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:34:46 -0400
Message-ID: <46A9F471.1020504@garzik.org>
Date: Fri, 27 Jul 2007 09:34:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rip some includes from linux/interrupt.h
References: <20070727132433.GB27237@ftp.linux.org.uk>
In-Reply-To: <20070727132433.GB27237@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 0a3c2eb..5523f19 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -11,8 +11,6 @@
>  #include <linux/hardirq.h>
>  #include <linux/sched.h>
>  #include <linux/irqflags.h>
> -#include <linux/bottom_half.h>
> -#include <linux/device.h>
>  #include <asm/atomic.h>
>  #include <asm/ptrace.h>
>  #include <asm/system.h>
> @@ -97,6 +95,8 @@ extern int __must_check request_irq(unsigned int, irq_handler_t handler,
>  		       unsigned long, const char *, void *);
>  extern void free_irq(unsigned int, void *);
>  
> +struct device;
> +
>  extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
>  			    irq_handler_t handler, unsigned long irqflags,
>  			    const char *devname, void *dev_id);
> diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
> index d8ee241..6d9204f 100644
> --- a/kernel/irq/devres.c
> +++ b/kernel/irq/devres.c
> @@ -1,5 +1,6 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
> +#include <linux/device.h>

ACK

Thanks for the devres.c patch, that was on my TODO list.  Caught that 
when I backported SATA into Red Hat's kernel.

	Jeff



