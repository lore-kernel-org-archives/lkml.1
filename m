Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZAUW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZAUW5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZAUW5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:57:11 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:52471 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbZAUW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:57:09 -0500
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 17:57:08 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.37,303,1231110000";   d="scan'208";a="97466530"
Date: Wed, 21 Jan 2009 23:27:03 +0100
From: Lars Noschinski <lkml@ml.noschinski.de>
To: linux-kernel@vger.kernel.org
Subject: XFS error & call trace
Message-id: <20090121222703.GA5522@aprove.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I just had a crash of my XFS file system on 2.6.29-rc1 (syslog output
follows) After this, the file system on /home returned -EIO on most (all?)
operations.  After a reboot from cdrom, I found it interesting to see that
xfs_check found no error on this partition. Instead, the XFS on the /
partition had a lot of errors.

Below is the call trace.

Jan 19 10:01:29 vertikal kernel: Pid: 3514, comm: firefox-bin Not tainted 2.6.29-rc1 #5
Jan 19 10:01:29 vertikal kernel: Call Trace:
Jan 19 10:01:29 vertikal kernel:  [<c01f3e0a>] xfs_error_report+0x2c/0x2e
Jan 19 10:01:29 vertikal kernel:  [<c01e863d>] xfs_btree_delrec+0x58a/0xa2c
Jan 19 10:01:29 vertikal kernel:  [<c01e8b06>] ? xfs_btree_delete+0x27/0x70
Jan 19 10:01:29 vertikal kernel:  [<c01e556f>] ? xfs_lookup_get_search_key+0x26/0x39
Jan 19 10:01:29 vertikal kernel:  [<c01e72d3>] ? xfs_btree_lookup+0x145/0x2c0
Jan 19 10:01:29 vertikal kernel:  [<c01e8b06>] xfs_btree_delete+0x27/0x70
Jan 19 10:01:29 vertikal kernel:  [<c01e19a9>] xfs_bmap_del_extent+0x390/0x99b
Jan 19 10:01:29 vertikal kernel:  [<c020ff2d>] ? kmem_zone_alloc+0x4d/0x90
Jan 19 10:01:29 vertikal kernel:  [<c020ff2d>] ? kmem_zone_alloc+0x4d/0x90
Jan 19 10:01:29 vertikal kernel:  [<c01e2965>] xfs_bunmapi+0x882/0xbe8
Jan 19 10:01:29 vertikal kernel:  [<c020b377>] ? xfs_trans_unlock_items+0x3b/0xa3
Jan 19 10:01:29 vertikal kernel:  [<c01fa16c>] xfs_itruncate_finish+0x1a9/0x2c9
Jan 19 10:01:29 vertikal kernel:  [<c020e686>] xfs_inactive+0x1d8/0x3c7
Jan 19 10:01:29 vertikal kernel:  [<c017f7c0>] ? inotify_inode_is_dead+0x71/0x79
Jan 19 10:01:29 vertikal kernel:  [<c0217353>] xfs_fs_clear_inode+0x1f/0x21
Jan 19 10:01:29 vertikal kernel:  [<c016e50c>] clear_inode+0x6f/0xbe
Jan 19 10:01:29 vertikal kernel:  [<c016e9db>] generic_delete_inode+0x76/0xbd
Jan 19 10:01:29 vertikal kernel:  [<c016ea34>] generic_drop_inode+0x12/0x117
Jan 19 10:01:29 vertikal kernel:  [<c016e0b0>] iput+0x4b/0x4e
Jan 19 10:01:29 vertikal kernel:  [<c016893e>] do_unlinkat+0xb9/0xfd
Jan 19 10:01:29 vertikal kernel:  [<c0168992>] sys_unlink+0x10/0x12
Jan 19 10:01:29 vertikal kernel:  [<c0102cee>] syscall_call+0x7/0xb
Jan 19 10:01:29 vertikal kernel: Pid: 3514, comm: firefox-bin Not tainted 2.6.29-rc1 #5
Jan 19 10:01:29 vertikal kernel: Call Trace:
Jan 19 10:01:29 vertikal kernel:  [<c01f3e0a>] xfs_error_report+0x2c/0x2e
Jan 19 10:01:29 vertikal kernel:  [<c02095b0>] xfs_trans_cancel+0x4b/0xd5
Jan 19 10:01:29 vertikal kernel:  [<c020e69e>] ? xfs_inactive+0x1f0/0x3c7
Jan 19 10:01:29 vertikal kernel:  [<c020e69e>] xfs_inactive+0x1f0/0x3c7
Jan 19 10:01:29 vertikal kernel:  [<c017f7c0>] ? inotify_inode_is_dead+0x71/0x79
Jan 19 10:01:29 vertikal kernel:  [<c0217353>] xfs_fs_clear_inode+0x1f/0x21
Jan 19 10:01:29 vertikal kernel:  [<c016e50c>] clear_inode+0x6f/0xbe
Jan 19 10:01:29 vertikal kernel:  [<c016e9db>] generic_delete_inode+0x76/0xbd
Jan 19 10:01:29 vertikal kernel:  [<c016ea34>] generic_drop_inode+0x12/0x117
Jan 19 10:01:29 vertikal kernel:  [<c016e0b0>] iput+0x4b/0x4e
Jan 19 10:01:29 vertikal kernel:  [<c016893e>] do_unlinkat+0xb9/0xfd
Jan 19 10:01:29 vertikal kernel:  [<c0168992>] sys_unlink+0x10/0x12
Jan 19 10:01:29 vertikal kernel:  [<c0102cee>] syscall_call+0x7/0xb
Jan 19 10:01:29 vertikal kernel: xfs_force_shutdown(dm-3,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc02095c6
Jan 19 10:01:51 vertikal kernel: Filesystem "dm-3": xfs_log_force: error 5 returned.
Jan 19 10:02:21 vertikal kernel: Filesystem "dm-3": xfs_log_force: error 5 returned.
Jan 19 10:03:21 vertikal last message repeated 2 times


In addition to this, over the last month, I had a few truncated files
after a reboot (shell history, firefox configuration, mutt's newsrc, ...)
on two occasions; even if I the shutdown was a clean one. Kernel was
2.6.26-git, (a26929fb489188ff959b1715ee67f0c9f84405b5 if I'm not mistaken).
This filesystem is running on top of dm-crypt. Can a volume group not
deactivated on shutdown cause such a failure? (The volume group cannot
be deactivated, because it contains also the root volume).


 - Lars
