Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXJXRBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXJXRBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759819AbXJXQue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:50:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:62897 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762821AbXJXQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=JrGKWK4JPaNnMzenbBrfwDaOJPphqy5QP/4S9hPl4cOCqexP8rGoJtX6dIWQXfcMm5pV6AWwRGa2IeyLNlC6ZG0oTd9tUefNmuVYafwdfLelPpzpfDjLm8hrBgbId/As/FmYBCSWE2YoqTvUqw6KmPwJ+Fc2DC2UwxADjQQPYUI=
Date: Wed, 24 Oct 2007 18:50:22 -0700
To: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org
Cc: linux-main <linux-kernel@vger.kernel.org>,
       linuxsh <linuxsh-dev@lists.sourceforge.net>
Subject: [PATA/LIBATA] No init found / init=/bin/sh failure
Message-Id: <20071024185022.58b1f2d2.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff any libata changes that might explain this?

I've been bugtracking this the last couple of days, but getting nowhere.
Same configuration was working less than a month ago. It uses pata_platform.c which in turn registers an ata device.

scsi0 : pata_platform
ata1: PATA max PIO0 mmio cmd 0x150001f0 ctl 0x150001fe irq 77
ata1.00: CFA: Hitachi XX.V.3.5.0.0, Rev 0.00, max PIO4
ata1.00: 2002896 sectors, multi 0: LBA 
ata1.00: configured for PIO
scsi 0:0:0:0: Direct-Access     ATA      Hitachi XX.V.3.5 Rev  PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0

This segment looks just as it usually does.

Any suggestions on how to bugtrack this, setting init=/bin/sh doesn't do anything.

Best wishes
Kristoffer Ericson


Bootlog:
Linux version 2.6.23-g6a6ebaa2-dirty (kristoffer@NightCrawler) (gcc version 3.4.5) #4 Sun Oct 21 21:41:45 PDT 2007
Booting machvec: hp6xx
Node 0: start_pfn = 0xd000, low = 0xf000
Zone PFN ranges:
  Normal      53248 ->    61440
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:    53248 ->    61440
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: mem=32M root=/dev/sda2 console=ttySC1,115200 init=/bin/sh
PID hash table entries: 128 (order: 7, 512 bytes)
Using tmu for system timer
Using 5.528 MHz high precision timer.
Console: colour dummy device 80x25
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 29132k/32768k available (2467k kernel code, 657k data, 84k init)
Mount-cache hash table entries: 512
CPU: SH7729
net_namespace: 64 bytes
NET: Registered protocol family 16
SCSI subsystem initialized
DMA: Registering DMA API.
DMA: Registering sh_dmac handler (4 channels).
Time: SuperH clocksource has been installed.
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
HD64461 configured at 0xb0000000 on irq 36(mapped into 64 to 79)
HD64461: enabling PCMCIA devices
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Console: switching to colour frame buffer device 80x30
fb0: Hitachi HD64461 frame buffer device
SuperH SCI(F) driver initialized
sh-sci: ttySC0 at MMIO 0xfffffe80 (irq = 25) is a sci
sh-sci: ttySC1 at MMIO 0xa4000150 (irq = 59) is a scif
console [ttySC1] enabled
sh-sci: ttySC2 at MMIO 0xa4000140 (irq = 55) is a irda
loop: module loaded
scsi0 : pata_platform
ata1: PATA max PIO0 mmio cmd 0x150001f0 ctl 0x150001fe irq 77
ata1.00: CFA: Hitachi XX.V.3.5.0.0, Rev 0.00, max PIO4
ata1.00: 2002896 sectors, multi 0: LBA 
ata1.00: configured for PIO
scsi 0:0:0:0: Direct-Access     ATA      Hitachi XX.V.3.5 Rev  PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 2002896 512-byte hardware sectors (1025 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI removable disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
hd64461_ss_init: pcmcia driver for hd64461 chipset started
hd64461_init: request for irq  78 accepted
hd64461_ss_init: init_socket returned with 0
hd64461_ss_init: setting socket device
hd64461_ss_init: registering socket hd64461_sockets[0].socket
input: HP Jornada 680 keyboard as /devices/platform/jornada680_kbd/input/input0
We have successfully registerd the keyboard driver
input: HP Jornada 680 touchscreen as /devices/virtual/input/input1
sh-rtc sh-rtc: rtc core: registered sh as rtc0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
sh-rtc sh-rtc: setting the system clock to 1999-01-01 00:01:27 (915148887)
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 84k freed
Failed to execute /bin/sh.  Attempting defaults...
Kernel panic - not syncing: No init found.  Try passing init= option to kernel.


