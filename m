Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYIWRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYIWRyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYIWRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:54:15 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:20865 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYIWRyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:54:14 -0400
Message-ID: <48D92D43.2070705@msgid.tls.msk.ru>
Date: Tue, 23 Sep 2008 21:54:11 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: PARAVIRT_GUEST bug? [was: Stable regression: usb-storage is stuck
 in 2.6.26.5]
References: <20080913122143.4B13B908E@gandalf.tls.msk.ru> <48CBB626.4050300@msgid.tls.msk.ru> <48CF6A45.3010204@msgid.tls.msk.ru> <48D22847.5020100@msgid.tls.msk.ru> <48D2AB8E.90305@goop.org>
In-Reply-To: <48D2AB8E.90305@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Michael Tokarev wrote:
>> Michael Tokarev wrote:
>>   
>>> Michael Tokarev wrote:
>>>
>>> [usb-storage hangs on asus M2NPV-VM (nVidia GeForce 6150/nForce 430)
>>>  motherboard with latest bios]
>>>
>>>     
>>>> Ok, it turned out to be pretty.. interesting.
>>>>
>>>> It's not a regression within -stable kernel series.  The problem
>>>> happens when BOTH are true:
>>>>
>>>>   - using latest BIOS for this mobo (1401), AND
>>>>   - enabling KVM_GUEST in kernel.
>>>>
>>>> The only difference in my kernel config between .1 and .5 was
>>>> to enable KVM_GUEST and KVM_CLOCK, and also I2C_HELPER_AUTO
>>>> which was added by kernel update.
>>>>
>>>> Going with previous BIOS (1201) OR disabling PARAVIRT_GUEST
>>>> fixes the problem.  I'll try to figure out which config
>>>> option is at problem here.
>>>>       
>>> After seeing similar situation on another motherboard, I
>>> become curious.
>>>
>>> Here's the result:  M3A78-EM motherboard (also from Asus),
>>> AMD780G/SB700 etc.  Updating to one of the latest bios
>>> makes the system unbootable.  Kernel hangs on boot right
>>> after displaying
>>>
>>>  SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
>>>
>>> Reverting to the older BIOS or disabling PARAVIRT_GUEST in kernel
>>>     
>> PARAVIRT it is, not PARAVIRT_GUEST.
>>   
> 
> Hm, mysterious.  CONFIG_PARAVIRT should have no functional effect on a
> native boot.
> 
> Could you post the complete dmesg output (with "initcall_debug" on the
> kernel command line), with both CONFIG_PARAVIRT on and off, and ideally,
> comparing working vs non-working BIOS?

It turned out to be more difficult than I thought.  There were other
problems with the motherboard I experimented with (my new home machine),
unrelated.  Also, it wasn't possible to re-flash bios back as it said
that the old version is incompatible with currently running bios so it
can't re-flash it.

Also, initcall_debug does not make any difference for my mobo.  All the
debugging shown by this option are AFTER the place where it hangs.
And for netconsole I'd need another machine at home, which I don't
have currently.

Instead, while debugging other issues, I tried 2.6.27-rc7 kernel -- this
one works on 2 motherboards with new BIOSes, no matter which PARAVIRT
options I turn on.  I'll try this kernel on other mobos where possible,
and if no issue will be found, I'd declare the issue to be solved.

If not, I'll try to find some time to debug it later.  After all, this
very issue is already worked around -- I enabled those options in order
to add (optimized) support for KVM guests, but for those I just built
another kernel flavour with only that config change.

Oh well.

And thank you for your support!

/mjt
