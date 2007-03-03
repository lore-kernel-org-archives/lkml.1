Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbXCCHa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbXCCHa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXCCHa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:30:26 -0500
Received: from email.authentidate.de ([213.61.157.66]:39860 "EHLO
	email.authentidate.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXCCHa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:30:26 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Mar 2007 02:30:25 EST
Subject: Re: usbserial not working/oops on removal
From: Andreas Laumann <al@authentidate.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Kevin Fenzi <kevin@scrye.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200703030745.19547.oliver@neukum.org>
References: <20070302193715.568098a6@ningauble.scrye.com>
	 <200703030745.19547.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Organization: AuthentiDate International AG
Date: Sat, 03 Mar 2007 08:19:44 +0100
Message-Id: <1172906384.26337.13.camel@justine.inexnet.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 03.03.2007, 07:45 +0100 schrieb Oliver Neukum:
> Am Samstag, 3. März 2007 03:37 schrieb Kevin Fenzi:
> > I'm seeing some oddity with the latest fedora development kernel and a
> > usbserial device. 
> 
> Very interesting. Is this repeatable? Does unplugging have the same effect?

I see it also on fedora rawhide using reinersct (cyberjack) scard
readers and it repeatable.
The first usbserial devices likes to register the line number 255 which
indeed is invalid.

2.6.20-1.2953.fc7:

usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
parport0: Printer, Hewlett-Packard HP LaserJet 6L
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for Reiner SCT Cyberjack USB card reader
cyberjack 5-2.2:1.0: Reiner SCT Cyberjack USB card reader converter detected
Attempt to register invalid tty line number  (255).
usb 5-2.2: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB255
cyberjack 5-2.3:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb-serial ttyUSB255: Error registering port device, continuing
usbcore: registered new interface driver cyberjack
drivers/usb/serial/cyberjack.c: v1.01 Matthias Bruestle
drivers/usb/serial/cyberjack.c: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver


Last rawhide kernel which was working for me is
kernel-2.6.20-1.2925.fc7.x86_64

2.6.20-1.2925.fc7:

usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
input: PC Speaker as /class/input/input2
ata_piix 0000:00:1f.1: version 2.00ac7
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata7: PATA max UDMA/100 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
scsi6 : ata_piix
drivers/usb/serial/usb-serial.c: USB Serial support registered for Reiner SCT Cyberjack USB card reader
cyberjack 4-1:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 4-1: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB0
cyberjack 4-2:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 4-2: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB1
cyberjack 5-4.1.2:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-4.1.2: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB2
cyberjack 5-4.1.3:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-4.1.3: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB3
cyberjack 5-2.3:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-2.3: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB4
cyberjack 5-2.1:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-2.1: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB5
cyberjack 5-2.2:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-2.2: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB6
usbcore: registered new interface driver cyberjack
drivers/usb/serial/cyberjack.c: v1.01 Matthias Bruestle
drivers/usb/serial/cyberjack.c: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver


System is x86_64 XEON 5160 4GB RAM


Regards
	Andreas
> 
> 	Regards
> 		Oliver
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


