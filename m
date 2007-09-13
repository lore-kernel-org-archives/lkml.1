Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXIMTz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXIMTz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbXIMTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:55:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46291 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbXIMTzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:55:38 -0400
Date: Thu, 13 Sep 2007 12:54:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: reiserfs-devel@vger.kernel.org
Subject: 2.6.23-rc6-git4: reiserfs bug
Message-Id: <20070913125448.e71a0b11.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on x86_64, 2 CPU + HT, 4 GB RAM:

reiserfs with blocksize of 1 KB, data=ordered


[ 9828.242431] ------------[ cut here ]------------
[ 9828.247056] kernel BUG at fs/reiserfs/journal.c:531!
[ 9828.252017] invalid opcode: 0000 [1] SMP
[ 9828.256070] CPU 0
[ 9828.258105] Modules linked in: reiserfs loop
[ 9828.262428] Pid: 16555, comm: pdflush Not tainted 2.6.23-rc6-git3 #1
[ 9828.268775] RIP: 0010:[<ffffffff8802832d>]  [<ffffffff8802832d>] :reiserfs:reiserfs_in_journal+0x10c/0x189
[ 9828.278457] RSP: 0018:ffff81010e749610  EFLAGS: 00010246
[ 9828.283766] RAX: 00000000000025e7 RBX: ffff81010e749664 RCX: 0000000000000f8f
[ 9828.290893] RDX: ffffc2001031b390 RSI: 00000000000025e7 RDI: ffff81011e4be000
[ 9828.298021] RBP: ffff81010e749620 R08: ffffc20010282000 R09: ffff81011e4be000
[ 9828.305149] R10: 00000000000005e7 R11: 0000000000000008 R12: ffff81011e4be000
[ 9828.312276] R13: ffff81010e749734 R14: ffff8101077115a8 R15: 0000000000000001
[ 9828.319404] FS:  0000000000000000(0000) GS:ffffffff80736000(0000) knlGS:0000000000000000
[ 9828.327484] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 9828.333226] CR2: 00002b61d730c000 CR3: 000000011d463000 CR4: 00000000000006e0
[ 9828.340354] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9828.347481] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 9828.354609] Process pdflush (pid: 16555, threadinfo ffff81010e748000, task ffff8101108bb040)
[ 9828.363035] Stack:  00000000000025e6 00000000000005e7 ffff81010e749690 ffffffff8800830a
[ 9828.371115]  000000011e853bd8 0000200000000001 ffff81011b88b1c0 ffffc20000072004
[ 9828.378563]  000005e60e749660 ffffffff8055cd05 000000000e749690 ffff81010e7498b0
[ 9828.385829] Call Trace:
[ 9828.388481]  [<ffffffff8800830a>] :reiserfs:scan_bitmap_block+0xe2/0x2ac
[ 9828.395179]  [<ffffffff8055cd05>] _spin_unlock+0x9/0xb
[ 9828.400318]  [<ffffffff880095f0>] :reiserfs:reiserfs_allocate_blocknrs+0x8dd/0xae7
[ 9828.407890]  [<ffffffff8802101a>] :reiserfs:search_for_position_by_key+0x165/0x2c9
[ 9828.415458]  [<ffffffff880104d9>] :reiserfs:reiserfs_get_block+0x3eb/0xfe6
[ 9828.422333]  [<ffffffff880117f3>] :reiserfs:reiserfs_writepage+0x71f/0xacf
[ 9828.429205]  [<ffffffff8055b3dc>] io_schedule+0x5d/0x62
[ 9828.434425]  [<ffffffff8055ce0f>] _read_unlock_irq+0x9/0xc
[ 9828.439910]  [<ffffffff802689d2>] find_get_pages_tag+0x94/0xa3
[ 9828.445736]  [<ffffffff8026d4f5>] __writepage+0x15/0x36
[ 9828.450958]  [<ffffffff8024baff>] wake_bit_function+0x0/0x2a
[ 9828.456613]  [<ffffffff8026dabb>] write_cache_pages+0x1dc/0x348
[ 9828.462527]  [<ffffffff8026d4e0>] __writepage+0x0/0x36
[ 9828.467663]  [<ffffffff8026dc49>] generic_writepages+0x22/0x28
[ 9828.473507]  [<ffffffff8026dc81>] do_writepages+0x32/0x3a
[ 9828.478941]  [<ffffffff802a47a2>] __writeback_single_inode+0x1f8/0x392
[ 9828.485488]  [<ffffffff8055c8cb>] __down_failed+0x35/0x3a
[ 9828.490916]  [<ffffffff880280cd>] :reiserfs:reiserfs_flush_old_commits+0x1e/0xca
[ 9828.498312]  [<ffffffff880275d6>] :reiserfs:journal_end_sync+0x75/0x7e
[ 9828.504836]  [<ffffffff802a4d13>] sync_sb_inodes+0x1b0/0x26c
[ 9828.510489]  [<ffffffff802a51b8>] writeback_inodes+0x9e/0xfa
[ 9828.516146]  [<ffffffff8026e228>] wb_kupdate+0xbf/0x136
[ 9828.521376]  [<ffffffff8026e54d>] pdflush+0x0/0x1ed
[ 9828.526250]  [<ffffffff8026e68f>] pdflush+0x142/0x1ed
[ 9828.531300]  [<ffffffff8026e169>] wb_kupdate+0x0/0x136
[ 9828.536437]  [<ffffffff8024b9bb>] kthread+0x49/0x76
[ 9828.541313]  [<ffffffff8020c378>] child_rip+0xa/0x12
[ 9828.546274]  [<ffffffff8024b972>] kthread+0x0/0x76
[ 9828.551063]  [<ffffffff8020c36e>] child_rip+0x0/0x12
[ 9828.556024]
[ 9828.557523]
[ 9828.557524] Code: 0f 0b eb fe 49 8b 41 18 4c 89 c9 48 c1 e9 07 48 c1 e0 03 48
[ 9828.566599] RIP  [<ffffffff8802832d>] :reiserfs:reiserfs_in_journal+0x10c/0x189
[ 9828.573934]  RSP <ffff81010e749610>
[ 9828.577794] Kernel panic - not syncing: Fatal exception
[ 9828.583029] Rebooting in 30 seconds..

---
~Randy
