Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXCZAYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXCZAYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXCZAYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:24:36 -0400
Received: from smtp.ono.com ([62.42.230.12]:36448 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933214AbXCZAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:24:35 -0400
Date: Mon, 26 Mar 2007 02:24:20 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Wrong IDE cable detection in libata [Re: 2.6.21-rc4-mm1]
Message-ID: <20070326022420.224cc4f2@werewolf-wl>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1cvs51 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 

Libata seems to misdetect my cable.
I have double-checked and the cable is 80 pin...

ata1 is PATA ICH5 bus 1 with DVD-RW + ZIP and 40 pin cable
ata2 is PATA ICH5 bus 2 with extra HD + DVD and 80 pin cable
ata3 is real SATA ICH5 with boot HD

(mm, I chaged bios settings to get the box booting from the SATA disk)

werewolf:~# lsscsi
[0:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL12  /dev/.tmp-11-0
[0:0:1:0]    disk    IOMEGA   ZIP 250          51.G  /dev/sda
[1:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdb
[1:0:1:0]    cd/dvd  TOSHIBA  DVD-ROM SD-M1712 1004  /dev/sr1
[2:0:0:0]    disk    ATA      ST3200822AS      3.01  /dev/sdc

ata_piix 0000:00:1f.1: version 2.10ac1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
scsi0 : ata_piix
ata1.00: ATAPI, max UDMA/33
ata1.01: ATAPI, max MWDMA0, CDB intr
ata1.00: configured for UDMA/33
ata1.01: configured for PIO3
scsi1 : ata_piix
ata2.00: ATA-6: ST3120022A, 3.06, max UDMA/100
ata2.00: 234441648 sectors, multi 16: LBA48
ata2.01: ATAPI, max UDMA/33
ata2.00: limited to UDMA/33 due to 40-wire cable    <=======================
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-H10N  JL12 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
scsi 0:0:1:0: Direct-Access     IOMEGA   ZIP 250          51.G PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] Attached SCSI removable disk
scsi 1:0:0:0: Direct-Access     ATA      ST3120022A       3.06 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 1:0:1:0: CD-ROM            TOSHIBA  DVD-ROM SD-M1712 1004 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr 1:0:1:0: Attached scsi CD-ROM sr1

Any ideas ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
