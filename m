Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYHKUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYHKUMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYHKUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:12:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:48404 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbYHKUMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Xsoh+dU8tZZ8KQSAppMwgX84vUwsGJQqMOrfdPQOZpgEz+AiXj4bAhV5vXkTKS21Qr
         nRzPk/kACdyfOEX2qS4t6WwCqMiKdwgh8Wvi5ob2JSfdl4osetk2QjaL5p6KPppfSIJe
         uaasZ7UIeRj5OJi//B7ag8mOkrLG7t8cbE6as=
Message-ID: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
Date: Mon, 11 Aug 2008 22:12:19 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org, mingo@elte.hu,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [2.6.26.*] boot problem (ahci/irq related?)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A have problem with booting 2.6.26* and 2.6.27-rc* kernels. Very often
booting stops on this message:

[...]
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
ICH7: not 100% native mode: will probe irqs later
ICH7: IDE port disabled
    ide0: BM-DMA at 0x60a0-0x60a7

afer should be:
hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[...]

Initially I was think, that is hardware problem. But XP and 2.6.25.8
work with _no_ problem (booting from xp, linux, knoppix, linux
firmware development kit - about 50 reboots).

So I try without CONFIG_IDE option and try libata.noacpi=1 option and
without it. It doesn't help. Next messages  (from dmesg) below are
with libata.noacpi=1 option enabled and CONFIG_IDE=n (libata only use
- 2.6.26.2 kernel). Firstly i try 2.6.26.2 and very often boot stops
on this message:

http://unixy.pl/maciek/download/kernel/dupa/img_0001.jpg

I observe few times this event:
1. boot to 2.6.26.2 fails
2. power on by power button and boot XP (works OK, clean logs)
3. back to 2.6.26.2 (fail)
4. power on by power button and boot XP (works OK)
5. back to 2.6.26.2 (fail or sometimes boot normally)

(The same sequence when XP change to 2.6.25.8)



Also (1-2 times) I observed this:
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 220
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/133
ata1.00: configured for UDMA/133
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
ata5.00: configured for MWDMA2
ata6: port disabled. ignoring.
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata5.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
        cdb 12 00 00 00 60 00 00 00  00 00 00 00 00 00 00 00
        res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
ata5: soft resetting link
ata5.00: configured for MWDMA2
ata5: EH complete
ata5.00: limiting speed to MWDMA1:PIO4
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata5.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
        cdb 12 00 00 00 60 00 00 00  00 00 00 00 00 00 00 00
        res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
ata5: soft resetting link
ata5.00: configured for MWDMA1
ata5: EH complete
ata5.00: limiting speed to PIO4
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata5.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
        cdb 12 00 00 00 60 00 00 00  00 00 00 00 00 00 00 00
        res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
ata5: soft resetting link
ata5.00: configured for PIO4
ata5: EH complete
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-840S  1.11 PQ: 0 ANSI: 5

and then booting normally.


2.6.26.2:
lspci -vvv: http://unixy.pl/maciek/download/kernel/dupa/lspci.txt
interrupts: http://unixy.pl/maciek/download/kernel/dupa/przerwania.txt
config: http://unixy.pl/maciek/download/kernel/dupa/config-2.6.26.2
dmesg (normal booting):
http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.26.2.txt

2.6.25.8:
config: http://unixy.pl/maciek/download/kernel/dupa/config-2.6.25.8
dmesg: http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.25.8.txt

I also try update BIOS - it doesn't help.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
