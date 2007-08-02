Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbXHCCrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbXHCCrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 22:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXHCCrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 22:47:48 -0400
Received: from smtp.aaisp.net.uk ([81.187.81.52]:57324 "EHLO smtp.aaisp.net.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbXHCCrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 22:47:47 -0400
X-Greylist: delayed 37971 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 22:47:46 EDT
Date: Thu, 2 Aug 2007 17:14:50 +0100
From: Andrew Clayton <andrew@digital-domain.net>
To: linux-kernel@vger.kernel.org
Subject: [NFSD OOPS] 2.6.23-rc1-git10
Message-ID: <20070802171450.7c9b4af3@zeus.pccl.info>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Got the following oopsen just now from 2.6.23-rc1-git10 on a 2
processor Opteron with 2GB RAM. System is running 64bit Fedora Core 6.

nfsd is exporting directories from a XFS filesystem on top a software
RAID 5 array comprising 3 x 250GB SATA disks using the sata_sil driver.

Amongst other things, users (about 12) home directories are
automounted from it.

Some problems seem to start when I was experimenting with the
stripe_cache_size of the md array. People could no longer run some apps
and having general NFS issues. IIRC I had dropped the stripe_cache_size
down from 8192 to 768 then I attempted to restart nfsd
via /etc/rc.d/init.d/nfsd restart

I then got the Oopses and the machine locked up needing a power cycle.


Aug  2 10:15:55 thor mountd[30048]: Caught signal 15, un-registering and exiting.
Aug  2 10:15:55 thor nfsd[16390]: nfssvc: Setting version failed: errno 16 (Device or resource busy)
Aug  2 10:15:56 thor kernel: lockd_down: lockd failed to exit, clearing pid
Aug  2 10:15:56 thor kernel: nfsd: last server has exited
Aug  2 10:15:56 thor kernel: nfsd: unexporting all filesystems
Aug  2 10:15:56 thor kernel: ------------[ cut here ]------------
Aug  2 10:15:56 thor kernel: kernel BUG at /home/andrew/src/linux-2.6/net/sunrpc/svc.c:488!
Aug  2 10:15:56 thor kernel: invalid opcode: 0000 [1] SMP 
Aug  2 10:15:56 thor kernel: CPU 0 
Aug  2 10:15:56 thor kernel: Pid: 30039, comm: nfsd Not tainted 2.6.23-rc1-git10 #28
Aug  2 10:15:56 thor kernel: RIP: 0010:[<ffffffff804b9bed>]  [<ffffffff804b9bed>] svc_destroy+0x1bd/0x1d0
Aug  2 10:15:56 thor kernel: RSP: 0018:ffff81007a149ee0  EFLAGS: 00010212
Aug  2 10:15:56 thor kernel: RAX: ffff81006fd4f4a8 RBX: ffff81006fd4f498 RCX: ffff81000000c000
Aug  2 10:15:56 thor kernel: RDX: ffff81006fd4f498 RSI: 000000000000004c RDI: ffff81006fd4f498
Aug  2 10:15:56 thor kernel: RBP: ffff81006fd4f4b8 R08: 9018000000000000 R09: 8000000000000000
Aug  2 10:15:56 thor kernel: R10: 0000000000000000 R11: ffffffff80453990 R12: ffff81006fd4f4a8
Aug  2 10:15:56 thor kernel: R13: ffff81006fd4f480 R14: ffff81006fd4f480 R15: ffffffff802dc000
Aug  2 10:15:56 thor kernel: FS:  00002affe30536e0(0000) GS:ffffffff805be000(0000) knlGS:0000000000000000
Aug  2 10:15:56 thor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  2 10:15:56 thor kernel: CR2: 000000345ce03080 CR3: 000000006fd65000 CR4: 00000000000006e0
Aug  2 10:15:56 thor kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 10:15:56 thor kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 10:15:56 thor kernel: Process nfsd (pid: 30039, threadinfo ffff81007a148000, task ffff810062fe77b0)
Aug  2 10:15:56 thor kernel: Stack:  ffff810062fe77b0 000000000000001e ffff81007a0c2000 ffff81007a149f20
Aug  2 10:15:56 thor kernel:  ffff810070eedf80 ffffffff802dc268 fffffffffffffeff 6e692e6c6363702e
Aug  2 10:15:56 thor kernel:  fffffffffffffef8 ffff810062fe77b0 ffff810070eedf84 0000000000000000
Aug  2 10:15:56 thor kernel: Call Trace:
Aug  2 10:15:56 thor kernel:  [<ffffffff802dc268>] nfsd+0x268/0x2d0
Aug  2 10:15:56 thor kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Aug  2 10:15:56 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:15:56 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:15:56 thor kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Aug  2 10:15:56 thor kernel: 
Aug  2 10:15:56 thor kernel: 
Aug  2 10:15:56 thor kernel: Code: 0f 0b eb fe 0f 1f 80 00 00 00 00 0f 1f 84 00 00 00 00 00 41 
Aug  2 10:15:56 thor kernel: RIP  [<ffffffff804b9bed>] svc_destroy+0x1bd/0x1d0
Aug  2 10:15:56 thor kernel:  RSP <ffff81007a149ee0>
Aug  2 10:16:17 thor kernel: general protection fault: 0000 [2] SMP 
Aug  2 10:16:17 thor kernel: CPU 0 
Aug  2 10:16:17 thor kernel: Pid: 16406, comm: nfsd Tainted: G      D 2.6.23-rc1-git10 #28
Aug  2 10:16:17 thor kernel: RIP: 0010:[<ffffffff802e011e>]  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:16:17 thor kernel: RSP: 0018:ffff8100496ffd60  EFLAGS: 00010202
Aug  2 10:16:17 thor kernel: RAX: 000000003b5f0767 RBX: 0000000000000100 RCX: ffff81007a579340
Aug  2 10:16:17 thor kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff80649f48
Aug  2 10:16:17 thor kernel: RBP: ffffffff80649f40 R08: ffff8100149d0990 R09: 0000000000000007
Aug  2 10:16:17 thor kernel: R10: 000000005245544e R11: 0000000000000001 R12: 495f594157455441
Aug  2 10:16:17 thor kernel: R13: 0000000018328d3e R14: 0000000000000004 R15: ffff810065dc66c0
Aug  2 10:16:17 thor kernel: FS:  00002b83155a86e0(0000) GS:ffffffff805be000(0000) knlGS:0000000000000000
Aug  2 10:16:17 thor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  2 10:16:17 thor kernel: CR2: 000000345c495890 CR3: 000000007b2c1000 CR4: 00000000000006e0
Aug  2 10:16:17 thor kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 10:16:17 thor kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 10:16:17 thor kernel: Process nfsd (pid: 16406, threadinfo ffff8100496fe000, task ffff81007e1310c0)
Aug  2 10:16:17 thor kernel: Stack:  ffff8100704f9b68 000000078034eee8 ffff8100149d0990 ffff8100149d0000
Aug  2 10:16:17 thor kernel:  009000005ed85080 0000000000030000 ffff81007c83e008 ffff81005ed85080
Aug  2 10:16:17 thor kernel:  0000000000000000 ffff8100496ffe00 0000000000030000 0000000000000000
Aug  2 10:16:17 thor kernel: Call Trace:
Aug  2 10:16:17 thor kernel:  [<ffffffff802e0972>] nfsd_read+0xe2/0x100
Aug  2 10:16:17 thor kernel:  [<ffffffff804bb710>] svc_sock_enqueue+0x80/0x340
Aug  2 10:16:17 thor kernel:  [<ffffffff802e81ad>] nfsd3_proc_read+0xfd/0x1a0
Aug  2 10:16:17 thor kernel:  [<ffffffff802dba71>] nfsd_dispatch+0xb1/0x250
Aug  2 10:16:17 thor kernel:  [<ffffffff804baa56>] svc_process+0x476/0x7a0
Aug  2 10:16:17 thor kernel:  [<ffffffff804c9182>] __down_read+0x12/0xb0
Aug  2 10:16:17 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:17 thor kernel:  [<ffffffff802dc190>] nfsd+0x190/0x2d0
Aug  2 10:16:17 thor kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Aug  2 10:16:17 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:17 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:17 thor kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Aug  2 10:16:17 thor kernel: 
Aug  2 10:16:17 thor kernel: 
Aug  2 10:16:17 thor kernel: Code: 4d 3b 6c 24 10 75 db 8b 44 24 24 41 3b 44 24 18 75 d0 48 39 
Aug  2 10:16:17 thor kernel: RIP  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:16:17 thor kernel:  RSP <ffff8100496ffd60>
Aug  2 10:16:28 thor kernel: general protection fault: 0000 [3] SMP 
Aug  2 10:16:28 thor kernel: CPU 1 
Aug  2 10:16:28 thor kernel: Pid: 16402, comm: nfsd Tainted: G      D 2.6.23-rc1-git10 #28
Aug  2 10:16:28 thor kernel: RIP: 0010:[<ffffffff802e011e>]  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:16:28 thor kernel: RSP: 0018:ffff810070891d60  EFLAGS: 00010202
Aug  2 10:16:28 thor kernel: RAX: 00000000954783fd RBX: 0000000000000240 RCX: ffff81007a5797b8
Aug  2 10:16:28 thor kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff8064a088
Aug  2 10:16:28 thor kernel: RBP: ffffffff8064a080 R08: ffff8100628e0990 R09: 0000000000000001
Aug  2 10:16:28 thor kernel: R10: 00000000203a2020 R11: 0000000000000001 R12: 2020202020202044
Aug  2 10:16:28 thor kernel: R13: 0000000018752c1c R14: 0000000000000009 R15: ffff81004f3ca4c0
Aug  2 10:16:28 thor kernel: FS:  00002b83155a86e0(0000) GS:ffff81000119dbc0(0000) knlGS:0000000000000000
Aug  2 10:16:28 thor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  2 10:16:28 thor kernel: CR2: 0000000000616e08 CR3: 000000007ac39000 CR4: 00000000000006e0
Aug  2 10:16:28 thor kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 10:16:28 thor kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 10:16:28 thor kernel: Process nfsd (pid: 16402, threadinfo ffff810070890000, task ffff81007ac90830)
Aug  2 10:16:28 thor kernel: Stack:  ffff81001f5ee928 000000018034eee8 ffff8100628e0990 ffff8100628e0000
Aug  2 10:16:28 thor kernel:  0090000063f1aae8 0000000000000000 ffff810070bc9c08 ffff810063f1aae8
Aug  2 10:16:28 thor kernel:  0000000000000000 ffff810070891e00 0000000000000000 0000000000000000
Aug  2 10:16:28 thor kernel: Call Trace:
Aug  2 10:16:28 thor kernel:  [<ffffffff802e0972>] nfsd_read+0xe2/0x100
Aug  2 10:16:28 thor kernel:  [<ffffffff804bb710>] svc_sock_enqueue+0x80/0x340
Aug  2 10:16:28 thor kernel:  [<ffffffff802e81ad>] nfsd3_proc_read+0xfd/0x1a0
Aug  2 10:16:28 thor kernel:  [<ffffffff802dba71>] nfsd_dispatch+0xb1/0x250
Aug  2 10:16:28 thor kernel:  [<ffffffff804baa56>] svc_process+0x476/0x7a0
Aug  2 10:16:28 thor kernel:  [<ffffffff804c9182>] __down_read+0x12/0xb0
Aug  2 10:16:28 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:28 thor kernel:  [<ffffffff802dc190>] nfsd+0x190/0x2d0
Aug  2 10:16:28 thor kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Aug  2 10:16:28 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:28 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:28 thor kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Aug  2 10:16:29 thor kernel: 
Aug  2 10:16:29 thor kernel: 
Aug  2 10:16:29 thor kernel: Code: 4d 3b 6c 24 10 75 db 8b 44 24 24 41 3b 44 24 18 75 d0 48 39 
Aug  2 10:16:29 thor kernel: RIP  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:16:29 thor kernel:  RSP <ffff810070891d60>
Aug  2 10:16:58 thor kernel: general protection fault: 0000 [4] SMP 
Aug  2 10:16:58 thor kernel: CPU 0 
Aug  2 10:16:58 thor kernel: Pid: 16401, comm: nfsd Tainted: G      D 2.6.23-rc1-git10 #28
Aug  2 10:16:58 thor kernel: RIP: 0010:[<ffffffff802e011e>]  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:16:58 thor kernel: RSP: 0018:ffff810070a4dd60  EFLAGS: 00010202
Aug  2 10:16:58 thor kernel: RAX: 0000000031e26a3c RBX: 00000000000003c0 RCX: ffff81007a579c98
Aug  2 10:16:58 thor kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff8064a208
Aug  2 10:16:58 thor kernel: RBP: ffffffff8064a200 R08: ffff81006e75c990 R09: 0000000000000005
Aug  2 10:16:58 thor kernel: R10: 00000000736d6567 R11: 0000000000000001 R12: 2f382e312f736d65
Aug  2 10:16:58 thor kernel: R13: 0000000031b7ac4f R14: 000000000000000f R15: ffff81003cb0d480
Aug  2 10:16:58 thor kernel: FS:  00002b83155a86e0(0000) GS:ffffffff805be000(0000) knlGS:0000000000000000
Aug  2 10:16:58 thor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  2 10:16:58 thor kernel: CR2: 000000345c495890 CR3: 000000007b2c1000 CR4: 00000000000006e0
Aug  2 10:16:58 thor kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 10:16:58 thor kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 10:16:58 thor kernel: Process nfsd (pid: 16401, threadinfo ffff810070a4c000, task ffff81002a3b0040)
Aug  2 10:16:58 thor kernel: Stack:  ffff81007a79d268 000000058034eee8 ffff81006e75c990 ffff81006e75c000
Aug  2 10:16:58 thor kernel:  00900000644a5700 0000000000000000 ffff810070472808 ffff8100644a5700
Aug  2 10:16:58 thor kernel:  0000000000000000 ffff810070a4de00 0000000000000000 0000000000000000
Aug  2 10:16:58 thor kernel: Call Trace:
Aug  2 10:16:58 thor kernel:  [<ffffffff802e0972>] nfsd_read+0xe2/0x100
Aug  2 10:16:58 thor kernel:  [<ffffffff804bb710>] svc_sock_enqueue+0x80/0x340
Aug  2 10:16:58 thor kernel:  [<ffffffff802e81ad>] nfsd3_proc_read+0xfd/0x1a0
Aug  2 10:16:58 thor kernel:  [<ffffffff802dba71>] nfsd_dispatch+0xb1/0x250
Aug  2 10:16:58 thor kernel:  [<ffffffff804baa56>] svc_process+0x476/0x7a0
Aug  2 10:16:58 thor kernel:  [<ffffffff804c9182>] __down_read+0x12/0xb0
Aug  2 10:16:58 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:58 thor kernel:  [<ffffffff802dc190>] nfsd+0x190/0x2d0
Aug  2 10:16:58 thor kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Aug  2 10:16:58 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:58 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:16:58 thor kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Aug  2 10:16:58 thor kernel: 
Aug  2 10:16:58 thor kernel: 
Aug  2 10:16:58 thor kernel: Code: 4d 3b 6c 24 10 75 db 8b 44 24 24 41 3b 44 24 18 75 d0 48 39 
Aug  2 10:16:58 thor kernel: RIP  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:16:58 thor kernel:  RSP <ffff810070a4dd60>
Aug  2 10:17:00 thor kernel: general protection fault: 0000 [5] SMP 
Aug  2 10:17:00 thor kernel: CPU 0 
Aug  2 10:17:00 thor kernel: Pid: 16403, comm: nfsd Tainted: G      D 2.6.23-rc1-git10 #28
Aug  2 10:17:00 thor kernel: RIP: 0010:[<ffffffff802e011e>]  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:17:00 thor kernel: RSP: 0018:ffff810070d13d60  EFLAGS: 00010202
Aug  2 10:17:00 thor kernel: RAX: 00000000e74fcb75 RBX: 0000000000000140 RCX: ffff81007a579410
Aug  2 10:17:00 thor kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff80649f88
Aug  2 10:17:00 thor kernel: RBP: ffffffff80649f80 R08: ffff8100704d0990 R09: 0000000000000001
Aug  2 10:17:00 thor kernel: R10: 00000000372e303d R11: 0000000000000001 R12: 713b2a2c372e303d
Aug  2 10:17:00 thor kernel: R13: 0000000059233474 R14: 0000000000000005 R15: ffff81003cb0d580
Aug  2 10:17:00 thor kernel: FS:  00002b83155a86e0(0000) GS:ffffffff805be000(0000) knlGS:0000000000000000
Aug  2 10:17:00 thor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  2 10:17:00 thor kernel: CR2: 0000000000616e08 CR3: 000000007ac39000 CR4: 00000000000006e0
Aug  2 10:17:00 thor kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  2 10:17:00 thor kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  2 10:17:00 thor kernel: Process nfsd (pid: 16403, threadinfo ffff810070d12000, task ffff81007e012080)
Aug  2 10:17:00 thor kernel: Stack:  ffff81003e5a3028 000000018034eee8 ffff8100704d0990 ffff8100704d0000
Aug  2 10:17:00 thor kernel:  0090000053a155f8 0000000000001000 ffff810070e64808 ffff810053a155f8
Aug  2 10:17:00 thor kernel:  0000000000000000 ffff810070d13e00 0000000000001000 0000000000000000
Aug  2 10:17:00 thor kernel: Call Trace:
Aug  2 10:17:00 thor kernel:  [<ffffffff802e0972>] nfsd_read+0xe2/0x100
Aug  2 10:17:00 thor kernel:  [<ffffffff802e81ad>] nfsd3_proc_read+0xfd/0x1a0
Aug  2 10:17:00 thor kernel:  [<ffffffff802dba71>] nfsd_dispatch+0xb1/0x250
Aug  2 10:17:00 thor kernel:  [<ffffffff804baa56>] svc_process+0x476/0x7a0
Aug  2 10:17:00 thor kernel:  [<ffffffff804c9182>] __down_read+0x12/0xb0
Aug  2 10:17:00 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:17:00 thor kernel:  [<ffffffff802dc190>] nfsd+0x190/0x2d0
Aug  2 10:17:00 thor kernel:  [<ffffffff8020ca28>] child_rip+0xa/0x12
Aug  2 10:17:00 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:17:00 thor kernel:  [<ffffffff802dc000>] nfsd+0x0/0x2d0
Aug  2 10:17:00 thor kernel:  [<ffffffff8020ca1e>] child_rip+0x0/0x12
Aug  2 10:17:00 thor kernel: 
Aug  2 10:17:00 thor kernel: 
Aug  2 10:17:00 thor kernel: Code: 4d 3b 6c 24 10 75 db 8b 44 24 24 41 3b 44 24 18 75 d0 48 39 
Aug  2 10:17:00 thor kernel: RIP  [<ffffffff802e011e>] nfsd_vfs_read+0x13e/0x450
Aug  2 10:17:00 thor kernel:  RSP <ffff810070d13d60>


Cheers,

Andrew
