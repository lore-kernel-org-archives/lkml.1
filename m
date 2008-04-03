Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYDCF0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYDCF0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYDCF0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:26:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:20622 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYDCF0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dzuspLpyBc9U3bHRuKzaLAZvjdsiI9GqYse1omPQq7ohldH3SyS6YtOsHgz7XcMbfILuZQoO174RVP0adk4AlNVwgKy38LI9eVW3O5lBldtFZoDmk5qV+LYKSuKtJ+ViF6/07TqIk8Z6kOp6OL7S82E5vmicCj8/M2NE/pTX7aE=
Message-ID: <47F46A74.504@gmail.com>
Date: Thu, 03 Apr 2008 14:26:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804021909.41609.volker.armin.hemmann@tu-clausthal.de> <47F43766.2070207@gmail.com> <200804030704.21480.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200804030704.21480.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Volker.

Volker Armin Hemmann wrote:
>>> In short, no changes at all.
>> Thanks for confirming.
>>
>> Peer, Kuan.  Volker is reporting detection problems on MCP65 AHCI.
>> The followings are what we've discovered till now.
>>
>> 1. When the controller is put into non-raid mode in BIOS
>>
>>   * If softreset is used, either the softreset itself or IDENTIFY
>>     following it times out once.  On retrial, it works fine.  It
>>     doesn't matter whether the SRST is issued by itself or as
>>     follow-up-srst after hardreset.  Using only hardreset works fine.
>>
>>   * The controller doesn't indicate MSI capability and MSI isn't used
>>     by default.
>>
>> 2. When the controller is put into ahci mode in BIOS
>>
>>   * SRST works fine.
>>
>>   * The controller indicates MSI capability but MSI doesn't work
>>     properly resulting in IRQ delivery failure.  Adding
>>     intx_disable_bug quirk doesn't help.
>>
>> I've performed similar test on MCP67 and everything worked fine on it.
>>
>> Both problems (SRST and MSI) can be worked around but I need more
>> information to work around those.
>>
>> * Which chips are affected?  Are there proper fixes?
>>
>> * For the MSI problem, is it system wide problem or local to the ahci
>>   controller?
> 
> 
> I rebooted with non-raid set, without pci=nomsi
> 
> this is cat /proc/interrupts:
>           CPU0       CPU1
>   0:         57          1   IO-APIC-edge      timer
>   1:          0         81   IO-APIC-edge      i8042
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          1   IO-APIC-fasteoi   acpi
>  12:          0          3   IO-APIC-edge      i8042
>  17:          2       2868   IO-APIC-fasteoi   nvidia
>  18:          0          0   IO-APIC-fasteoi   EMU10K1
>  22:          4        745   IO-APIC-fasteoi   ehci_hcd:usb1
> 314:          0        158   PCI-MSI-edge      eth0
> 315:          7      12769   PCI-MSI-edge      ahci
> 
> as you can see, only the sata controller and the network uses msi.
> 
> And networking works - or I wouldn't be able to send you this mail.

I guess the ahci controller works too.  This is getting confusing, so 
MSI doesn't work iff the controller is configured as ahci in BIOS?

> I will reboot from systemresucecd later today and post some results with 
> ahci-mode set, no nomsi. Just can't try patches that way.

Is sytemrescuecd using the same kernel?  Otherwise, it will only add 
more to the confusion.

-- 
tejun
