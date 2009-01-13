Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZAMVre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZAMVre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZAMVrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:47:21 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36238 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZAMVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:47:19 -0500
Date: Tue, 13 Jan 2009 16:47:44 -0500
From: Jody McIntyre <scjody@sun.com>
Subject: 2.6.29-rc1: BUG: unable to handle kernel paging request at
	000077fed87bb6bf
To: linux-kernel@vger.kernel.org
Message-id: <20090113214743.GE28831@clouds>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug occurs in 2.6.29-rc1 as well as the latest linux-2.6 git tree.
I've tried bisecting but there are at least 3 unrelated oopses on my
system since 2.6.28 that prevented me from isolating the problem.

[   23.339994] BUG: unable to handle kernel paging request at 000077fed87bb6bf
[   23.340983] IP: [<ffffffff8024e021>] wq_per_cpu+0x1e/0x24
[   23.340983] PGD 0
[   23.340983] Oops: 0000 [#1] SMP
[   23.340983] last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:00.0/0000:04:01.0/host1/target1:0:5/1:0:5:0/rev
[   23.340983] CPU 0
[   23.340983] Modules linked in: sg sd_mod crc_t10dif mptspi mptscsih mptbase scsi_transport_spi qla2xxx scsi_transport_fc floppy scsi_mod button parport_pc serio_raw parport rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core ehci_hcd uhci_hcd pcspkr shpchp e1000e nfs lockd nfs_acl auth_rpcgss sunrpc
[   23.340983] Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #1
[   23.340983] RIP: 0010:[<ffffffff8024e021>]  [<ffffffff8024e021>] wq_per_cpu+0x1e/0x24
[   23.340983] RSP: 0018:ffffffff808bbe78  EFLAGS: 00010246
[   23.340983] RAX: 000077fed87bb6bf RBX: ffff88013dd32810 RCX: ffff88013dd32830
[   23.340983] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880128d7ff80
[   23.340983] RBP: ffffffff808bbe78 R08: 0000000000000010 R09: ffffffff808bbf20
[   23.340983] R10: 0000000000000000 R11: ffffffff808bbf50 R12: 0000000000000100
[   23.340983] R13: ffffffff8024e99a R14: ffffffff808bbec8 R15: ffffffff808ff398
[   23.340983] FS:  0000000000000000(0000) GS:ffffffff808c4080(0000) knlGS:0000000000000000
[   23.340983] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   23.340983] CR2: 000077fed87bb6bf CR3: 0000000000201000 CR4: 00000000000006e0
[   23.340983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.340983] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   23.340983] Process swapper (pid: 0, threadinfo ffffffff80842000, task ffffffff8066a360)
[   23.340983] Stack:
[   23.340983]  ffffffff808bbe98 ffffffff8024e9c3 ffffffff80242ba0 ffffffff808fd780
[   23.340983]  ffffffff808bbf08 ffffffff80247862 ffffffff808b6d80 ffffffff808fef98
[   23.340983]  ffffffff808feb98 ffffffff808fe798 ffffffff808bbec8 ffffffff808bbec8
[   23.340983] Call Trace:
[   23.340983]  <IRQ> <0> [<ffffffff8024e9c3>] delayed_work_timer_fn+0x29/0x38
[   23.340983]  [<ffffffff80242ba0>] ? set_normalized_timespec+0x9/0x38
[   23.340983]  [<ffffffff80247862>] run_timer_softirq+0x15c/0x1cb
[   23.340983]  [<ffffffff8024374e>] __do_softirq+0x86/0x145
[   23.340983]  [<ffffffff8020d3bc>] call_softirq+0x1c/0x28
[   23.340983]  [<ffffffff8020e3a1>] do_softirq+0x39/0x7b
[   23.340983]  [<ffffffff802436c6>] irq_exit+0x44/0x46
[   23.340983]  [<ffffffff805350c0>] smp_apic_timer_interrupt+0x99/0xb2
[   23.340983]  [<ffffffff8020cdf3>] apic_timer_interrupt+0x13/0x20
[   23.340983]  <EOI> <0>Code: d0 48 3b 48 40 c9 0f 94 c0 0f b6 c0 c3 55 48 89 e5 e8 f4 de fb ff 83 7f 20 00 74 06 8b 35 e8 fd 5e 00 48 8b 07 48 63 d6 48 f7 d0 <48> 8b 04 d0 c9 c3 55 48 89 e5 41 54 53 48 83 ec 10 e8 c9 de fb
[   23.340983] RIP  [<ffffffff8024e021>] wq_per_cpu+0x1e/0x24
[   23.340983]  RSP <ffffffff808bbe78>
[   23.340983] CR2: 000077fed87bb6bf
[   23.614640] ---[ end trace 59b682ce1b8e5668 ]---
[   23.619417] Kernel panic - not syncing: Fatal exception in interrupt

.config is at
http://downloads.lustre.org/people/scjody/lkml/config_2009-01-13

Bisect log is at
http://downloads.lustre.org/people/scjody/lkml/bisect_2009-01-13-2

I marked anything that got further than 'Starting udev:' (where the
above problem happened) as "good" but I'm now left with changes to ARM,
regulator, and documentation, so something's wrong with my approach.

Suggestions?

Thanks,
Jody
