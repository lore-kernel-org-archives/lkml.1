Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYIOIJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYIOIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYIOIJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:09:14 -0400
Received: from smtp2.ono.com ([62.42.230.20]:13600 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751665AbYIOIJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:09:12 -0400
Date: Mon, 15 Sep 2008 10:09:09 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Linux-IDE <linux-ide@vger.kernel.org>
Subject: libata flooding syslog
Message-ID: <20080915100909.79c1d67b@werewolf.home>
X-Mailer: Claws Mail 3.5.0cvs103 (GTK+ 2.14.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

Since some days ago I have notcied my 64bit cooker box was too slow,
for example, to perform an urpmi update.
Looking at dmesg/syslog, I have seen an strange message:

ata4: EH pending after 5 tries, giving up
ata4: EH complete
ata3: EH pending after 5 tries, giving up
ata3: EH complete
ata2: EH complete
ata4: EH pending after 5 tries, giving up
ata4: EH complete
ata3: EH pending after 5 tries, giving up
ata3: EH complete

It repeats continuously. But there is nothing attached to ata > 1.
It looks like a bug in sata_nv, it keeps polling non present devices or
something like that.
Kernel is kernel-desktop-2.6.27-0.rc6.1mnb-1-1mnb2 (the mandriva kernel, but
if this is not a know bug I can try a plain rc6 kernel).
Some info comes below.

Any ideas ? Known bug in mainline ?

cicely:/var/log# lspci
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation G80 [GeForce 8800 GTX] (rev a2)
80:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
80:01.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
80:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
80:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
80:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
80:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
80:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)

cicely:/var/log# lsscsi
[0:0:0:0]    disk    ATA      MAXTOR STM332062 3.AA  /dev/sda
[9:0:0:0]    cd/dvd  PIONEER  DVD-RW  DVR-112D 1.21  /dev/sr0

dmesg on boot:

libata version 3.00 loaded.
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 22
sata_nv 0000:00:07.0: PCI INT A -> Link[LTID] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:07.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb800 irq 22
ata2: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb808 irq 22
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: MAXTOR STM3320620AS, 3.AAE, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM332062 3.AA PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LTIE] enabled at IRQ 21
sata_nv 0000:00:08.0: PCI INT A -> Link[LTIE] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:08.0: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xb400 ctl 0xb000 bmdma 0xa400 irq 21
ata4: SATA max UDMA/133 cmd 0xac00 ctl 0xa800 bmdma 0xa408 irq 21
ACPI: PCI Interrupt Link [LT3D] enabled at IRQ 47
sata_nv 0000:80:07.0: PCI INT A -> Link[LT3D] -> GSI 47 (level, low) -> IRQ 47
sata_nv 0000:80:07.0: setting latency timer to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xf800 ctl 0xf400 bmdma 0xe800 irq 47
ata6: SATA max UDMA/133 cmd 0xf000 ctl 0xec00 bmdma 0xe808 irq 47
ACPI: PCI Interrupt Link [LT2E] enabled at IRQ 46
sata_nv 0000:80:08.0: PCI INT A -> Link[LT2E] -> GSI 46 (level, low) -> IRQ 46
sata_nv 0000:80:08.0: setting latency timer to 64
scsi6 : sata_nv
scsi7 : sata_nv
ata7: SATA max UDMA/133 cmd 0xe400 ctl 0xe000 bmdma 0xd400 irq 46
ata8: SATA max UDMA/133 cmd 0xdc00 ctl 0xd800 bmdma 0xd408 irq 46
pata_amd 0000:00:06.0: version 0.3.10
pata_amd 0000:00:06.0: setting latency timer to 64
scsi8 : pata_amd
scsi9 : pata_amd
ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x3000 irq 14
ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x3008 irq 15
ata10.00: ATAPI: PIONEER DVD-RW  DVR-112D, 1.21, max UDMA/66
ata10: nv_mode_filter: 0x1f39f&0x1f01f->0x1f01f, BIOS=0x1f000 (0xc500) ACPI=0x1f
ata10.00: configured for UDMA/66
scsi 9:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-112D 1.21 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
