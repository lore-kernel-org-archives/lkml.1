Return-Path: <linux-kernel-owner+w=401wt.eu-S1031056AbXDSBtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031056AbXDSBtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031055AbXDSBtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:49:15 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61380 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031050AbXDSBtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:49:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17958.51858.63278.68495@smtp.charter.net>
Date: Wed, 18 Apr 2007 21:49:06 -0400
From: "John Stoffel" <john@stoffel.org>
To: "John Stoffel" <john@stoffel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 ATA HPT37x regression
In-Reply-To: <17958.50974.973764.356099@smtp.charter.net>
References: <17956.12963.163961.762444@smtp.charter.net>
	<4624D4C3.9010109@ru.mvista.com>
	<17956.63043.521397.597430@smtp.charter.net>
	<4624FE88.2010908@ru.mvista.com>
	<20070417181340.7de99868@the-village.bc.nu>
	<17957.8073.587946.969040@smtp.charter.net>
	<17958.50974.973764.356099@smtp.charter.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

>>>>> "John" == John Stoffel <john@stoffel.org> writes:
>>>> > Ok, so do I need to do anything special with the next -mm release and
>>>> > the next version?
>>>> 
>>>> Well, let Alan decide that (2Alan: and I said that HPT code is bogus :-).

Alan> Try drivers/ide/pci/hpt366 - if that works grab a dmesg and let
Alan> me know.  It means that Sergei's DPLL sync code seems to work
Alan> better than the vendor code and its time to swap it over.

John> Ok, I'll give that a whirl under 2.6.21-rc7 tonight.  I'll build them
John> in modular so I can switch around more easily.  I hope.  :]

John> Ok, here's the dmesg output using the hpt366 old IDE driver,
John> 2.6.21-rc7, SMP: 

John> [  160.926355] HPT302: IDE controller at PCI slot 0000:03:06.0
John> [  160.928030] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level, low) -> IRQ
John>  18
John> [  160.931212] HPT302: chipset revision 1
John> [  160.932801] HPT302: DPLL base: 66 MHz, f_CNT: 100, assuming 33 MHz PCI
John> [  160.941157] HPT302: using 66 MHz DPLL clock
John> [  160.942646] HPT302: 100% native mode on irq 18
John> [  160.943918]     ide2: BM-DMA at 0xe800-0xe807, BIOS settings: hde:DMA, hdf:pi
John> o
John> [  160.946636]     ide3: BM-DMA at 0xe808-0xe80f, BIOS settings: hdg:DMA, hdh:pi
John> o
John> [  160.949439] Probing IDE interface ide2...
John> [  161.213560] hde: WDC WD1200JB-00CRA1, ATA DISK drive
John> [  161.828020] ide2 at 0xecf8-0xecff,0xecf2 on irq 18
John> [  161.829616] Probing IDE interface ide3...
John> [  162.094086] hdg: WDC WD1200JB-00EVA0, ATA DISK drive
John> [  162.709002] ide3 at 0xece0-0xece7,0xecda on irq 18


John> Which looks ok to me I guess.  It found my MD disks on there and
John> assmebled them, eventually.  *grin*

John> I'll reboot and send out the corresponding ATA HPT37x driver dmesg...

And here's the output (much more verbose!) from the hpt37x ATA driver:

[  158.712007] hpt37x: HPT302: Bus clock 33MHz.
[  158.713390] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 18 (level, low) -> IRQ
 18
[  158.716254] ata5: PATA max UDMA/133 cmd 0x0001ecf8 ctl 0x0001ecf2 bmdma 0x000
1e800 irq 18
[  158.719019] ata6: PATA max UDMA/133 cmd 0x0001ece0 ctl 0x0001ecda bmdma 0x000
1e808 irq 18
[  158.722257] scsi7 : pata_hpt37x
[  158.878133] ata5.00: ATA-5: WDC WD1200JB-00CRA1, 17.07W17, max UDMA/100
[  158.879576] ata5.00: 234441648 sectors, multi 16: LBA 
[  158.880934] Find mode for 12 reports C829C62
[  158.882240] Find mode for DMA 69 reports 1C6DDC62
[  158.888152] ata5.00: configured for UDMA/100
[  158.889437] scsi8 : pata_hpt37x
[  158.900338] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  158.901660] ide: Assuming 33MHz system bus speed for PIO modes; override with
 idebus=xx
[  159.047026] ata6.00: ATA-6: WDC WD1200JB-00EVA0, 15.05R15, max UDMA/100
[  159.048412] ata6.00: 234441648 sectors, multi 16: LBA48 
[  159.050008] Find mode for 12 reports C829C62
[  159.051371] Find mode for DMA 69 reports 1C6DDC62
[  159.057079] ata6.00: configured for UDMA/100
[  159.063655] scsi 7:0:0:0: Direct-Access     ATA      WDC WD1200JB-00C 17.0 PQ
: 0 ANSI: 5
[  159.067506] SCSI device sdi: 234441648 512-byte hdwr sectors (120034 MB)
[  159.069004] sdi: Write Protect is off
[  159.070412] sdi: Mode Sense: 00 3a 00 00
[  159.070487] SCSI device sdi: write cache: enabled, read cache: enabled, doesn
't support DPO or FUA
[  159.073427] SCSI device sdi: 234441648 512-byte hdwr sectors (120034 MB)
[  159.074882] sdi: Write Protect is off
[  159.076262] sdi: Mode Sense: 00 3a 00 00
[  159.076339] SCSI device sdi: write cache: enabled, read cache: enabled, doesn
't support DPO or FUA
[  159.079097]  sdi: sdi1
[  159.097634] sd 7:0:0:0: Attached scsi disk sdi
[  159.099212] sd 7:0:0:0: Attached scsi generic sg9 type 0
[  159.102344] scsi 8:0:0:0: Direct-Access     ATA      WDC WD1200JB-00E 15.0 PQ
: 0 ANSI: 5
[  159.106197] SCSI device sdj: 234441648 512-byte hdwr sectors (120034 MB)
[  159.107722] sdj: Write Protect is off
[  159.109188] sdj: Mode Sense: 00 3a 00 00
[  159.109271] SCSI device sdj: write cache: enabled, read cache: enabled, doesn
't support DPO or FUA
[  159.112455] SCSI device sdj: 234441648 512-byte hdwr sectors (120034 MB)
[  159.114094] sdj: Write Protect is off
[  159.115870] sdj: Mode Sense: 00 3a 00 00
[  159.115943] SCSI device sdj: write cache: enabled, read cache: enabled, doesn
't support DPO or FUA
[  159.118965]  sdj: sdj1
[  159.138036] sd 8:0:0:0: Attached scsi disk sdj
[  159.139682] sd 8:0:0:0: Attached scsi generic sg10 type 0



In both cases, my RAID1 disks are found and come up cleanly, which is
good.  Thanks for all the work you guys have done on the IDE stuff, as
well as the new libATA stuff.

Let me know if you need more testing done here, I've only got a
scratch volume on this raid set.

John
