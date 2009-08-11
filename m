Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbZHKSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbZHKSvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbZHKSvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:51:22 -0400
Received: from mail.candelatech.com ([208.74.158.172]:51488 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbZHKSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:51:18 -0400
Message-ID: <4A81BDA6.4080804@candelatech.com>
Date: Tue, 11 Aug 2009 11:51:18 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: How to disable DMA for compact-flash disk?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to use Fedora 11 with default kernel on an old via system
that boots from compact flash.  DMA is not supported on the CF for
whatever reason, and in previous kernels, I've always disabled
DMA, first with ide=nodma, and then later with
ide_core.nodma=0.0 ide_core.nodma=0.1 ...

However, this no longer works in the 2.6.29.6 kernel.

Fedora 11 32-bit
Kernel 2.6.29.6-217.2.3.fc11.i686.PAE

(I can't get a custom built & somewhat hacked 2.6.31-rc5 to find a ramdisk or root-disk, but the
errors about unknown boot option are the same).


 From dmesg output:


Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255649
Kernel command line: ro root=UUID=6f65a5dd-7872-4715-be9c-3741bd6ac7d3
ide_core.nodma=0.0 ide_core.nodma=0.1 ide_core.nodma=1.0 ide_core.nodm
a=1.1 console=ttyS0,38400
Unknown boot option `ide_core.nodma=0.0': ignoring
Unknown boot option `ide_core.nodma=0.1': ignoring
Unknown boot option `ide_core.nodma=1.0': ignoring
Unknown boot option `ide_core.nodma=1.1': ignoring


....

Gscsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe900 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe908 irq 15
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
ata1.01: CFA: TRANSCEND, 20081024, max UDMA/66
ata1.01: 3980592 sectors, multi 0: LBA
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.01: configured for UDMA/33
scsi 0:0:1:0: Direct-Access     ATA      TRANSCEND        2008 PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] 3980592 512-byte hardware sectors: (2.03 GB/1.89 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sda] 3980592 512-byte hardware sectors: (2.03 GB/1.89 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  sda:<3>ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 dma 4096 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.01: status: { DRDY }
ata1: soft resetting link
ata1.01: configured for UDMA/33
ata1: EH complete
ata1.01: limiting speed to UDMA/25:PIO4
ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 dma 4096 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.01: status: { DRDY }
ata1: soft resetting link
ata1.01: configured for UDMA/25
ata1: EH complete
ata1.01: limiting speed to PIO4
ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 dma 4096 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.01: status: { DRDY }
ata1: soft resetting link
ata1.01: configured for PIO4
ata1: EH complete
  sda1
sd 0:0:1:0: [sda] Attached SCSI disk
sd 0:0:1:0: Attached scsi generic sg0 type 0
kjournald starting.  Commit interval 5 seconds

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

