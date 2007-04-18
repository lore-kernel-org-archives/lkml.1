Return-Path: <linux-kernel-owner+w=401wt.eu-S2992730AbXDRVRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992730AbXDRVRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992760AbXDRVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:17:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:55457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992730AbXDRVRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:17:24 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.21-rc5 from fc7-rc2 problems
Date: Wed, 18 Apr 2007 17:11:04 -0400
User-Agent: KMail/1.9.5
Cc: Stephen.Clark@seclark.us, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <460EC109.5070300@seclark.us> <200704181612.07257.lenb@kernel.org> <46267E38.9020909@garzik.org>
In-Reply-To: <46267E38.9020909@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181711.05344.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2007 16:23, Jeff Garzik wrote:
> Len Brown wrote:
> > < Linux version 2.6.20-1.2933.fc6
> > < (brewbuilder@hs20-bc2-4.build.redhat.com) (gcc version 4.1.1 20070105
> > < (Red Hat 4.1.1-51)) #1 SMP Mon Mar 19 11:38:26 EDT 2007
> > ---
> >> Linux version 2.6.20-1.3023.fc7
> >> (brewbuilder@ls20-bc1-13.build.redhat.com) (gcc version 4.1.2 20070317
> >> (Red Hat 4.1.2-5)) #1 SMP Sun Mar 25 22:12:02 EDT 2007
> > 
> > I agree that the fc7 version string looks strange, because
> > there are other things in the fc7 dmesg which are clearly from 2.6.21,
> > such as this:
> > 
> > < ACPI: Core revision 20060707
> > ---
> >> ACPI: Core revision 20070126
> > 
> > Perhaps you can try building a kernel.org 2.6.21 kernel and running
> > it on your FC6 install?
> > 
> > The ALI15X3 stuff exists only in the working FC6 dmesg:
> > 
> > < Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> > < ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> > < ALI15X3: IDE controller at PCI slot 0000:00:0f.0
> > < ACPI: Unable to derive IRQ for device 0000:00:0f.0
> > < ACPI: PCI Interrupt 0000:00:0f.0[A]: no GSI
> > < ALI15X3: chipset revision 195
> > < ALI15X3: not 100% native mode: will probe irqs later
> > <     ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:DMA, hdb:pio
> > <     ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:DMA, hdd:pio
> > < Probing IDE interface ide0...
> > < hda: HITACHI_DK23CA-20, ATA DISK drive
> > < ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > < Probing IDE interface ide1...
> > < hdc: MATSHITADVD-ROM SR-8175, ATAPI CD/DVD-ROM drive
> > < ide1 at 0x170-0x177,0x376 on irq 15
> > < Probing IDE interface ide2...
> > < Probing IDE interface ide3...
> > < Probing IDE interface ide4...
> > < Probing IDE interface ide5...
> > < hda: max request size: 128KiB
> > < hda: 39070080 sectors (20003 MB) w/2048KiB Cache, CHS=38760/16/63, UDMA(66)
> > < hda: cache flushes not supported
> > <  hda: hda1 hda2
> > < ide-floppy driver 0.99.newide
> > 
> > FC7 looks like it is using libata instead:
> > -Len
> > 
> >> SCSI subsystem initialized
> >> libata version 2.20 loaded.
> >> ACPI: Unable to derive IRQ for device 0000:00:0f.0
> >> ACPI: PCI Interrupt 0000:00:0f.0[A]: no GSI
> >> ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011000
> >> irq 14
> >> ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011008
> >> irq 15
> >> scsi0 : pata_ali
> >> PM: Adding info for No Bus:host0
> >> ata1.00: ATA-5: HITACHI_DK23CA-20, 00H1A0A3, max UDMA/100   <========
> >> drive can do 100
> >> ata1.00: 39070080 sectors, multi 16: LBA
> >> ata1.00: configured for UDMA/33    <=============== configured as 33
> >> scsi1 : pata_ali
> >> PM: Adding info for No Bus:host1
> >> ata2.00: ATAPI, max UDMA/33   <=== cd can't be read now
> >> ata2.00: configured for UDMA/33
> >> PM: Adding info for No Bus:target0:0:0
> >> scsi 0:0:0:0: Direct-Access     ATA      HITACHI_DK23CA-2 00H1 PQ: 0 ANSI: 5
> >> PM: Adding info for scsi:0:0:0:0
> >> PM: Adding info for No Bus:target1:0:0
> >> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >> ata2.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x12 data 36 in
> >>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >> ata2: soft resetting port
> 
> It looks like interrupts are not being delivered?

Dunno, both 2.6.20 and 2.6.21 say they're looking on IRQ14 and IRQ15.
ACPI isn't involved at all with those IRQs, as it couldn't find any info
for 0000:00:0f.0[A] and thus the legacy hard-coding for IDE must rule the day.

Is it possible to configure 2.6.21 with the driver that was running in 2.6.20?
If yes, and that works, then we know we didn't somehow otherwise break interrupts.

-Len
