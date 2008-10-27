Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYJ0OI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYJ0OI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYJ0OIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:08:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50275 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYJ0OIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:08:49 -0400
Date: Mon, 27 Oct 2008 15:08:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] SGI RTC: add RTC system interrupt
Message-ID: <20081027140829.GD5704@elte.hu>
References: <20081023163041.GA14574@sgi.com> <20081023163223.GA14815@sgi.com> <20081023163414.GB14815@sgi.com> <20081024031127.GA25165@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024031127.GA25165@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0504]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> +void uv_rtc_timer_interrupt(struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	ack_APIC_irq();
> +
> +	exit_idle();
> +
> +	irq_enter();
> +
> +	if (uv_rtc_interrupt_extension)
> +		uv_rtc_interrupt_extension();
> +
> +	irq_exit();
> +
> +	set_irq_regs(old_regs);
> +}

hm, the exit_idle() looks weird - why is it done? If we get an IRQ 
then the CPU will exit idle state anyway.

	Ingo
