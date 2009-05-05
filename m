Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZEEBa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZEEBa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 21:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZEEBaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 21:30:19 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:34913 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754203AbZEEBaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 21:30:17 -0400
Message-ID: <49FF96A7.5040401@snapgear.com>
Date: Tue, 05 May 2009 11:30:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: BUG: failure at mm/nommu.c:518/add_nommu_region()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

I am getting this BUG_ON with linux-2.6.30-rc4-git1, that I wasn't
getting with linux-2.6.30-rc3:


uClinux/COLDFIRE(m520x)
COLDFIRE port done by Greg Ungerer, gerg@snapgear.com
Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: root=/dev/mtdblock0
NR_IRQS:256
PID hash table entries: 128 (order: 7, 512 bytes)
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory available: 30160k/32768k RAM, (1144k kernel code, 159k data)
SLUB: Genslabs=13, HWalign=16, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop... 109.36 BogoMIPS (lpj=546816)
Mount-cache hash table entries: 512
net_namespace: 520 bytes
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
ROMFS MTD (C) 2007 Red Hat, Inc.
io scheduler noop registered (default)
ColdFire internal UART serial driver
ttyS0 at MMIO 0xfc060000 (irq = 90) is a ColdFire UART
console [ttyS0] enabled
ttyS1 at MMIO 0xfc064000 (irq = 91) is a ColdFire UART
ttyS2 at MMIO 0xfc068000 (irq = 92) is a ColdFire UART
brd: module loaded
FEC Ethernet Driver
fec: PHY @ 0x1, ID 0x20005c90 -- DP83848
eth0 (fec): not using net_device_ops yet
uclinux[mtd]: RAM probe address=0x40165e98 size=0xdc000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000000dc000 : "ROMfs"
TCP cubic registered
NET: Registered protocol family 17
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 44k freed (0x40150000 - 0x4015a000)
BUG: failure at mm/nommu.c:518/add_nommu_region()!
Kernel panic - not syncing: BUG!


This is on a ColdFire non-MMU target (using ROMfs with MTD backing
store).

Could it be related to the recent changes to mm/nommu.c?
I didn't revert those to see yet...

Removing the BUG_ON() I can boot all the way up, not sure if it
is still a valid check.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
