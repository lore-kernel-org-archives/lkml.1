Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYJFQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYJFQxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJFQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:53:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50481 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYJFQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:53:05 -0400
Message-ID: <48EA423F.50401@oracle.com>
Date: Mon, 06 Oct 2008 09:52:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [Bug #11504] reiserfs =?UTF-8?B?77+977+977+977+9QlVHIGluIDIu?=
 =?UTF-8?B?Ni4yNy1yYzU=?=
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.dN.u575IB@wind>
In-Reply-To: <yWwteD.A.dN.u575IB@wind>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11504
> Subject		: reiserfs  BUG in 2.6.27-rc5
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-09-03 16:35 (32 days old)
> References	: http://marc.info/?l=linux-kernel&m=122045982120138&w=4

Yes, it should remain since it happened recently on 2.6.27-rc8-git6.
Again with blocksize = 1KB.

I don't see any action from the reiserfs developers about trying
to fix this.  Maybe I shouldn't bother testing this.


Here's the BUG dump from 2.6.27-rc8-git6:

calling  init_reiserfs_fs+0x0/0x83 [reiserfs]
initcall init_reiserfs_fs+0x0/0x83 [reiserfs] returned 0 after 0 msecs
ReiserFS: cciss/c0d0p4: found reiserfs format "3.6" with standard journal
ReiserFS: cciss/c0d0p4: using journaled data mode
ReiserFS: cciss/c0d0p4: journal params: device cciss/c0d0p4, size 8125, journal first block 66, max trans len 256, max batch 225, max commit age 30, max trans age 30
ReiserFS: cciss/c0d0p4: checking transaction log (cciss/c0d0p4)
ReiserFS: cciss/c0d0p4: Using r5 hash to sort names
------------[ cut here ]------------
kernel BUG at fs/reiserfs/journal.c:530!
invalid opcode: 0000 [1] SMP
CPU 3
Modules linked in: reiserfs parport_pc lp parport tg3 lpfc cciss ehci_hcd ohci_hcd uhci_hcd [last unloaded: reiserfs]
Pid: 24918, comm: fsx-linux Not tainted 2.6.27-rc8-git6 #1
RIP: 0010:[<ffffffffa00b3e35>]  [<ffffffffa00b3e35>] reiserfs_in_journal+0xed/0x155 [reiserfs]
RSP: 0018:ffff88017e9bb748  EFLAGS: 00010246
RAX: 0000000000002493 RBX: ffff88017e9bb79c RCX: 0000000000002493
RDX: ffffc20011c97760 RSI: ffffc20011bf21f0 RDI: ffff8801f85a9000
RBP: ffff88017e9bb758 R08: 0000000000000005 R09: ffff880178851800
R10: ffffc20011bf2000 R11: 0000000000000008 R12: ffff88017e9bb86c
R13: ffff88027f07f3f0 R14: ffff880178851800 R15: 0000000000000001
FS:  00007facfc8af6f0(0000) GS:ffff88027f618c80(0000) knlGS:00000000f7f4d6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007facfcabf000 CR3: 000000017899f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx-linux (pid: 24918, threadinfo ffff88017e9ba000, task ffff8801796ce810)
Stack:  ffff880178851800 0000000000000493 ffff88017e9bb7c8 ffffffffa0096418
 000000116f000080 0000200000000001 ffff8801d78a7640 ffffc20000c74004
 000004837e9bb898 ffffffffa009dd29 0000000005cce34f ffff88017e9bb998
Call Trace:
 [<ffffffffa0096418>] scan_bitmap_block+0x128/0x227 [reiserfs]
 [<ffffffffa009dd29>] ? reiserfs_update_sd_size+0x297/0x2a9 [reiserfs]
 [<ffffffffa0097160>] reiserfs_allocate_blocknrs+0x87e/0xa94 [reiserfs]
 [<ffffffffa00acedd>] ? search_for_position_by_key+0x165/0x2c7 [reiserfs]
 [<ffffffffa009e341>] reiserfs_get_block+0x3b8/0xf67 [reiserfs]
 [<ffffffff802ba86c>] __block_prepare_write+0x1b9/0x39c
 [<ffffffffa009df89>] ? reiserfs_get_block+0x0/0xf67 [reiserfs]
 [<ffffffff8027991e>] ? __inc_zone_page_state+0x29/0x2b
 [<ffffffff802baafb>] block_write_begin+0x7d/0xcd
 [<ffffffffa00a0071>] reiserfs_write_begin+0x13d/0x1c6 [reiserfs]
 [<ffffffffa009df89>] ? reiserfs_get_block+0x0/0xf67 [reiserfs]
 [<ffffffff8026e1c4>] generic_file_buffered_write+0x14b/0x636
 [<ffffffff802396ea>] ? current_fs_time+0x22/0x29
 [<ffffffff8026ebb0>] __generic_file_aio_write_nolock+0x352/0x3bc
 [<ffffffff8024f04a>] ? debug_mutex_free_waiter+0x46/0x4a
 [<ffffffff8026ec7e>] generic_file_aio_write+0x64/0xc0
 [<ffffffff80299850>] do_sync_write+0xe2/0x126
 [<ffffffff80278b52>] ? vma_prio_tree_remove+0x42/0xe4
 [<ffffffff8029caa2>] ? cp_new_stat+0xf6/0x10f
 [<ffffffff802475e0>] ? autoremove_wake_function+0x0/0x38
 [<ffffffffa00a0b7c>] reiserfs_file_write+0x38/0x4d [reiserfs]
 [<ffffffff8029a029>] vfs_write+0xae/0x157
 [<ffffffff8029a537>] sys_write+0x47/0x6f
 [<ffffffff8020bf0b>] system_call_fastpath+0x16/0x1b


Code: d0 25 ff 1f 00 00 49 8b 94 c2 f8 01 00 00 eb 12 8b 42 10 48 39 c8 75 06 4c 39 4a 08 74 0d 48 8b 52 40 48 85 d2 75 e9 31 c0 eb 63 <0f> 0b eb fe 49 8b 41 18 48 c1 e0 03 48 0f af c8 48 63 c2 48 01
RIP  [<ffffffffa00b3e35>] reiserfs_in_journal+0xed/0x155 [reiserfs]
 RSP <ffff88017e9bb748>
Kernel panic - not syncing: Fatal exception



Now why didn't the system reboot?  :(
