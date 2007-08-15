Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXHOMoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXHOMoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXHOMo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:44:29 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:52036 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXHOMo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:44:28 -0400
Message-ID: <46C2F526.30005@dunaweb.hu>
Date: Wed, 15 Aug 2007 14:44:22 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Bad CD disk disables IDE DMA
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that a bad CD of mine makes DMA disabled:

hda: selected mode 0x44
hda: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
hda: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
ide: failed opcode was: unknown
hda: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
hda: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
ide: failed opcode was: unknown
hda: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
hda: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
ide: failed opcode was: unknown
hda: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
hda: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
ide: failed opcode was: unknown
hda: DMA disabled
hda: ide_intr: huh? expected NULL handler on exit
hda: ATAPI reset complete

Every time I put the said CD into to drive and DMA is on, I get the 
above messages.
Two things are interesting: first, it gets mounted correctly and 
readable and
second, when DMA was already disabled no such messages occur in the logs.
Anyhow, I would need DMA to correctly burn CDs/DVDs...
What can I do besides manually re-enable DMA?
All other disks I have tried behave perfectly.
This happened on 2.6.22[-rcX], 2.6.23-rc3-git1 and 2.6.20-1.2962.fc6.
This is on a Fedora Core 6 system. CD/DVD is using the old IDE drivers:

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP55: IDE controller at PCI slot 0000:00:04.0
NFORCE-MCP55: chipset revision 161
NFORCE-MCP55: not 100% native mode: will probe irqs later
NFORCE-MCP55: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE-MCP55: 0000:00:04.0 (rev a1) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
hda: PIONEER DVD-RW DVR-111L, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide-floppy driver 0.99.newide

$ cat /proc/ide/amd74xx
----------AMD BusMastering IDE Configuration----------------
Driver Version:                     2.13
South Bridge:                       0000:00:04.0
Revision:                           IDE 0xa1
Highest DMA rate:                   UDMA133
BM-DMA base:                        0xf000
PCI clock:                          33.3MHz
-----------------------Primary IDE-------Secondary IDE------
Prefetch Buffer:              yes                 yes
Post Write Buffer:            yes                 yes
Enabled:                      yes                  no
Simplex only:                  no                 yes
Cable Type:                   80w                 80w
-------------------drive0----drive1----drive2----drive3-----
Transfer Mode:        PIO       DMA       DMA       DMA
Address Setup:       30ns      90ns      90ns      90ns
Cmd Active:          90ns      90ns     300ns     300ns
Cmd Recovery:        30ns      30ns     300ns     300ns
Data Active:         90ns     330ns     330ns     330ns
Data Recovery:       30ns     270ns     270ns     270ns
Cycle Time:         120ns     600ns     600ns     600ns
Transfer Rate:   16.6MB/s   3.3MB/s   3.3MB/s   3.3MB/s

Best regards,
Zoltán Böszörményi


