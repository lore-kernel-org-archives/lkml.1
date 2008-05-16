Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYEPIqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYEPIqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYEPIqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:46:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33579 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbYEPIqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:46:13 -0400
X-Sasl-enc: D+ey/h1spEyyXw7VzRvdAAmCYM/vP3yZy5QP/u5xjumU 1210927571
Message-ID: <482D49CF.4030902@ladisch.de>
Date: Fri, 16 May 2008 10:46:07 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kevin Hao <kexin.hao@windriver.com>
CC: venkatesh.pallipadi@intel.com, bob.picco@hp.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Get irq for hpet timer
References: <1210917912.10881.1.camel@kevin-desktop>
In-Reply-To: <1210917912.10881.1.camel@kevin-desktop>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hao wrote:
> HPET timer's IRQ is 0 by default, so we have to select which irq
> will be used for these timers. We wait to set the timer's irq until
> we really turn on interrupt in order to reduce the chance of
> conflicting with some legacy device.
>
> +	for (irq = find_first_bit(&cap, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
> +		irq = find_next_bit(&cap, HPET_MAX_IRQ, 1 + irq)) {
> +		if (request_irq(irq, hpet_interrupt, irq_flags,
> +				devp->hd_name, (void *)devp)) {
> +			printk(KERN_WARNING "hpet: IRQ %d is not free\n", irq);
> +			continue;

This warning message will be output for every interrupt that is in use
by another device.  I think it would be better to postpone complaining
until after the loop, if no interrupt has been found at all.


Regards,
Clemens
