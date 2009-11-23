Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZKWMEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZKWMEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZKWMEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:04:54 -0500
Received: from mail001.aei.ca ([206.123.6.130]:55239 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbZKWMEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:04:53 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc8 opps leaving X
Date: Mon, 23 Nov 2009 07:04:51 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.31.6-crc; KDE/4.3.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911230704.51953.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following opps when leaving X with rc8:

[  183.846716] Unpin not necessary for ffff88016bba2200 !
[  183.860064] BUG: unable to handle kernel NULL pointer dereference at (null)
[  183.860069] IP: [<ffffffff8107bd39>] prepare_to_wait+0x19/0x80
[  183.860078] PGD 155125067 PUD 155126067 PMD 0
[  183.860082] Oops: 0002 [#1] PREEMPT SMP
[  183.860085] last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input
[  183.860089] CPU 0
[  183.860091] Modules linked in: kvm_amd kvm tun sit tunnel4 ipv6 bridge stp llc bnep sco rfcomm l2cap snd_seq_dummy snd_seq_oss snx
[  183.860140] Pid: 2720, comm: console-kit-dae Not tainted 2.6.32-rc8-crc #42 System Product Name
[  183.860142] RIP: 0010:[<ffffffff8107bd39>]  [<ffffffff8107bd39>] prepare_to_wait+0x19/0x80
[  183.860147] RSP: 0018:ffff88015586dc58  EFLAGS: 00010282
[  183.860149] RAX: ffff88015586dfd8 RBX: 000000005586dce8 RCX: 0000000000000000
[  183.860151] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff8175ee40
[  183.860154] RBP: ffff88015586dc78 R08: 0000000000000000 R09: 0000000000000001
[  183.860156] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[  183.860157] R13: 0000000000000000 R14: ffff880100000000 R15: 0000000000000001
[  183.860160] FS:  00007f6270fd1710(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
[  183.860161] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  183.860163] CR2: 0000000000000000 CR3: 0000000155a62000 CR4: 00000000000006f0
[  183.860165] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  183.860166] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  183.860168] Process console-kit-dae (pid: 2720, threadinfo ffff88015586c000, task ffff880155158000)
[  183.860169] Stack:
[  183.860170]  0000000000000000 000000005586dce8 0000000000000000 0000000000000000
[  183.860173] <0> ffff88015586dcd8 ffffffff812dc45f 0000000000000000 ffff880155158000
[  183.860175] <0> ffffffff8107bae0 ffff88015586dca0 ffff88015586dca0 0000000000000046
[  183.860178] Call Trace:
[  183.860183]  [<ffffffff812dc45f>] vt_event_wait+0xaf/0x140
[  183.860186]  [<ffffffff8107bae0>] ? autoremove_wake_function+0x0/0x40
[  183.860188]  [<ffffffff812dc523>] vt_waitactive+0x33/0x60
[  183.860191]  [<ffffffff812dda35>] vt_ioctl+0x1115/0x1cb0
[  183.860194]  [<ffffffff814a6f22>] ? _spin_unlock_irq+0x62/0x80
[  183.860198]  [<ffffffff81090cca>] ? __lock_acquire+0x38a/0x1550
[  183.860202]  [<ffffffff81142b02>] ? vfs_ioctl+0x22/0xa0
[  183.860204]  [<ffffffff81131025>] ? fget_light+0x95/0x170
[  183.860207]  [<ffffffff810b4179>] ? __rcu_read_unlock+0x79/0x2b0
[  183.860210]  [<ffffffff81130c66>] ? rcu_read_unlock+0x26/0x30
[  183.860212]  [<ffffffff811310e7>] ? fget_light+0x157/0x170
[  183.860214]  [<ffffffff81131025>] ? fget_light+0x95/0x170
[  183.860216]  [<ffffffff811432c9>] ? sys_ioctl+0xb9/0xc0
[  183.860220]  [<ffffffff8100b99b>] ? system_call_fastpath+0x16/0x1b
[  183.860221] Code: 74 24 18 49 89 4c 24 20 48 89 11 eb bb 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d
[  183.860241] RIP  [<ffffffff8107bd39>] prepare_to_wait+0x19/0x80
[  183.860243]  RSP <ffff88015586dc58>
[  183.860244] CR2: 0000000000000000
[  183.860247] ---[ end trace 3acb9156b0436989 ]---

Hope this helps
Ed Tomlinson

