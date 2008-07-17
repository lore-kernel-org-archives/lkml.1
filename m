Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYGQRWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYGQRWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYGQRWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:22:35 -0400
Received: from ns.hanzlici.cz ([212.158.159.56]:40336 "EHLO franta.hanzlici.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756397AbYGQRWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:22:35 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 13:22:34 EDT
Message-ID: <487F7D7B.5040803@hanzlici.cz>
Date: Thu, 17 Jul 2008 19:12:27 +0200
From: Frantisek Hanzlik <franta@hanzlici.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9.0.2pre) Gecko/2008071601 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: serverworks CSB5 IDE: DMA disabled on secondary channel
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Server with Intel SHG2 board, servervorks CSB5 rev. 93: After
upgrade from kernel 2.6.22 (IDE serverworks driver) to 2.6.25
(Fedora 9: libata+pata_serverworks driver), SW RAID1 performance
is very bad. Problem is probably with secondary IDE channel,
which has disabled DMA:

# hdparm -Tt /dev/sda
/dev/sda:
  Timing cached reads:   828 MB in  2.00 seconds = 414.26 MB/sec
  Timing buffered disk reads:  210 MB in  3.01 seconds =  69.83 MB/sec

# hdparm -Tt /dev/sdb
/dev/sdb:
  Timing cached reads:   408 MB in  2.00 seconds = 203.72 MB/sec
  Timing buffered disk reads:    6 MB in  3.05 seconds =   1.96 MB/sec

dmesg output:
...
libata version 3.00 loaded.
PCI: Setting latency timer of device 0000:00:0f.1 to 64
scsi0 : pata_serverworks
scsi1 : pata_serverworks
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2440 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2448 irq 15
ata1.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
ata1.00: 781422768 sectors, multi 16: LBA48
ata1.01: ATAPI: TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
ata2.00: ATA-7: ST3400620A, 3.AAE, max UDMA/100
ata2.00: 781422768 sectors, multi 16: LBA48
ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
ata2.00: simplex DMA is claimed by other device, disabling DMA
ata2.01: simplex DMA is claimed by other device, disabling DMA
ata2.00: configured for PIO4
ata2.01: configured for PIO4
...

# lsmod|grep ata
pata_serverworks       10496  8
pata_acpi               8320  0
libata                127328  2 pata_serverworks,pata_acpi
scsi_mod              120948  4 sg,sr_mod,libata,sd_mod

It's some sort of pata_serverworks bug, or is needed any special
setup for this driver to work?
What is "simplex DMA" term?

Thanks, Franta Hanzlik
