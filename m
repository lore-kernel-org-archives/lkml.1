Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYENOHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYENOHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYENOHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:07:23 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58619 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYENOHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:07:21 -0400
Message-ID: <482AF14F.9060708@linux.vnet.ibm.com>
Date: Wed, 14 May 2008 19:33:59 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       reiserfs-devel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] 2.6.26-rc2-mm1 - kernel BUG at fs/reiserfs/journal.c:1414!
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

While running the dbench benchmark on the reiserfs filesystem,
over the x86_64 box booted with the 2.6.26-rc2-mm1 kernel. The
Kernel BUG() is seen on the console.

------------[ cut here ]------------
kernel BUG at fs/reiserfs/journal.c:1414!
invalid opcode: 0000 [1] SMP 
last sysfs file: /sys/devices/pci0000:20/0000:20:04.1/resource
CPU 3 
Modules linked in:
Pid: 5160, comm: umount Not tainted 2.6.26-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff802e47e5>]  [<ffffffff802e47e5>] flush_journal_list+0x78/0x575
RSP: 0000:ffff8101fec6fb18  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000003
RDX: 0000000000000000 RSI: ffff81007edf7c00 RDI: ffffc2000210d0a0
RBP: ffff8101fec6fb58 R08: ffff8101fec6e000 R09: 0000000000000001
R10: 0000000000000000 R11: ffffc2000212f1b0 R12: ffff81007edf7c00
R13: 000000000000000d R14: ffff8101fe5d2c00 R15: ffffc2000210d000
FS:  0000000000000000(0000) GS:ffff8101fff07f80(0063) knlGS:00000000f7fbdb20
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7f5d260 CR3: 00000001fb475000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 5160, threadinfo ffff8101fec6e000, task ffff8101fe642c80)
Stack:  00000000fec6fb10 ffffffff802a557b 00000000fc7593f0 ffffc2000210d000
 ffff81007f65f900 000000000000000d ffff8101fe5d2c00 ffffc2000210d000
 ffff8101fec6fba8 ffffffff802e4aff 000000000000000d 0000000100000001
Call Trace:
 [<ffffffff802a557b>] submit_bh+0x105/0x111
 [<ffffffff802e4aff>] flush_journal_list+0x392/0x575
 [<ffffffff802e7e76>] do_journal_end+0xb6d/0xe0c
 [<ffffffff80261f7f>] __writepage+0x0/0x2a
 [<ffffffff80263c1f>] pagevec_lookup_tag+0x20/0x2a
 [<ffffffff8025ad8e>] wait_on_page_writeback_range+0xeb/0x13e
 [<ffffffff802e8376>] do_journal_begin_r+0x261/0x2a2
 [<ffffffff802e8a13>] do_journal_release+0x4c/0x180
 [<ffffffff80242070>] bit_waitqueue+0x12/0xa4
 [<ffffffff802e359e>] get_cnode+0x73/0x7e
 [<ffffffff802e517d>] journal_mark_dirty+0x150/0x247
 [<ffffffff802e8b62>] journal_release+0xb/0xd
 [<ffffffff802d8c83>] reiserfs_put_super+0x7f/0xed
 [<ffffffff802859dc>] generic_shutdown_super+0x63/0xf2
 [<ffffffff80286671>] kill_block_super+0x12/0x27
 [<ffffffff802d8c00>] reiserfs_kill_sb+0x53/0x57
 [<ffffffff80285893>] deactivate_super+0x46/0x5b
 [<ffffffff802993ff>] mntput_no_expire+0xe9/0x116
 [<ffffffff8029b0a3>] sys_umount+0x349/0x35e
 [<ffffffff8024497f>] up_read+0x9/0xb
 [<ffffffff8021ee39>] do_page_fault+0x493/0x7e8
 [<ffffffff803c2c24>] __up_write+0x10b/0x117
 [<ffffffff8029b0c3>] sys_oldumount+0xb/0xd
 [<ffffffff80222b52>] ia32_sysret+0x0/0xa


Code: ff ff 49 83 7c 24 40 00 75 04 0f 0b eb fe 83 7d d4 00 49 8d bf a0 00 00 00 74 07 e8 78 0d 23 00 eb 0d e8 21 10 23 00 85 c0 75 04 <0f> 0b eb fe c7 45 d0 00 00 00 00 41 8b 87 ec 00 00 00 48 39 c3 
RIP  [<ffffffff802e47e5>] flush_journal_list+0x78/0x575
 RSP <ffff8101fec6fb18>
---[ end trace 6509cf142d99140b ]---
------------[ cut here ]------------
WARNING: at kernel/exit.c:960 do_exit+0x41/0x6b1()
Modules linked in:
Pid: 5160, comm: umount Tainted: G      D   2.6.26-rc2-mm1-autotest #1

Call Trace:
 [<ffffffff802300f4>] warn_on_slowpath+0x58/0x75
 [<ffffffff80225d4b>] check_preempt_wakeup+0xde/0xe6
 [<ffffffff80231012>] printk+0xa2/0xa4
 [<ffffffff80232879>] do_exit+0x41/0x6b1
 [<ffffffff8020cf11>] __die+0x0/0xe2
 [<ffffffff8020d050>] die+0x5d/0x66
 [<ffffffff8020d216>] do_trap+0x110/0x11f
 [<ffffffff8020d418>] do_invalid_op+0x93/0x9c
 [<ffffffff802e47e5>] flush_journal_list+0x78/0x575
 [<ffffffff803b1cab>] __generic_unplug_device+0x22/0x26
 [<ffffffff802a4236>] sync_buffer+0x0/0x3f
 [<ffffffff805151d7>] io_schedule+0x25/0x31
 [<ffffffff805168d9>] error_exit+0x0/0x51
 [<ffffffff802e47e5>] flush_journal_list+0x78/0x575
 [<ffffffff802e47e1>] flush_journal_list+0x74/0x575
 [<ffffffff802a557b>] submit_bh+0x105/0x111
 [<ffffffff802e4aff>] flush_journal_list+0x392/0x575
 [<ffffffff802e7e76>] do_journal_end+0xb6d/0xe0c
 [<ffffffff80261f7f>] __writepage+0x0/0x2a
 [<ffffffff80263c1f>] pagevec_lookup_tag+0x20/0x2a
 [<ffffffff8025ad8e>] wait_on_page_writeback_range+0xeb/0x13e
 [<ffffffff802e8376>] do_journal_begin_r+0x261/0x2a2
 [<ffffffff802e8a13>] do_journal_release+0x4c/0x180
 [<ffffffff80242070>] bit_waitqueue+0x12/0xa4
 [<ffffffff802e359e>] get_cnode+0x73/0x7e
 [<ffffffff802e517d>] journal_mark_dirty+0x150/0x247
 [<ffffffff802e8b62>] journal_release+0xb/0xd
 [<ffffffff802d8c83>] reiserfs_put_super+0x7f/0xed
 [<ffffffff802859dc>] generic_shutdown_super+0x63/0xf2
 [<ffffffff80286671>] kill_block_super+0x12/0x27
 [<ffffffff802d8c00>] reiserfs_kill_sb+0x53/0x57
 [<ffffffff80285893>] deactivate_super+0x46/0x5b
 [<ffffffff802993ff>] mntput_no_expire+0xe9/0x116
 [<ffffffff8029b0a3>] sys_umount+0x349/0x35e
 [<ffffffff8024497f>] up_read+0x9/0xb
 [<ffffffff8021ee39>] do_page_fault+0x493/0x7e8
 [<ffffffff803c2c24>] __up_write+0x10b/0x117
 [<ffffffff8029b0c3>] sys_oldumount+0xb/0xd
 [<ffffffff80222b52>] ia32_sysret+0x0/0xa

---[ end trace 6509cf142d99140b ]---

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
