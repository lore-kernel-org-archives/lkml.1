Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbXB0Ufw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbXB0Ufw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXB0Ufw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:35:52 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:10489 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752556AbXB0Ufv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:35:51 -0500
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
Date: Tue, 27 Feb 2007 15:35:20 -0500
Message-ID: <8E8F647D7835334B985D069AE964A4F7033AB59B@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
Thread-Index: AcdaioOgx2HPfQ5VT++DxFFw1J6UHwAIrvHg
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>  <45D5C789.1090607@student.ltu.se>  <8E8F647D7835334B985D069AE964A4F7028FE550@ECQCMTLMAIL1.quebec.int.ec.gc.ca>  <Pine.LNX.4.64.0702182216060.25686@twin.jikos.cz> <1171844733.2488.33.camel@violet> <Pine.LNX.4.64.0702271648190.10496@twin.jikos.cz> <8E8F647D7835334B985D069AE964A4F7028FE5B0@ECQCMTLMAIL1.quebec.int.ec.gc.ca> <Pine.LNX.4.64.0702271713220.10496@twin.jikos.cz>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Jiri Kosina" <jikos@jikos.cz>
Cc: <linux-kernel@vger.kernel.org>, <marcel@holtmann.org>,
       <zaitcev@redhat.com>
X-OriginalArrivalTime: 27 Feb 2007 20:35:21.0620 (UTC) FILETIME=[CD296540:01C75AAE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Actually I don't know... Let me test this.

Here is the scenario:
1) If I plug my USB dongle after my system has booted, everything works fine (except that the keyboard repeats a few keys somethimes..)
2) If the dongle is already plugged at boot-time, there is a BUG echo in the dmesg when the bluetooth service fires up.  This make both the mouse and keyboard unresponsive until I finally unplug / replug the dongle hence going back at state 1)

I never run the hid2hci command manually but the bluetooth init script seems to do so.

Quick test:
1- unplug/plug back the dongle to get back to state 1)
The keyboard and mouse do work has expected...
2- Now run the hid2hci command has root
[root@localhost init.d]# hid2hci
Switching device 046d:c70a to HCI mode was successful
Switching device 046d:c70e to HCI mode was successful

DMESG:
input: Logitech Logitech BT Mini-Receiver as /class/input/input15
input,hiddev96: USB HID v1.11 Mouse [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.7-6.2.2.1.2.3
BUG: warning: (value > m) at drivers/usb/input/hid-core.c:793/implement() (Tainted: P     )
 [<c0405018>] dump_trace+0x69/0x1b6
 [<c040517d>] show_trace_log_lvl+0x18/0x2c
 [<c0405778>] show_trace+0xf/0x11
 [<c0405875>] dump_stack+0x15/0x17
 [<c05993c0>] hid_output_report+0x23c/0x2e7
 [<c05994b7>] hid_submit_ctrl+0x4c/0x1d9
 [<c05997fd>] hid_submit_report+0x134/0x15f
 [<c059bd09>] hiddev_ioctl+0x327/0x88a
 [<c04802c8>] do_ioctl+0x4c/0x62
 [<c0480528>] vfs_ioctl+0x24a/0x25c
 [<c0480586>] sys_ioctl+0x4c/0x66
 [<c040404b>] syscall_call+0x7/0xb
 [<001e8402>] 0x1e8402
 =======================
BUG: warning: ....


3) Now repeat step 1):
 =======================
usb 4-6.2.2.1.2.1: new full speed USB device using ehci_hcd and address 24
usb 4-6.2.2.1.2.1: configuration #1 chosen from 1 choice
usb 4-6.2.2.1.2: USB disconnect, address 21
usb 4-6.2.2.1.2.1: USB disconnect, address 24
usb 4-6.2.2.1.2.2: USB disconnect, address 22
usb 4-6.2.2.1.2.3: USB disconnect, address 23
usb 4-6.2.2.1.2: new full speed USB device using ehci_hcd and address 25
usb 4-6.2.2.1.2: configuration #1 chosen from 1 choice
hub 4-6.2.2.1.2:1.0: USB hub found
hub 4-6.2.2.1.2:1.0: 3 ports detected
usb 4-6.2.2.1.2.1: new full speed USB device using ehci_hcd and address 26
usb 4-6.2.2.1.2.1: configuration #1 chosen from 1 choice
usb 4-6.2.2.1.2.2: new full speed USB device using ehci_hcd and address 27
usb 4-6.2.2.1.2.2: configuration #1 chosen from 1 choice
input: Logitech Logitech BT Mini-Receiver as /class/input/input16
input: USB HID v1.11 Keyboard [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.7-6.2.2.1.2.2
usb 4-6.2.2.1.2.3: new full speed USB device using ehci_hcd and address 28
usb 4-6.2.2.1.2.3: configuration #1 chosen from 1 choice
input: Logitech Logitech BT Mini-Receiver as /class/input/input17
input,hiddev96: USB HID v1.11 Mouse [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.7-6.2.2.1.2.3

So yes, it looks like a hid2hci BUG or kernel BUG initiated by the hid2hci command.

- vin


> -----Message d'origine-----
> De : Jiri Kosina [mailto:jikos@jikos.cz] 
> Envoyé : 27 février 2007 11:15
> À : Fortier,Vincent [Montreal]
> Objet : RE: Boot time Bluetooth BUG: warning: (value > m) at 
> hid-core.c:793
> 
> On Tue, 27 Feb 2007, Fortier,Vincent [Montreal] wrote:
> 
> > Actually it's the first time I'm trying this keyboard and mouse.
> 
> And I guess when you use it in HID mode (i.e. when the 
> hid2hci command is not run), then keyboard and mouse work 
> with no errors reported in the kernel logs, and all the 
> buttons work correctly, am I right?
> 
> --
> Jiri Kosina
> 
