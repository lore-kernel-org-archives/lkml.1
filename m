Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbXKHJdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbXKHJdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXKHJcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:32:55 -0500
Received: from smtp2a.orange.fr ([80.12.242.140]:29493 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbXKHJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:32:54 -0500
X-ME-UUID: 20071108093251766.BB1BA70000AE@mwinf2a22.orange.fr
Date: Thu, 8 Nov 2007 10:28:06 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: oprofile-list@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] AVR32: Oprofile support
Message-ID: <20071108092806.GB2889@zaniah>
References: <1194444333-9264-1-git-send-email-hskinnemoen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194444333-9264-1-git-send-email-hskinnemoen@atmel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2007 at 15:05 +0000, Haavard Skinnemoen wrote:

> This adds the necessary architecture code to run oprofile on AVR32
> using the performance counters documented by the AVR32 Architecture
> Manual.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

> --- /dev/null
> +++ b/arch/avr32/oprofile/op_model_avr32.c
> @@ -0,0 +1,235 @@
> +/*


> +static irqreturn_t avr32_perf_counter_interrupt(int irq, void *dev_id)
> +{
> +	struct avr32_perf_counter *ctr = dev_id;
> +	struct pt_regs *regs;
> +	u32 pccr;
> +
> +	if (likely(!(intc_get_pending(AVR32_PERFCTR_IRQ_GROUP)
> +					& (1 << AVR32_PERFCTR_IRQ_LINE))))
> +		return IRQ_NONE;
> +
> +	regs = get_irq_regs();
> +	pccr = sysreg_read(PCCR);
> +
> +	/* Clear the interrupt flags we're about to handle */
> +	sysreg_write(PCCR, pccr);
> +
> +	/* PCCNT */
> +	if (ctr->enabled && (pccr & ctr->flag_mask)) {
> +		sysreg_write(PCCNT, -ctr->count);
> +		oprofile_add_sample(regs, PCCNT);
> +	}
> +	ctr++;
> +	/* PCNT0 */
> +	if (ctr->enabled && (pccr & ctr->flag_mask)) {
> +		sysreg_write(PCNT0, -ctr->count);
> +		oprofile_add_sample(regs, PCNT0);
> +	}
> +	ctr++;
> +	/* PCNT1 */
> +	if (ctr->enabled && (pccr & ctr->flag_mask)) {
> +		sysreg_write(PCNT1, -ctr->count);
> +		oprofile_add_sample(regs, PCNT1);
> +	}

Why not a loop here ?

-- 
regards,
Phe

