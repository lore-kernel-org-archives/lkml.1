Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXDFQhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXDFQhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXDFQhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:37:21 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60943 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbXDFQhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:37:19 -0400
Date: Fri, 6 Apr 2007 17:37:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070406163707.GA25880@srcf.ucam.org>
References: <20070405141352.12fddb6e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405141352.12fddb6e@the-village.bc.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] HPA support: Revised patch
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 02:13:52PM +0100, Alan Cox wrote:
> This one should fix the problems with slave devices and the Macintosh hang

Better, but still not happy with ata_piix - I get the following:

[   10.972000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 16337840
[   10.972000] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[   10.972000] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   10.980000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = -1342616656
[   10.980000] ata3.01: Host Protected Area detected:
[   10.980000] 	current size: 234441648 sectors
[   10.980000] 	native size: -1342616656 sectors
                             ^^^^^^^^^^^!?!?!?!?!?!?!?

so I'm not especially keen on letting it reprogram stuff. With ahci it 
works fine. Still on a Macbook Pro - fuller logs below.

With ata_piix:
[    9.984000] ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140b0 irq 14
[    9.984000] ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140b8 irq 15
[    9.984000] scsi0 : ata_piix
[   10.304000] ata1.00: ATAPI, max UDMA/66
[   10.468000] ata1.00: configured for UDMA/66
[   10.468000] scsi1 : ata_piix
[   10.632000] ATA: abnormal status 0x7F on port 0x00010177
[   10.636000] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
[   10.636000] ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
[   10.636000] ata_piix 0000:00:1f.2: invalid MAP value 0
[   10.792000] ata3: SATA max UDMA/133 cmd 0x000140c8 ctl 0x000140e6 bmdma 0x000140a0 irq 20
[   10.792000] ata4: SATA max UDMA/133 cmd 0x000140c0 ctl 0x000140e2 bmdma 0x000140a8 irq 20
[   10.792000] scsi2 : ata_piix
[   10.948000] ATA: abnormal status 0x7F on port 0x000140cf
[   10.964000] ATA: abnormal status 0x7F on port 0x000140cf
[   10.972000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 16337840
[   10.972000] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[   10.972000] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   10.980000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = -1342616656
[   10.980000] ata3.01: Host Protected Area detected:
[   10.980000] 	current size: 234441648 sectors
[   10.980000] 	native size: -1342616656 sectors
[   10.980000] ata3.01: configured for UDMA/100
[   10.980000] scsi3 : ata_piix
[   11.136000] ATA: abnormal status 0x7F on port 0x000140c7
[   11.140000] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5

With ahci:
[   10.052000] libata version 2.20 loaded.
[   10.052000] ahci 0000:00:1f.2: version 2.1
[   10.052000] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 20
[   11.056000] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   11.056000] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x4 impl IDE mode
[   11.056000] ahci 0000:00:1f.2: flags: 64bit ncq ilck pm led clo pio slum part 
[   11.056000] ata1: SATA max UDMA/133 cmd 0xf88a8100 ctl 0x00000000 bmdma 0x00000000 irq 20
[   11.056000] ata2: SATA max UDMA/133 cmd 0xf88a8180 ctl 0x00000000 bmdma 0x00000000 irq 20
[   11.056000] ata3: SATA max UDMA/133 cmd 0xf88a8200 ctl 0x00000000 bmdma 0x00000000 irq 20
[   11.056000] ata4: SATA max UDMA/133 cmd 0xf88a8280 ctl 0x00000000 bmdma 0x00000000 irq 20
[   11.056000] scsi0 : ahci
[   11.300000] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0017f2fffe812952]
[   11.368000] ata1: SATA link down (SStatus 0 SControl 0)
[   11.368000] scsi1 : ahci
[   11.680000] ata2: SATA link down (SStatus 0 SControl 0)
[   11.680000] scsi2 : ahci
[   12.164000] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   12.164000] ata3.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[   12.164000] ata3.00: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[   12.164000] ata3.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   12.164000] ata3.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[   12.164000] ata3.00: configured for UDMA/100
[   12.164000] scsi3 : ahci
[   12.476000] ata4: SATA link down (SStatus 0 SControl 0)
[   12.476000] scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
[   12.476000] ata_piix 0000:00:1f.1: version 2.10ac1
[   12.476000] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[   12.476000] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   12.476000] ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140b0 irq 14
[   12.476000] ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140b8 irq 15
[   12.476000] scsi4 : ata_piix
[   12.480000] SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)

