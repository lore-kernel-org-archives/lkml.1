Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZCEW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZCEW0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZCEW03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:26:29 -0500
Received: from smtp1.infomaniak.ch ([84.16.68.89]:47533 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbZCEW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:26:27 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 17:26:27 EST
Message-ID: <49B04FC0.4070102@calvert.ch>
Date: Thu, 05 Mar 2009 23:18:40 +0100
From: Thomas Calvert <thomas@calvert.ch>
User-Agent: Thunderbird 2.0.0.19 (X11/20090303)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel oops when writing NAND - hardware failure?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on smtp1 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to you all!

This is my first time posting on this list, so if I transgress any rules 
please forgive me (and tell me so I won't do it again).

I have an embedded ARM926EJ-based at91sam9263ek board on which I want to 
get a JFFS2 partition on NAND.

Unfortunately, whenever I try to fill the filesystem (by regular cp onto 
the mounted partition or by dd'ing an image), I eventually get a kernel 
oops. Usually I have to scrub the NAND afterwards for that part to 
become usable again (subsequent accesses immediately generate I/O 
error). This happens both with my kernel and with the precompiled one 
from linux4sam.org.

My question is, is this a hardware fault? Or have I done something 
wrong? I am aware that I am not the most knowledgeable person in the 
embedded area, but my googling has not yielded any results, and I would 
be most grateful for any tips.

I am not suscribed to the list, please CC me any follow-ups.

Thank you in advance,
- Thomas

Typical oops (always seems to happen at a different moment) :

Unable to handle kernel paging request at virtual address e5945b1c
pgd = c3ad4000
[e5945b1c] *pgd=00000000
Internal error: Oops: 0 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.27 #5)
PC is at 0xe5945b1c
LR is at nand_write_page+0x80/0xd8
pc : [<e5945b1c>]    lr : [<c01b3cd0>]    psr: 40000013
sp : c3973a60  ip : 000000c3  fp : c3973a84
r10: 00000800  r9 : 00000000  r8 : 0001f084
r7 : 0001f084  r6 : c3ab4000  r5 : c39fe718  r4 : c39fe600
r3 : ffffffff  r2 : ffffffff  r1 : 00000010  r0 : c39fe718
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 23ad4000  DAC: 00000015
Process cp (pid: 871, stack limit = 0xc3972268)
Stack: (0xc3973a60 to 0xc3974000)
3a60: c3973a84 c3973a70 00000800 c39fe600 00000000 c3ab4000 c3973adc 
c3973a88
3a80: c01b4288 c01b3c60 00000000 00000000 09700722 c39fe718 00000000 
0001f084
3aa0: 0000003f 00000000 00000000 c3ab4000 00000000 c39fe600 c39fe718 
0f842000
3ac0: 00000000 00000800 0f5a2434 00000800 c3973b0c c3973ae0 c01b4480 
c01b3ff4
3ae0: c39fe6e4 083009b9 0f5a2000 00000000 0fd60000 00000000 00000000 
00000044
3b00: c3973b3c c3973b10 c01ad07c c01b43f8 00000800 c3973b74 c3ab4000 
099a09c9
3b20: c3aa942c c3aa942c c3af8f24 c3aa9400 c3973ba4 c3973b40 c013a034 
c01acfdc
3b40: 00000800 c3973b74 c3ab4000 09430983 08c30912 0863096e 07e308f2 
087d0801
3b60: 06fa09c0 06630961 09ef08b2 05c80543 07c80892 c3aa9400 c3aa9400 
00000800
3b80: 00000e84 c3aa9400 00000000 c3a7d000 0f5a2434 00000044 c3973c0c 
c3973ba8
3ba0: c013ad98 c0139eb8 09e9089d 07bd08dd 0000091f 09620770 08270792 
00000002
3bc0: c3973c30 c3aa951c 00000001 00000008 0f5a2434 0f5a23f0 080f077d 
000003cc
3be0: c3a7d000 c3a7d000 c3aa2000 0f5a23f0 00000000 0f5a23f0 c3bb3600 
c3aa9400
3c00: c3973c74 c3973c10 c01325f8 c013ab98 0f5a23f0 00000000 c3973c44 
000017e1
3c20: c1b796d8 00000ec8 00000000 00000002 c3aa2000 00000044 c3a7d000 
00000e84
3c40: 00001000 00001000 00001000 00000000 00000000 00000007 00000005 
00000520
3c60: c3aa2000 c1b796d8 c3973cd4 c3973c78 c0132c88 c0132478 00000e84 
00000003
3c80: 00000084 00000007 c08f7000 c3aa9400 00000000 00000000 00000e84 
00001000
3ca0: 0001dba0 c3a7d000 00001000 c3aa2028 c3aa2000 c1b79700 c0355ee0 
00000000
3cc0: 00001000 00000000 c3973d34 c3973cd8 c012d52c c01329dc 00052000 
00001000
3ce0: c3973d04 c00edc40 00052000 00000000 00052000 00000000 00001000 
c3aa9400
3d00: 00000000 00000000 00001000 00001000 00001000 00052000 00000000 
00000000
3d20: c3973d88 c3972000 c3973dcc c3973d38 c0065f34 c012d3a4 00001000 
00001000
3d40: c0355ee0 c009a7f0 c1b79798 c3973e98 c3964400 c1b79798 c02717a4 
c1b79700
3d60: 00000000 00001000 00000000 c02717a4 c00433cc c0042f50 49b04975 
02425cc3
3d80: c009de78 c3973da0 c3973f28 00000001 00000000 00002000 c009a7f0 
c0355ee0
3da0: 49b04975 c1b79700 00002000 00052000 00000000 c1b79700 00000000 
c3973f28
3dc0: c3973e4c c3973dd0 c0066a78 c0065db8 00052000 00000000 c3973ee8 
00002000
3de0: 00000000 c3973df0 c3973ee8 c3973e98 00000000 00000054 c3964400 
c1b79798
3e00: 00000000 00000001 00000053 00000001 00000015 00002000 00000000 
00002000
3e20: 00000000 c1b7976c c3973e98 c3973f28 c1b79700 00052000 00000000 
00000001
3e40: c3973e8c c3973e50 c0066b60 c0066668 c00ec8e4 c0066e58 c3964400 
c1b79798
3e60: c3973f78 c3973e98 c3964400 c3973f78 00002000 c002a3cc c3972000 
00900004
3e80: c3973f4c c3973e90 c0086570 c0066af8 00052000 00000000 00000000 
49b04973
3ea0: 00000000 00000001 ffffffff c3964400 00000000 00000000 00000000 
00000000
3ec0: c3872900 00000001 00000000 00000000 00000000 c3872900 c0052a30 
c3973edc
3ee0: c3973edc 00001000 00052000 00000000 49b04973 00000000 c0326008 
c39f1238
3f00: 00002000 00000024 c3973f3c c3973f18 c003ab58 00000000 00000000 
c342dbd4
3f20: c3973f54 00000001 00025000 00002000 c3964400 c3964400 00025000 
c3973f78
3f40: c3973f74 c3973f50 c0086e74 c00864d0 00000000 c00564a8 c3964400 
fffffff7
3f60: 00052000 00000000 c3973fa4 c3973f78 c008732c c0086dcc 00052000 
00000000
3f80: c0263578 00000000 00002000 00002000 00025000 00000004 00000000 
c3973fa8
3fa0: c0029ba0 c00872f8 00002000 00002000 00000004 00025000 00002000 
00000000
3fc0: 00002000 00002000 00025000 00000004 7fffe000 0001fbf0 000219e0 
be944810
3fe0: 00000000 be9444f8 000120d4 401092a4 60000010 00000004 00000000 
00000000
Backtrace:
[<c01b3c50>] (nand_write_page+0x0/0xd8) from [<c01b4288>] 
(nand_do_write_ops+0x2a4/0x328)
 r7:c3ab4000 r6:00000000 r5:c39fe600 r4:00000800
[<c01b3fe4>] (nand_do_write_ops+0x0/0x328) from [<c01b4480>] 
(nand_write+0x98/0xbc)
[<c01b43e8>] (nand_write+0x0/0xbc) from [<c01ad07c>] (part_write+0xb0/0xb8)
[<c01acfcc>] (part_write+0x0/0xb8) from [<c013a034>] 
(__jffs2_flush_wbuf+0x18c/0xce0)
 r6:c3aa9400 r5:c3af8f24 r4:c3aa942c
[<c0139ea8>] (__jffs2_flush_wbuf+0x0/0xce0) from [<c013ad98>] 
(jffs2_flash_writev+0x210/0x418)
[<c013ab88>] (jffs2_flash_writev+0x0/0x418) from [<c01325f8>] 
(jffs2_write_dnode+0x190/0x43c)
[<c0132468>] (jffs2_write_dnode+0x0/0x43c) from [<c0132c88>] 
(jffs2_write_inode_range+0x2bc/0x3ec)
[<c01329cc>] (jffs2_write_inode_range+0x0/0x3ec) from [<c012d52c>] 
(jffs2_write_end+0x198/0x2f0)
[<c012d394>] (jffs2_write_end+0x0/0x2f0) from [<c0065f34>] 
(generic_file_buffered_write+0x18c/0x668)
[<c0065da8>] (generic_file_buffered_write+0x0/0x668) from [<c0066a78>] 
(__generic_file_aio_write_nolock+0x420/0x490)
[<c0066658>] (__generic_file_aio_write_nolock+0x0/0x490) from 
[<c0066b60>] (generic_file_aio_write+0x78/0xf4)
[<c0066ae8>] (generic_file_aio_write+0x0/0xf4) from [<c0086570>] 
(do_sync_write+0xb0/0x100)
[<c00864c0>] (do_sync_write+0x0/0x100) from [<c0086e74>] 
(vfs_write+0xb8/0x148)
 r6:c3973f78 r5:00025000 r4:c3964400
[<c0086dbc>] (vfs_write+0x0/0x148) from [<c008732c>] (sys_write+0x44/0x70)
 r7:00000000 r6:00052000 r5:fffffff7 r4:c3964400
[<c00872e8>] (sys_write+0x0/0x70) from [<c0029ba0>] 
(ret_fast_syscall+0x0/0x2c)
 r7:00000004 r6:00025000 r5:00002000 r4:00002000
Code: bad PC value.
---[ end trace 102f070c3025cfd0 ]---
