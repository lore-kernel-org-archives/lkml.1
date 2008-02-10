Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYBJL6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYBJL6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYBJL56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:57:58 -0500
Received: from acorn.exetel.com.au ([220.233.0.21]:59496 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYBJL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:57:57 -0500
X-Greylist: delayed 1910 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 06:57:57 EST
Message-ID: <52417.220.233.174.242.1202642765.squirrel@webmail.exetel.com.au>
Date: Sun, 10 Feb 2008 22:26:05 +1100 (EST)
Subject: pata_sil680 regression 2.6.22->2.6.24
From: "Robert Lowery" <rglowery@exemail.com.au>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

Having recently upgaded my Ubuntu install from Gutsy to Hardy, my 750GB
Seagate disk connected via a SiI680 PCI card is no longer detected.  I
suspect this is caused by the MMIO changes in 2.6.24.  Strangely in 2.6.22
the drive appears as sda1, but on 2.6.24 it appears as a non functioning
hde.

A working 2.6.22 based system reports

Feb 10 01:49:22 myth-backend kernel: [   88.296373] sil680: BA5_EN = 1
clock = 00
Feb 10 01:49:22 myth-backend kernel: [   88.296401] sil680: BA5_EN = 1
clock = 10
Feb 10 01:49:22 myth-backend kernel: [   88.296479] sil680: 133MHz clock.
Feb 10 01:49:22 myth-backend kernel: [   88.296672] ACPI: PCI Interrupt
0000:00:0d.0[A] -> GSI 19 (level, low) -> IRQ 19
Feb 10 01:49:22 myth-backend kernel: [   88.297584] scsi2 : pata_sil680
Feb 10 01:49:22 myth-backend kernel: [   88.298142] scsi3 : pata_sil680
Feb 10 01:49:22 myth-backend kernel: [   88.298398] ata1: PATA max
UDMA/133 cmd 0x00019000 ctl 0x00018802 bmdma 0x00017800 irq 19
Feb 10 01:49:22 myth-backend kernel: [   88.298409] ata2: PATA max
UDMA/133 cmd 0x00018400 ctl 0x00018002 bmdma 0x00017808 irq 19
Feb 10 01:49:22 myth-backend kernel: [   88.530102] ata1.00: ATA-7:
ST3750640A, 3.AAE, max UDMA/100
Feb 10 01:49:22 myth-backend kernel: [   88.530139] ata1.00: 1465149168
sectors, multi 0: LBA48
Feb 10 01:49:22 myth-backend kernel: [   88.604735] ata1.00: configured
for UDMA/100

A non working 2.6.24 based system reports

Feb  9 16:19:28 myth-backend kernel: [   81.149973] SiI680: IDE controller
(0x1095:0x0680 rev 0x02) at  PCI slot 0000:00:0d.0
Feb  9 16:19:28 myth-backend kernel: [   81.150031] ACPI: PCI Interrupt
0000:00:0d.0[A] -> GSI 19 (level, low) -> IRQ 19
Feb  9 16:19:28 myth-backend kernel: [   81.150094] SiI680: BASE CLOCK == 133
Feb  9 16:19:28 myth-backend kernel: [   81.150104] SiI680: 100% native
mode on irq 19
Feb  9 16:19:28 myth-backend kernel: [   81.150121]     ide2: MMIO-DMA ,
BIOS settings: hde:pio, hdf:pio
Feb  9 16:19:28 myth-backend kernel: [   81.150145]     ide3: MMIO-DMA ,
BIOS settings: hdg:pio, hdh:pio
Feb  9 16:19:28 myth-backend kernel: [   82.113860] hde: þþÿþ`KÐ, ATA DISK
drive
Feb  9 16:19:28 myth-backend kernel: [   82.114038] ide2 at
0xf882a080-0xf882a087,0xf882a08a on irq 19

Note, my bios does not support 750GB drives, so the drive is not
configured in the card BIOS.  This has not stopped linux detecting it ok
in the past.

Please let me know if I need to provide any more information or additional
testing.

Thanks

-Rob

