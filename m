Return-Path: <linux-kernel-owner+w=401wt.eu-S934614AbYBOGx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614AbYBOGx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759755AbYBOGum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:50:42 -0500
Received: from mga10.intel.com ([192.55.52.92]:26708 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933536AbYBOGuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:50:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,356,1199692800"; 
   d="scan'208";a="519019951"
Subject: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 15 Feb 2008 14:47:01 +0800
Message-Id: <1203058021.3027.143.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my 16-core tigerton, kernel panic when I ran hackbench process testing. See
below log.

Commandline to start hackbench:
#./hackbench 150 process 2000

Kernel config options:
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set


Kernel panic at line 1637 in file mm/slub.c because object=c->freelist=NULL.

-yanmin

********************syslog***************

lkp-tt01-x8664 login: BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80279948>] kmem_cache_alloc+0x3c/0x6c
PGD 45c5a1067 PUD 45c5a2067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: video output
Pid: 8095, comm: hackbench Not tainted 2.6.25-rc1 #1
RIP: 0010:[<ffffffff80279948>]  [<ffffffff80279948>] kmem_cache_alloc+0x3c/0x6c
RSP: 0018:ffff81045c5b3bf8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff810001007d40 RCX: ffffffff805e0024
RDX: 0000000000000000 RSI: 00000000000004d0 RDI: ffffffff80928890
RBP: 00000000000004d0 R08: ffff81045cfa2a80 R09: ffff81045cfa2a80
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000064
R13: ffffffff80928890 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fb63b0ab6f0(0000) GS:ffffffff808ff000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000045c5a0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hackbench (pid: 8095, threadinfo ffff81045c5b2000, task ffff81045c5ae7b0)
Stack:  ffff810437c399c0 0000000000000000 00000000000004d0 ffffffff805e0024
 ffff81045cfdbb80 00000000000004d0 7fffffffffffffff 0000000000000064
 ffff81045c5b3d04 ffffffff805dc389 0000000000000000 ffff81045c5ae7b0
Call Trace:
 [<ffffffff805e0024>] ? __alloc_skb+0x31/0x121
 [<ffffffff805dc389>] ? sock_alloc_send_skb+0x77/0x1d2
 [<ffffffff80243897>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff805e12d5>] ? memcpy_fromiovec+0x36/0x66
 [<ffffffff80636ec0>] ? unix_stream_sendmsg+0x165/0x333
 [<ffffffff805d9863>] ? sock_aio_write+0xd1/0xe0
 [<ffffffff80227834>] ? __wake_up_common+0x41/0x74
 [<ffffffff8027d267>] ? do_sync_write+0xc9/0x10c
 [<ffffffff80265fbb>] ? __do_fault+0x382/0x3cd
 [<ffffffff80243897>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff80268840>] ? handle_mm_fault+0x38a/0x70d
 [<ffffffff806afd39>] ? error_exit+0x0/0x51
 [<ffffffff80228008>] ? __dequeue_entity+0x1c/0x32
 [<ffffffff8027d9bb>] ? vfs_write+0xc0/0x136
 [<ffffffff8027dee5>] ? sys_write+0x45/0x6e
 [<ffffffff8020bdcb>] ? system_call_after_swapgs+0x7b/0x80


