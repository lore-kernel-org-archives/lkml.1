Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXH2QMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXH2QMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXH2QL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:11:56 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:51967 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbXH2QLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mhOyru9oNpyKF/6Afa5D8UJ6rgOgDKX5dFHUs+LQS1YsEFxKC3lxtiavO9KU+/o2tdKu6MIjcZsO/t98hga/T7Baz6TC1rnvBN3WYpJKDwsj23OoZO2W+s3ZG1PvAcmhRLr14+/VT3rUh3dRfLC15OEzhrSmI5Eb1bRl595o5s0=
Message-ID: <46D5A742.8090201@gmail.com>
Date: Wed, 29 Aug 2007 19:05:06 +0200
From: Yan Burman <burman.yan@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       hdaps-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.23-rc2]  hwmon: HP Mobile Data Protection System 3D
 ACPI driver (resend)
References: <1186831562.6452.10.camel@localhost> <20070825102512.GA5850@ucw.cz> <46D01420.3070400@gmail.com> <20070827171107.GA15647@khazad-dum.debian.net>
In-Reply-To: <20070827171107.GA15647@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Sat, 25 Aug 2007, Yan Burman wrote:
>   
>>> Aha, /sys. Could we simply power off the device when its input device
>>> is not opened?
>>>   
>>>       
>> No, we can't since the sys interface provides the position info and some 
>> applications (hdaps apps for example) use this interface.
>>     
>
> Power it off when not used for some time.  Power on when opened.  -EBUSY
> while powering on and before it stablizes, if you don't want to get anything
> userland stuck in D state.  This much work might not make sense if your
> accelerometer doesn't waste resources when enabled.
>
> Heck, try to get rid of that position sysfs crap if you can! It was a bad
> design idea for hdaps to come up with, there is no reason to let it leak to
> other drivers.
>
> Input devices are the way to go for this, a joystick-emulation input device
> (for games and toys), plus a input device that outputs accelerometer data in
> micro (or mili?) gravities (generic stuff that works with all accelerometers
> should use this one) and a raw accelerometer data input device (for higly
> specific signal processing apps) when possible.
>
>   
I don't mind doing it this way, it's just that from what I saw all 
current applications use the sys interface, so I figured that people
would like to be able to use those.
> HDAPS (the one that matters, which ships in tp_smapi) lacks the g-normalized
> device, though, but it would be a proper generic accelerometer interface.
> The in-tree hdaps driver is basically ignored.  So some other accelerometer
>   
This is not the impression that I got - I got quite a few responses from 
people that were using my driver with the hdaps applications that use sys.
I just saw gentoo have a package for it and they are using the sys 
version for the most important feature of this device: HD protection. I 
got hdapsd to work a while
back, so if in-tree hdaps did not change the interface, it should still 
work with mdps as well.
Debian/Ubuntu also have some stuff for hdaps in their repositories. So 
it seems to me that people are using the sys interface.
> driver gets the dibs on how to implement those interfaces in a proper
> generic way.  Want to be the one? Please?  We in hdaps-devel can certainly
> help with ideas and fix out-of-tree hdaps to also implement the interface.
>
>   
I agree that the sys interface is probably not the best choice, but the 
accelerometer data should provide not only position, but also generate 
an event when it detects
that it's falling. From what I understood hdaps does not have that info, 
but mdps and ams do. I am open to suggestions regarding the proper 
interface assuming it exposes the free-fall events as well,
since if you can get an interrupt from the device it's a hell lot better 
than polling it and doing some heuristics to detect that it's falling. 
This is especially true for mdps, since each read is rather expensive
CPU-wise. I will think about the interface more when I get some more 
free time.

