Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbZDVMe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbZDVMe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZDVMek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:34:40 -0400
Received: from langos.euedge.com ([209.190.22.130]:43276 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZDVMei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:34:38 -0400
Message-ID: <49EF0ED7.3060706@maroy.hu>
Date: Wed, 22 Apr 2009 14:34:31 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904211539.23671.oliver@neukum.org> <49EDFA80.9060305@maroy.hu> <200904211952.25616.oliver@neukum.org>
In-Reply-To: <200904211952.25616.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

I made additional tests: made a clean compilation of 2.6.29.1 with
CONFIG_USB_DEBUG=y , but the dmesg output is the same.

Strangely enough, I compiled 2.6.24.7, and got the same results (the
communication hangs at the poll() call), on the same machine. This is
despite the fact that when running the same application on an ubuntu
8.04, it runs fine, which reports a kernel version of 2.6.24-23-generic.

one interesting message I get on the console when plugging in the device is:

drivers/usb/class/cdc-acm.c: This device cannot do calls on its own. It
is no modem.


the dmesg output for 2.6.29.1 when inserting the device is:

Apr 22 14:08:19 tomodachi kernel: [  259.088065] usb 2-1: new full speed
USB device using uhci_hcd and address 2
Apr 22 14:08:19 tomodachi kernel: [  259.245307] usb 2-1: New USB device
found, idVendor=ffff, idProduct=0005
Apr 22 14:08:19 tomodachi kernel: [  259.245312] usb 2-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Apr 22 14:08:19 tomodachi kernel: [  259.245316] usb 2-1: Product: USBSerial
Apr 22 14:08:19 tomodachi kernel: [  259.245319] usb 2-1: Manufacturer:
LPCUSB
Apr 22 14:08:19 tomodachi kernel: [  259.245322] usb 2-1: SerialNumber:
DEADC0DE
Apr 22 14:08:19 tomodachi kernel: [  259.245842] usb 2-1: configuration
#1 chosen from 1 choice
Apr 22 14:08:19 tomodachi kernel: [  259.294225] cdc_acm 2-1:1.0:
ttyACM0: USB ACM device
Apr 22 14:08:19 tomodachi kernel: [  259.297156] usbcore: registered new
interface driver cdc_acm
Apr 22 14:08:19 tomodachi kernel: [  259.297162] cdc_acm: v0.26:USB
Abstract Control Model driver for USB modems and ISDN adapters


for 2.6.24.7, it is:

Apr 22 14:13:47 tomodachi kernel: [  181.049644] usb 2-1: new full speed
USB device using uhci_hcd and address 2
Apr 22 14:13:47 tomodachi kernel: [  181.210892] usb 2-1: configuration
#1 chosen from 1 choice
Apr 22 14:13:47 tomodachi kernel: [  181.213045] usb 2-1: Product: USBSerial
Apr 22 14:13:47 tomodachi kernel: [  181.213047] usb 2-1: Manufacturer:
LPCUSB
Apr 22 14:13:47 tomodachi kernel: [  181.213050] usb 2-1: SerialNumber:
DEADC0DE
Apr 22 14:13:48 tomodachi kernel: [  181.240322] cdc_acm 2-1:1.0:
ttyACM0: USB ACM device
Apr 22 14:13:48 tomodachi kernel: [  181.243117] usbcore: registered new
interface driver cdc_acm
Apr 22 14:13:48 tomodachi kernel: [  181.243127]
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for
USB modems and ISDN adapters


what could be the problem?

Akos

