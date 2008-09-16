Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYIPRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYIPRTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYIPRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:19:09 -0400
Received: from gw.goop.org ([64.81.55.164]:58521 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYIPRTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:19:09 -0400
Message-ID: <48CFEA8C.3020703@goop.org>
Date: Tue, 16 Sep 2008 10:19:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: PARAVIRT_GUEST bug? [was: Stable regression: usb-storage is stuck
 in 2.6.26.5]
References: <20080913122143.4B13B908E@gandalf.tls.msk.ru> <48CBB626.4050300@msgid.tls.msk.ru> <48CF6A45.3010204@msgid.tls.msk.ru>
In-Reply-To: <48CF6A45.3010204@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Michael Tokarev wrote:
>
> [usb-storage hangs on asus M2NPV-VM (nVidia GeForce 6150/nForce 430)
>  motherboard with latest bios]
>
>> Ok, it turned out to be pretty.. interesting.
>>
>> It's not a regression within -stable kernel series.  The problem
>> happens when BOTH are true:
>>
>>   - using latest BIOS for this mobo (1401), AND
>>   - enabling KVM_GUEST in kernel.
>>
>> The only difference in my kernel config between .1 and .5 was
>> to enable KVM_GUEST and KVM_CLOCK, and also I2C_HELPER_AUTO
>> which was added by kernel update.
>>
>> Going with previous BIOS (1201) OR disabling PARAVIRT_GUEST
>> fixes the problem.  I'll try to figure out which config
>> option is at problem here.
>
> After seeing similar situation on another motherboard, I
> become curious.
>
> Here's the result:  M3A78-EM motherboard (also from Asus),
> AMD780G/SB700 etc.  Updating to one of the latest bios
> makes the system unbootable.  Kernel hangs on boot right
> after displaying
>
>  SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
>
> Reverting to the older BIOS or disabling PARAVIRT_GUEST in kernel
> fixes this (turning off KVM_GUEST isn't enough), and kernel happily
> boots further, with next line being
>
>  hpet clockevent registered
>  ...
>
> Reportedly, another Asus motherboard (M2N-SLI DELUXE) also hangs
> with new BIOS and KVM_GUEST optimizations turned on, but not on
> older BIOS.
>
> So it's quite.. funny.  At least SOME latest BIOSes from Asustec,
> together with PARAVIRT_GUEST, -- a problem.  Don't do either of
> those, and it's all ok.
>
> The question is if Asus introduced the same bug in quite.. some
> of their recent BIOSes, or PARAVIRT_GUEST code is somehow buggy
> and the bug is exposed by new BIOS code.
>
> Any hints on this? ;)

PARAVIRT_GUEST doesn't enable anything by itself; it just makes other
config options appear.  What other config options are you enabling?

That is, what's the diff between a working and a non-working .config?

    J
