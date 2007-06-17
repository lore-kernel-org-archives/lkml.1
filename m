Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXFQReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXFQReS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXFQReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:34:11 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:46722 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbXFQReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:34:10 -0400
Date: Sun, 17 Jun 2007 11:33:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: solution to "usb disconnect problems regarding usb 1.1 and 2.0"
In-reply-to: <fa.sk01i7wDPt73ssXVqjiuwKLchDE@ifi.uio.no>
To: Wolfgang Schnitker <wolfgang.schnitker@gmx.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <46757083.4060607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa.sk01i7wDPt73ssXVqjiuwKLchDE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Schnitker wrote:
> Dear Kernel Developers,
> 
> I had some trouble with my usb devices, often showing a disconnect problem. I 
> did some googleing and saw, that it is a less or more common problem.
> 
> This problem is discussed in various internet sites. 
> 
> log from my machine:
> 
> #############################
> usb 4-6: new high speed USB device using ehci_hcd and address 7
> usb 4-6: configuration #1 chosen from 1 choice
> hub 4-6:1.0: USB hub found
> hub 4-6:1.0: 4 ports detected
> usb 4-6.1: new full speed USB device using ehci_hcd and address 8
> usb 4-6.1: device descriptor read/64, error -32
> usb 4-6.1: device descriptor read/64, error -32
> usb 4-6.1: new full speed USB device using ehci_hcd and address 9
> usb 4-6.1: device descriptor read/64, error -110
> usb 4-6.1: device descriptor read/64, error -110
> usb 4-6.1: new full speed USB device using ehci_hcd and address 10
> usb 4-6.1: device not accepting address 10, error -32
> usb 4-6.1: new full speed USB device using ehci_hcd and address 11
> usb 4-6.1: device not accepting address 11, error -71
> usb 4-6: USB disconnect, address 7
> usb 4-6: new high speed USB device using ehci_hcd and address 12
> usb 4-6: configuration #1 chosen from 1 choice
> hub 4-6:1.0: USB hub found
> hub 4-6:1.0: 4 ports detected
> usb 4-6.1: new full speed USB device using ehci_hcd and address 13
> usb 4-6.1: device descriptor read/64, error -32
> usb 4-6.1: device descriptor read/64, error -32
> usb 4-6.1: new full speed USB device using ehci_hcd and address 14
> usb 4-6.1: device descriptor read/64, error -110
> usb 4-6.1: device descriptor read/64, error -71
> usb 4-6.1: new full speed USB device using ehci_hcd and address 15
> usb 4-6.1: device not accepting address 15, error -71
> usb 4-6.1: new full speed USB device using ehci_hcd and address 16
> usb 4-6.1: device not accepting address 16, error -71
> usb 4-6.1: new full speed USB device using ehci_hcd and address 17
> usb 4-6.1: configuration #1 chosen from 1 choice
> SCSI subsystem initialized
> Initializing USB Mass Storage driver...
> scsi0 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new driver usb-storage
> usb-storage: device found at 17
> usb-storage: waiting for device to settle before scanning
> USB Mass Storage support registered.
>   Vendor:           Model: USB Card Reader   Rev: 1.05
>   Type:   Direct-Access                      ANSI SCSI revision: 00
>   Vendor:           Model: USB Card Reader   Rev: 1.05
>   Type:   Direct-Access                      ANSI SCSI revision: 00
>   Vendor:           Model: USB Card Reader   Rev: 1.05
>   Type:   Direct-Access                      ANSI SCSI revision: 00
>   Vendor:           Model: USB Card Reader   Rev: 1.05
>   Type:   Direct-Access                      ANSI SCSI revision: 00
> usb-storage: device scan complete
> sd 0:0:0:0: Attached scsi removable disk sda
> sd 0:0:0:1: Attached scsi removable disk sdb
> sd 0:0:0:2: Attached scsi removable disk sdc
> sd 0:0:0:3: Attached scsi removable disk sdd
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
> usb 4-6.1: USB disconnect, address 17
> 
> #########################
> 
> I have a solution/hint to solve this problem.
> 
> In my case I had following NOT WORKING config:
> 
> internal USB-Card PCI --> USB Hub --> Card Reader 
> ( ali usb card, i-rocks hub, Phision cardreader)
> 
> 00:08.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:08.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:08.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
> 00:08.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
> 
> linux sets it up using:
> 
> ehci --> ehci --> ehci (total usb 2.0 support)
> 
> Bus 004 Device 028: ID 0d7d:0240 Phison Electronics Corp. I/O-Magic/Transcend 
> 6-in-1 Card Reader
> Bus 004 Device 027: ID 05e3:0605 Genesys Logic, Inc. USB 2.0 Hub [ednet]
> 
> 
> 
> but only the hub is a usb 2.0 compliant product. the card-reader is usb 1.1!!
> 
> So i changed physically the hub back to a 1.1 device.
> 
> and now linux sets this to 
> 
> ohci --> ohci --> ohci
> 
> Bus 003 Device 011: ID 0d7d:0240 Phison Electronics Corp. I/O-Magic/Transcend 
> 6-in-1 Card Reader
> Bus 003 Device 010: ID 03eb:3301 Atmel Corp. at43301 4-port Hub
> 
> 
> And this configuration works perfect, without any trouble any more.
> 
> So in my opinion the problem is comming from ehci, which tries to set up a usb 
> 1.1 device in a 2.0 mode. this results in severe timing problems, because the 
> 1.1 device is too slow to handle this protocol, this results in a "dead" 
> device from the point of view of the driver (no reaction). It disconnects the 
> device and reconnects it again. It is only a problem, if you use a HUB 
> between the USB Controller and the end device. I think we have to take care 
> about the last device in the chain to set it up in the correct way.

I don't think that is what is going on. If you connect a USB 1.1 device 
to a USB 2.0 hub, the USB 2.0 controller can still talk to it at high 
speed using the EHCI controller, since the USB 2.0 hub has a transaction 
translator for low and full speed devices. This is as designed and 
should work (though it's possible there's a bug somewhere).

Are you sure that USB 2.0 hub is actually working properly, and can 
supply adequate power for that card reader? (I've seen some crap hubs 
that identify themselves as self-powered with 500mA per port, but a) it 
still lists this even if the AC adapter is not plugged in and therefore 
is actually bus-powered with far less power available, and b) even if it 
was plugged in, the AC adapter is far too weak to actually be able to 
supply this much power..)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

