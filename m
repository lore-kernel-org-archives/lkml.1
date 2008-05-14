Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYENXvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYENXvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYENXuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:50:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45784 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbYENXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:50:50 -0400
Message-ID: <482B7AC0.2050800@oracle.com>
Date: Wed, 14 May 2008 16:50:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: reiserfs BUG in 2.6.26-rc2-mm1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is blocksize=1024 bytes, data=ordered.

On x86_64.

------------[ cut here ]------------
kernel BUG at fs/reiserfs/journal.c:1414!
invalid opcode: 0000 [1] SMP
last sysfs file: /sys/devices/pci0000:40/0000:40:0c.0/0000:41:00.0/0000:42:08.0/class
CPU 3
Modules linked in: reiserfs parport_pc lp parport tg3 cciss ehci_hcd ohci_hcd uhci_hcd [last unloaded: xfs]
Pid: 7153, comm: fsx-linux Not tainted 2.6.26-rc2-mm1 #1
RIP: 0010:[<ffffffffa0073d35>]  [<ffffffffa0073d35>] :reiserfs:flush_journal_list+0x7b/0x5e4
RSP: 0018:ffff81027946d458  EFLAGS: 00010246                                            RAX: 0000000000000000 RBX: 0000000000000002 RCX: 00000000000020fc
RDX: ffff81027946d4a8 RSI: ffff81027041b700 RDI: ffffc200104d20b8                       RBP: ffff81027946d4a8 R08: ffff81027946c000 R09: 000000007946d268
R10: 0000000000000400 R11: ffff8102588c1400 R12: 000000000000004a
R13: ffff81027041b700 R14: ffff8102588c1400 R15: ffff8102588c1400
FS:  00007fb71152a6f0(0000) GS:ffff81027f807980(0000) knlGS:00000000f7f1b6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fb71173a000 CR3: 000000014f5b9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx-linux (pid: 7153, threadinfo ffff81027946c000, task ffff81024dc686f0)
Stack:  000000000000004d 00000000104d2000 00000000104d20b8 ffffc200104d2000
 ffff81027903db60 ffffc200104d2000 000000000000004a ffff810279c25300
 ffff8102588c1400 ffff8102588c1400 ffff81027946d508 ffffffffa0074064
Call Trace:
 [<ffffffffa0074064>] :reiserfs:flush_journal_list+0x3aa/0x5e4
 [<ffffffffa00745a0>] :reiserfs:flush_used_journal_lists+0x302/0x316
 [<ffffffffa0075075>] :reiserfs:do_journal_end+0xac1/0xc8f
 [<ffffffffa0075601>] :reiserfs:do_journal_begin_r+0x1ed/0x2aa
 [<ffffffffa0075776>] :reiserfs:journal_begin+0xb8/0xf5
 [<ffffffffa0060f84>] :reiserfs:restart_transaction+0x78/0x96
 [<ffffffffa0061d71>] :reiserfs:reiserfs_get_block+0xdcf/0xf6f
 [<ffffffff802b40dc>] __block_prepare_write+0x1ba/0x3a0
 [<ffffffffa0060fa2>] ? :reiserfs:reiserfs_get_block+0x0/0xf6f
 [<ffffffff80278a54>] ? __inc_zone_page_state+0x1e/0x20
 [<ffffffff802b436f>] block_write_begin+0x7d/0xce
 [<ffffffffa00630a3>] :reiserfs:reiserfs_write_begin+0x13d/0x1c6
 [<ffffffffa0060fa2>] ? :reiserfs:reiserfs_get_block+0x0/0xf6f
 [<ffffffff8026e2de>] generic_file_buffered_write+0x14b/0x63c
 [<ffffffffa007520f>] ? :reiserfs:do_journal_end+0xc5b/0xc8f
 [<ffffffff8023623e>] ? current_fs_time+0x22/0x29
 [<ffffffff8026ecbf>] __generic_file_aio_write_nolock+0x356/0x3c0
 [<ffffffff8024b67e>] ? debug_mutex_free_waiter+0x46/0x4a
 [<ffffffff8026ed8d>] generic_file_aio_write+0x64/0xc0
 [<ffffffff802927f6>] do_sync_write+0xe2/0x126
 [<ffffffff80295aad>] ? cp_new_stat+0xf6/0x10f
 [<ffffffff80243b3e>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8022bd94>] ? __dequeue_entity+0x61/0x69
 [<ffffffffa0063ba4>] :reiserfs:reiserfs_file_write+0x38/0x4d
 [<ffffffff80292fd3>] vfs_write+0xae/0x157
 [<ffffffff802935a0>] sys_write+0x47/0x70
 [<ffffffff8020c042>] tracesys+0xd5/0xda


Code: 83 7d 58 00 75 04 0f 0b eb fe 83 7d bc 00 48 8b 55 c8 48 8d ba b8 00 00 00 74 07 e8 ad e3 4c e0 eb 0d e8 b4 dd 4c e0 85 c0 75 04 <0f> 0b eb fe 48 8b 55 c8 8b 82 1c 01 00 00 48 39 c3 76 18 49 8b
RIP  [<ffffffffa0073d35>] :reiserfs:flush_journal_list+0x7b/0x5e4
 RSP <ffff81027946d458>
Kernel panic - not syncing: Fatal exception

-- 
~Randy
