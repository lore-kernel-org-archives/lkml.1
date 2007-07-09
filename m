Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbXGIV71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbXGIV71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbXGIV7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:59:18 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:55189 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXGIV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:59:17 -0400
X-Greylist: delayed 2031 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 17:59:17 EDT
Message-ID: <4692A7C3.9030802@mandriva.org>
Date: Tue, 10 Jul 2007 00:25:23 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-ide@vger.kernel.org
Subject: Problem with SiS Ide/Pata/Sata on 2.6.22-rc7-git4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
(Please CC me in any responses)
There are some weirdness going on with SiS IDE/Pata/Sata support...

After moving from a 2.6.17 based kernel with ide dupport built in to a 
2.6.22-rc7-git4 based kernel with fully modular ide/pata/sata we see the 
following problem on a system with ide disks:


If you modprobe sata_sis:
(it also pulls pata_sis, is that really intended)
  - both disks are detected ok

If you modprobe sata_sis/pata_sis and then sis5513:
(it also pulls pata_sis, is that really intended)
  - both disks are detected ok

If you modprobe only sis5513
  OR
If you modprobe only sis5513 and then sata_sis/pata_sis:
  - you get this:
    (the hdb drive does not get detected/usable)


<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with 
idebus=xx
<5>SCSI subsystem initialized
<6>SIS5513: IDE controller at PCI slot 0000:00:02.5
<6>ACPI: PCI Interrupt 0000:00:02.5[A] -> GSI 16 (level, low) -> IRQ 21
<6>SIS5513: chipset revision 1
<6>SIS5513: not 100% native mode: will probe irqs later
<6>SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
<6>    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
<6>    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
<7>Probing IDE interface ide0...
<4>hdb: QUANTUM FIREBALLlct15 07, ATA DISK drive
<4>hdb: host side 80-wire cable detection failed, limiting max speed to 
UDMA33
<7>hdb: selected mode 0x42
<4>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<7>Probing IDE interface ide1...
<4>hdc: ATAPI-CD ROM-DRIVE-50MAX, ATAPI CD/DVD-ROM drive
<7>hdc: selected mode 0x42
<4>ide1 at 0x170-0x177,0x376 on irq 15
<6>hdc: ATAPI 50X CD-ROM drive, 128kB Cache, UDMA(33)
<6>Uniform CD-ROM driver Revision: 3.20
<7>libata version 2.21 loaded.
<6>sata_sis 0000:00:05.0: version 0.8
<6>ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 17 (level, low) -> IRQ 22
<6>sata_sis 0000:00:05.0: Detected SiS 180/181/964 chipset in SATA mode
<6>scsi0 : sata_sis
<6>scsi1 : sata_sis
<6>ata1: SATA max UDMA/133 cmd 0x0001ac00 ctl 0x0001b002 bmdma 
0x0001bc00 irq 0
<6>ata2: SATA max UDMA/133 cmd 0x0001b400 ctl 0x0001b802 bmdma 
0x0001bc08 irq 0
<6>ata1: SATA link down (SStatus 0 SControl 300)
<6>ata2: SATA link down (SStatus 0 SControl 300)



kernel config is here:
http://tmb.kkc.fi/Kernels/Cooker/BUG/SiS/config

and Mandriva Installer bug report here:
http://tmb.kkc.fi/Kernels/Cooker/BUG/SiS/report.bug

Note! this report is from a 2.6.22-tmb-desktop586-0.rc7.1mdv
Mandriva Cooker Contrib kernel wich is 2.6.22-rc7-git1 wich has several 
patches including CFS, HRT, and several other patches (but none of them 
touching ide/pata/sata)...

But we got the exact same behaviour with a clean 2.6.22-rc7-git4 + 
Squashfs-3.2-r2 (needed for the installer)

http://tmb.kkc.fi/Kernels/Cooker/i586/kernel-linus-2.6.22-0.rc7.3mdv-1-1mdv2007.1.i586.rpm

Any pointers of what/how to fix ?

--
Thomas
