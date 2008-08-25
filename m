Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYHYUGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYHYUGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYHYUFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:05:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:26986 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYHYUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hhLmrpj9bIxZyHkxV9F8un4Dq+eBcYsouuStLk6mWepjRxfmOD9SUgHzwXzHugAPQt
         FqVch99Zq3KrrDmkDopuzFtj3D3Jx/qwV/antPu9qB72bNqMmieOpghcn+gQpa5Bz5FM
         A+Jcj9AHBJx0EOGxbX4yZzINXG9GNtVNIW7qo=
Message-ID: <86802c440808251305y77ccf4fan557045a52fda713c@mail.gmail.com>
Date: Mon, 25 Aug 2008 13:05:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: let 64 bit to use 32 bit calibrate_apic_clock
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080825164748.GB7249@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219642886-22030-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080825074704.GA20698@elte.hu>
	 <86802c440808250104i51d438eboe58dc1cc731b545e@mail.gmail.com>
	 <20080825164748.GB7249@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 9:47 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Yinghai Lu - Mon, Aug 25, 2008 at 01:04:34AM -0700]
> | On Mon, Aug 25, 2008 at 12:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
> | >
> | > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> | >
> | >> Signed-of-by: Yinghai Lu <yhlu.kernel@gmail.com>
> | >
> | > applied to tip/irq/sparseirq - thanks Yinghai.
> | >
> | > btw., why was this bit needed:
> | >
> | >> @@ -659,6 +575,7 @@ static int __init calibrate_APIC_clock(v
> | >>       delta = lapic_cal_t1 - lapic_cal_t2;
> | >>       apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
> | >>
> | >> +#ifdef CONFIG_X86_PM_TIMER
> | >>       /* Check, if the PM timer is available */
> | >>       deltapm = lapic_cal_pm2 - lapic_cal_pm1;
> | >>       apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
> | >> @@ -687,6 +604,7 @@ static int __init calibrate_APIC_clock(v
> | >>               }
> | >>               pm_referenced = 1;
> | >>       }
> | >> +#endif
> | >
> | > wouldnt this be a (small) fix for the pre-unification 32-bit side as
> | > well, which we should put into tip/x86/urgent as well?
> |
> | 64bit have those MACRO, it seems when CONFIG_EMBEDDED is set, could
> | reduce some size if pm is not selected.
> |
> | it seems not be urgent for 2.6.27.
> |
> | YH
> |
>
> Hey, APIC_DIVISOR is now wrong - it should be 16 for both modes

why?

calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;

> then, shouldn't it? :)

could make for 64 to use 16 too.

YH
