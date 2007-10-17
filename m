Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbXJQFTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbXJQFTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXJQFTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:19:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41313 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXJQFTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:19:34 -0400
Date: Tue, 16 Oct 2007 22:15:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Subject: mtd: onenand_sim crashes
Message-Id: <20071016221525.307c8904.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on x86_64, 2.6.23-git7, no MTD devices.
Same config file as mtd crash a few minutes earlier.

loading onenand_sim a _second_ time crashes:

OneNAND Manufacturer: Samsung (0xec)
OneNAND 16MB 1.8V 16-bit (0x04)
OneNAND version = 0x001e
Lock scheme is Continuous Lock
Scanning device for bad blocks
Creating 1 MTD partitions on "OneNAND simulator":
0x00000000-0x01000000 : "OneNAND simulator partition"
mtd: Giving out device 0 to OneNAND simulator partition
------------[ cut here ]------------
kernel BUG at mm/slab.c:2983!
invalid opcode: 0000 [1] SMP 
CPU 0 
Modules linked in: hidp l2cap bluetooth snd_via82xx snd_ac97_codec ac97_bus snd_seq_dummy s
nd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_
alloc snd_mpu401_uart parport snd_rawmidi snd_seq_device snd soundcore
Pid: 3676, comm: bash Not tainted 2.6.23-git7 #11
RIP: 0010:[<ffffffff8028a1af>]  [<ffffffff8028a1af>] cache_alloc_refill+0xcc/0x1b3
RSP: 0018:ffff81002f199e18  EFLAGS: 00010046
RAX: 0000000000000004 RBX: 0000000000000006 RCX: ffff8100010ff8a0
RDX: ffff81003e7c0800 RSI: ffff8100010ff880 RDI: ffff81003d545680
RBP: ffff81002f199e68 R08: ffff8100010ff880 R09: ffff810037ff4000
R10: ffffffff8028a15c R11: 0000000000000202 R12: ffff81003d545680
R13: ffff810037ff1a00 R14: ffff8100010ff880 R15: 000000000000000a
FS:  00002b8d51d76f10(0000) GS:ffffffff806b4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000008e1f28 CR3: 0000000030508000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 3676, threadinfo ffff81002f198000, task ffff81002fc5c040)
Stack:  ffff81002fc5c040 000080d0806708d8 ffff81003e7c0800 ffff8100010ff8c0
 0000000000000246 0000000000000246 00000000000080d0 ffff81003e7c0800
 00000000ffffffff 0000000000000000 ffff81002f199e98 ffffffff8028a42b
Call Trace:
 [<ffffffff8028a42b>] kmem_cache_alloc+0x8c/0xd1
 [<ffffffff80294579>] alloc_pipe_info+0x1b/0x48
 [<ffffffff80294603>] create_write_pipe+0x5d/0x1b5
 [<ffffffff80295115>] do_pipe+0x1a/0x105
 [<ffffffff80211460>] sys_pipe+0x1c/0x4b
 [<ffffffff8020be81>] tracesys+0x71/0xe1
 [<ffffffff8020beec>] tracesys+0xdc/0xe1


Code: 0f 0b eb fe 41 8b 5d 00 8b 55 d4 4c 89 e6 48 8b 7d c0 e8 1e 
RIP  [<ffffffff8028a1af>] cache_alloc_refill+0xcc/0x1b3
 RSP <ffff81002f199e18>
BUG: spinlock lockup on CPU#0, events/0/6, ffff8100010ff8c0

Call Trace:
 [<ffffffff80328c19>] _raw_spin_lock+0xd1/0xf9
 [<ffffffff8050bd0a>] _spin_lock_irq+0x47/0x54
 [<ffffffff8028abc7>] drain_array+0x4e/0xc9
 [<ffffffff8028b8ec>] cache_reap+0x0/0x20a
 [<ffffffff8028b999>] cache_reap+0xad/0x20a
 [<ffffffff8028b8ec>] cache_reap+0x0/0x20a
 [<ffffffff80244def>] run_workqueue+0x97/0x16a
 [<ffffffff8024589e>] worker_thread+0x0/0xea
 [<ffffffff8024597d>] worker_thread+0xdf/0xea
 [<ffffffff80248981>] autoremove_wake_function+0x0/0x38
 [<ffffffff80248869>] kthread+0x49/0x78
 [<ffffffff8020cb88>] child_rip+0xa/0x12
 [<ffffffff802486e4>] kthreadd+0x120/0x145
 [<ffffffff80248820>] kthread+0x0/0x78
 [<ffffffff8020cb7e>] child_rip+0x0/0x12

---
~Randy
