Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYGMIQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYGMIQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYGMIQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:16:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:31766 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYGMIQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xLmlLvn0tdqG/mdp9xzH+JK+nmQoYnOcvm2TPk8wo6ORzmEcFHS18jtU2dbXu5RKSC
         mWgoI8elm0yRNIGZ1XjZtj7CdS1Et8LZFJ9yp1/utvkSRcGZ3/5acwSSIVFUuvRB4QIR
         epn5+rx+i1uCT7fOUar5c8K3tIbdx4sDFNbac=
Message-ID: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
Date: Sun, 13 Jul 2008 01:16:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>
Subject: per-cpu related?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calling  pcie_portdrv_init+0x0/0x77
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff802557de>] hrtick_start_fair+0x8e/0x178
PGD 0
Oops: 0000 [1] SMP
CPU 4
Modules linked in:
Pid: 103, comm: events/4 Not tainted 2.6.26-rc9-tip-01834-g99e624f-dirty #354
RIP: 0010:[<ffffffff802557de>]  [<ffffffff802557de>]
hrtick_start_fair+0x8e/0x178
RSP: 0018:ffff88082486dbd0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880824870000 RCX: 0000000000000006
RDX: ffff88084423e700 RSI: ffff880824870000 RDI: ffff88084423e700
RBP: ffff88082486dc00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88084423e700
R13: ffff880844239700 R14: ffff880824870000 R15: 0000000000000c18
FS:  0000000000000000(0000) GS:ffff881024c3a600(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/4 (pid: 103, threadinfo ffff88082486c000, task ffff880824864230)
Stack:  ffff880844248118 0000000060ce4c84 ffff880844239700 ffff880824955878
 ffff88084423e700 0000000000000000 ffff88082486dc40 ffffffff80258339
 ffff88082486dc30 ffffffff805196dd 0000000060ce4c84 ffff880824955840
Call Trace:
 [<ffffffff80258339>] dequeue_task_fair+0x64/0x83
 [<ffffffff805196dd>] ? __first_cpu+0x26/0x49
 [<ffffffff80254387>] dequeue_task+0xd3/0xf5
 [<ffffffff80254434>] deactivate_task+0x36/0x55
 [<ffffffff802547b0>] pull_task+0x31/0x7d
 [<ffffffff8025691b>] load_balance_fair+0x192/0x27c
 [<ffffffff80a4daf3>] schedule+0x3e0/0x96d
 [<ffffffff802c3303>] ? vmstat_update+0x0/0x5e
 [<ffffffff8027a965>] ? schedule_delayed_work+0x31/0x48
 [<ffffffff80279b8a>] worker_thread+0xbb/0x114
 [<ffffffff8027e788>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff80279acf>] ? worker_thread+0x0/0x114
 [<ffffffff8027e2e3>] kthread+0x61/0xa4
 [<ffffffff802634ee>] ? schedule_tail+0x3b/0x8a
 [<ffffffff8022b589>] child_rip+0xa/0x11
 [<ffffffff8027e282>] ? kthread+0x0/0xa4
 [<ffffffff8022b57f>] ? child_rip+0x0/0x11


Code: c3 80 e8 38 09 01 00 80 3d 3f 86 c0 00 00 0f 89 e1 00 00 00 41
f6 84 24 70 08 00 00 04 0f 85 d2 00 00 00 49 8b 84 24 a8 08 00 00 <48>
8b 00 83 b8 c0 00 00 00 00 0f 84 ba 00 00 00 49 83 7d 10 01
RIP  [<ffffffff802557de>] hrtick_start_fair+0x8e/0x178
 RSP <ffff88082486dbd0>
CR2: 0000000000000000
---[ end trace 52609fe2a2756609 ]---
