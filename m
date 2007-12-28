Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXL1C3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXL1C3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 21:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXL1C3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 21:29:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:31371 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXL1C3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 21:29:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=b090i45dt/Z0SB6fVQK+ZRb6sXVbUieJN5i3Cq71Zl88gDw2GnNwjeC23BjvNf5aiIF66VYpZmY2MmeNdIY6YTWtItGaQhZT7O2vOFVB5gBhuRO7ypWEIuRHX2HMlMtbeiMZhE44DTtafBGnFlp+yBtMIrUqe7K7eqpH9cNnZ9k=
Message-ID: <47745F70.7090204@googlemail.com>
Date: Fri, 28 Dec 2007 03:29:04 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: shacky <shacky83@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Udev problem
References: <7fedbc910712271434v56f45b37r875203063bc38be8@mail.gmail.com>
In-Reply-To: <7fedbc910712271434v56f45b37r875203063bc38be8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shacky wrote:

[ Added linux-hotplug  to CC ]

> Hi.

Hi,

> 
> I'm writing here because I didn't found a mailing list specific for udev.

There it is :

http://vger.kernel.org/vger-lists.html#linux-hotplug

> I'm sorry if I am out of topic. In this case please tell me.
> 
> I'm trying to get an Huawei e220 UMTS/HSDPA USB modem working on my Ubuntu 7.10.
> The problem of that peripheral is that when you plug the modem in the
> USB port, it is recognise as an USB CD-ROM.
> I have the 2.6.22 kernel, which shouldn't recognise this modem as a
> CD-ROM (I read this on http://oozie.fm.interia.pl/pro/huawei-e220/),
> but this doesn't happen.
> 
> To make this modem works you have to execute a program named
> "huaweiAktBbo", whose source can be found at
> http://www.kanoistika.sk/bobovsky/archiv/umts/huaweiAktBbo.c
> I compiled it and I saved the compiled program in /sbin.
> Please note that the program works perfectly if executed from the shell as root.
> 
> So I wrote a new udev rule (/etc/udev/rules.d/50-huwaei-e220.rules)
> with this rule:
> 
> SUBSYSTEM=="usb", SYSFS{idProduct}="1003", SYSFS{idVendor}=="12d1",
> RUN+="/sbin/huaweiAktBbo"
> 
> But when I plug the modem in the USB port I get this errors in /var/log/syslog:
> 
> Dec 23 23:06:39 studio2 udevd-event[5644]: run_program: '/sbin/huaweiAktBbo'
> Dec 23 23:06:39 studio2 udevd-event[5644]: run_program:
> '/sbin/huaweiAktBbo' (stderr) 'huaweiAktBbo: huaweiAktBbo.c:113: main:
> Assertion `dev' failed.'
> Dec 23 23:06:39 studio2 udevd-event[5644]: run_program:
> '/sbin/huaweiAktBbo' (stdout) 'Hladam HUAWEI E220 a prepnem na modem -
> bbo 06'
> Dec 23 23:06:40 studio2 udevd-event[5644]: run_program:
> '/sbin/huaweiAktBbo' abnormal exit
> 
> If I run that program as root from the console, it works, and I can
> use the modem well:
> 
> Hladam HUAWEI E220 a prepnem na modem - bbo 06
> 4 set feature request returned 0
> Prepnute-OK, Mas ttyUSB0 ttyUSB1 (cez usbserial vendor=0x12d1 product=0x1003)
> pozri /proc/bus/usb/devices
> 
> I contacted the creator of the program, and he told me that the
> program doesn't work because it doesn't found the device in the bus.
> But udev recognise the device, because it executes the script as you
> can see in the logs.
> he told me that the problem can be if udev execute the rule before it
> adds the device in the kernel, is it possible?
> 
> Is it possible to delay the execution of the rule after the device is
> recognised in the kernel and added to the device list in the bus
> (lsusb)?
> 
> Could you help me, please?
> Thank you very much in advance for your help!
> Bye.

