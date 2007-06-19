Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbXFSPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbXFSPk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbXFSPkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:40:52 -0400
Received: from smtp-01b.mandic.com.br ([200.225.81.136]:42775 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757108AbXFSPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:40:51 -0400
Message-ID: <4677F820.5020207@mandic.com.br>
Date: Tue, 19 Jun 2007 12:37:04 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jiri Kosina <jikos@jikos.cz>
Subject: Re: Error -71 on device descriptor read/all
References: <4677EBF8.5020104@mandic.com.br> <Pine.LNX.4.64.0706191657050.3068@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706191657050.3068@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 19 Jun 2007, Renato S. Yamane wrote:
>> I see this in dmesg:
>> usb 1-1: device descriptor read/all, error -71
> 
> Is this a USB 2.0 high-speed device?

lspci -v | grep 1d.7
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB2 EHCI Controller (rev 04) (prog-if 20 [EHCI])

My machine is a Laptop Toshiba M45-S355

> Don't you for example have USB 
> extension cable too long to work on-high speed?

My only USB device is a mouse (Microsoft Notebook Optical Mouse) without 
extension cable (I use original cable, with less than 3 feets).

> I guess the situation improves when you force USB 1.1 (i.e. rmmod 
> ehci_hcd), right?

#rmmode ehci_hcd
#tail /var/log/messages

kernel: ehci_hcd 0000:00:1d.7: remove, state 4
kernel: usb usb5: USB disconnect, address 1
kernel: ehci_hcd 0000:00:1d.7: USB bus 5 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled

I don't see any error (-71).

#modprobe ehci_hcd
#tail /var/log/messages
kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> Link [LNKH] -> GSI 10 
(level, low) -> IRQ 10
kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
kernel: ehci_hcd 0000:00:1d.7: debug port 1
kernel: ehci_hcd 0000:00:1d.7: irq 10, io mem 0xf4000000
kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 
2004
kernel: usb usb5: configuration #1 chosen from 1 choice
kernel: hub 5-0:1.0: USB hub found
kernel: hub 5-0:1.0: 8 ports detected
kernel: usb 1-1: USB disconnect, address 4
kernel: usb 1-1: new low speed USB device using uhci_hcd and address 5
kernel: usb 1-1: configuration #1 chosen from 1 choice
kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye? as 
/class/input/input8
kernel: input: USB HID v1.00 Mouse [Microsoft Microsoft 3-Button Mouse 
with IntelliEye?] on usb-0000:00:1d.0-1

This error is present only in dmesg, see below (line 8):

PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 10, io mem 0xf4000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb 1-1: device descriptor read/all, error -71
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
Clocksource tsc unstable (delta = -194969704 ns)
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 6
PCI: setting IRQ 6 as level-triggered

Best regards,
Renato
