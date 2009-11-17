Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZKQNtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZKQNtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZKQNtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:49:18 -0500
Received: from huecha.unizar.es ([155.210.1.51]:52672 "EHLO huecha.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZKQNtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:49:17 -0500
X-Greylist: delayed 1669 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 08:49:17 EST
From: "=?utf-8?Q?=22J.A._Magall=C3=B3n=22?=" <jamagallon@ono.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Out of order kernel messages in sd detection
Date: Tue, 17 Nov 2009 14:21:22 +0100
Message-Id: <C991F902-ED0F-44B5-8326-DB51C2E0C899@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

In latest kernels, I have a strage ordering in info about deteted disks.
I think it can lead to confussion, as it happened to me (i was trying to solve
another different problem...).
Look at this:

Linux version 2.6.31.6-desktop-0.rc1.1mnb (herton@n2.mandriva.com) (gcc version 4.4.1 (GCC) ) #1 SMP Mon Nov 9 15:27:49 EST 2009
...
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata_piix 0000:00:1f.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xda00 ctl 0xdb00 bmdma 0xde00 irq 18
ata4: SATA max UDMA/133 cmd 0xdc00 ctl 0xdd00 bmdma 0xde08 irq 18
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4120B, A117, max UDMA/33
ata2.00: configured for UDMA/33
ata1.00: ATA-6: ST340014A, 8.01, max UDMA/100
ata1.00: 78165360 sectors, multi 16: LBA48 
ata1.01: ATA-6: ST3120022A, 3.76, max UDMA/100
ata1.01: 234441648 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST340014A        8.01 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     ATA      ST3120022A       3.76 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:                                <============ LOOK HERE !!!! ==========
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4120B A117 PQ: 0 ANSI: 5
sd 0:0:1:0: [sdb] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sda1 sda2                      <============ AND HERE !!!! ===========
 sdb1                                <============ AND HERE !!!! ===========
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:0:0: [sda] Attached SCSI disk
...

Looks like partition detection is done in parallel, and some locking is
needed in the messages....

And, BTW, would sometime the numbering in ataX be made consistent with
SCSI ( ie, ata1 is scsi0....). It's really a mess...

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free




