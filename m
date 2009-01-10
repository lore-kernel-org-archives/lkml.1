Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZAJAg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZAJAg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZAJAgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:36:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:29756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZAJAgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:36:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="480477236"
Date: Fri, 9 Jan 2009 16:36:45 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: tytso@mit.edu
Subject: kernel BUG at fs/ext/super.c:428
Message-ID: <20090110003645.GA16107@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I started seeing this BUG on one of my test systems during file system unmount
on the way to shutdown/reboot. The problem is present with latest git and not
present in 2.6.28.

Hoping that someone has already seen this and fix available before I go
git bisect way...

Let me know if you need any more detais about the bug or test system.

Thanks,
Venki


[  212.222623] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  213.824126] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: R
X/TX
[  213.832083] 0000:06:00.0: eth0: 10/100 speed: disabling TSO
[  213.842423] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  579.820973] sb orphan head is 291585
[  579.824856] sb_info orphan list:
[  579.828373]   inode sda3:291585 at ffff880220449c00: mode 100600, nlink 0, ne
xt 0
[  579.836381] ------------[ cut here ]------------
[  579.841264] kernel BUG at /home/venkip/src/linus/linux-2.6/fs/ext3/super.c:42
8!
[  579.849065] invalid opcode: 0000 [#1] SMP
[  579.853602] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:0b:01.
0/irq
[  579.861638] CPU 0
[  579.863974] Modules linked in:
[  579.867387] Pid: 7027, comm: umount Not tainted 2.6.28-05716-gfe0bdec-dirty #
587
[  579.875244] RIP: 0010:[<ffffffff80321151>]  [<ffffffff80321151>] ext3_put_sup
er+0x198/0x1f6
[  579.884162] RSP: 0018:ffff88022c9a7e18  EFLAGS: 00010287
[  579.889753] RAX: ffff880220449b68 RBX: ffff880229151278 RCX: 0000000000000000
[  579.897162] RDX: 0000000000007675 RSI: 0000000000000001 RDI: 000000000000000f
[  579.904573] RBP: ffff88022c9a7e48 R08: 0000000000000086 R09: 0000000000000086
[  579.911982] R10: ffffffff8024ee4b R11: 0000000000000086 R12: ffff880229150000
[  579.919410] R13: ffff88022ae6b000 R14: ffff880229151278 R15: ffff88022cbf8498
[  579.926820] FS:  00007fa202bdd6d0(0000) GS:ffffffff80a83080(0000) knlGS:00000
00000000000
[  579.935408] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  579.941422] CR2: 000000000059d4b8 CR3: 00000002299d7000 CR4: 00000000000406e0
[  579.948832] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  579.956244] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  579.963669] Process umount (pid: 7027, threadinfo ffff88022c9a6000, task ffff
88022993e180)
[  579.972422] Stack:
[  579.974695]  0000000000000000 ffffffff80a70c80 ffff88022ae6b000 ffffffff806c2
440
[  579.982414]  0000000000000008 ffffffff80a70c80 ffff88022c9a7e68 ffffffff802a5
e6a
[  579.990643]  ffff88022a9d5040 0000000000000003 ffff88022c9a7e88 ffffffff802a5
f18
[  579.999317] Call Trace:
[  580.002027]  [<ffffffff802a5e6a>] generic_shutdown_super+0x63/0xf7
[  580.008553]  [<ffffffff802a5f18>] kill_block_super+0x1a/0x32
[  580.014584]  [<ffffffff802a5fe5>] deactivate_super+0x4c/0x61
[  580.020609]  [<ffffffff802b8e4a>] mntput_no_expire+0x10d/0x13d
[  580.026814]  [<ffffffff802b93ec>] sys_umount+0x2c0/0x2ed
[  580.032473]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[  580.038826] Code: ff ff 48 81 c6 50 04 00 00 89 04 24 31 c0 e8 c8 4f 37 00 48
 8b 1b 48 8b 03 4c 39 f3 0f 18 08 75 a9 4d 39 b4 24 78 12 00 00 74 04 <0f> 0b eb
 fe 49 8b bd d0 01 00 00 e8 0c 18 fa ff 49 8b bc 24 90
[  580.062926] RIP  [<ffffffff80321151>] ext3_put_super+0x198/0x1f6
[  580.069264]  RSP <ffff88022c9a7e18>
[  580.073020] ---[ end trace 9a9df175acc77635 ]---
[  580.077917] ------------[ cut here ]------------
[  580.082828] WARNING: at /home/venkip/src/linus/linux-2.6/kernel/exit.c:1014 d
o_exit+0x45/0x7cc()
[  580.092108] Hardware name: X7DB8
[  580.095604] Modules linked in:
[  580.099012] Pid: 7027, comm: umount Tainted: G      D    2.6.28-05716-gfe0bde
c-dirty #587
[  580.107683] Call Trace:
[  580.110404]  [<ffffffff80237c51>] warn_slowpath+0xd3/0x10f
[  580.116162]  [<ffffffff8020c1ae>] ? apic_timer_interrupt+0xe/0x20
[  580.122526]  [<ffffffff8024ee4b>] ? up+0xf/0x39
[  580.127323]  [<ffffffff802388e6>] ? vprintk+0x30b/0x337
[  580.132821]  [<ffffffff80696168>] ? printk+0x67/0x69
[  580.138060]  [<ffffffff8023af7c>] do_exit+0x45/0x7cc
[  580.143315]  [<ffffffff8020dd18>] ? show_registers+0x215/0x224
[  580.149426]  [<ffffffff8069baff>] ? atomic_notifier_call_chain+0xf/0x11
[  580.156319]  [<ffffffff803fcbe8>] ? do_unblank_screen+0x2e/0x12c
[  580.162598]  [<ffffffff80699fbd>] oops_end+0x89/0x8e
[  580.167840]  [<ffffffff8020e941>] die+0x55/0x5e
[  580.172651]  [<ffffffff80699a63>] do_trap+0x110/0x11f
[  580.177973]  [<ffffffff8020cf03>] do_invalid_op+0x91/0x9a
[  580.183666]  [<ffffffff80321151>] ? ext3_put_super+0x198/0x1f6
[  580.189769]  [<ffffffff80696168>] ? printk+0x67/0x69
[  580.195001]  [<ffffffff8020c415>] invalid_op+0x15/0x20
[  580.200437]  [<ffffffff8024ee4b>] ? up+0xf/0x39
[  580.205237]  [<ffffffff80321151>] ? ext3_put_super+0x198/0x1f6
[  580.211340]  [<ffffffff80321139>] ? ext3_put_super+0x180/0x1f6
[  580.217449]  [<ffffffff802a5e6a>] generic_shutdown_super+0x63/0xf7
[  580.223898]  [<ffffffff802a5f18>] kill_block_super+0x1a/0x32
[  580.229850]  [<ffffffff802a5fe5>] deactivate_super+0x4c/0x61
[  580.235789]  [<ffffffff802b8e4a>] mntput_no_expire+0x10d/0x13d
[  580.241889]  [<ffffffff802b93ec>] sys_umount+0x2c0/0x2ed
[  580.247487]  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
[  580.253761] ---[ end trace 9a9df175acc77635 ]---
