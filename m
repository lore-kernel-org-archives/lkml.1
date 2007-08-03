Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXHCB2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXHCB2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbXHCB2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:28:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:18525 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbXHCB2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hHZuvNbssW7PoDlBJCBhDxOMLnDrXOQm1r9QcRGf7GpFzmTXIrxNI1BoiNPtHlR4BO/cu4xLK2Oupn5u9lgLuBbklB4Ng26nLL+U8SzdIb1es/rPzEwLhkL7VyxW7AiyQ5jZJLP7VIpMPBoNnxO6T4bzZf5XHG3fmV5H84c91CE=
Message-ID: <9f37d7da0708021828h1f9070eax4ae4f5f24d136c19@mail.gmail.com>
Date: Fri, 3 Aug 2007 10:28:09 +0900
From: "Park Sangsu" <sangsu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem with USB Gadget Filesystem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone.
Now I'm developing USB Mass Storage App with
GadgetFS(drivers/usb/gadget/inode.c).
(linux kernel version is 2.6.17. We ported it to arm(s5c7329).
The target board is now FPGA board.
USB chip is 3884-0 DWC USB 2.0 HS OTG of Synopsys.)
But, when plug in USB to Desktop PC(Win xp pro), kernel panic
occur. The panic messages are like below. How can I debug like this panic?
Or is there anybody to tell me about below situation?


complete_ep :complete_ep :read_packet
complete_ep :complete_ep :read_packet
complete_ep :complete_ep :read_packet
complete_ep :<1>Unable to handle kernel NULL pointer dereference at virtual add4
pgd = c5f24000
[00000004] *pgd=256a2031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1]
Modules linked in:
CPU: 0
PC is at kfree+0x50/0x9c
LR is at ep_read+0xd8/0x16c
pc : [<c0066854>]    lr : [<c0126324>]    Not tainted
sp : c566ff1c  ip : c566ff38  fp : c566ff34
r10: 40037000  r9 : c566e000  r8 : 0000001f
r7 : c027f940  r6 : a0000013  r5 : c027f940  r4 : 00000004
r3 : 00000080  r2 : c018ec30  r1 : c0198fe0  r0 : c01930c0
Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  Segment user
Control: 5317F  Table: 25F24000  DAC: 00000015
Process ums (pid: 133, stack limit = 0xc566e198)
Stack: (0xc566ff1c to 0xc5670000)
ff00:                                                                0000001f
ff20: c17b4460 0003c4da c566ff58 c566ff38 c0126324 c0066814 c02a8580 0003c4da
ff40: c566e000 c012624c c566ff80 c566ff7c c566ff5c c006ae9c c012625c 00000000
ff60: 00000000 c02a8580 00000003 c001af84 c566ffa4 c566ff80 c006b194 c006ae00
ff80: 00000000 00000000 00000001 00000000 bddffbe0 0000c004 00000000 c566ffa8
ffa0: c001ade0 c006b154 00000000 bddffbe0 00000007 0003c4da 0000001f 00000001
ffc0: 00000000 bddffbe0 0000c004 001ff000 00000004 bdc01000 40037000 bddff9ec
ffe0: 00000000 bddff9bc 4002ca30 4002ca44 60000010 00000007 00000000 00000000
Backtrace:
[<c0066804>] (kfree+0x0/0x9c) from [<c0126324>] (ep_read+0xd8/0x16c)
 r6 = 0003C4DA  r5 = C17B4460  r4 = 0000001F
[<c012624c>] (ep_read+0x0/0x16c) from [<c006ae9c>] (vfs_read+0xac/0x124)
 r8 = C566FF80  r7 = C012624C  r6 = C566E000  r5 = 0003C4DA
 r4 = C02A8580
[<c006adf0>] (vfs_read+0x0/0x124) from [<c006b194>] (sys_read+0x50/0x88)
 r8 = C001AF84  r7 = 00000003  r6 = C02A8580  r5 = 00000000
 r4 = 00000000
[<c006b144>] (sys_read+0x0/0x88) from [<c001ade0>] (ret_fast_syscall+0x0/0x2c)
 r6 = 0000C004  r5 = BDDFFBE0  r4 = 00000000
Code: e3130901 1591100c e5910018 e5904000 (e5943000)
 <1>Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = c0004000
[00000004] *pgd=00000000
Internal error: Oops: 17 [#2]
Modules linked in:
CPU: 0
PC is at drain_array+0x18/0xd0
LR is at cache_reap+0x68/0x1f0
pc : [<c0066b28>]    lr : [<c0068420>]    Not tainted
sp : c17d5efc  ip : c17d5f18  fp : c17d5f14
r10: 00000000  r9 : 00000000  r8 : c0280770
r7 : c0193108  r6 : c01930c0  r5 : 00000001  r4 : 00000004
r3 : 00000000  r2 : 00000004  r1 : 00000000  r0 : c01930c0
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
Control: 5317F  Table: 25F24000  DAC: 00000017
Process events/0 (pid: 3, stack limit = 0xc17d4198)
Stack: (0xc17d5efc to 0xc17d6000)
5ee0:                                                                c027e860
5f00: 00000001 c01930c0 c17d5f48 c17d5f18 c0068420 c0066b20 00000000 c012ea38
5f20: c02806a0 80000013 c00683b8 c02806a8 c02806a0 00000000 c17d5f88 c17d5f68
5f40: c17d5f4c c0040db4 c00683c8 c02806b0 c02806a8 c17d5f98 c17d4000 c17d5fc0
5f60: c17d5f6c c0040f44 c0040d30 ffffffff ffffffff 00000001 00000000 c002cd64
5f80: 00010000 00000000 00000000 c028f7c0 c002cd64 00100100 00200200 c0040e30
5fa0: c17d4000 fffffffc c0297efc c02806a0 00000001 c17d5ff4 c17d5fc4 c004494c
5fc0: c0040e40 00000001 ffffffff ffffffff 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 c17d5ff8 c0032c08 c0044854 00000000 00000000
Backtrace:
[<c0066b10>] (drain_array+0x0/0xd0) from [<c0068420>] (cache_reap+0x68/0x1f0)
 r6 = C01930C0  r5 = 00000001  r4 = C027E860
[<c00683b8>] (cache_reap+0x0/0x1f0) from [<c0040db4>] (run_workqueue+0x94/0x110)
[<c0040d20>] (run_workqueue+0x0/0x110) from [<c0040f44>] (worker_thread+0x114/0)
 r7 = C17D4000  r6 = C17D5F98  r5 = C02806A8  r4 = C02806B0
[<c0040e30>] (worker_thread+0x0/0x158) from [<c004494c>] (kthread+0x108/0x134)
[<c0044844>] (kthread+0x0/0x134) from [<c0032c08>] (do_exit+0x0/0x894)
Code: e24cb004 e2524000 e1a01003 089da870 (e5943000)
 ==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
[Info]: UMS_CONNECT==> gadgetfs event 3
