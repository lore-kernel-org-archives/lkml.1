Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYGJUfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYGJUfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYGJUfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:35:30 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:60772 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbYGJUf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:35:29 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@redhat.com>
Subject: Re: pata_it821x completely broken
Date: Thu, 10 Jul 2008 22:35:20 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807062350.35650.linux@rainbow-software.org> <20080706230118.GA25905@devserv.devel.redhat.com>
In-Reply-To: <20080706230118.GA25905@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102235.22651.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
commenting out the error check after ata_dev_init_params() call in 
ata_dev_read_id() function (libata-core.c), I got at least the device name. 
The capacity is 0 so it doesn't work, obviously:

pata_it821x: controller in smart mode.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
PCI: Setting latency timer of device 0000:00:12.0 to 64
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max MWDMA2 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max MWDMA2 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
ata3.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata3.00: 781422768 sectors, multi 0: LBA48
ata3.01: ATA-0: Integrated Technology Express Inc, , max MWDMA2
ata3.01: 0 sectors, multi 0, CHS 0/0/0
IT821x RAID1 volume.
ata3.00: configured for DMA
ata3.01: configured for PIO
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD400LD  WQ10 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 2:0:1:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI: 5
sd 2:0:1:0: [sdc] Too big for this kernel. Use a kernel compiled with support 
for large block devices.
sd 2:0:1:0: [sdc] 0 512-byte hardware sectors (0 MB)
sd 2:0:1:0: [sdc] Write Protect is off
sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:1:0: [sdc] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg3 type 0


(0 is too big for the kernel, interesting :)


-- 
Ondrej Zary
