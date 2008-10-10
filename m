Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYJJLOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYJJLOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYJJLOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:14:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:27217 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYJJLOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ROwtrNjGBM1zCoql+ZlToCBEctVNqGlZd6jtjVJ2S1iZfiT5Z/BZWYReVIWDUoIAfn
         skJbFwFqQcCrkHsYcmXdyCbPxA7GA7Fx7kShgW5wCe56SlJ03O6RpPFl0AY/jPO2Piuy
         JIoJUf8m7p+1iBtctDgREY/Fom1LwLtOtVL/w=
Message-ID: <aa79d98a0810100414q21d5a7c6k35d516d6f33bd3f1@mail.gmail.com>
Date: Fri, 10 Oct 2008 15:14:05 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010090100.GC319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010002203.GA23238@linux-os.sc.intel.com>
	 <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com>
	 <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
	 <20081010090100.GC319@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 1:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Ah, it was CONFG who is guilty :) This is true indeed, thanks!
>
> yeah.
>
>> But here is not the same
>>
>>        apic_write(APIC_TDCR,
>>                (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
>> -               APIC_TDR_DIV_16);
>> +               APIC_TDR_DIV);
>>
>> On x86_64 it will be 1 now but we've used 16 for a long time in
>> purpose to slowdown processor's bus CLKs from APIC point of view. So I
>> don't think it's good idea to change it now. If we start using divisor
>> 1 today -- it would work for some time 'till processor bus raised to
>> the some speed when we'll get counter underflow before calibration
>> finished.
>>
>> So could you please split the patch into two:
>> 1) Plain CONFG typo fix (which is completely Ack'ed)
>> 2) APIC divisor patch (which I'm not sure if we've to touch)
>
> okay, since we typoed that CONFG thing (sidenote: we really need a
> .config flag that will start a grep that fails the build if there's a
> non-existent CONFIG option anywhere in the tree), we basically tested
> the divisor of 16 on a wide range of boxes.
>
> So .. how about just standardizing on the divisor of 16 on both 32-bit
> and 64-bit?
>
>        Ingo
>

I think the best approach would be to use divisor 16 and initial counter value
set to 0xFFFFFFFF while doing APIC timer calibration cycle (iirc there was a
SMI related patch at August had been doing such a thing -- can't remember
the LKML ref to it). Or you meant something different?
