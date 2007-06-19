Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXFSPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXFSPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXFSPzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:55:21 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54976 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbXFSPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:55:20 -0400
Date: Tue, 19 Jun 2007 17:55:08 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Error -71 on device descriptor read/all
In-Reply-To: <4677F820.5020207@mandic.com.br>
Message-ID: <Pine.LNX.4.64.0706191751490.3068@twin.jikos.cz>
References: <4677EBF8.5020104@mandic.com.br> <Pine.LNX.4.64.0706191657050.3068@twin.jikos.cz>
 <4677F820.5020207@mandic.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ OK, it probably seems like a faulty hardware (controller or the device 
  itself), which is not able to run at high speed, but runs nicely on full 
  speed. Do you have a chance to try another high speed device in this 
  machine to check whether it works?

  Adding linux-usb-devel into CC , just in case, and leaving the full 
  original message below ]

On Tue, 19 Jun 2007, Renato S. Yamane wrote:

> Jiri Kosina wrote:
> > On Tue, 19 Jun 2007, Renato S. Yamane wrote:
> > > I see this in dmesg:
> > > usb 1-1: device descriptor read/all, error -71
> > 
> > Is this a USB 2.0 high-speed device?
> 
> lspci -v | grep 1d.7
> 00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> USB2 EHCI Controller (rev 04) (prog-if 20 [EHCI])
> 
> My machine is a Laptop Toshiba M45-S355
> 
> > Don't you for example have USB extension cable too long to work on-high
> > speed?
> 
> My only USB device is a mouse (Microsoft Notebook Optical Mouse) without
> extension cable (I use original cable, with less than 3 feets).
> 
> > I guess the situation improves when you force USB 1.1 (i.e. rmmod ehci_hcd),
> > right?
> 
> #rmmode ehci_hcd
> #tail /var/log/messages
> 
> kernel: ehci_hcd 0000:00:1d.7: remove, state 4
> kernel: usb usb5: USB disconnect, address 1
> kernel: ehci_hcd 0000:00:1d.7: USB bus 5 deregistered
> kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> 
> I don't see any error (-71).
> 
> #modprobe ehci_hcd
> #tail /var/log/messages
> kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> Link [LNKH] -> GSI 10 (level,
> low) -> IRQ 10
> kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
> kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> kernel: ehci_hcd 0000:00:1d.7: debug port 1
> kernel: ehci_hcd 0000:00:1d.7: irq 10, io mem 0xf4000000
> kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 
> 2004
> kernel: usb usb5: configuration #1 chosen from 1 choice
> kernel: hub 5-0:1.0: USB hub found
> kernel: hub 5-0:1.0: 8 ports detected
> kernel: usb 1-1: USB disconnect, address 4
> kernel: usb 1-1: new low speed USB device using uhci_hcd and address 5
> kernel: usb 1-1: configuration #1 chosen from 1 choice
> kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye? as 
> /class/input/input8
> kernel: input: USB HID v1.00 Mouse [Microsoft Microsoft 3-Button Mouse with
> IntelliEye?] on usb-0000:00:1d.0-1
> 
> This error is present only in dmesg, see below (line 8):
> 
> PCI: Setting latency timer of device 0000:00:1d.7 to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> ehci_hcd 0000:00:1d.7: debug port 1
> PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> ehci_hcd 0000:00:1d.7: irq 10, io mem 0xf4000000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb 1-1: device descriptor read/all, error -71
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 8 ports detected
> Clocksource tsc unstable (delta = -194969704 ns)
> ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 6
> PCI: setting IRQ 6 as level-triggered
> 
> Best regards,
> Renato
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jiri Kosina
