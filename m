Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbXGKMd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbXGKMd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbXGKMdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:33:49 -0400
Received: from matups.math.u-psud.fr ([129.175.50.4]:55591 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXGKMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:33:48 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Wed, 11 Jul 2007 14:33:32 +0200
User-Agent: KMail/1.9.7
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <ca35ce500707100332n35661e6al22edded892fbf427@mail.gmail.com> <ca35ce500707110422j73c5c256i384327c652b7ccba@mail.gmail.com>
In-Reply-To: <ca35ce500707110422j73c5c256i384327c652b7ccba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111433.33156.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikie,

> I begin to think that the isochronous mode is not working. I tried the
> speedtch module with disabled and enabled isoc and there is no
> difference in transfer speeds at all.
> 
> All I checked was :
> root@srv:~# cat /sys/module/speedtch/parameters/enable_isoc
> Y
> 
> which as I now believe only means what options have been specified,
> but does not confirm the actual mode being in use.
> Especially that I do not see anything like "isoc support enabled" in
> any of the logs.
> 
> Are there any requirements for UHCI hardware to support isoc mode  ?
> Mine is:
> USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 08) (prog-if 00 [UHCI])
> 
> Or maybe I am missing something else? I am sure the isoc mode is
> supported by my modem, now I only have doubts if my hardware on server
> box supports this ?

can you please send the part of /proc/bus/usb/devices concerning the
modem, while the modem is plugged in and (supposedly) using isoc mode.
If /proc/bus/usb isn't mounted, you can mount it like this IIRC:
	mount -t usbfs usbfs /proc/bus/usb/
Also, looking in the driver I see that if isoc mode is disabled you
should see one of the following messages:
	- setting interface to ?? failed (??)!
	- isochronous transfer not supported - using bulk
The first one may be a debug message, so you will not necessarily see
it depend on which level of kernel debug messages you have turned on.
(I have made some changes in my tree so that if you asked for isoc
transfer but get bulk then a message is printed).

Ciao,

Duncan.
