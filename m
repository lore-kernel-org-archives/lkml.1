Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbXEUHMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbXEUHMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXEUHM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:12:26 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:6414 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbXEUHMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:12:25 -0400
Date: Mon, 21 May 2007 01:12:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
In-reply-to: <fa.mF3GWjxaUtH4GJg0vJ8o0F2EuwE@ifi.uio.no>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org
Message-id: <4651464B.4080903@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.mF3GWjxaUtH4GJg0vJ8o0F2EuwE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe wrote:
> A collegue of mine has an Intel mainboard with the i865 chipset onboard
> (DQ965).  All kernels up to and including 2.6.22-rc2 do not detect the IDE
> CDROM/DVDROM when booting.  The SATA hard drive is found without any
> problems.
> 
> Relevant parts from lspci:
> 
>   00:1f.2 0101: 8086:2820 (rev 02)
>   00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port SATA
>   IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: Intel Corporation Unknown device 514d
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
> 
>   00:1f.5 0101: 8086:2825 (rev 02)
>   00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port SATA
>   IDE Controller (rev 02) (prog-if 85 [Master SecO PriO])
>         Subsystem: Intel Corporation Unknown device 514d
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
> 
> What's interesting here is that 00:1f.2 and 00:1f.5 are both identified as
> "n port SATA" controllers even though one of them (I suspect 00:1f.5) is a
> PATA controller.  This may just be a typo in lspci's database though.
> 
> Boot messages:
> 
>   ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>   Probing IDE interface ide0...
>   Probing IDE interface ide1...
>   :
>   ata_piix 0000:00:1f.2: version 2.11
>   ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
>   ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
>   PCI: Setting latency timer of device 0000:00:1f.2 to 64
>   scsi0 : ata_piix
>   scsi1 : ata_piix
>   ata1: SATA max UDMA/133 cmd 0x00012138 ctl 0x00012156 bmdma 0x00012110 irq 0
>   ata2: SATA max UDMA/133 cmd 0x00012130 ctl 0x00012152 bmdma 0x00012118 irq 0
>   ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
>   ata1.00: ATA-7: WDC WD2500AAJS-00RYA0, 12.01B01, max UDMA/133
>   ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
>   ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
>   ata1.00: configured for UDMA/133
>   ATA: abnormal status 0x7F on port 0x00012137
>   scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-0 12.0 PQ: 0 ANSI: 5
>   sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
>   sd 0:0:0:0: [sda] Write Protect is off
>   sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>   sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>   sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
>   sd 0:0:0:0: [sda] Write Protect is off
>   sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>   sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>   sda: sda1 sda2
>   sd 0:0:0:0: [sda] Attached SCSI disk
>   ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
> 
> Here the HDD is clearly detected while the CDROM/DVDROM (attached to ide0)
> isn't.
> 
> libata is compiled into the kernel as is the non-libata PATA driver.
> In the libata configuration, only SATA_AHCI, ATA_PIIX and ATA_GENERIC are
> defined.  For the non-libata side of things most options are selected
> including BLK_DEV_IDE, BLK_DEV_IDECD, IDE_GENERIC, BLK_DEV_IDEPCI, 
> BLK_DEV_GENERIC, BLK_DEV_IDEDMA_PCI and BLK_DEV_PIIX.
> 
> Does anyone have any ideas as to why there is a problem detecting the PATA
> (IDE) CDROM/DVDROM in this machine?  Further information/testing can be
> provided if requested.

A lot of newer Intel boards have the IDE interface provided by an 
external JMicron, etc. chip so you may need to enable that driver for 
things to work.

Also, it's unrelated to this problem, but you should check the BIOS 
settings for the SATA controller - you really want to get the controller 
into AHCI mode for best performance.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

