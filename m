Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXKWBU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXKWBU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXKWBUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:20:49 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40289 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXKWBUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:20:49 -0500
Date: Thu, 22 Nov 2007 19:20:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Where is the interrupt going?
In-reply-to: <fa.4GMGd+vtd9BoH5cWYyPKXdddZG4@ifi.uio.no>
To: niessner@jpl.nasa.gov
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org
Message-id: <47462AD8.2040905@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.KsmqgW5tYuaXUkIKwnbJk9eJIAI@ifi.uio.no>
 <fa.JGl5fAfWYHut6bLbEcD35M84qbY@ifi.uio.no>
 <fa.4GMGd+vtd9BoH5cWYyPKXdddZG4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

niessner@jpl.nasa.gov wrote:
> 
> I tried the hammer and the problem persists.
> observer@bbb:~$ cat /proc/cmdline
> root=UUID=8b3c3666-22c3-4c04-b399-ece266f2ef30 ro noapic quiet splash
> 
> However, I reserve the right to try the hammer again in the future. When 
> I look at /proc/interrupts without the APIC:
> observer@bbb:~$ cat /proc/interrupts
>            CPU0
>   0:        144    XT-PIC-XT        timer
>   1:         10    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   5:     100000    XT-PIC-XT        ohci_hcd:usb5, mxser
>   6:          5    XT-PIC-XT        floppy
>   7:          1    XT-PIC-XT        parport0
>   8:          3    XT-PIC-XT        rtc
>   9:          1    XT-PIC-XT        acpi, uhci_hcd:usb2
>  10:     100000    XT-PIC-XT        ohci_hcd:usb4, ehci_hcd:usb6, 
> r128@pci:0000:01:00.0
>  11:       2231    XT-PIC-XT        uhci_hcd:usb1, ohci_hcd:usb3, eth0
>  12:        130    XT-PIC-XT        i8042
>  14:       4362    XT-PIC-XT        libata
>  15:      15315    XT-PIC-XT        libata
> NMI:          0
> LOC:     130125
> ERR:          0
> MIS:          0
> 
> I do not even see the device that I registered unless it is that r128... 
> line. However the code printed out in /var/log/messages:
> Nov 22 16:05:27 bbb kernel: [  104.712473] apc8620: VID = 0x10B5
> Nov 22 16:05:27 bbb kernel: [  104.712486] apc8620: mapped addr = e0bd4000
> Nov 22 16:05:27 bbb kernel: [  104.713022] apc8620: registered carrier 0
> Nov 22 16:05:27 bbb kernel: [  104.713028] apc8620: interrupt data 
> (0xe1083e40) on irq (10) and status (0x10)
> 
> which indicates it successfully registered without being shared. When I 
> have more time, I will changed the code to be a shared IRQ and try the 
> noapic again.

You're not calling pci_enable_device anywhere. Unless you do this before 
requesting the IRQ, the IRQ routing may not be set up properly for your 
device and it may not even give you the right IRQ number. You should see 
a line like this somewhere in dmesg for the IRQ your card is on:

ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) -> IRQ 17

I think this behavior changed in the somewhat recent past..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

