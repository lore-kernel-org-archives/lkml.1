Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZB0Ts0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZB0Ts0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZB0TsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:48:17 -0500
Received: from welcomes-you.com ([85.214.50.128]:59161 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZB0TsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:48:17 -0500
Message-ID: <49A84376.6030800@aei.mpg.de>
Date: Fri, 27 Feb 2009 20:48:06 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at kernel/workqueue.c:291
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

a few of our nodes showed this bug suddenly, possibly triggered by some
user jobs (still need to look for correlations):

[...]
[228496.772509] nfs: server n0051 not responding, timed out
[228704.928037] ------------[ cut here ]------------
[228704.928224] kernel BUG at kernel/workqueue.c:291!
[228704.928404] invalid opcode: 0000 [1] SMP
[228704.928647] CPU 0
[228704.928852] Modules linked in: lm92 w83793 w83781d hwmon_vid hwmon nfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs autofs4 netconsole configfs ipmi_si ipmi_devintf ipmi_watchdog ipmi_poweroff ipmi_msghandler e1000e i2c_i801 8250_pnp 8250 serial_core i2c_core
[228704.930002] Pid: 1609, comm: rpciod/0 Not tainted 2.6.27.14-nodes #1
[228704.930002] RIP: 0010:[<ffffffff8023c6db>]  [<ffffffff8023c6db>] run_workqueue+0x6f/0x102
[228704.930002] RSP: 0018:ffff880214bcdec0  EFLAGS: 00010207
[228704.930002] RAX: 0000000000000000 RBX: ffff880214b82f40 RCX: ffff880215444418
[228704.930002] RDX: ffff880187d07d58 RSI: ffff880214bcdee0 RDI: ffff880215444410
[228704.930002] RBP: ffffffffa0077186 R08: ffff880214bcc000 R09: ffff88021491f808
[228704.930002] R10: 0000000000000246 R11: ffff880187d07d50 R12: ffff880214ad7d28
[228704.930002] R13: ffffffff806065a0 R14: ffffffff80607280 R15: 0000000000000000
[228704.930002] FS:  0000000000000000(0000) GS:ffffffff80636040(0000) knlGS:0000000000000000
[228704.930002] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[228704.930002] CR2: 00007fc056333fd8 CR3: 00000001ed270000 CR4: 00000000000006e0
[228704.930002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[228704.930002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[228704.930002] Process rpciod/0 (pid: 1609, threadinfo ffff880214bcc000, task ffff880217b08780)
[228704.930002] Stack:  ffff880214b82f40 ffff880214b82f40 ffff880214b82f58 ffffffff8023cff3
[228704.930002]  0000000000000000 ffff880217b08780 ffffffff8023f7d7 ffff880214bcdef8
[228704.930002]  ffff880214bcdef8 ffffffff806065a0 ffffffff80607280 ffff880214b82f40
[228704.930002] Call Trace:
[228704.930002]  [<ffffffff8023cff3>] ? worker_thread+0x90/0x9b
[228704.930002]  [<ffffffff8023f7d7>] ? autoremove_wake_function+0x0/0x2e
[228704.930002]  [<ffffffff8023cf63>] ? worker_thread+0x0/0x9b
[228704.930002]  [<ffffffff8023f6c2>] ? kthread+0x47/0x75
[228704.930002]  [<ffffffff8022afa8>] ? schedule_tail+0x27/0x5f
[228704.930002]  [<ffffffff8020ccb9>] ? child_rip+0xa/0x11
[228704.930002]  [<ffffffff8023f67b>] ? kthread+0x0/0x75
[228704.930002]  [<ffffffff8020ccaf>] ? child_rip+0x0/0x11
[228704.930002]
[228704.930002]
[228704.930002] Code: 6f 18 48 89 7b 30 48 8b 11 48 8b 41 08 48 89 42 08 48 89 10 48 89 49 08 48 89 09 fe 03 fb 48 8b 41 f8 48 83 e0 fc 48 39 d8 74 04 <0f> 0b eb fe f0 80 61 f8 fe ff d5 65 48 8b 04 25 10 00 00 00 8b
[228704.930002] RIP  [<ffffffff8023c6db>] run_workqueue+0x6f/0x102
[228704.930002]  RSP <ffff880214bcdec0>
[228704.941003] ---[ end trace deef6e5387b5a584 ]---
[229698.790015] nfs: server n0051 not responding, timed out
[229878.790016] nfs: server n0051 not responding, timed out
[...]

Is this a known bug, google did not find anything relevant on the first try.

Cheers

Carsten

PS: Please Cc me
