Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZEHVr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZEHVr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZEHVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:47:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33901 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbZEHVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:47:19 -0400
Date: Fri, 8 May 2009 23:47:18 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>
Subject: Possible boot race (seen on MX35)
Message-ID: <20090508214718.GP15802@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 23:43:56 up 79 days, 13:37, 18 users,  load average: 89.77,
	54.99, 26.47
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing 2.6.30-rc4 on i.MX35 (with mxc-master ontop of the vanilla
-rc4) I have seen the following oops. As it went away by booting the
board again and didn't show up0 again even after several boots, I assume
it could be a race coming from the recent fast boot activities? Does
anyone have an idea?

After the oops, the board continues booting as usual.

rsc

----------8<----------

Uncompressing Linux.................................................................................................................... done, booting the kernel.
Linux version 2.6.30-rc4-ptx-mxc1 (jbe§octopus) (gcc version 4.3.2 (OSELAS.Toolchain-1.99.3) ) #1 PREEMPT Fri May 8 22:04:53 CEST 2009
CPU: ARMv6-compatible processor Ä4117b363Ü revision 3 (ARMv6TEJ), cr=00c5387f
CPU: VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
Machine: Phytec Phycore pcm043
Memory policy: ECC disabled, Data cache writeback
On node 0 totalpages: 32768
free_area_init_node: node 0, pgdat c038a0f0, node_mem_map c03a4000
  Normal zone: 256 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 32512 pages, LIFO batch:7
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: console=ttymxc0,115200 video=mx3fb:Sharp-LQ035Q7 ip=192.168.24.47:192.168.23.2:192.168.23.1:255.255.0.0::: root=/dev/nfs nfsroot=192.168.23.2:/home/jbe/work/bsp/phytec/phyCORE/OSELAS.BSP-phyCORE-trunk/platform-phyCORE-i.MX35/root,v3,tcp mtdparts="physmap-flash.0:256k(uboot)ro,128k(ubootenv),2M(kernel),-(root)"
NR_IRQS:180
MXC GPIO hardware
MXC IRQ initialized
PID hash table entries: 512 (order: 9, 2048 bytes)
Console: colour dummy device 80x30
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 128MB = 128MB total
Memory: 126064KB available (3224K code, 258K data, 108K init, 0K highmem)
Calibrating delay loop... 398.13 BogoMIPS (lpj=1990656)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
net_namespace: 296 bytes
regulator: core version 0.5
NET: Registered protocol family 16
Unable to handle kernel NULL pointer dereference at virtual address 000000e4
pgd = c0004000
Ä000000e4Ü *pgd=00000000
Internal error: Oops: 805 Ä#1Ü PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.30-rc4-ptx-mxc1 #1)
PC is at call_usermodehelper_setup+0x44/0x78
LR is at exit_notify+0x168/0x184
pc : Ä<c004aa00>Ü    lr : Ä<c003d620>Ü    psr: 00000013
sp : c786dff8  ip : 00000000  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000000  r5 : 0000003c  r4 : 000000cc
r3 : c003d620  r2 : c004aa00  r1 : c781ca00  r0 : c781ca00
Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 00c5387f  Table: 80004008  DAC: 00000017
Process khelper (pid: 27, stack limit = 0xc786c260)
Stack: (0xc786dff8 to 0xc786e000)
dfe0:                                                       00000000 00000000
Ä<c004aa00>Ü (call_usermodehelper_setup+0x44/0x78) from Ä<c78c5c40>Ü (0xc78c5c40)
Code: e4823004 e59f3034 e5842008 e584300c (e5846018)
---Ä end trace 1b75b31a2719ed1c Ü---

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
