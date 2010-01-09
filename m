Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380Ab0AIAl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0AIAl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786Ab0AIAl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:41:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612Ab0AIAlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:41:55 -0500
Date: Fri, 8 Jan 2010 16:39:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] set_irq_noprobe shouldn't be __init
Message-Id: <20100108163910.ed49b5f4.akpm@linux-foundation.org>
In-Reply-To: <20100105203842.04a1a523@hyperion.delvare>
References: <20100105203842.04a1a523@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 20:38:42 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Non-__init functions need to call set_irq_noprobe() so this function
> shouldn't be marked __init. Also remove __init from set_irq_probe()
> for consistency.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  kernel/irq/chip.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.33-rc2.orig/kernel/irq/chip.c	2009-12-18 08:34:52.000000000 +0100
> +++ linux-2.6.33-rc2/kernel/irq/chip.c	2010-01-05 17:21:38.000000000 +0100
> @@ -682,7 +682,7 @@ set_irq_chip_and_handler_name(unsigned i
>  	__set_irq_handler(irq, handle, 0, name);
>  }
>  
> -void __init set_irq_noprobe(unsigned int irq)
> +void set_irq_noprobe(unsigned int irq)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	unsigned long flags;
> @@ -697,7 +697,7 @@ void __init set_irq_noprobe(unsigned int
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  }
>  
> -void __init set_irq_probe(unsigned int irq)
> +void set_irq_probe(unsigned int irq)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	unsigned long flags;

These non-__init callers will instantly crash, surely?  Are there any
reports of such crashes?

If you're talking about new code then what is the status of that code?

Right now I don't know if this patch is needed in 2.6.34, 2.6.33 or
2.6.32.x and earlier.

IOW: the changelog sucks :)

Thanks.

