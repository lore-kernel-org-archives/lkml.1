Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbXBIVee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbXBIVee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXBIVee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:34:34 -0500
Received: from ns01.unsolicited.net ([69.10.132.115]:3966 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbXBIVed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:34:33 -0500
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 16:34:33 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=YL15+07B+cUWor9+MRb6s9PN8EausJ+V1gTT6F43eusuMg7cw1X4bC9geIA6tQw+7QoMxHcomIssgggCKfteK/lqRBKWK1h+haEi3Y2aFiOqW+b4q7cok/5S8PV8gznaizvQUWDigHVzZSkhwY1iTiPi9b1OMHLS6O0okwUlls8=;
Message-ID: <45CCE392.6060809@unsolicited.net>
Date: Fri, 09 Feb 2007 21:11:46 +0000
From: David R <david@unsolicited.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_nv - ADMA issues with 2.6.20
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just upgraded my home server to 2.6.20. It's got an Athlon64 on an ASUS
nForce-4 motherboard running a 32 bit kernel. I've had to fall back to using
sata_nv.adma=0 on the kernel command line. One of the NCQ capable drives
repeatedly produced the following errors. There wasn't much disk IO going on
at the time. It's perfectly happy now with ADMA disabled. Strange thing is the
other identical drive ata8 showed no problems (they're both part of a software
raid1)

Some clues follow.

Cheers
David

>> Feb  9 18:40:27 server kernel: ata7: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400
>> Feb  9 18:40:27 server kernel: ata7: CPB 0: ctl_flags 0x1f, resp_flags 0x0
>> Feb  9 18:40:27 server kernel: ata7: CPB 1: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:40:27 server kernel: ata7: CPB 2: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:40:27 server kernel: ata7: CPB 3: ctl_flags 0x1f, resp_flags 0x1
etc etc..
>> Feb  9 18:40:29 server kernel: ata7: CPB 27: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:40:29 server kernel: ata7: CPB 28: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:40:29 server kernel: ata7: CPB 29: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:40:29 server kernel: ata7: CPB 30: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:40:29 server kernel: ata7: Resetting port
>> Feb  9 18:40:29 server kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
>> Feb  9 18:40:29 server kernel: ata7.00: cmd 61/08:00:1f:e4:50/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 out
>> Feb  9 18:40:29 server kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Feb  9 18:40:29 server kernel: ata7: soft resetting port
>> Feb  9 18:40:29 server kernel: ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> Feb  9 18:40:29 server kernel: ata7.00: configured for UDMA/133
>> Feb  9 18:40:29 server kernel: ata7: EH complete
>> Feb  9 18:40:29 server kernel: SCSI device sdg: 156301488 512-byte hdwr sectors (80026 MB)
>> Feb  9 18:40:29 server kernel: sdg: Write Protect is off
>> Feb  9 18:40:29 server kernel: sdg: Mode Sense: 00 3a 00 00
>> Feb  9 18:40:29 server kernel: SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

eventually bringing the speed down

>> Feb  9 18:47:36 server kernel: ata7: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400
>> Feb  9 18:47:36 server kernel: ata7: CPB 0: ctl_flags 0x1f, resp_flags 0x0
>> Feb  9 18:47:36 server kernel: ata7: CPB 1: ctl_flags 0x1f, resp_flags 0x1
> ....
>> Feb  9 18:47:36 server kernel: ata7: CPB 29: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:47:36 server kernel: ata7: CPB 30: ctl_flags 0x1f, resp_flags 0x1
>> Feb  9 18:47:36 server kernel: ata7: Resetting port
>> Feb  9 18:47:36 server kernel: ata7.00: limiting speed to UDMA/100
>> Feb  9 18:47:36 server kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
>> Feb  9 18:47:36 server kernel: ata7.00: cmd 61/08:00:1f:e4:50/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 out
>> Feb  9 18:47:36 server kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Feb  9 18:47:36 server kernel: ata7: soft resetting port
>> Feb  9 18:47:36 server kernel: ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> Feb  9 18:47:36 server kernel: ata7.00: configured for UDMA/100
>> Feb  9 18:47:36 server kernel: ata7: EH complete
>> Feb  9 18:47:36 server kernel: SCSI device sdg: 156301488 512-byte hdwr sectors (80026 MB)
>> Feb  9 18:47:36 server kernel: sdg: Write Protect is off
>> Feb  9 18:47:36 server kernel: sdg: Mode Sense: 00 3a 00 00
>> Feb  9 18:47:36 server kernel: SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

All the way to UDMA/33

>> Feb  9 19:47:38 server kernel: ata7: Resetting port
>> Feb  9 19:47:38 server kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
>> Feb  9 19:47:38 server kernel: ata7.00: cmd 61/08:00:1f:e4:50/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 out
>> Feb  9 19:47:38 server kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Feb  9 19:47:38 server kernel: ata7: soft resetting port
>> Feb  9 19:47:39 server kernel: ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> Feb  9 19:47:39 server kernel: ata7.00: configured for UDMA/33
>> Feb  9 19:47:39 server kernel: ata7: EH complete
>> Feb  9 19:47:39 server kernel: SCSI device sdg: 156301488 512-byte hdwr sectors (80026 MB)
>> Feb  9 19:47:39 server kernel: sdg: Write Protect is off
>> Feb  9 19:47:39 server kernel: sdg: Mode Sense: 00 3a 00 00
>> Feb  9 19:47:39 server kernel: SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

relevant dmesg follows

>> <6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>> <6>NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
>> <6>NFORCE-CK804: chipset revision 242
>> <6>NFORCE-CK804: not 100%% native mode: will probe irqs later
>> <6>NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
>> <6>    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
>> <6>    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
>> <7>Probing IDE interface ide0...
>> <4>hda: PIONEER DVD-RW DVR-107D, ATAPI CD/DVD-ROM drive
>> <4>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>> <7>Probing IDE interface ide1...
>> <7>Probing IDE interface ide1...
>> <6>hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
>> <6>Uniform CD-ROM driver Revision: 3.20
>> <6>megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
>> <6>megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
>> <7>sata_sil 0000:05:0a.0: version 2.0
>> <6>ACPI: PCI Interrupt 0000:05:0a.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 20
>> <6>sata_sil 0000:05:0a.0: Applying R_ERR on DMA activate FIS errata fix
>> <6>ata1: SATA max UDMA/100 cmd 0xF882E080 ctl 0xF882E08A bmdma 0xF882E000 irq 20
>> <6>ata2: SATA max UDMA/100 cmd 0xF882E0C0 ctl 0xF882E0CA bmdma 0xF882E008 irq 20
>> <6>ata3: SATA max UDMA/100 cmd 0xF882E280 ctl 0xF882E28A bmdma 0xF882E200 irq 20
>> <6>ata4: SATA max UDMA/100 cmd 0xF882E2C0 ctl 0xF882E2CA bmdma 0xF882E208 irq 20
>> <6>scsi0 : sata_sil
>> <6>ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> <6>ata1.00: ATA-7, max UDMA/133, 586114704 sectors: LBA48 NCQ (depth 0/32)
>> <6>ata1.00: ata1: dev 0 multi count 16
>> <6>ata1.00: configured for UDMA/100
>> <6>scsi1 : sata_sil
>> <6>ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> <6>ata2.00: ATA-7, max UDMA/133, 586072368 sectors: LBA48 NCQ (depth 0/32)
>> <6>ata2.00: ata2: dev 0 multi count 16
>> <6>ata2.00: configured for UDMA/100
>> <6>scsi2 : sata_sil
>> <6>ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> <6>ata3.00: ATA-7, max UDMA/133, 586072368 sectors: LBA48 NCQ (depth 0/32)
>> <6>ata3.00: ata3: dev 0 multi count 16
>> <6>ata3.00: configured for UDMA/100
>> <6>scsi3 : sata_sil
>> <6>ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>> <6>ata4.00: ATA-7, max UDMA/133, 586114704 sectors: LBA48 NCQ (depth 0/32)
>> <6>ata4.00: ata4: dev 0 multi count 16
>> <6>ata4.00: configured for UDMA/100
>> <5>scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L300S0   BACE PQ: 0 ANSI: 5
>> <5>SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
>> <5>sda: Write Protect is off
>> <7>sda: Mode Sense: 00 3a 00 00
>> <5>SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
>> <5>sda: Write Protect is off
>> <7>sda: Mode Sense: 00 3a 00 00
>> <5>SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sda: sda1
>> <5>sd 0:0:0:0: Attached scsi disk sda
>> <5>sd 0:0:0:0: Attached scsi generic sg0 type 0
>> <5>scsi 1:0:0:0: Direct-Access     ATA      ST3300831AS      3.03 PQ: 0 ANSI: 5
>> <5>SCSI device sdb: 586072368 512-byte hdwr sectors (300069 MB)
>> <5>sdb: Write Protect is off
>> <7>sdb: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sdb: 586072368 512-byte hdwr sectors (300069 MB)
>> <5>sdb: Write Protect is off
>> <7>sdb: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sdb: sdb1
>> <5>sd 1:0:0:0: Attached scsi disk sdb
>> <5>sd 1:0:0:0: Attached scsi generic sg1 type 0
>> <5>scsi 2:0:0:0: Direct-Access     ATA      ST3300831AS      3.03 PQ: 0 ANSI: 5
>> <5>SCSI device sdc: 586072368 512-byte hdwr sectors (300069 MB)
>> <5>sdc: Write Protect is off
>> <7>sdc: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sdc: 586072368 512-byte hdwr sectors (300069 MB)
>> <5>sdc: Write Protect is off
>> <7>sdc: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sdc: sdc1
>> <5>sd 2:0:0:0: Attached scsi disk sdc
>> <5>sd 2:0:0:0: Attached scsi generic sg2 type 0
>> <5>scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6L300S0   BACE PQ: 0 ANSI: 5
>> <5>SCSI device sdd: 586114704 512-byte hdwr sectors (300091 MB)
>> <5>sdd: Write Protect is off
>> <7>sdd: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sdd: 586114704 512-byte hdwr sectors (300091 MB)
>> <5>sdd: Write Protect is off
>> <7>sdd: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sdd: sdd1
>> <5>sd 3:0:0:0: Attached scsi disk sdd
>> <5>sd 3:0:0:0: Attached scsi generic sg3 type 0
>> <7>sata_nv 0000:00:07.0: version 3.2
>> <4>ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
>> <6>ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 21
>> <5>sata_nv 0000:00:07.0: Using ADMA mode
>> <7>PCI: Setting latency timer of device 0000:00:07.0 to 64
>> <6>ata5: SATA max UDMA/133 cmd 0xF8836480 ctl 0xF88364A0 bmdma 0xD800 irq 21
>> <6>ata6: SATA max UDMA/133 cmd 0xF8836580 ctl 0xF88365A0 bmdma 0xD808 irq 21
>> <6>scsi4 : sata_nv
>> <6>ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> <6>ata5.00: ATA-7, max UDMA/133, 586114704 sectors: LBA48 NCQ (depth 31/32)
>> <6>ata5.00: ata5: dev 0 multi count 1
>> <6>ata5.00: configured for UDMA/133
>> <6>scsi5 : sata_nv
>> <6>ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> <6>ata6.00: ATA-6, max UDMA/100, 488397168 sectors: LBA48
>> <6>ata6.00: ata6: dev 0 multi count 1
>> <6>ata6.00: configured for UDMA/100
>> <5>scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6L300S0   BACE PQ: 0 ANSI: 5
>> <6>ata5: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
>> <5>SCSI device sde: 586114704 512-byte hdwr sectors (300091 MB)
>> <5>sde: Write Protect is off
>> <7>sde: Mode Sense: 00 3a 00 00
>> <5>SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sde: 586114704 512-byte hdwr sectors (300091 MB)
>> <5>sde: Write Protect is off
>> <7>sde: Mode Sense: 00 3a 00 00
>> <5>SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sde: sde1
>> <5>sd 4:0:0:0: Attached scsi disk sde
>> <5>sd 4:0:0:0: Attached scsi generic sg4 type 0
>> <5>scsi 5:0:0:0: Direct-Access     ATA      HDS722525VLSA80  V36O PQ: 0 ANSI: 5
>> <6>ata6: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
>> <5>SCSI device sdf: 488397168 512-byte hdwr sectors (250059 MB)
>> <5>sdf: Write Protect is off
>> <7>sdf: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sdf: 488397168 512-byte hdwr sectors (250059 MB)
>> <5>sdf: Write Protect is off
>> <7>sdf: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sdf: sdf1
>> <5>sd 5:0:0:0: Attached scsi disk sdf
>> <5>sd 5:0:0:0: Attached scsi generic sg5 type 0
>> <4>ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
>> <6>ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 22
>> <5>sata_nv 0000:00:08.0: Using ADMA mode
>> <7>PCI: Setting latency timer of device 0000:00:08.0 to 64
>> <6>ata7: SATA max UDMA/133 cmd 0xF883E480 ctl 0xF883E4A0 bmdma 0xC400 irq 22
>> <6>ata8: SATA max UDMA/133 cmd 0xF883E580 ctl 0xF883E5A0 bmdma 0xC408 irq 22
>> <6>scsi6 : sata_nv
>> <6>ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> <6>ata7.00: ATA-6, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 31/32)
>> <6>ata7.00: ata7: dev 0 multi count 1
>> <6>ata7.00: configured for UDMA/133
>> <6>scsi7 : sata_nv
>> <6>ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> <6>ata8.00: ATA-6, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 31/32)
>> <6>ata8.00: ata8: dev 0 multi count 1
>> <6>ata8.00: configured for UDMA/133
>> <5>scsi 6:0:0:0: Direct-Access     ATA      ST380817AS       3.42 PQ: 0 ANSI: 5
>> <6>ata7: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
>> <5>SCSI device sdg: 156301488 512-byte hdwr sectors (80026 MB)
>> <5>sdg: Write Protect is off
>> <7>sdg: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sdg: 156301488 512-byte hdwr sectors (80026 MB)
>> <5>sdg: Write Protect is off
>> <7>sdg: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sdg: sdg1 sdg2 sdg3
>> <5>sd 6:0:0:0: Attached scsi disk sdg
>> <5>sd 6:0:0:0: Attached scsi generic sg6 type 0
>> <5>scsi 7:0:0:0: Direct-Access     ATA      ST380817AS       3.42 PQ: 0 ANSI: 5
>> <6>ata8: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
>> <5>SCSI device sdh: 156301488 512-byte hdwr sectors (80026 MB)
>> <5>sdh: Write Protect is off
>> <7>sdh: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <5>SCSI device sdh: 156301488 512-byte hdwr sectors (80026 MB)
>> <5>sdh: Write Protect is off
>> <7>sdh: Mode Sense: 00 3a 00 00
>> <5>SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> <6> sdh: sdh1 sdh2 sdh3
>> <5>sd 7:0:0:0: Attached scsi disk sdh
>> <5>sd 7:0:0:0: Attached scsi generic sg7 type 0


