Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZL1UBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZL1UBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZL1UBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:01:49 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63426 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZL1UBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:01:48 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/UzlOL0OIevino/m8/p+d9
Date: Mon, 28 Dec 2009 12:01:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: mfd: twl4030-irq: irq_desc->lock converted to raw_spinlock_t
Message-ID: <20091228200145.GN3512@atomide.com>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
 <1261998172-29760-5-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261998172-29760-5-git-send-email-felipe.balbi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <felipe.balbi@nokia.com> [091228 03:04]:
> commit 239007b8440abff689632f50cdf0f2b9e895b534 converted
> the spinlock_t to raw_spinlock_t. Unfortunately twl4030-irq
> was left aside on the conversion.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> 
> ---
> 
> resending because it wasn't applied before

This should go via Samuel as it's MFD related.

Acked-by: Tony Lindgren <tony@atomide.com>

 
> 
>  drivers/mfd/twl4030-irq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index 20d29ba..9df9a5a 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -568,12 +568,12 @@ static void twl4030_sih_do_edge(struct work_struct *work)
>  
>  		bytes[byte] &= ~(0x03 << off);
>  
> -		spin_lock_irq(&d->lock);
> +		raw_spin_lock_irq(&d->lock);
>  		if (d->status & IRQ_TYPE_EDGE_RISING)
>  			bytes[byte] |= BIT(off + 1);
>  		if (d->status & IRQ_TYPE_EDGE_FALLING)
>  			bytes[byte] |= BIT(off + 0);
> -		spin_unlock_irq(&d->lock);
> +		raw_spin_unlock_irq(&d->lock);
>  
>  		edge_change &= ~BIT(i);
>  	}
