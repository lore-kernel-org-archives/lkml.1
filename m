Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZCOM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZCOM7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZCOM7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 08:59:16 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:47681 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZCOM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 08:59:15 -0400
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS lock warning, 2.6.29-rc8
Date: Sun, 15 Mar 2009 14:59:01 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151459.01320.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi

Here is what i got suddently. But seems everything is working.
If any other information required, please let me know.


/dev/md2 on / type xfs (rw,noatime)

[39993.560200]
[39993.560202] =======================================================
[39993.560206] [ INFO: possible circular locking dependency detected ]
[39993.560208] 2.6.29-rc8-home1 #2
[39993.560210] -------------------------------------------------------
[39993.560212] kmail/5077 is trying to acquire lock:
[39993.560214]  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff811426aa>] 
xfs_ilock+0x27/0x79
[39993.560222]
[39993.560223] but task is already holding lock:
[39993.560225]  (&mm->mmap_sem){----}, at: [<ffffffff81095090>] 
sys_munmap+0x32/0x59
[39993.560230]
[39993.560231] which lock already depends on the new lock.
[39993.560232]
[39993.560233]
[39993.560234] the existing dependency chain (in reverse order) is:
[39993.560236]
[39993.560236] -> #1 (&mm->mmap_sem){----}:
[39993.560240]        [<ffffffff8105b9fc>] __lock_acquire+0x12b0/0x161a
[39993.560244]        [<ffffffff8105bdbb>] lock_acquire+0x55/0x71
[39993.560247]        [<ffffffff813fc2a5>] down_read+0x34/0x41
[39993.560252]        [<ffffffff813ffbfe>] do_page_fault+0x3fa/0x848
[39993.560256]        [<ffffffff813fda2f>] page_fault+0x1f/0x30
[39993.560258]        [<ffffffff8107e13d>] generic_file_aio_read+0x35f/0x5da
[39993.560268]        [<ffffffff811650d8>] xfs_read+0x17d/0x1f5
[39993.560272]        [<ffffffff81161646>] xfs_file_aio_read+0x5f/0x61
[39993.560275]        [<ffffffff810a88ff>] do_sync_read+0xe7/0x12d
[39993.560284]        [<ffffffff810a928c>] vfs_read+0xab/0x134
[39993.560287]        [<ffffffff810a93d9>] sys_read+0x47/0x6f
[39993.560289]        [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
[39993.560293]        [<ffffffffffffffff>] 0xffffffffffffffff
[39993.560302]
[39993.560302] -> #0 (&(&ip->i_iolock)->mr_lock){----}:
[39993.560306]        [<ffffffff8105b6cb>] __lock_acquire+0xf7f/0x161a
[39993.560309]        [<ffffffff8105bdbb>] lock_acquire+0x55/0x71
[39993.560312]        [<ffffffff8104ebde>] down_write_nested+0x37/0x46
[39993.560316]        [<ffffffff811426aa>] xfs_ilock+0x27/0x79
[39993.560318]        [<ffffffff8115b40e>] xfs_inactive+0x14d/0x411
[39993.560322]        [<ffffffff8116552f>] xfs_fs_clear_inode+0x83/0x85
[39993.560325]        [<ffffffff810ba8f7>] clear_inode+0x8a/0xe3
[39993.560329]        [<ffffffff810bb044>] generic_delete_inode+0xf8/0x173
[39993.560332]        [<ffffffff810bb0d6>] generic_drop_inode+0x17/0x1d5
[39993.560335]        [<ffffffff810ba1c7>] iput+0x61/0x65
[39993.560338]        [<ffffffff810b7554>] dentry_iput+0xa9/0xc1
[39993.560341]        [<ffffffff810b7651>] d_kill+0x40/0x60
[39993.560344]        [<ffffffff810b942d>] dput+0x141/0x14e
[39993.560347]        [<ffffffff810a9a85>] __fput+0x173/0x198
[39993.560350]        [<ffffffff810a9ac2>] fput+0x18/0x1a
[39993.560353]        [<ffffffff8109411e>] remove_vma+0x3e/0x63
[39993.560355]        [<ffffffff8109503c>] do_munmap+0x2e9/0x30b
[39993.560358]        [<ffffffff8109509e>] sys_munmap+0x40/0x59
[39993.560361]        [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
[39993.560363]        [<ffffffffffffffff>] 0xffffffffffffffff
[39993.560366]
[39993.560367] other info that might help us debug this:
[39993.560368]
[39993.560370] 1 lock held by kmail/5077:
[39993.560371]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff81095090>] 
sys_munmap+0x32/0x59
[39993.560376]
[39993.560377] stack backtrace:
[39993.560379] Pid: 5077, comm: kmail Not tainted 2.6.29-rc8-home1 #2
[39993.560381] Call Trace:
[39993.560384]  [<ffffffff8105a366>] print_circular_bug_tail+0xc5/0xd0
[39993.560388]  [<ffffffff8105b6cb>] __lock_acquire+0xf7f/0x161a
[39993.560391]  [<ffffffff8105bdbb>] lock_acquire+0x55/0x71
[39993.560393]  [<ffffffff811426aa>] ? xfs_ilock+0x27/0x79
[39993.560396]  [<ffffffff8104ebde>] down_write_nested+0x37/0x46
[39993.560399]  [<ffffffff811426aa>] ? xfs_ilock+0x27/0x79
[39993.560401]  [<ffffffff811426aa>] xfs_ilock+0x27/0x79
[39993.560404]  [<ffffffff8115b40e>] xfs_inactive+0x14d/0x411
[39993.560407]  [<ffffffff8116552f>] xfs_fs_clear_inode+0x83/0x85
[39993.560410]  [<ffffffff810ba8f7>] clear_inode+0x8a/0xe3
[39993.560413]  [<ffffffff810bb044>] generic_delete_inode+0xf8/0x173
[39993.560416]  [<ffffffff810bb0d6>] generic_drop_inode+0x17/0x1d5
[39993.560419]  [<ffffffff810ba1c7>] iput+0x61/0x65
[39993.560421]  [<ffffffff810b7554>] dentry_iput+0xa9/0xc1
[39993.560424]  [<ffffffff810b7651>] d_kill+0x40/0x60
[39993.560427]  [<ffffffff810b942d>] dput+0x141/0x14e
[39993.560429]  [<ffffffff810a9a85>] __fput+0x173/0x198
[39993.560432]  [<ffffffff810a9ac2>] fput+0x18/0x1a
[39993.560434]  [<ffffffff8109411e>] remove_vma+0x3e/0x63
[39993.560437]  [<ffffffff8109503c>] do_munmap+0x2e9/0x30b
[39993.560440]  [<ffffffff8109509e>] sys_munmap+0x40/0x59
[39993.560442]  [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
