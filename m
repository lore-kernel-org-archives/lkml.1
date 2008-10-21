Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYJUHd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYJUHd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYJUHdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:33:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:50880 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbYJUHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:33:06 -0400
Subject: Re: Bug in "genirq: record trigger type"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <20081021072857.GA333@elte.hu>
References: <200810202205.m9KM5une024759@hera.kernel.org>
	 <1224570730.7654.242.camel@pasglop>
	 <86802c440810210022i75d3c081r8fc979386cdda9ce@mail.gmail.com>
	 <20081021072857.GA333@elte.hu>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 18:32:23 +1100
Message-Id: <1224574343.7654.244.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 09:28 +0200, Ingo Molnar wrote:

> From: Chris Friesen <cfriesen@nortel.com>
> Date: Mon, 20 Oct 2008 12:41:58 -0600
> Subject: [PATCH] genirq: fix set_irq_type() when recording trigger type
> 
> In set_irq_type() we want to pass the type rather than the current
> interrupt state.
> 
> Signed-off-by: Chris Friesen <cfriesen@nortel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  kernel/irq/chip.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 4895fde..3de6ea3 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -127,7 +127,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
>  		return 0;
>  
>  	spin_lock_irqsave(&desc->lock, flags);
> -	ret = __irq_set_trigger(desc, irq, flags);
> +	ret = __irq_set_trigger(desc, irq, type);
>  	spin_unlock_irqrestore(&desc->lock, flags);
>  	return ret;
>  }

