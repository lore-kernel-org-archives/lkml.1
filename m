Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYHKS1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYHKS1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHKS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:27:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55799 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYHKS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:27:35 -0400
Date: Mon, 11 Aug 2008 11:27:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: INFO: task blocked for more than 120 seconds
Message-Id: <20080811112712.f858d77c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.27-rc2-git4 and several previous kernels, I see several
of these messages.  E.g.:

INFO: task kjournald:665 blocked for more than 120 seconds.
INFO: task stress:17797 blocked for more than 120 seconds.
INFO: task stress:17805 blocked for more than 120 seconds.


Has anyone tracked this down?  Should I attempt to bisect it?
(on x86_64, SMP, 8 GB RAM)



INFO: task kjournald:665 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D ffff88027e04be30  4592   665      2
 ffff88027e04bdd0 0000000000000046 ffff88027e04bd90 ffffffff8022b5f8
 ffff88027e703090 ffff880178c91bc0 ffff88027e7033d0 0000000178c91c08
 ffff88027e04bdb0 ffff88027e04be30 ffff88017eaf80f0 0000000000000246
Call Trace:
 [<ffffffff8022b5f8>] ? __wake_up_common+0x41/0x74
 [<ffffffff802f6eef>] journal_commit_transaction+0xe9/0xd7e
 [<ffffffff8023db06>] ? lock_timer_base+0x26/0x4a
 [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023db80>] ? try_to_del_timer_sync+0x56/0x62
 [<ffffffff802fa388>] kjournald+0xc3/0x1fb
 [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff802fa2c5>] ? kjournald+0x0/0x1fb
 [<ffffffff80247107>] kthread+0x49/0x76
 [<ffffffff8020ce39>] child_rip+0xa/0x11
 [<ffffffff802470be>] ? kthread+0x0/0x76
 [<ffffffff8020ce2f>] ? child_rip+0x0/0x11

INFO: task stress:17797 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
stress        D ffff88017eaf8024  5088 17797  17795
 ffff8801f4055cd8 0000000000000082 0000000000000086 ffff88027e04bec0
 ffff880178c93090 ffff88017faf75f0 ffff880178c933d0 0000000300000001
 0000000000000292 ffff8801f4055ce8 ffff88017eaf80a8 0000000000000246
Call Trace:
 [<ffffffff802f9c04>] log_wait_commit+0xa4/0xf4
 [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff802f5798>] journal_stop+0x17c/0x1a9
 [<ffffffff802f5fe6>] journal_force_commit+0x23/0x25
 [<ffffffff802eee53>] ext3_force_commit+0x26/0x28
 [<ffffffff802e91d2>] ext3_write_inode+0x39/0x3f
 [<ffffffff802b58cf>] __writeback_single_inode+0x180/0x284
 [<ffffffff80247278>] ? wake_bit_function+0x0/0x2a
 [<ffffffff802b5db1>] generic_sync_sb_inodes+0x1c3/0x29e
 [<ffffffff802b5e95>] sync_sb_inodes+0x9/0xb
 [<ffffffff802b5f2c>] sync_inodes_sb+0x95/0x9c
 [<ffffffff802b5f95>] __sync_inodes+0x62/0xaf
 [<ffffffff802b6010>] sync_inodes+0x2e/0x33
 [<ffffffff802b8908>] do_sync+0x34/0x59
 [<ffffffff802b893b>] sys_sync+0xe/0x13
 [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
