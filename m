Return-Path: <linux-kernel-owner+w=401wt.eu-S1764701AbXGKQz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764701AbXGKQz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXGKQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:55:21 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:1225 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXGKQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aHZWJZhjYJCH2grlT51lPfVVmUqgftSUFGNiN5LvRv+XSXDrCHbYz+FO5+bSqzSi9DVwgfu2wwWiL8d6HIT+cqvnPOzgbddSAVWReuaHWffcxSa1BMqb9Sl7viEmaWltpLQjktG18P5rDm/+KYRU1rBodpo6Q14vcSLmkqUVzFY=
Message-ID: <ca35ce500707110955t44d9b998r769c02df3e29e00a@mail.gmail.com>
Date: Wed, 11 Jul 2007 18:55:19 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707111507.11656.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <200707111433.33156.duncan.sands@math.u-psud.fr>
	 <ca35ce500707110547h1eb9ad68i1f2fe74f46981366@mail.gmail.com>
	 <200707111507.11656.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/11, Duncan Sands <duncan.sands@math.u-psud.fr>:
> Hi,
>
> > Actually I had to mount it (I  hope that not having it mounted does
> > not change a lot in this matter).
>
> probably not.  Not having sysfs mounted can cause hotplug to fail,
> but I think not having /proc/bus/usb mounted shouldn't cause any
> trouble nowadays.
>
> > I:* If#= 1 Alt= 3 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
> > E:  Ad=06(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> > E:  Ad=07(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> > E:  Ad=87(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
>
> The * means that this altsetting is being used - this is the altsetting
> when using isochronous mode.  So it looks to me like isochronous mode is
> being used.
>
> > I have CONFIG_USB_DEBUG=y set in kernel. However I do not see any of
> > the messages you are referring to. It does not say that it tried isoc
> > and falls to bulk, nothing like that. Also nothing about "setting
> > interface to ?? failed".
>
> Most likely it is using isochronous transfer.  The question then is: why
> is it slow?  I will look in my cupboard to see if I have the same modem,
> and if so see what speed I can get out of it.
>
> > Which debug option should I switch to see these?
>
> Something like this IIRC:
>         echo 7 > /proc/sys/kernel/printk
> Then it should turn up in dmesg.
>

I made a more advanced testing. I used one computer only to be
absolutely sure that this is not a hardware issue. So I took a laptop
(P4 1.8GHz, OHCI usb host), and booted into Knoppix LiveCD. It was
running kernel 2.6.19 and the version of speedtch module was 1.10.
First I did something like rmmod speedtch; rmmod ohci-hcd to be sure
that I start with a fresh environment.
I also did: echo 7 > /proc/sys/kernel/printk which caused the usual
debug messages being printed directly in the console.
Then I did modprobe ohci-hcd;modprobe speedtch enable_isoc=1

Certainly I've put the same firmware in the /lib/firmware so that udev
found it correctly and loaded it up to the modem. The ADSL link went
up with the same values (7456 downlink). PPPd started (I use
pppoatm.so, if that is important). In this setup I achieved transfer
rates of around 480...500 kbyte/s. Then I did the similar thing, but
speedtch without enable_isoc, and the result was exactly the same.
In both cases I still could not see the messages from the speedtch
driver about enabling isochronous mode, or falling back to bulk,
nothing like that.

Right after that, to minimize the risk of any outside network being
overloaded (I doubt that anyway), I switched to Windows Xp. Transfers
were up to 730 kbyte/s. So this proves definitely that it is not a
hardware related issue.
The transfers were so fast that the LED (marked usb led) on the modem,
which usually blinks where any transfers are in process, it went
completely off, and only blinked once a few seconds...

So there is a small progress when compared to my server box (celeron
633 to remind you), where I can get only 400kbyte/s (on this laptop it
went 100kbyte/s faster).

I still cannot get the full 6mbit/s that my ADSL service runs at on
the linux system.

-- 
Regards,
MK
