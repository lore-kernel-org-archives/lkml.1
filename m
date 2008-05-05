Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYEEKBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYEEKBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbYEEJ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:59:54 -0400
Received: from www.tglx.de ([62.245.132.106]:33458 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372AbYEEJ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:59:52 -0400
Date: Mon, 5 May 2008 11:59:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 II
In-Reply-To: <20080502094543.GA11114@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de>
References: <20080502091806.GA26062@basil.nowhere.org> <20080502094543.GA11114@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-625776120-1209981574=:3318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-625776120-1209981574=:3318
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Fri, 2 May 2008, Andi Kleen wrote:
> +static void stack_overflow(void)
> +{
> +	printk("low stack detected by irq handler\n");

Needs a KERN_ERR

> +		/* Execute warning on interrupt stack */
> +		if (unlikely(overflow))
> +			call_on_stack2(stack_overflow, isp, 0, 0);
> +
> +		call_on_stack2(desc->handle_irq, isp, irq, desc);

arch/x86/kernel/irq_32.c:148: warning: passing argument 2 of ¡call_on_stack2¢ makes integer from pointer without a cast
arch/x86/kernel/irq_32.c:150: warning: passing argument 2 of ¡call_on_stack2¢ makes integer from pointer without a cast
arch/x86/kernel/irq_32.c:150: warning: passing argument 4 of ¡call_on_stack2¢ makes integer from pointer without a cast

>  	} else
>  #endif
> -		desc->handle_irq(irq, desc);
> +	{
> +		/* AK: Slightly bogus here */

Bogus comment. This applies to both the !4KSTACKS and the overflow of
the irq stack in the 4KSTACKS case.

> +		if (overflow)

unlikely(overflow) ?

> +			stack_overflow();
> + 		desc->handle_irq(irq, desc);

Thanks,

	tglx
--8323328-625776120-1209981574=:3318--
