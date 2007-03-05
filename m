Return-Path: <linux-kernel-owner+w=401wt.eu-S1751060AbXCEAwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbXCEAwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXCEAwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:52:22 -0500
Received: from postfix2-g20.free.fr ([212.27.60.43]:50202 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXCEAwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:52:21 -0500
Message-ID: <45EB6980.90600@crans.org>
Date: Mon, 05 Mar 2007 01:51:12 +0100
From: =?UTF-8?B?TWF0aGlldSBCw6lyYXJk?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-ide@vger.kernel.org
Subject: Regression between 2.6.20 and 2.6.21-rc1: NCQ problem with ahci and
 Hitachi drive
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have and laptop with an ICH6M SATA Controller and an Hitachi hard drive.
While it worked well using the ahci module and with NCQ enabled using
Linux 2.6.20, it does not work anymore (hang at boot) with 2.6.21-rc*

My drive is among those that were recently blacklisted (see lkml post
"[PATCH] libata:
add NCQ blacklist entries from Silicon Image Windowsdriver)
(Model Number: HTS541010G9SA00 and Firmware Revision: MBZOC60D)
This blacklisting patch is in -mm now.
So there is probably a drive related issue here, I'm just wondering why
it just work
flawlessly with a 2.6.20...

Relevant part of kernel log:
2.6.20:
[   41.076963] SCSI subsystem initialized
[   41.083119] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[   42.083637] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5
Gbps 0x5 impl IDE mode
[   42.083695] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
[   42.083825] ata1: SATA max UDMA/133 cmd 0xF8872D00 ctl 0x0 bmdma 0x0
irq 19
[   42.083938] ata2: SATA max UDMA/133 cmd 0xF8872D80 ctl 0x0 bmdma 0x0
irq 19
[   42.084049] ata3: SATA max UDMA/133 cmd 0xF8872E00 ctl 0x0 bmdma 0x0
irq 19
[   42.084165] ata4: SATA max UDMA/133 cmd 0xF8872E80 ctl 0x0 bmdma 0x0
irq 19
[   42.084221] scsi0 : ahci
[   42.541356] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   42.542404] ata1.00: ATA-7, max UDMA/100, 195371568 sectors: LBA48
NCQ (depth 31/32)
[   42.542460] ata1.00: ata1: dev 0 multi count 0
[   42.543731] ata1.00: configured for UDMA/100
[   42.543781] scsi1 : ahci
[   42.846169] ata2: SATA link down (SStatus 0 SControl 0)
[   42.846223] scsi2 : ahci
[   43.148995] ata3: SATA link down (SStatus 0 SControl 300)
[   43.149049] scsi3 : ahci
[   43.451821] ata4: SATA link down (SStatus 0 SControl 0)
[   43.451957] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00 
MBZO PQ: 0 ANSI: 5
[   43.487465] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   43.487544] sda: Write Protect is off
[   43.487810] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   43.488805] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   43.488879] sda: Write Protect is off
[   43.489462] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

2.6.21-rc1:
[   14.580991] SCSI subsystem initialized
[   14.586026] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[   15.586790] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5
Gbps 0x5 impl IDE mode
[   15.586847] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
[   15.586974] ata1: SATA max UDMA/133 cmd 0xf8824d00 ctl 0x00000000
bmdma 0x00000000 irq 19
[   15.587093] ata2: SATA max UDMA/133 cmd 0xf8824d80 ctl 0x00000000
bmdma 0x00000000 irq 19
[   15.587211] ata3: SATA max UDMA/133 cmd 0xf8824e00 ctl 0x00000000
bmdma 0x00000000 irq 19
[   15.587331] ata4: SATA max UDMA/133 cmd 0xf8824e80 ctl 0x00000000
bmdma 0x00000000 irq 19
[   15.587394] scsi0 : ahci
[   16.044663] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   16.089475] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
[   16.089525] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   16.091804] ata1.00: configured for UDMA/100
[   16.091855] scsi1 : ahci
[   16.394567] ata2: SATA link down (SStatus 0 SControl 0)
[   16.394620] scsi2 : ahci
[   16.697494] ata3: SATA link down (SStatus 0 SControl 300)
[   16.697547] scsi3 : ahci
[   17.000422] ata4: SATA link down (SStatus 0 SControl 0)
[   17.000552] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00 
MBZO PQ: 0 ANSI: 5
[....]
[   18.151756] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   18.151856] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   18.151911] sda: Write Protect is off
[   18.151977] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[....]
[   48.143940] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[   48.143999] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[   48.144000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   48.446854] ata1: soft resetting port
[   48.601835] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   48.607218] ata1.00: configured for UDMA/100
[   48.607272] ata1: EH complete
[   48.607355] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   48.607411] sda: Write Protect is off
[   48.607478] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   78.599605] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[   78.599659] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[   78.599661]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   78.902526] ata1: soft resetting port
[   79.057505] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   79.062836] ata1.00: configured for UDMA/100
[   79.062887] ata1: EH complete
[   79.062957] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   79.063011] sda: Write Protect is off
[   79.063077] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  109.055268] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[  109.055324] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[  109.055325]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  109.358190] ata1: soft resetting port
[  109.513168] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  109.518528] ata1.00: configured for UDMA/100
[  109.518579] ata1: EH complete
[  109.518648] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[  109.518703] sda: Write Protect is off
[  109.518769] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[looping forever with this error]

Thanks.
(Please CC me)
-- 
Mathieu Bérard
