Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZGVIoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZGVIoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZGVIoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:44:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32846 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbZGVIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:44:53 -0400
Date: Wed, 22 Jul 2009 10:44:24 +0200
From: John Kacur <jkacur@redhat.com>
To: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, williams@redhat.com
Subject: i915_driver_irq_handler - BUG: NULL pointer dereference
Message-ID: <20090722084424.GA3507@tycho.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas et al

I'm still seeing this sometimes, in this case during shutdown with the experimental rt kernel
based off of 2.6.31-rc3

The system is going down for reboot NOW!
Disabling monthly Smolt update: [  OK  ]
Shutting down Avahi daemon: [drm:gm45_get_vblank_counter] *ERROR* trying to get1
BUG: unable to handle kernel NULL pointer dereference at 0000000000000084
IP: [<ffffffffa05df8ef>] i915_driver_irq_handler+0x848/0x8e9 [i915]
PGD 12b9b1067 PUD 12c0ce067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/class/power_supply/BAT0/energy_full
CPU 1 
Modules linked in: fuse i915 drm i2c_algo_bit ipt_MASQUERADE iptable_nat nf_nat]
Pid: 2644, comm: irq/31-i915@pci Not tainted 2.6.31-rc3-rt1 #1 2241B48
RIP: 0010:[<ffffffffa05df8ef>]  [<ffffffffa05df8ef>] i915_driver_irq_handler+0x]
RSP: 0018:ffff88012adf9d40  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000004b01
RDX: ffffc90006502898 RSI: 0000000000000003 RDI: 0000000050b909e3
RBP: ffff88012adf9db0 R08: 0000000050b909e3 R09: 0000000050b909e3
R10: 00000000bdbd66d2 R11: 0000000000018600 R12: 0000000000000000
R13: ffff880138d169c0 R14: ffff88012ac30000 R15: ffff880139008000
FS:  0000000000000000(0000) GS:ffff88002bfda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000084 CR3: 0000000139198000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process irq/31-i915@pci (pid: 2644, threadinfo ffff88012adf8000, task ffff88012)
Stack:
 ffff88012ac301f0 ffff88012ac302d8 ffff88012ac30110 000000402b864628
<0> 0044000000040206 ffffffff00000004 0000000050b909e3 0000000050b909e3
<0> 0000000050b909e3 ffff88012b8645c0 ffff88012b864628 ffff880138d169c0
Call Trace:
 [<ffffffff810b5528>] irq_thread+0xeb/0x22b
 [<ffffffff810b543d>] ? irq_thread+0x0/0x22b
 [<ffffffff810b543d>] ? irq_thread+0x0/0x22b
 [<ffffffff81070b13>] kthread+0xa6/0xae
 [<ffffffff8104ccf0>] ? schedule_tail+0x57/0xd5
 [<ffffffff810851e4>] ? trace_hardirqs_on_caller+0x126/0x169
 [<ffffffff8100d15a>] child_rip+0xa/0x20
 [<ffffffff8100cac0>] ? restore_args+0x0/0x30
 [<ffffffff81070a6d>] ? kthread+0x0/0xae
 [<ffffffff8100d150>] ? child_rip+0x0/0x20
Code: 00 00 8b 18 49 8b 87 00 0a 00 00 48 8b 80 18 03 00 00 48 85 c0 74 20 48 8 
RIP  [<ffffffffa05df8ef>] i915_driver_irq_handler+0x848/0x8e9 [i915]
 RSP <ffff88012adf9d40>
CR2: 0000000000000084
---[ end trace d237249163e43cb0 ]---

