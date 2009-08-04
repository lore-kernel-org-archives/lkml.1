Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZHDOOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZHDOOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZHDOOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:14:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40388 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZHDOOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:14:30 -0400
Date: Tue, 4 Aug 2009 10:14:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: neilb@suse.de
Subject: 2.6.31rc5 RAID10 lockdep report
Message-ID: <20090804141425.GA2831@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, neilb@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report from a user we received today ..
(https://bugzilla.redhat.com/show_bug.cgi?id=515471)

	Dave


=================================
[ INFO: inconsistent lock state ]
2.6.31-0.118.rc5.fc12.x86_64 #1
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
md126_resync/475 [HC0[0]:SC1[1]:HE1:SE0] takes:
(sysfs_open_dirent_lock){+.?...}, at: [<ffffffff811a7d08>] sysfs_notify_dirent+0x2c/0x75
{SOFTIRQ-ON-W} state was registered at:
 [<ffffffff81097468>] __lock_acquire+0x2e9/0xc0e
 [<ffffffff81097e7b>] lock_acquire+0xee/0x12e
 [<ffffffff814fc99f>] _spin_lock+0x45/0x8e
 [<ffffffff811a70e0>] sysfs_open_file+0x18f/0x295
 [<ffffffff8113fba1>] __dentry_open+0x197/0x316
 [<ffffffff8113fe20>] nameidata_to_filp+0x51/0x76
 [<ffffffff8114e900>] do_filp_open+0x516/0x9d8
 [<ffffffff8113f889>] do_sys_open+0x71/0x131
 [<ffffffff8113f9b6>] sys_open+0x33/0x49
 [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
 [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 12243532
hardirqs last  enabled at (12243532): [<ffffffff814fc69b>] _spin_unlock_irq+0x3f/0x61
hardirqs last disabled at (12243531): [<ffffffff814fcaa9>] _spin_lock_irq+0x2e/0x9a
softirqs last  enabled at (12243378): [<ffffffff8106c9ad>] __do_softirq+0x1c4/0x1f0
softirqs last disabled at (12243471): [<ffffffff8101422c>] call_softirq+0x1c/0x30

other info that might help us debug this:
1 lock held by md126_resync/475:
#0:  (&new->safemode_timer){+.-...}, at: [<ffffffff8107233a>] run_timer_softirq+0x198/0x2a3

stack backtrace:
Pid: 475, comm: md126_resync Not tainted 2.6.31-0.118.rc5.fc12.x86_64 #1
Call Trace:
<IRQ>  [<ffffffff81095f60>] valid_state+0x187/0x1ae
[<ffffffff810969f1>] ? check_usage_forwards+0x0/0x79
[<ffffffff810960b0>] mark_lock+0x129/0x253
[<ffffffff810973f4>] __lock_acquire+0x275/0xc0e
[<ffffffff8109536a>] ? save_trace+0x4e/0xba
[<ffffffff81097e7b>] lock_acquire+0xee/0x12e
[<ffffffff811a7d08>] ? sysfs_notify_dirent+0x2c/0x75
[<ffffffff811a7d08>] ? sysfs_notify_dirent+0x2c/0x75
[<ffffffff813eb86a>] ? md_safemode_timeout+0x0/0x70
[<ffffffff814fc99f>] _spin_lock+0x45/0x8e
[<ffffffff811a7d08>] ? sysfs_notify_dirent+0x2c/0x75
[<ffffffff811a7d08>] sysfs_notify_dirent+0x2c/0x75
[<ffffffff813eb8b3>] md_safemode_timeout+0x49/0x70
[<ffffffff8107239e>] run_timer_softirq+0x1fc/0x2a3
[<ffffffff8107233a>] ? run_timer_softirq+0x198/0x2a3
[<ffffffff8106c8df>] __do_softirq+0xf6/0x1f0
[<ffffffff8101422c>] call_softirq+0x1c/0x30
[<ffffffff81015d77>] do_softirq+0x5f/0xd7
[<ffffffff8106c1f6>] irq_exit+0x66/0xbc
[<ffffffff814fc0ec>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[<ffffffff81015406>] do_IRQ+0xb8/0xe5
[<ffffffff810139d3>] ret_from_intr+0x0/0x16
<EOI>  [<ffffffff814fc71c>] ? _spin_unlock_irqrestore+0x5f/0x7f
[<ffffffff813580a6>] ? scsi_dispatch_cmd+0x1d4/0x25f
[<ffffffff8135f095>] ? scsi_request_fn+0x483/0x4c4
[<ffffffff8125c00e>] ? __blk_run_queue+0x54/0x9a
[<ffffffff8126e727>] ? cfq_insert_request+0x26c/0x3d4
[<ffffffff81253d83>] ? elv_insert+0x120/0x1e0
[<ffffffff81253eea>] ? __elv_add_request+0xa7/0xc2
[<ffffffff8125ce11>] ? __make_request+0x35e/0x3f1
[<ffffffff81259e20>] ? generic_make_request+0x29e/0x2fc
[<ffffffffa00db8af>] ? sync_request+0x833/0x8b2 [raid10]
[<ffffffff813f1104>] ? md_do_sync+0x756/0xb4f
[<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
[<ffffffff813f1dbc>] ? md_thread+0x100/0x132
[<ffffffff813f1cbc>] ? md_thread+0x0/0x132
[<ffffffff810816f5>] ? kthread+0xa5/0xad
[<ffffffff8101412a>] ? child_rip+0xa/0x20
[<ffffffff81013a90>] ? restore_args+0x0/0x30
[<ffffffff81081650>] ? kthread+0x0/0xad
[<ffffffff81014120>] ? child_rip+0x0/0x20

