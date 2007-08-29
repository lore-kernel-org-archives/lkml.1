Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbXH2Ru3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbXH2Ru3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbXH2RuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:50:22 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:21642 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXH2RuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:50:21 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wed, 29 Aug 2007 19:50:14 +0200
User-Agent: PLD Linux KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708291950.14513.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I guess I should sent these here since it looks like not scsi bug anyway.

----------  Forwarded Message  ----------

Subject: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wednesday 29 of August 2007
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-scsi@vger.kernel.org

Hello,

I'm trying to get stable kernel for Promise SuperTrak 
X16350 hardware. So far 2.6.20, 2.6.21 and 2.6.22 oopsed
like this (while doing rsync):

kernel BUG at block/elevator.c:366!
invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: softdog sch_sfq forcedeth ext3 jbd mbcache dm_mod xfs 
scsi_wait_scan sd_mod stex scsi_mod
Pid: 1139:#0, comm: xfsbufd Not tainted 2.6.22.5-0.2 #1
RIP: 0010:[<ffffffff8033f5da>]  [<ffffffff8033f5da>] elv_rb_del+0x3a/0x40
RSP: 0000:ffff8100759b1c00  EFLAGS: 00010046
RAX: ffff81000d1f5428 RBX: ffff81000d1f5428 RCX: ffff81007c1a1a00
RDX: 0000000000000000 RSI: ffff81000d1f53b0 RDI: ffff81007c102af0
RBP: ffff81000d1f53b0 R08: ffff81004a9dab50 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff880072c0 R12: ffff81007c102ac0
R13: ffff81007c1a1a00 R14: 0000000000000004 R15: ffff81007c102b18
FS:  00002ba2cafc9be0(0000) GS:ffff81007d0a5b40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ba2cab5a158 CR3: 000000003c5ce000 CR4: 00000000000006e0
Process xfsbufd (pid: 1139[#0], threadinfo ffff8100759b0000, task 
ffff81007cac1040)
Stack:  0000000000000001 ffff81007c102ac0 ffff81000d1f53b0 ffffffff8034abe8
 0000000000000246 ffff81000d1f53b0 ffff81007c1a1a00 ffff81007c102ac0
 ffff81007c0f2d08 0000000000000004 ffff81007c102b18 ffffffff8034ad55
Call Trace:
 [<ffffffff8034abe8>] cfq_remove_request+0x78/0x1b0
 [<ffffffff8034ad55>] cfq_dispatch_insert+0x35/0x70
 [<ffffffff8034b61f>] cfq_dispatch_requests+0x1bf/0x3a0
 [<ffffffff8033f11f>] elv_next_request+0x3f/0x150
 [<ffffffff80243b04>] lock_timer_base+0x34/0x70
 [<ffffffff88007329>] :scsi_mod:scsi_request_fn+0x69/0x3d0
 [<ffffffff80343d46>] __make_request+0xe6/0x5d0
 [<ffffffff8034158b>] generic_make_request+0x18b/0x230
 [<ffffffff8034438a>] submit_bio+0x5a/0xf0
 [<ffffffff8808d1e9>] :xfs:_xfs_buf_ioapply+0x199/0x340
 [<ffffffff8808e099>] :xfs:xfs_buf_iorequest+0x29/0x80
 [<ffffffff88092fbb>] :xfs:xfs_bdstrat_cb+0x3b/0x50
 [<ffffffff8808e3c2>] :xfs:xfsbufd+0x92/0x140
 [<ffffffff8808e330>] :xfs:xfsbufd+0x0/0x140
 [<ffffffff8024fa3b>] kthread+0x4b/0x80
 [<ffffffff8020b0a8>] child_rip+0xa/0x12
 [<ffffffff8024f9f0>] kthread+0x0/0x80
 [<ffffffff8020b09e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 66 90 48 83 ec 08 49 89 f8 48 89 f8 31 c9 eb 09
RIP  [<ffffffff8033f5da>] elv_rb_del+0x3a/0x40
 RSP <ffff8100759b1c00>


I can reproduce it without bigger problem.


Here are the same oopses on 2.6.20:
http://paste.stgraber.org/3138

This is 1 x dual core athlon64 on asus m2npv mainboard, 2GB RAM.
There is hw raid on fasttrack 16350 only (no software one).

Has anyone seen this ?

Going to try without cfq.

-- 
Arkadiusz Mi턪iewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-------------------------------------------------------

----------  Forwarded Message  ----------

Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wednesday 29 of August 2007
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-scsi@vger.kernel.org

On Wednesday 29 of August 2007, Arkadiusz Miskiewicz wrote:
> Hello,
>
> I'm trying to get stable kernel for Promise SuperTrak
> X16350 hardware. So far 2.6.20, 2.6.21 and 2.6.22 oopsed
> like this (while doing rsync):

With anticipatory:

berta login: ------------[ cut here ]------------
kernel BUG at block/as-iosched.c:1084!
invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: softdog sch_sfq forcedeth ext3 jbd mbcache dm_mod xfs 
scsi_wait_scan sd_mod stex scsi_mod
Pid: 32:#0, comm: kblockd/1 Not tainted 2.6.22.5-0.2 #1
RIP: 0010:[<ffffffff80349028>]  [<ffffffff80349028>] 
as_dispatch_request+0x438/0x460
RSP: 0018:ffff81007d1fddc0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81007c765a00 RCX: 00000000ffffffff
RDX: ffff81007c765a28 RSI: 0000000000000000 RDI: ffff81007c54ad08
RBP: 0000000000000000 R08: ffffffffffffffff R09: ffff81006a289d80
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: ffff81007cf85048
FS:  00002ba4421e8b00(0000) GS:ffff81007d0a5b40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ba46298f000 CR3: 0000000050951000 CR4: 00000000000006e0
Process kblockd/1 (pid: 32[#0], threadinfo ffff81007d1fc000, task 
ffff81007d1db040)
Stack:  ffff81007c54ad08 ffff81007cf85000 ffff81007cf7e000 ffff81007d1fde00
 ffff81006a289cc0 ffffffff8033f11f 0000000000000287 ffffffff88000fa8
 ffff81001646a6f8 0000000000000000 ffff81007cf85000 ffff81007cf7e000
Call Trace:
 [<ffffffff8033f11f>] elv_next_request+0x3f/0x150
 [<ffffffff88000fa8>] :scsi_mod:scsi_dispatch_cmd+0x1c8/0x310
 [<ffffffff88007329>] :scsi_mod:scsi_request_fn+0x69/0x3d0
 [<ffffffff80347b30>] as_work_handler+0x0/0x50
 [<ffffffff80347b5c>] as_work_handler+0x2c/0x50
 [<ffffffff8024b94c>] run_workqueue+0xcc/0x170
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024c443>] worker_thread+0xa3/0x110
 [<ffffffff8024fe10>] autoremove_wake_function+0x0/0x30
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024c3a0>] worker_thread+0x0/0x110
 [<ffffffff8024fa3b>] kthread+0x4b/0x80
 [<ffffffff8020b0a8>] child_rip+0xa/0x12
 [<ffffffff8024f9f0>] kthread+0x0/0x80
 [<ffffffff8020b09e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 0f 0b eb fe 31 ed c7 83 b8 00 00 00 01 00 00 00
RIP  [<ffffffff80349028>] as_dispatch_request+0x438/0x460
 RSP <ffff81007d1fddc0>

-- 
Arkadiusz Mi턪iewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-------------------------------------------------------

----------  Forwarded Message  ----------

Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Wednesday 29 of August 2007
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-scsi@vger.kernel.org

On Wednesday 29 of August 2007, Arkadiusz Miskiewicz wrote:
> On Wednesday 29 of August 2007, Arkadiusz Miskiewicz wrote:
> > Hello,
> >
> > I'm trying to get stable kernel for Promise SuperTrak
> > X16350 hardware. So far 2.6.20, 2.6.21 and 2.6.22 oopsed
> > like this (while doing rsync):
>
> With anticipatory:
>
> berta login: ------------[ cut here ]------------
> kernel BUG at block/as-iosched.c:1084!

One more information: I'm currently running 2.6.19 for few hours and the oops 
doesn't happen. Looks like some regression introduced between 2.6.19 and 
2.6.20.

-- 
Arkadiusz Mi턪iewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-------------------------------------------------------

-- 
Arkadiusz Mi턪iewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
