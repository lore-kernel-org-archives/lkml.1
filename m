Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZGTXD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZGTXD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZGTXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:03:26 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:54173 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZGTXDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:03:25 -0400
Message-ID: <4A64F7BA.2030900@technicalogic.com>
Date: Mon, 20 Jul 2009 18:03:22 -0500
From: Dwayne Rightler <drightler@technicalogic.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: No UDMA with BLK_DEV_IT821X with 2.6.30.2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a ITE8212 PCI card and it does not seem to allow UDMA on the 
drives attached.  The drives run at ATA100 under other controllers.

Dmesg:

[    3.029612] it821x 0000:01:07.0: IDE controller (0x1283:0x8212 rev 0x13)
[    3.029835] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    3.029840] pci 0000:01:07.0: PCI INT A -> Link[APC4] -> GSI 19 
(level, low) -> IRQ 19
[    3.029847] it821x 0000:01:07.0: controller in smart mode
[    3.029848] it821x 0000:01:07.0: 100% native mode on irq 19
[    3.029852]     ide1: BM-DMA at 0xcb00-0xcb07
[    3.029857]     ide2: BM-DMA at 0xcb08-0xcb0f
[    3.029859] Probing IDE interface ide1...
[    3.316151] hdc: ST3400633A, ATA DISK drive
[    3.652003] hdd: ST3400633A, ATA DISK drive
[    3.652018] hdc: Performing identify fixups.
[    3.652019] hdd: Performing identify fixups.
[    3.652022] hdc: MWDMA2 mode selected
[    3.652026] hdd: MWDMA2 mode selected
[    3.652028] Probing IDE interface ide2...
[    3.940151] hde: ST3400633A, ATA DISK drive
[    4.276003] hdf: ST3400633A, ATA DISK drive
[    4.276015] hde: Performing identify fixups.
[    4.276016] hdf: Performing identify fixups.
[    4.276019] hde: MWDMA2 mode selected
[    4.276023] hdf: MWDMA2 mode selected
[    4.276037] ide1 at 0xcf00-0xcf07,0xce02 on irq 19
[    4.276052] ide2 at 0xcd00-0xcd07,0xcc02 on irq 19
[    4.276187] ide_generic: please use "probe_mask=0x3f" module 
parameter for probing all legacy ISA IDE ports
[    4.276195] ide-gd driver 1.18
[    4.276210] hdc: max request size: 128KiB
[    4.276212] hdc: 781422768 sectors (400088 MB) w/16384KiB Cache, 
CHS=48641/255/63
[    4.276233]  hdc:<3>hdc: task_no_data_intr: status=0x51 { DriveReady 
SeekComplete Error }
[    4.280086] hdc: task_no_data_intr: error=0x04 { DriveStatusError }
[    4.280323] hdc: possibly failed opcode: 0x10
[    5.445905]  hdc1
[    5.445972] hdd: max request size: 128KiB
[    5.445974] hdd: 781422768 sectors (400088 MB) w/16384KiB Cache, 
CHS=48641/255/63
[    5.445989]  hdd:<3>hdd: task_no_data_intr: status=0x51 { DriveReady 
SeekComplete Error }
[    5.448080] hdd: task_no_data_intr: error=0x04 { DriveStatusError }
[    5.448314] hdd: possibly failed opcode: 0x10
[    6.609738]  hdd1
[    6.609795] hde: max request size: 128KiB
[    6.609797] hde: 781422768 sectors (400088 MB) w/16384KiB Cache, 
CHS=48641/255/63
[    6.609813]  hde:<3>hde: task_no_data_intr: status=0x51 { DriveReady 
SeekComplete Error }
[    6.612080] hde: task_no_data_intr: error=0x04 { DriveStatusError }
[    6.612315] hde: possibly failed opcode: 0x10
[    7.772545]  hde1
[    7.772600] hdf: max request size: 128KiB
[    7.772602] hdf: 781422768 sectors (400088 MB) w/16384KiB Cache, 
CHS=48641/255/63
[    7.772617]  hdf:<3>hdf: task_no_data_intr: status=0x51 { DriveReady 
SeekComplete Error }
[    7.776081] hdf: task_no_data_intr: error=0x04 { DriveStatusError }
[    7.776316] hdf: possibly failed opcode: 0x10
[    8.937987]  hdf1


hdparm:

/dev/hdd:

  Model=ST3400633A, FwRev=3.AAH, SerialNo=3NF1QK7K
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=16384kB, MaxMultSect=16, MultSect=16
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=781422768
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  *mdma0 mdma1 mdma2
  AdvancedPM=no
  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

  * signifies the current active mode
