Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbXH3OvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbXH3OvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXH3OvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:51:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:48384 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996AbXH3Ou7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qjkmzcMlYXZ1hpaZAzJOPO/7fIJQDSFSbdKMewdFroYZYlwKLxgWQytvcNuNhtxUdsiE7bHQttR20yGMgnYJ0pO3JsPLceAUkSle48WhKlmi2XK0UGUb3YRKJkn5GKAttfR1lyUiebaB64JTzpXVBD0ReNe09Oa4Lhj0lBfF1MI=
Message-ID: <46D6E5CD.4060807@gmail.com>
Date: Thu, 30 Aug 2007 17:44:13 +0200
From: Yan Burman <burman.yan@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Shem Multinymous <multinymous@gmail.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       hdaps-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data Protection
 System 3D ACPI driver (resend)
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz>	 <46D01420.3070400@gmail.com>	 <20070827171107.GA15647@khazad-dum.debian.net>	 <46D5A742.8090201@gmail.com>	 <20070829233024.GA7433@khazad-dum.debian.net> <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com>
In-Reply-To: <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shem Multinymous wrote:
> On 8/29/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
>   
>> On Wed, 29 Aug 2007, Yan Burman wrote:
>>     
>
>   
>> HDAPS with input device support is quite new.  hdapsd was patched to talk to
>> it, too.  I suppose we should port the input device support to the driver
>> in-tree just so that we get it in tree as well.  Sounds like an useful
>> reason to bother with in-tree hdaps.  Not that it will save much power with
>> the in-tree driver, but at least it will be widely available from there.
>>     
>
> In case they'll be of help for such porting, the relevant hdaps
> patches from my tp_smapi patch series are attached.
>
>
>   
>>> I agree that the sys interface is probably not the best choice, but the
>>> accelerometer data should provide not only position, but also generate
>>> an event when it detects
>>> that it's falling. From what I understood hdaps does not have that info,
>>>       
>> You can generate events on input devices, but I am not sure that's the best
>> way to go about it for this.  Things that block on read until an interrupt
>> happens might work better.
>>     
>
> You can do the latter via another (4th) input device.
>
>
>   
What's wrong with the stuff I did in mdps? a misc character device that 
acts like /dev/rtc. Why does it have to be input device oriented?
>> I'd suggest an accelerometer sysfs interface, that we implement in hdaps
>> (in and out-of-tree), ams and hpmdp.  One input device for joystick
>> emulation (optional), one input device with accelerometer data in mg or ug,
>>     
>
> Is any of the accelerometer drivers currently capable of computing the
> physical acceleration? Also, is there an issue of linear vs. angular
> acceleration?
>
>
>   
>> and an optional one with the raw accelerometer data.
>>     
>
> Before or after axis inversion/swapping? The tp_smapi hdaps driver
> (losslessly) inverts the raw data too, to avoid duplication of
> model-specific orientation logic.
>
>
>   
>> unless someone wants to implement their own free-fall algorithms instead of
>> using whatever is in the firmware).
>>     
>
> The term "free-fall" is dangerously misleading, for the reasons
> explained in the IBM APS whitepaper.
>
>   Shem
>   

I also looked at what you did in the patches as well as the modified 
hdapsd. I'm doing the raw input device right now in the mdps, but I have 
a suggestion.
It seems to me that right now there are at least 3 drivers that provide 
the same functionality - hdaps, ams and mdps. Why not create the input 
device
that exports raw accelerometer data with a name that is generic - 
something like accel/input or something along those lines. This way 
hdapsd could work
with any driver that provides the functionality without being hdaps 
specific.

Yan
