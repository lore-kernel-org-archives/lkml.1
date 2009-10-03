Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZJCKf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZJCKf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZJCKf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:35:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:22325 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZJCKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NNR4LikAylTVx04FAMsQ5uhdcQfBkMOrjYkTbRkG5h3vM+8Dt45QlD9uLPcAxTLfIf
         T1LQsaPoH7dvUE/Kw/VjOhCGBCJju2HwRz/Tiu97FxiZqZ1ZS5NboNTBBgyn7Z+QaZw+
         pcGsnkpTJ1yDdMvloZKRfC4kEiZO9ei7k1EXU=
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 13:35:58 +0300
Message-ID: <94a0d4530910030335p2eae17a6wddf6d87b7f60b712@mail.gmail.com>
Subject: Annoying problems with lacie external hd (JMicron 0x2339?)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is with 2.6.31.1.

I'm having a lot of problems with a lacie external hd[1]. It seems the
actual disk is a seagate ST375064, and the bridge is a JMicron 2339.

In normal usage what I see is that if I don't use the disk after a
while hear a loud click (as if something got stuck) and then I cannot
use it any more; I have to turn it off and on again.

But then I started to see some problems on one fs, so I ran badblocks
and I noticed a lot of strange behavior. It seems once I get a
read/write error then I get more of them in a row, and after a while I
hear another loud click, and then I only get read/write errors
constantly.

I noticed in 'unusual_devs.h' there's already a quirk for another
JMicron product, so I tried to do the same:

+UNUSUAL_DEV(  0x152d, 0x2339, 0x0000, 0xffff,
+               "JMicron",
+               "USB to ATA/ATAPI Bridge",
+               US_SC_DEVICE, US_PR_DEVICE, NULL,
+               US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),

This seemed to help with the consecutive errors, but not with the loud click.

This is what I get when this click happens:

Oct  3 13:14:54 annwn kernel: [  351.099096] usb 1-1: reset high speed
USB device using ehci_hcd and address 3
Oct  3 13:14:54 annwn kernel: [  351.213541] usb 1-1: device firmware changed
Oct  3 13:14:54 annwn kernel: [  351.213588] usb 1-1: USB disconnect, address 3
Oct  3 13:14:54 annwn kernel: [  351.213633] sd 4:0:0:0: Device
offlined - not ready after error recovery
Oct  3 13:14:54 annwn kernel: [  351.213650] sd 4:0:0:0: [sdb]
Unhandled error code
Oct  3 13:14:54 annwn kernel: [  351.213655] sd 4:0:0:0: [sdb] Result:
hostbyte=DID_ABORT driverbyte=DRIVER_OK
Oct  3 13:14:54 annwn kernel: [  351.213663] end_request: I/O error,
dev sdb, sector 8596352
Oct  3 13:14:54 annwn kernel: [  351.213774] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.213816] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.213852] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.213891] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.213927] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.213962] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.213997] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:54 annwn kernel: [  351.214202] sd 4:0:0:0: rejecting I/O
to offline device
Oct  3 13:14:55 annwn kernel: [  351.317278] usb 1-1: new high speed
USB device using ehci_hcd and address 4
Oct  3 13:14:55 annwn kernel: [  351.432192] usb 1-1: New USB device
found, idVendor=152d, idProduct=2339
Oct  3 13:14:55 annwn kernel: [  351.432196] usb 1-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=5
Oct  3 13:14:55 annwn kernel: [  351.432199] usb 1-1: Product: USB to
ATA/ATAPI Bridge
Oct  3 13:14:55 annwn kernel: [  351.432202] usb 1-1: Manufacturer: JMicron
Oct  3 13:14:55 annwn kernel: [  351.432204] usb 1-1: SerialNumber: 5D27FFFFFFFF
Oct  3 13:14:55 annwn kernel: [  351.432321] usb 1-1: configuration #1
chosen from 1 choice
Oct  3 13:14:55 annwn kernel: [  351.432791] scsi5 : SCSI emulation
for USB Mass Storage devices

Can anyone help? This disk is important for me =/

Cheers.

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 62 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=152d ProdID=2339 Rev= 1.00
S:  Manufacturer=JMicron
S:  Product=USB to ATA/ATAPI Bridge
S:  SerialNumber=152D203380B6
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

[1] http://www.lacie.com/us/products/product.htm?pid=11016

-- 
Felipe Contreras
