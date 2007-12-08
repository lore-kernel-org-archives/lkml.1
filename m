Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXLHXot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXLHXot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXLHXol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:44:41 -0500
Received: from lucidpixels.com ([75.144.35.66]:53573 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbXLHXok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:44:40 -0500
Date: Sat, 8 Dec 2007 18:44:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: 2.6.23.9 64-bit IRQ sharing without irqbalance with p35 vs i965?
Message-ID: <Pine.LNX.4.64.0712081842250.12499@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can some please explain with almost identical kernel .config's I see this 
on a p965 Intel board:

            CPU0       CPU1       CPU2       CPU3
   0: 2501669875          0          0          0   IO-APIC-edge      timer
   1:          8          0          0          0   IO-APIC-edge      i8042
   7:          0          0          0          0   IO-APIC-edge      parport0
   8:          1          0          0          0   IO-APIC-edge      rtc
   9:          0          0          0          0   IO-APIC-fasteoi   acpi
  12:   21187797          0          0          0   IO-APIC-edge      i8042
  16:   29096123          0          0          0   IO-APIC-fasteoi   sata_sil24, uhci_hcd:usb3
  17:        122          0          0          0   IO-APIC-fasteoi   libata
  18:   27177188          0          0          0   IO-APIC-fasteoi   sata_sil24, ehci_hcd:usb1, uhci_hcd:usb7
  19:   29230654          0          0          0   IO-APIC-fasteoi   sata_sil24, ohci1394, uhci_hcd:usb6
  21:   41626956          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4, eth1
  22:        203          0          0          0   IO-APIC-fasteoi   HDA Intel
  23:        108          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
377:  590862399          0          0          0   PCI-MSI-edge      eth0
378:   89967666          0          0          0   PCI-MSI-edge      ahci
NMI:          0          0          0          0 
LOC: 2501568889 2501566748 2501569508 2501566435 
ERR:          0

And this on a Gigabyte p35 chipset:

            CPU0       CPU1       CPU2       CPU3
   0:    4798363    4806242    4807103    4801203   IO-APIC-edge      timer
   1:          1          2          3          2   IO-APIC-edge      i8042
   6:          3          0          0          0   IO-APIC-edge      floppy
   8:          0          0          0          1   IO-APIC-edge      rtc
   9:          0          0          0          0   IO-APIC-fasteoi   acpi
  12:         22         32         26         33   IO-APIC-edge      i8042
  16:          0          0          0          0   IO-APIC-fasteoi   ahci, uhci_hcd:usb3
  17:      16994      17065      16955      16952   IO-APIC-fasteoi   libata, eth0
  18:          0          1          1          1   IO-APIC-fasteoi   ohci1394, ehci_hcd:usb1, uhci_hcd:usb5, uhci_hcd:usb8
  19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
  21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
  22:         38         39         40         38   IO-APIC-fasteoi   HDA Intel
  23:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
380:    6838702    6823411    6822704    6836873   PCI-MSI-edge      ahci
NMI:          0          0          0          0 
LOC:   18993695   18993662   18891135   18891030 
ERR:          0

Both are running Debian Lenny (testing) with (almost the same exact kernel 
configuration).

Why is this?

Justin.
