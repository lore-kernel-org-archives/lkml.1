Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXFZRw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXFZRw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXFZRwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:52:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:50326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756680AbXFZRwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:52:20 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/2KURgbxr2qeRjcx5KNN2xEg2PjU0zIhHW/Blpss
	cTmWaJSRvE4M1/
Message-ID: <4681524F.9090608@gmx.de>
Date: Tue, 26 Jun 2007 19:52:15 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: held lock freed!
References: <4680EAB8.10703@gmx.de> <Pine.LNX.4.64.0706261557320.30082@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0706261557320.30082@blonde.wat.veritas.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I removed xfs from my system. The first reboot after replacing xfs with
>> ext3 brought be
> 
> Perhaps this is a curse that falls on those who desert XFS ;)

My laptop sometimes 'kicks' his keyboard. That means no key is working
any more, mouse is ok and I can copy and paste single characters in
xterms to enter some commands. Pasting 'reboot' in a root-xterm does not
work.

AFAIR it always happens when a DVB-T recording ends. But, even on daily
recordings, only about once a month. Ingo Molnar told me to activate
CONFIG_PROVE_LOCKING. Since then I had

=============================================
[ INFO: possible recursive locking detected ]
2.6.21.5-cfs-v17 #5
---------------------------------------------
xauth/6510 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<e16e0715>] xfs_ilock+0x47/0x67 [xfs]

but task is already holding lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<e16e0715>] xfs_ilock+0x47/0x67 [xfs]

other info that might help us debug this:
2 locks held by xauth/6510:
 #0:  (&inode->i_mutex){--..}, at: [<c016477c>] open_namei+0xe2/0x555
 #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<e16e0715>]
xfs_ilock+0x47/0x67 [xfs]

stack backtrace:
 [<c0136026>] __lock_acquire+0x11e/0xb23
 [<c0136dd9>] lock_acquire+0x56/0x6e
 [<e16e0715>] xfs_ilock+0x47/0x67 [xfs]
 [<c012fe10>] down_write+0x2e/0x46
 [<e16e0715>] xfs_ilock+0x47/0x67 [xfs]
 [<e16e0715>] xfs_ilock+0x47/0x67 [xfs]
 [<e16e0fa3>] xfs_iget_core+0x291/0x579 [xfs]
 [<e16e1312>] xfs_iget+0x87/0xfd [xfs]
 [<e16f7665>] xfs_trans_iget+0xe6/0x151 [xfs]
 [<e16e4a53>] xfs_ialloc+0xb2/0x479 [xfs]
 [<e16f7fda>] xfs_dir_ialloc+0x7b/0x29d [xfs]
 [<c012fe10>] down_write+0x2e/0x46
 [<e16fda9b>] xfs_create+0x31c/0x5d6 [xfs]
 [<e1707676>] xfs_vn_mknod+0x19b/0x2ce [xfs]
 [<c01621f6>] vfs_create+0xa5/0xeb
 [<c0164811>] open_namei+0x177/0x555
 [<c015a8ab>] get_unused_fd+0x1f/0xb4
 [<c015ab5c>] do_filp_open+0x25/0x39
 [<c02e57da>] _spin_unlock+0x14/0x1c
 [<c015a936>] get_unused_fd+0xaa/0xb4
 [<c015abb2>] do_sys_open+0x42/0xc3
 [<c015ac6c>] sys_open+0x1c/0x1e
 [<c0103bca>] sysenter_past_esp+0x5f/0x99
 =======================

or

=============================================
[ INFO: possible recursive locking detected ]
2.6.21.5-cfs-v17 #5
---------------------------------------------
dotlockfile/6467 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<e15a6715>] xfs_ilock+0x47/0x67 [xfs]

but task is already holding lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<e15a6715>] xfs_ilock+0x47/0x67 [xfs]

other info that might help us debug this:
2 locks held by dotlockfile/6467:
 #0:  (&inode->i_mutex){--..}, at: [<c016477c>] open_namei+0xe2/0x555
 #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<e15a6715>] xfs_ilock+0x47/0x67

stack backtrace:
 [<c0136026>] __lock_acquire+0x11e/0xb23
 [<c0136dd9>] lock_acquire+0x56/0x6e
 [<e15a6715>] xfs_ilock+0x47/0x67 [xfs]
 [<c012fe10>] down_write+0x2e/0x46
 [<e15a6715>] xfs_ilock+0x47/0x67 [xfs]
 [<e15a6715>] xfs_ilock+0x47/0x67 [xfs]
 [<e15a6fa3>] xfs_iget_core+0x291/0x579 [xfs]
 [<e15a7312>] xfs_iget+0x87/0xfd [xfs]
 [<e15bd665>] xfs_trans_iget+0xe6/0x151 [xfs]
 [<e15aaa53>] xfs_ialloc+0xb2/0x479 [xfs]
 [<e15bdfda>] xfs_dir_ialloc+0x7b/0x29d [xfs]
 [<c012fe10>] down_write+0x2e/0x46
 [<e15c3a9b>] xfs_create+0x31c/0x5d6 [xfs]
 [<e15cd676>] xfs_vn_mknod+0x19b/0x2ce [xfs]
 [<c01621f6>] vfs_create+0xa5/0xeb
 [<c0164811>] open_namei+0x177/0x555
 [<c015a8ab>] get_unused_fd+0x1f/0xb4
 [<c015ab5c>] do_filp_open+0x25/0x39
 [<c02e57da>] _spin_unlock+0x14/0x1c
 [<c015a936>] get_unused_fd+0xaa/0xb4
 [<c015abb2>] do_sys_open+0x42/0xc3
 [<c015ac6c>] sys_open+0x1c/0x1e
 [<c0103bca>] sysenter_past_esp+0x5f/0x99
 =======================

in dmesg right after bootup. Ingo said that xfs used to have problems
with lockdep, but that this doesn't mean there's anything wrong with
XFS, but that lockdep turns itself off after it finds the first locking
problem. So I formated the data partition as ext3, which gave me the
formerly posted info.

> Odd.  I can't see any error at the shmem_delete_inode end nor at the
> free_fdtable_rcu end.  It seems to be some kind of corruption, whereby
> free_fdtable_rcu is kfree'ing some memory (perhaps fdt->open_fds),
> but the address kfreed is that of the shmem_sb_info in which it has
> just acquired a spinlock at the top of the stack.

There was a typo in my mail, I'm running 2.6.21.5-cfs-v18, not 2.6.22,
sorry for that.

> It could come about through a single-bit error, and I was going to
> suggest that you give memtest86+ a good run overnight.  And still do
> suggest that, though we seem to have rather too much of a coincidence
> for it to be a likely explanation.  But I've no other ideas, sorry.

I'll run memtest86+ this night and post the results tomorrow.

Please remember to CC me as I'm not subscribed to the list.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german
