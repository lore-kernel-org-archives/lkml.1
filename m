Return-Path: <linux-kernel-owner+w=401wt.eu-S1946854AbXD3WK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946854AbXD3WK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946859AbXD3WK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:10:59 -0400
Received: from www.osadl.org ([213.239.205.134]:34214 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946854AbXD3WK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:10:57 -0400
Subject: Re: [PATCH] fix dynticks for voyager
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1177951131.3674.37.camel@mulgrave.il.steeleye.com>
References: <1177951131.3674.37.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 00:13:10 +0200
Message-Id: <1177971190.5791.251.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 11:38 -0500, James Bottomley wrote:
> As usual voyager tripped over an explicit boot CPU is zero assumption in
> the dynticks code.  This is the fix I have queued in the voyager tree.

I expected some kind of voyager breakage. I desperately tried to find
one for testing in my museum of bizarre hardware to avoid this,
but ... :)

	tglx

> ---
> 
> >From 5d3e489cf8fcf12eff92476098b9bfa0120ee3c7 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Mon, 30 Apr 2007 11:27:25 -0500
> Subject: [VOYAGER] clockevents: correct boot cpu is zero assumption
> 
> This isn't true for voyager, so alter setup_pit_timer() to initialise
> the cpumask from the current processor id (which should be the boot
> processor) rather than defaulting to zero.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/i386/kernel/i8253.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/i386/kernel/i8253.c b/arch/i386/kernel/i8253.c
> index 10cef5c..f8a3c40 100644
> --- a/arch/i386/kernel/i8253.c
> +++ b/arch/i386/kernel/i8253.c
> @@ -110,7 +110,7 @@ void __init setup_pit_timer(void)
>  	 * Start pit with the boot cpu mask and make it global after the
>  	 * IO_APIC has been initialized.
>  	 */
> -	pit_clockevent.cpumask = cpumask_of_cpu(0);
> +	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
>  	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
>  	pit_clockevent.max_delta_ns =
>  		clockevent_delta2ns(0x7FFF, &pit_clockevent);

