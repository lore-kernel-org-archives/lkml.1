Return-Path: <linux-kernel-owner+w=401wt.eu-S1764615AbXGKMr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764615AbXGKMr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762866AbXGKMrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:47:18 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:18863 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762499AbXGKMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DyTfVi7I0jYZfI19f7feNx/4nHA2DX8iUTQb+plBPgZAqUKkTO+0YGEMhWMh626Uq624BJO8/OzHoW3sZNteImoj1dNzeTVe+BXLCoiKrekTIPoJ/y0OThnJuDDxYO8an7Vez02ZC5qd05F9GP/p1n85SzI8W4hQuBYdlUErfA0=
Message-ID: <ca35ce500707110547h1eb9ad68i1f2fe74f46981366@mail.gmail.com>
Date: Wed, 11 Jul 2007 14:47:15 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707111433.33156.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <ca35ce500707100332n35661e6al22edded892fbf427@mail.gmail.com>
	 <ca35ce500707110422j73c5c256i384327c652b7ccba@mail.gmail.com>
	 <200707111433.33156.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/11, Duncan Sands <duncan.sands@math.u-psud.fr>:
> Hi Mikie,
>
> > I begin to think that the isochronous mode is not working. I tried the
> > speedtch module with disabled and enabled isoc and there is no
> > difference in transfer speeds at all.
> >
> > All I checked was :
> > root@srv:~# cat /sys/module/speedtch/parameters/enable_isoc
> > Y
> >
> > which as I now believe only means what options have been specified,
> > but does not confirm the actual mode being in use.
> > Especially that I do not see anything like "isoc support enabled" in
> > any of the logs.
> >
> > Are there any requirements for UHCI hardware to support isoc mode  ?
> > Mine is:
> > USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> > Controller (rev 08) (prog-if 00 [UHCI])
> >
> > Or maybe I am missing something else? I am sure the isoc mode is
> > supported by my modem, now I only have doubts if my hardware on server
> > box supports this ?
>
> can you please send the part of /proc/bus/usb/devices concerning the
> modem, while the modem is plugged in and (supposedly) using isoc mode.
> If /proc/bus/usb isn't mounted, you can mount it like this IIRC:
>         mount -t usbfs usbfs /proc/bus/usb/

Actually I had to mount it (I  hope that not having it mounted does
not change a lot in this matter). Here is the cat of "devices"  from
/proc/bus/usb

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=ff(vend.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=06b9 ProdID=4061 Rev= 2.00
S:  Manufacturer=ALCATEL
S:  Product=Speed Touch 330
S:  SerialNumber=0090D0AA28CD
C:* #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=50ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
I:  If#= 1 Alt= 1 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
E:  Ad=06(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:  If#= 1 Alt= 2 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
E:  Ad=06(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=87(I) Atr=01(Isoc) MxPS= 640 Ivl=1ms
I:* If#= 1 Alt= 3 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
E:  Ad=06(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=87(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
E:  Ad=05(O) Atr=02(Bulk) MxPS=   8 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=   8 Ivl=0ms


> Also, looking in the driver I see that if isoc mode is disabled you
> should see one of the following messages:
>         - setting interface to ?? failed (??)!
>         - isochronous transfer not supported - using bulk
> The first one may be a debug message, so you will not necessarily see
> it depend on which level of kernel debug messages you have turned on.
> (I have made some changes in my tree so that if you asked for isoc
> transfer but get bulk then a message is printed).

I have CONFIG_USB_DEBUG=y set in kernel. However I do not see any of
the messages you are referring to. It does not say that it tried isoc
and falls to bulk, nothing like that. Also nothing about "setting
interface to ?? failed". Which debug option should I switch to see
these?

-- 
Regards,
MK
