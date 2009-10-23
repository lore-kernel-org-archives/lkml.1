Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbZJWJhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbZJWJhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZJWJhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:37:31 -0400
Received: from chipmunk.wormnet.eu ([195.195.131.226]:47558 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZJWJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:37:30 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 05:37:29 EDT
Date: Fri, 23 Oct 2009 10:30:56 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at fs/dcache.c:670 +lvm +md +ext3 (snapshots)
Message-ID: <20091023093056.GW6085@chipmunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Whilst running a 'fun and wild' USB key based RAID1 with LVM I got hit 
with an BUG when making a snapshot of an ext3 based LV with:

/sbin/lvcreate -n SNAP-06_student-db -s -l 256 -p r /dev/lvm-northdown/student-db

The spiel below is what I got hit by, if any more information is needed 
then let me know.

As you can seen it's 2.6.32-rc5 I'm running with a merge of the Marvell 
Orion git tree[1] on top of that....nothing too fancy.  The OS is Debian 
'lenny' stable for armel and the board is an OpenRD Client.

Cheers

[1] http://git.marvell.com/?p=orion.git;a=summary

BUG: Dentry cdb2f100{i=2,n=/} still in use (1) [unmount of ext3 dm-1]
kernel BUG at fs/dcache.c:670!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = df378000
[00000000] *pgd=1f27c031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/devices/virtual/block/dm-5/removable
CPU: 0    Not tainted  (2.6.32-rc5-00014-gdd0f698 #13)
PC is at __bug+0x20/0x2c
LR is at release_console_sem+0x1a4/0x208
pc : [<c002d3c0>]    lr : [<c003cad8>]    psr: 60000013
sp : c2ed7d78  ip : c2ed7cb8  fp : c2ed7d84
r10: 00200200  r9 : 00100100  r8 : c04590fc
r7 : df51eeb8  r6 : 00000006  r5 : cdb2f100  r4 : cdb2f100
r3 : 00000000  r2 : c04540d4  r1 : 00005669  r0 : 00000025
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 1f378000  DAC: 00000015
Process lvcreate (pid: 6994, stack limit = 0xc2ed6270)
Stack: (0xc2ed7d78 to 0xc2ed8000)
7d60:                                                       c2ed7dc4 c2ed7d88
7d80: c0098d18 c002d3b0 00000001 c0406936 dfa94f54 c2d36348 00000003 dfa94e00
7da0: c03867c8 df421860 df4218bc d40bda0c c2ed6000 c0271f10 c2ed7ddc c2ed7dc8
7dc0: c0098e7c c0098b74 c2ed7e04 dfa94e00 c2ed7df4 c2ed7de0 c008a7dc c0098e2c
7de0: df421860 00000001 c2ed7e0c c2ed7df8 c008a8e8 c008a7c8 dfa94e00 c04597f0
7e00: c2ed7e24 c2ed7e10 c008a9b8 c008a8d8 dfa94e00 df421860 c2ed7e44 c2ed7e28
7e20: c00afa60 c008a988 d40bda00 d40bda00 df030480 00000000 c2ed7e5c c2ed7e48
7e40: c026c220 c00af998 c004c19c 00000000 c2ed7e84 c2ed7e60 c026d1a0 c026c204
7e60: d40bda00 00000000 d40bda00 e2fc5000 df030480 c138fd06 c2ed7ea4 c2ed7e88
7e80: c0272074 c026d0f4 00000000 00000006 c2ed6000 000bfd78 c2ed7eec c2ed7ea8
7ea0: c0272ab4 c0271f20 0000000d 00000000 00000000 000004cc 00000004 0000000f
7ec0: 00000000 e2fc5000 dfb4b980 c138fd06 000bfd78 dfb4b980 000bfd78 00000046
7ee0: c2ed7f0c c2ed7ef0 c00948e4 c02728a0 4adeecb6 00000003 dfb4b980 00000003
7f00: c2ed7f7c c2ed7f10 c009500c c00948bc c0036180 c01a36e0 df890bd0 c0453b58
7f20: c992e8d0 007d1a9f 00000000 c992e8a0 c2ed7f54 c2ed7f40 c003629c c00360b0
7f40: 00048ecb 00000000 c2ed7fac c2ed7f58 c037fd4c 00000003 000bfd78 c138fd06
7f60: dfb4b980 c002a0a4 c2ed6000 00000046 c2ed7fa4 c2ed7f80 c00950b4 c0094b20
7f80: 00001000 00000000 0004fa9c 40038220 0000004e 00000036 00000000 c2ed7fa8
7fa0: c0029f20 c0095084 0004fa9c 40038220 00000003 c138fd06 000bfd78 00001258
7fc0: 0004fa9c 40038220 0000004e 00000036 000c8888 000bfd78 00000046 000000fd
7fe0: 40042580 bef5e338 40036470 40156fbc 20000010 00000003 00000000 00000000
Backtrace: 
[<c002d3a0>] (__bug+0x0/0x2c) from [<c0098d18>] (shrink_dcache_for_umount_subtree+0x1b4/0x2b8)
[<c0098b64>] (shrink_dcache_for_umount_subtree+0x0/0x2b8) from [<c0098e7c>] (shrink_dcache_for_umount+0x60/0x78)
[<c0098e1c>] (shrink_dcache_for_umount+0x0/0x78) from [<c008a7dc>] (generic_shutdown_super+0x24/0x110)
 r4:dfa94e00
[<c008a7b8>] (generic_shutdown_super+0x0/0x110) from [<c008a8e8>] (kill_block_super+0x20/0x38)
 r5:00000001 r4:df421860
[<c008a8c8>] (kill_block_super+0x0/0x38) from [<c008a9b8>] (deactivate_locked_super+0x40/0x64)
 r5:c04597f0 r4:dfa94e00
[<c008a978>] (deactivate_locked_super+0x0/0x64) from [<c00afa60>] (thaw_bdev+0xd8/0xf8)
 r5:df421860 r4:dfa94e00
[<c00af988>] (thaw_bdev+0x0/0xf8) from [<c026c220>] (unlock_fs+0x2c/0x54)
 r7:00000000 r6:df030480 r5:d40bda00 r4:d40bda00
[<c026c1f4>] (unlock_fs+0x0/0x54) from [<c026d1a0>] (dm_resume+0xbc/0x100)
 r4:00000000
[<c026d0e4>] (dm_resume+0x0/0x100) from [<c0272074>] (dev_suspend+0x164/0x1a4)
 r8:c138fd06 r7:df030480 r6:e2fc5000 r5:d40bda00 r4:00000000
[<c0271f10>] (dev_suspend+0x0/0x1a4) from [<c0272ab4>] (dm_ctl_ioctl+0x224/0x2a4)
 r7:000bfd78 r6:c2ed6000 r5:00000006 r4:00000000
[<c0272890>] (dm_ctl_ioctl+0x0/0x2a4) from [<c00948e4>] (vfs_ioctl+0x38/0x7c)
[<c00948ac>] (vfs_ioctl+0x0/0x7c) from [<c009500c>] (do_vfs_ioctl+0x4fc/0x564)
 r6:00000003 r5:dfb4b980 r4:00000003
[<c0094b10>] (do_vfs_ioctl+0x0/0x564) from [<c00950b4>] (sys_ioctl+0x40/0x64)
[<c0095074>] (sys_ioctl+0x0/0x64) from [<c0029f20>] (ret_fast_syscall+0x0/0x28)
 r7:00000036 r6:0000004e r5:40038220 r4:0004fa9c
Code: e1a01000 e59f000c eb0d48e2 e3a03000 (e5833000) 
---[ end trace aea992f03fbb0ee3 ]---

-- 
Alexander Clouter
.sigmonster says: Give your child mental blocks for Christmas.
