Return-Path: <linux-kernel-owner+w=401wt.eu-S965732AbXIJTZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965732AbXIJTZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965150AbXIJTZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:25:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:60799 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760792AbXIJTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=unV1Y/gH2LDZK1YY5YB0bMEyRHBVBtF4aRkNhQuzMFj8dQ0k/3+b7vwDijLmVn8tkZgf3CeBaiKOIR1h5evVsBWaveny5EbSv28+G0rtv5X8rkNmvl679zh2Ayo+WA3qEmgfceMcofRKtwCaW1MCU5jlMsv8tyDcLBm8VLgnlnk=
Message-ID: <46E5A680.9020706@gmail.com>
Date: Mon, 10 Sep 2007 22:18:08 +0200
From: Yan Burman <burman.yan@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Shem Multinymous <multinymous@gmail.com>,
       hdaps-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Hdaps-devel] [PATCH 2.6.23-rc2] hwmon: HP Mobile Data	Protection
 System 3D ACPI driver (resend)
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com> <20070827171107.GA15647@khazad-dum.debian.net> <46D5A742.8090201@gmail.com> <20070829233024.GA7433@khazad-dum.debian.net> <41840b750708291731w3fb5e673k3c1283e4a2fa82f0@mail.gmail.com> <46D6E5CD.4060807@gmail.com> <20070830164132.GA21023@khazad-dum.debian.net>
In-Reply-To: <20070830164132.GA21023@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 30 Aug 2007, Yan Burman wrote:
>   
>>>> You can generate events on input devices, but I am not sure that's the
>>>> best way to go about it for this.  Things that block on read until an
>>>> interrupt happens might work better.
>>>>         
>>> You can do the latter via another (4th) input device.
>>>
>>>       
>> What's wrong with the stuff I did in mdps? a misc character device that
>> acts like /dev/rtc. Why does it have to be input device oriented?
>>     
>
> I am fine with a char device that acts like /dev/rtc, but if we are doing
> something as heavyweight as a char device, I'd rather we go full generic
> netlink and send the various events over it.  We'd have a netlink device
> that sends everything over various "channels" and just one input device that
> does joystick emulation, then.
>
> Can we use a simple sysfs attribute that blocks the caller on write and
> returns immediately on read? If it has to be more complicated than that, I'd
> rather we go the netlink path. Any other ideas that are not a char device,
> not a netlink socket, not an input device node, and not a sysfs attribute?
>
>   
But, how are you going to make the sysfs attribute look generic so that 
application will not have to know whether to go
to /sys/.../mdps /sys/.../hdaps/ or /sys/.../whatever?

I'd probably prefer netlink, since this way it's something more generic 
and if some more functionality is added, you don't need to start
adding more sysfs attributes.

Sorry it took me a while to respond - I was too busy lately.

>> I also looked at what you did in the patches as well as the modified 
>> hdapsd. I'm doing the raw input device right now in the mdps, but I have a 
>> suggestion.
>>
>> It seems to me that right now there are at least 3 drivers that provide the 
>> same functionality - hdaps, ams and mdps. Why not create the input device
>> that exports raw accelerometer data with a name that is generic - something 
>> like accel/input or something along those lines. This way hdapsd could work
>> with any driver that provides the functionality without being hdaps 
>> specific.
>>     
>
> THAT is the idea, IMO.  But the naming is userspace's problem (thorugh
> udev), not ours :-)
>
> Or do you mean the "hardware port" part of the input device? If so, yes, we
> should try to make standard names for those as that makes it easier for
> userspace.
>
>   

