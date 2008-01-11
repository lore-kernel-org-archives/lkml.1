Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYAKKRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYAKKRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYAKKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:17:34 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40844 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbYAKKRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:17:33 -0500
Date: Fri, 11 Jan 2008 12:17:31 +0200 (EET)
From: Timo Jantunen <jeti@iki.fi>
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: soft lockup with kernel 2.6.23.12 (x86-64)
Message-ID: <Pine.LNX.4.64.0801111206040.5918@limbo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heip!


I did something like "dd if=/dev/sda1 bs=256M of=dump" and the whole system 
hanged after a while.

Netconsole captured following soft lockup:

===cut
BUG: soft lockup - CPU#3 stuck for 11s! [metalog:4767]
CPU 3:
Modules linked in: fglrx(P) cinergyT2
Pid: 4767, comm: metalog Tainted: P      D 2.6.23.12 #6
RIP: 0010:[<ffffffff80568b67>]  [<ffffffff80568b67>] _spin_lock+0x7/0x10
RSP: 0018:ffff810128dd9b00  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff8100c5341b70 RCX: 0000000000000000
RDX: ffff81012aa50720 RSI: ffffffff8061df23 RDI: ffffffff8069bce0
RBP: ffff8100c5341b70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000001000 R12: ffff8100c5341b70
R13: ffff810108421a00 R14: 0000000000000001 R15: 00010b84002cffff
FS:  00002b9a1ba83b00(0000) GS:ffff81012fc0f200(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8900757b0600 CR3: 000000012c223000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8029ee15>] __mark_inode_dirty+0x65/0x1b0
 [<ffffffff802d59a9>] reiserfs_file_write+0x1b9/0x1b90
 [<ffffffff8028ce81>] free_poll_entry+0x11/0x20
 [<ffffffff8028cec0>] poll_freewait+0x30/0x90
 [<ffffffff8028d090>] do_sys_poll+0x170/0x3f0
 [<ffffffff8028de60>] __pollwait+0x0/0x130
 [<ffffffff80291d28>] __d_lookup+0x98/0x120
 [<ffffffff802875df>] do_lookup+0x8f/0x220
 [<ffffffff8029232b>] dput+0xab/0x140
 [<ffffffff80289b03>] __link_path_walk+0xc83/0xe40
 [<ffffffff80296c67>] mntput_no_expire+0x27/0xb0
 [<ffffffff80289d40>] link_path_walk+0x80/0xf0
 [<ffffffff8028a019>] do_path_lookup+0x89/0x1f0
 [<ffffffff802889c5>] getname+0xf5/0x200
 [<ffffffff8037a938>] _atomic_dec_and_lock+0x48/0x70
 [<ffffffff80296c67>] mntput_no_expire+0x27/0xb0
 [<ffffffff80282c85>] cp_new_stat+0xe5/0x100
 [<ffffffff8027fb28>] vfs_write+0xc8/0x170
 [<ffffffff802801d3>] sys_write+0x53/0x90
 [<ffffffff8020bbde>] system_call+0x7e/0x83

BUG: soft lockup - CPU#0 stuck for 11s! [pdflush:290]
CPU 0:
Modules linked in: fglrx(P) cinergyT2
Pid: 290, comm: pdflush Tainted: P      D 2.6.23.12 #6
RIP: 0010:[<ffffffff80568b67>]  [<ffffffff80568b67>] _spin_lock+0x7/0x10
RSP: 0000:ffff81012ff5de58  EFLAGS: 00000286
RAX: 0000000000000001 RBX: ffff81004c854070 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000282 RDI: ffffffff8069bce0
RBP: ffff81012fc90000 R08: ffff81012ff5c000 R09: 0000000000000000
R10: 0000000000000080 R11: 00000000ffffffff R12: ffff81012ff5a000
R13: ffffffff8023a590 R14: 0000000103f4afa4 R15: 0000000000200200
FS:  0000000000000000(0000) GS:ffffffff806ff000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000f6509000 CR3: 00000001221ad000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8029f004>] writeback_inodes+0xa4/0xf0
 [<ffffffff802600d6>] wb_kupdate+0xa6/0x120
 [<ffffffff802604f0>] pdflush+0x0/0x1e0
 [<ffffffff80260600>] pdflush+0x110/0x1e0
 [<ffffffff80260030>] wb_kupdate+0x0/0x120
 [<ffffffff802459cb>] kthread+0x4b/0x80
 [<ffffffff8020c9f8>] child_rip+0xa/0x12
 [<ffffffff80245980>] kthread+0x0/0x80
 [<ffffffff8020c9ee>] child_rip+0x0/0x12

BUG: soft lockup - CPU#2 stuck for 11s! [pdflush:289]
CPU 2:
Modules linked in: fglrx(P) cinergyT2
Pid: 289, comm: pdflush Tainted: P      D 2.6.23.12 #6
RIP: 0010:[<ffffffff80568b67>]  [<ffffffff80568b67>] _spin_lock+0x7/0x10
RSP: 0000:ffff81012ff59e38  EFLAGS: 00000286
RAX: 0000000000000001 RBX: ffff81004c854070 RCX: 000000000001fcc6
RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffffff8069bce0
RBP: ffff81012fc90000 R08: 00000000000c5c60 R09: ffff81012ff59eb0
R10: 28f5c28f5c28f5c3 R11: 00000000ffffffff R12: ffff81012ff54720
R13: ffffffff8023a590 R14: 0000000103f4afa3 R15: 0000000000200200
FS:  0000000000000000(0000) GS:ffff81012fc0f180(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002b1e07aee000 CR3: 000000004d4a7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8029f004>] writeback_inodes+0xa4/0xf0
 [<ffffffff8025ffc7>] background_writeout+0xa7/0xd0
 [<ffffffff802604f0>] pdflush+0x0/0x1e0
 [<ffffffff80260600>] pdflush+0x110/0x1e0
 [<ffffffff8025ff20>] background_writeout+0x0/0xd0
 [<ffffffff802459cb>] kthread+0x4b/0x80
 [<ffffffff8020c9f8>] child_rip+0xa/0x12
 [<ffffffff80245980>] kthread+0x0/0x80
 [<ffffffff8020c9ee>] child_rip+0x0/0x12

BUG: soft lockup - CPU#1 stuck for 11s! [boinc:5597]
CPU 1:
Modules linked in: fglrx(P) cinergyT2
Pid: 5597, comm: boinc Tainted: P      D 2.6.23.12 #6
RIP: 0010:[<ffffffff80568b6a>]  [<ffffffff80568b6a>] _spin_lock+0xa/0x10
RSP: 0018:ffff810127f33b50  EFLAGS: 00000286
RAX: 00000000000011d0 RBX: ffff8100056d1680 RCX: 0000000000000012
RDX: 00000000f0000095 RSI: ffff8100056d1680 RDI: ffffffff8069bce0
RBP: 0000000000000000 R08: 000000000000000a R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff802f05e0 R12: 0000000000000010
R13: ffff810127f33de0 R14: ffff810127f33dd8 R15: ffff810127f33dd0
FS:  0000000000000000(0000) GS:ffff81012fc0f100(0063) knlGS:00000000f7f696c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f654c000 CR3: 0000000127c2f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff80293d27>] ifind_fast+0x27/0xa0
 [<ffffffff80294164>] iget_locked+0x44/0x180
 [<ffffffff802bb8c6>] proc_get_inode+0x26/0x140
 [<ffffffff802c0275>] proc_lookup+0x95/0x110
 [<ffffffff802876ca>] do_lookup+0x17a/0x220
 [<ffffffff8028968d>] __link_path_walk+0x80d/0xe40
 [<ffffffff8029232b>] dput+0xab/0x140
 [<ffffffff80289b03>] __link_path_walk+0xc83/0xe40
 [<ffffffff80289d1a>] link_path_walk+0x5a/0xf0
 [<ffffffff8027d5d9>] get_unused_fd_flags+0x79/0x120
 [<ffffffff802808d1>] get_empty_filp+0x31/0x110
 [<ffffffff8028a019>] do_path_lookup+0x89/0x1f0
 [<ffffffff8028ae9a>] __path_lookup_intent_open+0x6a/0xd0
 [<ffffffff8028b0c6>] open_namei+0x86/0x700
 [<ffffffff80282b60>] vfs_stat_fd+0x50/0x80
 [<ffffffff802a50ea>] invalidate_inode_buffers+0x2a/0x100
 [<ffffffff8027d97c>] do_filp_open+0x1c/0x50
 [<ffffffff8027d5d9>] get_unused_fd_flags+0x79/0x120
 [<ffffffff8027da0a>] do_sys_open+0x5a/0xf0
 [<ffffffff80220b80>] sysenter_do_call+0x1b/0x67
===cut


The kernel had ATI binary blob loaded, but I was remote at the time so I 
don't think that was it.

Kernel: 2.6.23.12
CPU: Quad core Intel (x86-64 bit mode)
Memory: 4GB

The target filesystem was ext3, but most of my filesystems are reiserfs 
(like /var/log).

The dump file was in the same physical disk (but not the same partition) as 
sda1 (which is why I used so big block size.) When I did the same operation 
again with 4M block size I had no problems.


//T
