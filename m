Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbXL0We7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbXL0We7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXL0Weu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:34:50 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:20128 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbXL0Wet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Sn/6Lc4k4RIt6MXmyhBncYs6NknzX9xXvI5B9Nv40CIrsBlDl78OqyHm4k3FxZ4HETmmBi1OhgzWLD48FDOLrkJhKYl0W1QACZbUsdNd6BdM5c43eOmX1WmMjYjLWsezVswVa9BrgAQKditiAsLk4OqH+r2y8QaLX8w4/DsTIyo=
Message-ID: <7fedbc910712271434v56f45b37r875203063bc38be8@mail.gmail.com>
Date: Thu, 27 Dec 2007 23:34:47 +0100
From: shacky <shacky83@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Udev problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm writing here because I didn't found a mailing list specific for udev.
I'm sorry if I am out of topic. In this case please tell me.

I'm trying to get an Huawei e220 UMTS/HSDPA USB modem working on my Ubuntu 7.10.
The problem of that peripheral is that when you plug the modem in the
USB port, it is recognise as an USB CD-ROM.
I have the 2.6.22 kernel, which shouldn't recognise this modem as a
CD-ROM (I read this on http://oozie.fm.interia.pl/pro/huawei-e220/),
but this doesn't happen.

To make this modem works you have to execute a program named
"huaweiAktBbo", whose source can be found at
http://www.kanoistika.sk/bobovsky/archiv/umts/huaweiAktBbo.c
I compiled it and I saved the compiled program in /sbin.
Please note that the program works perfectly if executed from the shell as root.

So I wrote a new udev rule (/etc/udev/rules.d/50-huwaei-e220.rules)
with this rule:

SUBSYSTEM=="usb", SYSFS{idProduct}="1003", SYSFS{idVendor}=="12d1",
RUN+="/sbin/huaweiAktBbo"

But when I plug the modem in the USB port I get this errors in /var/log/syslog:

Dec 23 23:06:39 studio2 udevd-event[5644]: run_program: '/sbin/huaweiAktBbo'
Dec 23 23:06:39 studio2 udevd-event[5644]: run_program:
'/sbin/huaweiAktBbo' (stderr) 'huaweiAktBbo: huaweiAktBbo.c:113: main:
Assertion `dev' failed.'
Dec 23 23:06:39 studio2 udevd-event[5644]: run_program:
'/sbin/huaweiAktBbo' (stdout) 'Hladam HUAWEI E220 a prepnem na modem -
bbo 06'
Dec 23 23:06:40 studio2 udevd-event[5644]: run_program:
'/sbin/huaweiAktBbo' abnormal exit

If I run that program as root from the console, it works, and I can
use the modem well:

Hladam HUAWEI E220 a prepnem na modem - bbo 06
4 set feature request returned 0
Prepnute-OK, Mas ttyUSB0 ttyUSB1 (cez usbserial vendor=0x12d1 product=0x1003)
pozri /proc/bus/usb/devices

I contacted the creator of the program, and he told me that the
program doesn't work because it doesn't found the device in the bus.
But udev recognise the device, because it executes the script as you
can see in the logs.
he told me that the problem can be if udev execute the rule before it
adds the device in the kernel, is it possible?

Is it possible to delay the execution of the rule after the device is
recognised in the kernel and added to the device list in the bus
(lsusb)?

Could you help me, please?
Thank you very much in advance for your help!
Bye.
