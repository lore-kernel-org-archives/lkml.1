Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYHYQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYHYQsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbYHYQrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:47:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:30759 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYHYQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MxMnuBDBewDqvvlFQa4EbJ5uLv4zEDAtDLPB3VFTTE61kgAZD4AFEDNJW6PLFG0s4A
         qRC16CfCx14LtA0p5R2V0PQyogWYYbaBCkTBTBSldzoAYKHdbtPmt6Y7LNa4i1UScxX+
         IQEYx9oiJBaN3HpuXg31zVRK7oBKSimJE8m9U=
Date: Mon, 25 Aug 2008 20:47:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: let 64 bit to use 32 bit calibrate_apic_clock
Message-ID: <20080825164748.GB7249@lenovo>
References: <1219642886-22030-1-git-send-email-yhlu.kernel@gmail.com> <20080825074704.GA20698@elte.hu> <86802c440808250104i51d438eboe58dc1cc731b545e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808250104i51d438eboe58dc1cc731b545e@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Mon, Aug 25, 2008 at 01:04:34AM -0700]
| On Mon, Aug 25, 2008 at 12:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
| >
| > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
| >
| >> Signed-of-by: Yinghai Lu <yhlu.kernel@gmail.com>
| >
| > applied to tip/irq/sparseirq - thanks Yinghai.
| >
| > btw., why was this bit needed:
| >
| >> @@ -659,6 +575,7 @@ static int __init calibrate_APIC_clock(v
| >>       delta = lapic_cal_t1 - lapic_cal_t2;
| >>       apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
| >>
| >> +#ifdef CONFIG_X86_PM_TIMER
| >>       /* Check, if the PM timer is available */
| >>       deltapm = lapic_cal_pm2 - lapic_cal_pm1;
| >>       apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
| >> @@ -687,6 +604,7 @@ static int __init calibrate_APIC_clock(v
| >>               }
| >>               pm_referenced = 1;
| >>       }
| >> +#endif
| >
| > wouldnt this be a (small) fix for the pre-unification 32-bit side as
| > well, which we should put into tip/x86/urgent as well?
| 
| 64bit have those MACRO, it seems when CONFIG_EMBEDDED is set, could
| reduce some size if pm is not selected.
| 
| it seems not be urgent for 2.6.27.
| 
| YH
| 

Hey, APIC_DIVISOR is now wrong - it should be 16 for both modes
then, shouldn't it? :)

		- Cyrill -
