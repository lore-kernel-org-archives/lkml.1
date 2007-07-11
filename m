Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbXGKLWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbXGKLWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbXGKLWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:22:43 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:12243 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXGKLWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DlVasBYO6cc+KGD9wlNA8OjMhNQ1PD5EU0uvvFmydBHxeMu00nDeGE0g48tAXG2MfqvjK8eMPpz5ZoLbN4Uz4HdhzYHoQbDrVW1tg5YfppV+Kll3JRZUGwOXVBzI32r8HTzwF4kvL4WDhLIBSzQskmIFJ19dfIye5JsRoW/QE70=
Message-ID: <ca35ce500707110422j73c5c256i384327c652b7ccba@mail.gmail.com>
Date: Wed, 11 Jul 2007 13:22:39 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ca35ce500707100332n35661e6al22edded892fbf427@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <200707101057.57538.duncan.sands@math.u-psud.fr>
	 <ca35ce500707100213n10b08cc1y8b09957cd3a655d4@mail.gmail.com>
	 <200707101132.50815.duncan.sands@math.u-psud.fr>
	 <ca35ce500707100332n35661e6al22edded892fbf427@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/10, mikie <mikie.pl@gmail.com>:
> 2007/7/10, Duncan Sands <duncan.sands@math.u-psud.fr>:
> > On Tuesday 10 July 2007 11:13:09 mikie wrote:
> > > 2007/7/10, Duncan Sands <duncan.sands@math.u-psud.fr>:
> > > > > I also tried a couple of other firmwares available on the net, and
> > > > > also the one from Windows XP install (which works and achieves speeds
> > > > > of up to 720kbyte/sec downlink). Some of the firmwares did not work
> > > > > either, and some worked the same way - it means not more than 3mbit/s
> > > > > (around 400kbyte/s) could be achieved.
> > > >
> > > > I'm pretty sure you won't get anything faster out of a revision 2 modem.
> > >
> > > Too bad to hear that :/
> > > Especially that windows does this with the same modem without a hitch.
> >
> > Really?  In that case I take it back, the hardware can clearly do it :)  Presumably
> > you are using the firmware that came with windows?  Which kernel version?  Also, what
> > synchronization speed is reported?
>
> Yes, the hardware in the modem can do it for sure. I have a laptop
> with a pentium4 CPU, USB2.0, windows XP installed. I attach the same
> modem to this laptop and I can go up to 730..740 kbyte/s (the same
> phone line of course). Windows XP had to be modified with a registry
> tweak (from thomson website) to switch to isochronous mode and it
> works.
>
> However my server running linux is on a ECS motherboard (P6BAP as I
> remember), Celeron 633 CPU, USB1.1. I have compiled quite fresh kernel
> 2.6.21.5
>
> I am 100% sure that I use the same firmware for the modem, because I
> copied it directly from windows XP from laptop.
> Now since the modem itself can go as fast as 6mbit/s, I am only
> concerned if the _computer_ hardware on my linux server box can do it
> via USB ? I can see the usb reporting it to be at 12Mbit/s, which
> should be enough to reach 6mbit/s teoretically. CPU load is normal
> even during transfers.
> I would have to install windows xp on that machine to be 100% sure
> that both modem and computer hardware can go up to 6mbit/s via USB...
>
> By the way, I just tried to switch sw_buffering in the speedtch module
> but that did not help.

I begin to think that the isochronous mode is not working. I tried the
speedtch module with disabled and enabled isoc and there is no
difference in transfer speeds at all.

All I checked was :
root@srv:~# cat /sys/module/speedtch/parameters/enable_isoc
Y

which as I now believe only means what options have been specified,
but does not confirm the actual mode being in use.
Especially that I do not see anything like "isoc support enabled" in
any of the logs.

Are there any requirements for UHCI hardware to support isoc mode  ?
Mine is:
USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 08) (prog-if 00 [UHCI])

Or maybe I am missing something else? I am sure the isoc mode is
supported by my modem, now I only have doubts if my hardware on server
box supports this ?

-- 
Regards,
MK
