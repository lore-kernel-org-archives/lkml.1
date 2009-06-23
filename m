Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZFWVOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZFWVOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZFWVOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:14:01 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46447 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZFWVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:14:00 -0400
Subject: Re: Regression: Problem in using USB Bluetooth Dongle (Worked fine
 in  2.6.24.x)
From: Marcel Holtmann <marcel@holtmann.org>
To: Brian Marete <bgmarete@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6dd519ae0906231314k930be18p296281c1e59ba798@mail.gmail.com>
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
	 <1241821498.4903.69.camel@localhost.localdomain>
	 <6dd519ae0905110030n2abd87c0j507e476fb5622d87@mail.gmail.com>
	 <1242031614.3384.10.camel@localhost.localdomain>
	 <6dd519ae0905120915s5dc1f4b9h8c0b80a243f9cf7f@mail.gmail.com>
	 <6dd519ae0906231314k930be18p296281c1e59ba798@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 23:14:01 +0200
Message-Id: <1245791641.15367.143.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

> >>> >> At least until kernel version 2.6.24, I was able to use my USB
> >>> >> bluetooth dongle to download contacts from my phone. I made a jump
> >>> >> from 2.6.24 to 2.6.27, so I am not sure exactly which kernel version
> >>> >> starts the problem, but all kernels from the latter (2.6.27) now do
> >>> >> not work. The latest kernel I have tested is 2.6.29.2.
> >>> >
> >>> > can you test 2.6.30-rc4 or bluetooth-testing.git. I am pretty sure that
> >>> > whatever broke in 2.6.27 has been fixed by now. Some cheapo USB dongles
> >>> > behaved wrongly and it was a long time not clear what caused it.
> >>>
> >>> Alas, the regression is still there in 2.6.30-rc5 which I tested over
> >>> the weekend.
> >>>
> >>> I also forgot to mention that, even with the kernels with the
> >>> regression, device pairing using the dongle still works.
> >>>
> >>> Would a packet capture (usbmon) help? Willing to capture whatever
> >>> other debugging data that you think may help
> >>
> >> if device pairing works fine, the I guess this is a different problem.
> >> It could be that your USB host controller doesn't like the device. Or
> >> you forgot to load the EHCI driver or something. Otherwise your dongle
> >> should work fine. Since pairing works, what does hciconfig -a says?
> >>
> >
> > EHCI is actually loaded. See my regression report in my original email.
> >
> > Regarding some conflict with the host controller, well, it did work
> > fine in 2.6.24.
> >
> > Is there some other debug output I can collect or some other
> > information that I can provide to help identify the source of the
> > regression?
> >
>
> The regression persists even in the latest kernels.
> 
> Decided to collect some more debug information on this problem. This
> output is from the same system detailed above running on
> kernel 2.6.28.10:

the latest kernel is 2.6.30 btw. Can you please test that one.

> Here is the output of hciconfig -a:
> 
> hci0:	Type: USB
> 	BD Address: BB:4A:BB:33:40:36 ACL MTU: 339:6 SCO MTU: 180:1
> 	UP RUNNING PSCAN ISCAN
> 	RX bytes:14299 acl:0 sco:0 events:386 errors:0
> 	TX bytes:2221 acl:0 sco:0 commands:231 errors:0
> 	Features: 0xef 0x3e 0x09 0xf0 0x0b 0x08 0x00 0x80
> 	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
> 	Link policy: RSWITCH HOLD SNIFF PARK
> 	Link mode: SLAVE ACCEPT
> 	Name: 'oqb-0'
> 	Class: 0x08010c
> 	Service Classes: Capturing
> 	Device Class: Computer, Laptop
> 	HCI Ver: 1.2 (0x2) HCI Rev: 0x2 LMP Ver: 1.2 (0x2) LMP Subver: 0x2
> 	Manufacturer: Accel Semiconductor Ltd. (74)
> -----------------------------------------------------------------------------

To be honest, I have never seen a chip from this manufacturer. SO I have
no experience with them. Where did you get that dongle from. I might
have to buy one of these.

> Here is the output and hcidump of l2ping:
> 
> $ sudo l2ping 00:21:AB:9D:0C:C8
> Can't connect: Device or resource busy
> 
> HCI sniffer - Bluetooth packet analyzer ver 1.40
> device: hci0 snap_len: 1028 filter: 0xffffffff
> < HCI Command: Create Connection (0x01|0x0005) plen 13
>   C8 0C 9D AB 21 00 18 CC 02 00 00 00 01

Please redu them with hcidump -X -V since decoding by hand is way too
painful.

Regards

Marcel


