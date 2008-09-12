Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYILAGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYILAGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYILAGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:06:35 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:12412 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYILAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:06:34 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=kQClJZ_Tad0PbbvEho8A:9 a=1IwCd_yZCUFYAjVzB6YA:7 a=Wdd0-MFyE3gX8FGrk14wshNWGCIA:4 a=ObQG5Uc_XFcA:10 a=6TOxP3HYYZQA:10
Message-ID: <48C9B284.5000109@shaw.ca>
Date: Thu, 11 Sep 2008 18:06:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hard drive not seen by mount when booting using busybox/initrd
 under 2.6.27-2-generic (Ubuntu)
References: <fa.MvWZ/xec9z3nsf+J9z2h7HMQv8U@ifi.uio.no>
In-Reply-To: <fa.MvWZ/xec9z3nsf+J9z2h7HMQv8U@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> I get the messages below during the setup of the drives on my machine.
>  Is the kernel failing to set up my drives correctly?  One clue is
> that it looks as though perhaps BOTH pata_acpi and ata_piix are trying
> to handle the hard drives interface???  I am also puzzled by the line
> "sda:<6>ata5.00: ATAPI: Optiarc DVD RW AD-7530A", which seems to
> indicate that sda is somehow getting confused with my DVD-RW drive.

That's just two kernel messages stomping on top of each other.

> 
> I get a similar problem when I compile and test a 2.6.27-rc6 kernel.
> The only difference is that I also see a message saying that my
> modules cannot be found before the mount error occurs.
> 
> I tried mounting partitions from my drive from the command line and
> all attempts gave the same error:  "device not found".

There doesn't seem like there's anything wrong here, the /dev/sda device 
should be available. Unless there's some kind of udev problem or 
something that's screwing up the device nodes..

> 
> [    4.459717] ata1: SATA max UDMA/133 abar m1024@0xd8444400 port
> 0xd8444500 irq 2301
> [    4.459720] ata2: DUMMY
> [    4.459723] ata3: SATA max UDMA/133 abar m1024@0xd8444400 port
> 0xd8444600 irq 2301
> [    4.459726] ata4: DUMMY
> [    5.056152] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    5.057177] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [    5.057342] ata1.00: ATA-7: Hitachi HTS541616J9SA00, SB4OC70P, max UDMA/100
> [    5.057345] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    5.058519] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [    5.058686] ata1.00: configured for UDMA/100
> [    5.392129] ata3: SATA link down (SStatus 0 SControl 300)
> [    5.408396] scsi 0:0:0:0: Direct-Access     ATA      Hitachi
> HTS54161 SB4O PQ: 0 ANSI: 5
> [    5.464760] pata_acpi 0000:00:1f.1: PCI INT B -> GSI 19 (level,
> low) -> IRQ 19
> [    5.464798] pata_acpi 0000:00:1f.1: setting latency timer to 64
> [    5.464821] pata_acpi 0000:00:1f.1: PCI INT B disabled
> [    5.468055] ata_piix 0000:00:1f.1: version 2.12
> [    5.468065] ata_piix 0000:00:1f.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    5.468109] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    5.468195] scsi4 : ata_piix
> [    5.468273] scsi5 : ata_piix
> [    5.469015] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
> [    5.469019] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
> [    5.478018] Driver 'sd' needs updating - please use bus_type methods
> [    5.478163] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> [    5.478192] sd 0:0:0:0: [sda] Write Protect is off
> [    5.478195] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.478240] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    5.478344] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> [    5.478369] sd 0:0:0:0: [sda] Write Protect is off
> [    5.478372] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.478418] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    5.478423]  sda:<6>ata5.00: ATAPI: Optiarc DVD RW AD-7530A, EX32,
> max UDMA/33
> [    5.648451] ata5.00: configured for UDMA/33
> [    5.648503] ata6: port disabled. ignoring.
> [    5.648548] isa bounce pool size: 16 pages
> [    5.649976] scsi 4:0:0:0: CD-ROM            Optiarc  DVD RW
> AD-7530A  EX32 PQ: 0 ANSI: 5
> [    5.661100] Driver 'sr' needs updating - please use bus_type methods
> [    5.879315]  sda1 sda2
> [    5.879493] sd 0:0:0:0: [sda] Attached SCSI disk
> [    5.886208] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    5.886253] sr 4:0:0:0: Attached scsi generic sg1 type 5
> [    5.894719] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
> xa/form2 cdda tray
> [    5.894725] Uniform CD-ROM driver Revision: 3.20
> [    5.894830] sr 4:0:0:0: Attached scsi CD-ROM sr0

