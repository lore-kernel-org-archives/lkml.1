Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYAHAud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYAHAud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYAHAuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:50:25 -0500
Received: from smtp.ono.com ([62.42.230.12]:32790 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752857AbYAHAuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:50:25 -0500
Date: Tue, 8 Jan 2008 01:50:12 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080108015012.2e518dd4@werewolf>
In-Reply-To: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.2.0cvs23 (GTK+ 2.12.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI all...

On Sun, 6 Jan 2008 14:19:16 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> It's been two weeks since rc6, but let's face it, with xmas and new years 
> (and birthdays) in between, there hasn't actually been a lot of working 
> days, and the incremental patch from -rc6 is about half the size of the 
> one from rc5->rc6.
> 
> And I'll be charitable and claim it's because it's all stabilizing, and 
> not because we've all been in a drunken stupor over the holidays.
> 
> The shortlog (appended below) is short and fairly informative. It's all 
> really just a lot of rather small changes. The diffstat shows a lot of 
> one- and two-liners, with just a few drivers (and the Cell platform) 
> getting a bit more attention, and the SLUB support of /proc/slabinfo 
> showing up as a blip.
> 

With this kernel I'm getting frequent temporary freezes (system comes
back responsive after a minute or so...). I see this in dmesg:

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ca/00:08:67:10:18/00:00:00:00:00/e2 tag 0 dma 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd c8/00:08:ef:0b:c7/00:00:00:00:00/e7 tag 0 dma 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: soft resetting link
ata4.00: configured for UDMA/133
ata4: EH complete
sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

See this are two different drives, I doubt both drives have gone nuts
at the same time...

Controllers:
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
03:04.0 RAID bus controller: Promise Technology, Inc. PDC20378 (FastTrak 378/SATA 378) (rev 02)

Drives (sda is PATA, sd[bcd] are SATA, 
werewolf:~> lsscsi
[0:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sda
[0:0:1:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL12  /dev/sr0
[2:0:0:0]    disk    ATA      ST3200822AS      3.01  /dev/sdb
[3:0:0:0]    disk    ATA      MAXTOR STM332082 3.AA  /dev/sdc
[4:0:0:0]    disk    ATA      Maxtor 7Y250M0   YAR5  /dev/sdd
werewolf:~> df
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sdb1     ext3     30G   11G   18G  38% /
/dev/sdb2     ext3    152G   71G   81G  47% /home
/dev/sdc1     ext3    294G   67G  212G  24% /home/store/media/music
/dev/sdd1     ext3    231G   42G  177G  20% /home/store/media/video
/dev/sda1     ext3    111G  887M  104G   1% /scratch


Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
ata1.00: ATA-6: ST3120022A, 3.06, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 
ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-H10N, JL12, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST3120022A       3.06 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-H10N  JL12 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xc000 ctl 0xc400 bmdma 0xd000 irq 16
ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xcc00 bmdma 0xd008 irq 16
ata3.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata3.00: 390721968 sectors, multi 16: LBA48 
ata3.00: configured for UDMA/133
ata4.00: ATA-7: MAXTOR STM3320820AS, 3.AAE, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 2:0:0:0: [sdb] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      MAXTOR STM332082 3.AA PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 3:0:0:0: [sdc] Attached SCSI disk
...
sata_promise 0000:03:04.0: version 2.11
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 23 (level, low) -> IRQ 17
scsi4 : sata_promise
scsi5 : sata_promise
scsi6 : sata_promise
ata5: SATA max UDMA/133 mmio m4096@0xf6026000 port 0xf6026200 irq 17
ata6: SATA max UDMA/133 mmio m4096@0xf6026000 port 0xf6026280 irq 17
ata7: PATA max UDMA/133 mmio m4096@0xf6026000 port 0xf6026300 irq 17
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7: Maxtor 7Y250M0, YAR51EW0, max UDMA/133
ata5.00: 490234752 sectors, multi 0: LBA48 
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 4:0:0:0: Direct-Access     ATA      Maxtor 7Y250M0   YAR5 PQ: 0 ANSI: 5
sd 4:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg4 type 0

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
