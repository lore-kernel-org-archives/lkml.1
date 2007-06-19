Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXFSNse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXFSNse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXFSNs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:48:26 -0400
Received: from nn7.de ([85.214.94.156]:46359 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbXFSNsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:48:25 -0400
Subject: ata1: soft resetting port
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Jun 2007 15:48:22 +0200
Message-Id: <1182260902.14805.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear List,

since the switch to 

CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_ATA_PIIX=y,

the ATA_PIIX driver manages both, internal sata disk aswell as cd/dvd
rom. However I am being flooded with the error messages below (well they
appear from time to time, dominating dmesg). 

This happens on kernel 2.6.22-rc5, I am copying relevant parts from dmesg:

libata version 2.21 loaded.
ata_piix 0000:00:1f.1: version 2.11
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140c0 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140c8 irq 15
ata1.00: ATAPI: HL-DT-ST DVDRW GWA4080M, AA26, max UDMA/33
ata1.00: configured for UDMA/33
ATA: abnormal status 0x7F on port 0x00010177
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRW GWA4080M   AA26 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
ata_piix 0000:00:1f.2: invalid MAP value 0
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x000140d8 ctl 0x000140f6 bmdma 0x00014020 irq 0
ata4: SATA max UDMA/133 cmd 0x000140d0 ctl 0x000140f2 bmdma 0x00014028 irq 0
ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
ata3.01: ATA-7: ST9120821AS, 7.01, max UDMA/133
ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
ata3.01: configured for UDMA/133
ATA: abnormal status 0x7F on port 0x000140d7


the actual errors:


ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
         res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x5)
ata1.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x25 data 8 in
         res 00/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
         res 00/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x5)
ata1.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x25 data 8 in
         res 00/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x5)
ata1.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
         res 00/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
         res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA stat 0x5)
ata1.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x25 data 8 in
         res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x5)
ata1.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
         res 00/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata1: soft resetting port

-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
