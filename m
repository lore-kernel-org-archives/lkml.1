Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYHYIEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYHYIEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 04:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYHYIEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 04:04:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:31323 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYHYIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 04:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T+eytf8x1g+CUl7ts5V7EtQ9u0IIyqV2Lgkmk69GnMg/Fq+PGZoZEndzuInJntW0L/
         NROMFfnNSPtJTuUFvVaqqxyAPraoTPlXcW/KBreZ1ouU2BzMngpDPrlI2ffIWhJo3mu/
         0RW6SJ2I2hwXznkzVZePsYH8Hydp1V/SS00D8=
Message-ID: <86802c440808250104i51d438eboe58dc1cc731b545e@mail.gmail.com>
Date: Mon, 25 Aug 2008 01:04:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: let 64 bit to use 32 bit calibrate_apic_clock
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080825074704.GA20698@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219642886-22030-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080825074704.GA20698@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 12:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> Signed-of-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> applied to tip/irq/sparseirq - thanks Yinghai.
>
> btw., why was this bit needed:
>
>> @@ -659,6 +575,7 @@ static int __init calibrate_APIC_clock(v
>>       delta = lapic_cal_t1 - lapic_cal_t2;
>>       apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
>>
>> +#ifdef CONFIG_X86_PM_TIMER
>>       /* Check, if the PM timer is available */
>>       deltapm = lapic_cal_pm2 - lapic_cal_pm1;
>>       apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
>> @@ -687,6 +604,7 @@ static int __init calibrate_APIC_clock(v
>>               }
>>               pm_referenced = 1;
>>       }
>> +#endif
>
> wouldnt this be a (small) fix for the pre-unification 32-bit side as
> well, which we should put into tip/x86/urgent as well?

64bit have those MACRO, it seems when CONFIG_EMBEDDED is set, could
reduce some size if pm is not selected.

it seems not be urgent for 2.6.27.

YH
