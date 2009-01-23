Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZAWXwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZAWXwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZAWXwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:52:33 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:52385 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZAWXwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:52:33 -0500
Message-ID: <497A5836.2070904@lwfinger.net>
Date: Fri, 23 Jan 2009 17:52:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-ide@vger.kernel.org
Subject: v2.6.29-rc2 gets HSM violations for CD drive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometime since v2.6.28, one of my systems started getting libata
errors for my CD drive.

I have started bisecting this problem, but that system is very slow so
it will likely take a while.

The ide/ata parts of the dmesg output:

=============================

SCSI subsystem initialized
libata version 3.00 loaded.
pata_ali 0000:00:0f.0: can't derive routing for PCI INT A
pata_ali 0000:00:0f.0: setting latency timer to 64
scsi0 : pata_ali
scsi1 : pata_ali
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc90 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xfc98 irq 15
ata1.00: ATA-6: HTS541010G9AT00, MBZOA60A, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48
ata1.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9AT00  MBZO PQ: 0
ANSI: 5
ata2.00: ATAPI: SR242S, z03, max MWDMA2
ata2.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be
enabled
ata2.00: WARNING: via pata_ali.atapi_dma modparam or corresponding
sysfs node.
ata2.00: configured for PIO4
scsi 1:0:0:0: CD-ROM            MITSUMI  CD-ROM SR242S !A z03  PQ: 0
ANSI: 5
Uniform Multi-Platform E-IDE driver
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
udevd version 128 started
ACPI: EC: missing confirmations, switch off interrupt mode.
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EXT3 (no)acl options not supported
EXT3 (no)user_xattr options not supported
udevd version 128 started
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Driver 'sr' needs updating - please use bus_type methods
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x3 (HSM violation)
ata2.00: status: { DRDY ERR }
ata2: soft resetting link
ata2.00: configured for PIO4
ata2: EH complete
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x3 (HSM violation)
ata2.00: status: { DRDY ERR }
ata2: soft resetting link

