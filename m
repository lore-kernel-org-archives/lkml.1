Return-Path: <linux-kernel-owner+w=401wt.eu-S1761812AbXFCNRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761812AbXFCNRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 09:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXFCNRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 09:17:15 -0400
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:32910 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753207AbXFCNRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 09:17:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=t4F73Mt+zgisVzGdnlhwvn6M//tGqev5Kd5RU0kqhHNMJB7XIulBioltEpav1eqVAKPKRqLAbiSsRsbry+N62vyle5ppIRf/9ku07jDtubPVEB7/xboJDB/LahUm6OgKTH8P6FKzG2Y0FQ/9lGLnwXcTt1XltLtonNUbDqtJJ5I=;
X-YMail-OSG: x2Hx.CEVM1kI2MPBLCiz744qVG9CC91Zgqpj2bnjxDnqsUjmqwzGSGwWX5SiIofJXxrrZIb1inGIcCni_n7Y8IoNLPOP1VY1CdMOTLiHejaRNMYQTG7vWes7ggG8cw--
Date: Sun, 3 Jun 2007 14:17:13 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [Linux 2.6.21.3] CDRW drive not recognised by PATA (ata_piix)
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <336034.8278.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tried replacing the old IDE layer on my dual P4 machine with the PATA driver instead, but
the CDRW drive on the second IDE bus (the old /dev/hdd drive) is never recognised:

ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
scsi0 : ata_piix
ata1.00: ATA-6: IC35L090AVV207-0, V23OA66A, max UDMA/100
ata1.00: 156250000 sectors, multi 8: LBA48 
ata1.00: configured for UDMA/100
scsi1 : ata_piix
ata2.00: ATAPI, max UDMA/33
ata2.01: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
ata2.01: qc timeout (cmd 0xef)
ata2.01: failed to set xfermode (err_mask=0x4)
ata2: failed to recover some devices, retrying in 5 secs
ata2.00: configured for UDMA/33
ata2.01: qc timeout (cmd 0xef)
ata2.01: failed to set xfermode (err_mask=0x4)
ata2.01: limiting speed to UDMA/33:PIO3
ata2: failed to recover some devices, retrying in 5 secs
ata2.00: configured for UDMA/33
ata2.01: qc timeout (cmd 0xef)
ata2.01: failed to set xfermode (err_mask=0x4)
ata2.01: disabled
ata2: failed to recover some devices, retrying in 5 secs
ata2.00: failed to set xfermode (err_mask=0x40)
ata2: failed to recover some devices, retrying in 5 secs
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IC35L090AVV207-0 V23O PQ: 0 ANSI: 5
SCSI device sda: 156250000 512-byte hdwr sectors (80000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sda: 156250000 512-byte hdwr sectors (80000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8162B 0015 PQ: 0 ANSI: 5

The DVD-ROM drive on the same PATA controller is still found correctly (fortunately), once the
ata_piix driver gives up and disabled the misbehaving drive.

I have tried setting both atapi_dmadir=1 and fua=1 with the libata module, to no effect.

The CDRW drive works fine with the old IDE layer, but modern distros seem to be forcing everyone
down the PATA route. Can anyone suggest why the PATA layer hates my CDRW drive so much, please?

For reference, this is what the old IDE layer used to say:

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH4: chipset revision 1
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IC35L090AVV207-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-STDVD-ROM GDR8162B, ATAPI CD/DVD-ROM drive
hdd: SONY CD-RW CRX216E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15

hdc: ATAPI 48X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)

And the relevant(?) bits from lspci too:

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR-
FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 01) (prog-if 8a
[Master SecP PriP])
        Subsystem: Dell Unknown device 012c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR-
FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]
        Region 5: Memory at 88100000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
        Subsystem: Dell Unknown device 012c
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR-
FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
<PERR-
        Interrupt: pin B routed to IRQ 20
        Region 4: I/O ports at bc80 [size=32]

Thanks,
Chris

(P.S. It's not just 2.6.21.3 that is unable to activate this drive. Both FC7 and Ubuntu 7.04 have
exactly the same problem.)


      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
