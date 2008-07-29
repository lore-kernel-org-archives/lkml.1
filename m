Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYG2In6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYG2In6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYG2Ins
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:43:48 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:46235 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755718AbYG2Inr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:43:47 -0400
Message-ID: <488ED837.2060509@alcatel-lucent.com>
Date: Tue, 29 Jul 2008 16:43:35 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gshan <gshan@alcatel-lucent.com>
Subject: PIIX4: DMA timeout issue
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2008 08:43:26.0105 (UTC) 
	FILETIME=[2AB59090:01C8F157]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scores: Clean:0.87023 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I sent mails on this issue before, but nobody made response.
There are 2 types of board for me. The hardware configuration for
those 2 boards are almost same except that one of them has 100GB
harddisk, and another type of board has 60GB harddisk. All harddisk
was access through PIIX4. I found this issue on board with 60GB
disk, but can't reproduce it on that with 100GB disk.

When I uncompressed a large file (600MB) to a logic partition with 8GB
size, following errors was report on middle way (5 minutes about from 
start).
Anybody has ideas?

hdc: dma_timer_expiry: dma status == 0x21
hdc: DMA timeout error
hdc: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hdc: DMA disabled
ide1: reset: success

Output at booting as follows:
=====================
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0001:00:03.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:pio, hdd:pio
hdc: HTS726060M9ATX0, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 47
hdc: max request size: 512KiB
hdc: 117210240 sectors (60011 MB) w/7877KiB Cache, CHS=16383/255/63, 
UDMA(33)
hdc: cache flushes supported
 hdc: hdc1 hdc4 < hdc5 hdc6 hdc7 hdc8 >

More info from proc
==============
/proc/ide/ide1/hdc $ cat settings
name                    value           min             max             mode
----                    -----           ---             ---             ----
acoustic                0               0               254             rw
address                 1               0               2               rw
bios_cyl                16383           0               65535           rw
bios_head               255             0               255             rw
bios_sect               63              0               63              rw
bswap                   0               0               1               r
current_speed           66              0               70              rw
dma_timeout             20000           0               20000           rw
failures                0               0               65535           rw
init_speed              66              0               70              rw
io_32bit                0               0               3               rw
keepsettings            0               0               1               rw
lun                     0               0               7               rw
max_failures            1               0               65535           rw
multcount               0               0               16              rw
nice1                   1               0               1               rw
nowerr                  0               0               1               rw
number                  2               0               3               rw
pio_mode                write-only      0               255             w
unmaskirq               0               0               1               rw
using_dma               1               0               1               rw
wcache                  1               0               1               rw

Output from fdisk
=============
/proc/ide/ide1/hdc $ fdisk /dev/hdc

The number of cylinders for this disk is set to 7296.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): p

Disk /dev/hdc: 60.0 GB, 60011642880 bytes
255 heads, 63 sectors/track, 7296 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x488ea1c3

   Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1          17      136521   83  Linux
/dev/hdc4              18        7296    58468567+   5  Extended
/dev/hdc5              18        1014     8008371   83  Linux
/dev/hdc6            1015        2011     8008371   83  Linux
/dev/hdc7            2012        3008     8008371   83  Linux
/dev/hdc8            3009        4005     8008371   83  Linux


Regards,
Gavin
