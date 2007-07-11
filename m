Return-Path: <linux-kernel-owner+w=401wt.eu-S1764764AbXGKNHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764764AbXGKNHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbXGKNHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:07:22 -0400
Received: from mathups.math.u-psud.fr ([129.175.52.4]:56120 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757558AbXGKNHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:07:20 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Wed, 11 Jul 2007 15:07:11 +0200
User-Agent: KMail/1.9.7
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <200707111433.33156.duncan.sands@math.u-psud.fr> <ca35ce500707110547h1eb9ad68i1f2fe74f46981366@mail.gmail.com>
In-Reply-To: <ca35ce500707110547h1eb9ad68i1f2fe74f46981366@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111507.11656.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Actually I had to mount it (I  hope that not having it mounted does
> not change a lot in this matter).

probably not.  Not having sysfs mounted can cause hotplug to fail,
but I think not having /proc/bus/usb mounted shouldn't cause any
trouble nowadays.

> I:* If#= 1 Alt= 3 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=speedtch
> E:  Ad=06(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=07(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=87(I) Atr=01(Isoc) MxPS= 960 Ivl=1ms

The * means that this altsetting is being used - this is the altsetting
when using isochronous mode.  So it looks to me like isochronous mode is
being used.

> I have CONFIG_USB_DEBUG=y set in kernel. However I do not see any of
> the messages you are referring to. It does not say that it tried isoc 
> and falls to bulk, nothing like that. Also nothing about "setting 
> interface to ?? failed".

Most likely it is using isochronous transfer.  The question then is: why
is it slow?  I will look in my cupboard to see if I have the same modem,
and if so see what speed I can get out of it.

> Which debug option should I switch to see these?

Something like this IIRC:
	echo 7 > /proc/sys/kernel/printk
Then it should turn up in dmesg.

Ciao,

Duncan.


