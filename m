Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbXGXQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbXGXQ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbXGXQ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:57:22 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42491 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760872AbXGXQ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:57:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=SLoTAfYsOEap3ue6BGhaHCKVFLxunteJ3zJSKg8snNc00PbZnOIWmhvf08L3ei/5OnP2fVHSgFK8iqsLewTBvZ4WapQ4dsV+nZgJq3ixKKxRBxgSXmuGsb2fy4v2vHgL;
Message-ID: <46A62F6A.8010403@simon.arlott.org.uk>
Date: Tue, 24 Jul 2007 17:57:14 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs/udev broken in 2.6.23-rc1 [input, i2c, ...] (Was: sysfs/udev
 broken in latest git?)
References: <46A59EAA.9030105@simon.arlott.org.uk>	 <20070724072540.GA835@suse.de>	 <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>	 <20070724084654.GB13152@suse.de>	 <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>	 <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>	 <46A628AC.3060900@simon.arlott.org.uk> <3ae72650707240934o68047677n97e6081ff3f42ce7@mail.gmail.com>
In-Reply-To: <3ae72650707240934o68047677n97e6081ff3f42ce7@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/07 17:34, Kay Sievers wrote:
> On 7/24/07, Simon Arlott <simon@fire.lp0.eu> wrote:
>> On 24/07/07 13:54, Cornelia Huck wrote:
>> > On Tue, 24 Jul 2007 11:20:02 +0200,
>> > "Kay Sievers" <kay.sievers@vrfy.org> wrote:
>> >
>> >> It looks fine to me. "device" links must never point to anything else
>> >> than a bus device.
>> >
>> > Hm, but then
>> > 1. The patch sneaks this check in (the old code only checked for
>> >    dev->parent)
>> > 2. The code is rather inconsistent now, since none of the other code
>> >    paths check for dev->parent->bus...
>>
>> Removing the dev->parent->bus check fixes it:
>>
>> [   40.043981] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [   40.044653] mice: PS/2 mouse device common for all mice
>> [   40.044792] dev->parent && !dev->parent->bus:
>> [   40.044794]  dev->kobj->k_name=event0
>> [   40.044796]  dev->kobj->name=event0
>> [   40.044798]  dev->parent->kobj->k_name=input0
>> [   40.044800]  dev->parent->kobj->name=input0
>>
>> [   40.044948] dev->parent && !dev->parent->bus:
>> [   40.044951]  dev->kobj->k_name=event1
>> [   40.044952]  dev->kobj->name=event1
>> [   40.044954]  dev->parent->kobj->k_name=input1
>> [   40.044956]  dev->parent->kobj->name=input1
>>
>> [   40.045075] dev->parent && !dev->parent->bus:
>> [   40.045077]  dev->kobj->k_name=event2
>> [   40.045079]  dev->kobj->name=event2
>> [   40.045080]  dev->parent->kobj->k_name=input2
>> [   40.045082]  dev->parent->kobj->name=input2
>>
>> [   40.067204] input: AT Translated Set 2 keyboard as /class/input/input3
>> [   40.067368] dev->parent && !dev->parent->bus:
>> [   40.067370]  dev->kobj->k_name=event3
>> [   40.067372]  dev->kobj->name=event3
>> [   40.067373]  dev->parent->kobj->k_name=input3
>> [   40.067375]  dev->parent->kobj->name=input3
>>
>> [   40.067713] i2c /dev entries driver
>> [   40.068190] dev->parent && !dev->parent->bus:
>> [   40.068193]  dev->kobj->k_name=i2c-0
>> [   40.068195]  dev->kobj->name=i2c-0
>> [   40.068196]  dev->parent->kobj->k_name=i2c-0
>> [   40.068198]  dev->parent->kobj->name=i2c-0
>>
>> [   40.068386] dev->parent && !dev->parent->bus:
>> [   40.068389]  dev->kobj->k_name=i2c-9191
>> [   40.068391]  dev->kobj->name=i2c-9191
>> [   40.068392]  dev->parent->kobj->k_name=platform
>> [   40.068394]  dev->parent->kobj->name=platform
>>
>> [   40.068892] dev->parent && !dev->parent->bus:
>> [   40.068895]  dev->kobj->k_name=i2c-1
>> [   40.068896]  dev->kobj->name=i2c-1
>> [   40.068898]  dev->parent->kobj->k_name=i2c-1
>> [   40.068899]  dev->parent->kobj->name=i2c-1
>>
>> [   40.085201] input: Logitech USB-PS/2 Optical Mouse as
>> /class/input/input4
>> [   40.085362] dev->parent && !dev->parent->bus:
>> [   40.085365]  dev->kobj->k_name=mouse0
>> [   40.085367]  dev->kobj->name=mouse0
>> [   40.085368]  dev->parent->kobj->k_name=input4
>> [   40.085370]  dev->parent->kobj->name=input4
>>
>> [   40.085528] dev->parent && !dev->parent->bus:
>> [   40.085530]  dev->kobj->k_name=event4
>> [   40.085532]  dev->kobj->name=event4
>> [   40.085534]  dev->parent->kobj->k_name=input4
>> [   40.085535]  dev->parent->kobj->name=input4
> 
> Strange.
> 
> What's the setting of CONFIG_SYSFS_DEPRECATED? Maybe there is
> something that needs to be fixed in the block patch where the code
> snippet is coming from.

It was =y, I changed it to =n and... it becomes worse:

[   40.697936] dev->parent && !dev->parent->bus:
[   40.697940]  dev->kobj->k_name=midiC1D0
[   40.697943]  dev->kobj->name=midiC1D0
[   40.697944]  dev->parent->kobj->k_name=card1
[   40.697946]  dev->parent->kobj->name=card1

[   40.698192] dev->parent && !dev->parent->bus:
[   40.698194]  dev->kobj->k_name=midi1
[   40.698196]  dev->kobj->name=midi1
[   40.698197]  dev->parent->kobj->k_name=card1
[   40.698199]  dev->parent->kobj->name=card1

[   40.698466] dev->parent && !dev->parent->bus:
[   40.698468]  dev->kobj->k_name=dmmidi1
[   40.698470]  dev->kobj->name=dmmidi1
[   40.698472]  dev->parent->kobj->k_name=card1
[   40.698473]  dev->parent->kobj->name=card1

[   40.698849] dev->parent && !dev->parent->bus:
[   40.698853]  dev->kobj->k_name=controlC1
[   40.698855]  dev->kobj->name=controlC1
[   40.698856]  dev->parent->kobj->k_name=card1
[   40.698858]  dev->parent->kobj->name=card1

[   40.699128] dev->parent && !dev->parent->bus:
[   40.699130]  dev->kobj->k_name=mixer1
[   40.699132]  dev->kobj->name=mixer1
[   40.699134]  dev->parent->kobj->k_name=card1
[   40.699135]  dev->parent->kobj->name=card1

[   41.210301] dev->parent && !dev->parent->bus:
[   41.210305]  dev->kobj->k_name=pcmC0D0p
[   41.210307]  dev->kobj->name=pcmC0D0p
[   41.210309]  dev->parent->kobj->k_name=card0
[   41.210311]  dev->parent->kobj->name=card0

[   41.210553] dev->parent && !dev->parent->bus:
[   41.210556]  dev->kobj->k_name=pcmC0D0c
[   41.210557]  dev->kobj->name=pcmC0D0c
[   41.210559]  dev->parent->kobj->k_name=card0
[   41.210561]  dev->parent->kobj->name=card0

[   41.210761] dev->parent && !dev->parent->bus:
[   41.210764]  dev->kobj->k_name=dsp
[   41.210765]  dev->kobj->name=dsp
[   41.210767]  dev->parent->kobj->k_name=card0
[   41.210768]  dev->parent->kobj->name=card0

[   41.210952] dev->parent && !dev->parent->bus:
[   41.210954]  dev->kobj->k_name=audio
[   41.210956]  dev->kobj->name=audio
[   41.210958]  dev->parent->kobj->k_name=card0
[   41.210959]  dev->parent->kobj->name=card0

[   41.211318] dev->parent && !dev->parent->bus:
[   41.211321]  dev->kobj->k_name=controlC0
[   41.211323]  dev->kobj->name=controlC0
[   41.211325]  dev->parent->kobj->k_name=card0
[   41.211327]  dev->parent->kobj->name=card0

[   41.211499] dev->parent && !dev->parent->bus:
[   41.211501]  dev->kobj->k_name=mixer
[   41.211503]  dev->kobj->name=mixer
[   41.211504]  dev->parent->kobj->k_name=card0
[   41.211506]  dev->parent->kobj->name=card0

[   41.239531] dev->parent && !dev->parent->bus:
[   41.239534]  dev->kobj->k_name=pcmC2D0c
[   41.239536]  dev->kobj->name=pcmC2D0c
[   41.239538]  dev->parent->kobj->k_name=card2
[   41.239539]  dev->parent->kobj->name=card2

[   41.239706] dev->parent && !dev->parent->bus:
[   41.239709]  dev->kobj->k_name=dsp2
[   41.239710]  dev->kobj->name=dsp2
[   41.239712]  dev->parent->kobj->k_name=card2
[   41.239714]  dev->parent->kobj->name=card2

[   41.239843] dev->parent && !dev->parent->bus:
[   41.239845]  dev->kobj->k_name=audio2
[   41.239847]  dev->kobj->name=audio2
[   41.239849]  dev->parent->kobj->k_name=card2
[   41.239850]  dev->parent->kobj->name=card2

[   41.240013] dev->parent && !dev->parent->bus:
[   41.240015]  dev->kobj->k_name=controlC2
[   41.240017]  dev->kobj->name=controlC2
[   41.240018]  dev->parent->kobj->k_name=card2
[   41.240020]  dev->parent->kobj->name=card2

[   41.240230] dev->parent && !dev->parent->bus:
[   41.240233]  dev->kobj->k_name=mixer2
[   41.240234]  dev->kobj->name=mixer2
[   41.240236]  dev->parent->kobj->k_name=card2
[   41.240238]  dev->parent->kobj->name=card2

Those definitely didn't trigger the same condition before, 
so that's weird too.

-- 
Simon Arlott
