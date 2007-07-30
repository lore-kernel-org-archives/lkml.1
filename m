Return-Path: <linux-kernel-owner+w=401wt.eu-S936888AbXG3QLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936888AbXG3QLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbXG3QKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:10:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:54842 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbXG3QKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oYkJO4ECOLxP9MjpQjfuwhgWIKnw28X6Z6c4DskhYN9znHUggZF8hkfPf1qgjQKZI6iyHFDdRz+MZiPWOCIT5V5MKtT1eFPO4hhl3CYm+mH/Y39DzKttXytp77IbOIR91n73xpquBS+gPx+ic+ijej/CVS7UkMISYZE1rbkBXHk=
Message-ID: <1b0b1fc90707300910va417055mb1e64126c1519c9f@mail.gmail.com>
Date: Mon, 30 Jul 2007 12:10:52 -0400
From: "Ryan Bair" <ryandbair@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Repeated XFS corruption -Corruption of in-memory data detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel: 2.6.18-4-amd64 (Debian 2.6.18.dfsg.1-12etch2) Debian Etch
System: Dell PowerEdge 1850
Processor: 3.2 GHz Intel Xeon w/ microcode v1.14a, Hyperthreading disabled.
RAM: 2x1GB ECC DDR-400
RAID Controller: Dell PERC5/E using megaraid driver

I got another unexpected error on my XFS partition today. I was able
to reboot the system normally and the journal recovered on the
following mount. Shortly thereafter, the error occurred again. After
this the filesystem was no longer able to be mounted as the error
would occur immediately.

The volume is on a 9.5TB LVM2 volume on a Dell MD1000 loaded with 15
750GB drives in a RAID5 set. Writeback is disabled. Memtest86+ was run
on this system for 48 hours without fault. The system is otherwise
stable.

XFS was able to repair the damage, but previously the drive returned
to its corrupted state within a few hours of heavy I/O.

Here is the message:
SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, no debug enabled
 SGI XFS Quota Management subsystem
 Filesystem "dm-3": Disabling barriers, not supported by the underlying device
 XFS mounting filesystem dm-3
 Starting XFS recovery on filesystem: dm-3 (logdev: internal)
 XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1561 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff881fa6a7

 Call Trace:
  [<ffffffff881f8db0>] :xfs:xfs_free_ag_extent+0x19f
/0x67f
  [<ffffffff881fa6a7>] :xfs:xfs_free_extent+0xa9/0xc9
  [<ffffffff88236200>] :xfs:xfs_trans_log_efd_extent+0x1c/0x4b
  [<ffffffff8822f355>] :xfs:xlog_recover_finish+0x157/0x241
  [<ffffffff88232dc4>] :xfs:xfs_mountfs+0xa29/0xc35
  [<ffffffff8020bce8>] _atomic_dec_and_lock+0x39/0x57
  [<ffffffff88238b68>] :xfs:xfs_mount+0x762/0x83b
  [<ffffffff8824816b>] :xfs:xfs_fs_fill_super+0x0/0x1e5
  [<ffffffff882481e9>] :xfs:xfs_fs_fill_super+0x7e/0x1e5
  [<ffffffff8025e244>] __down_write_nested+0x12/0x9a
  [<ffffffff802c3941>] get_filesystem+0x12/0x3b
  [<ffffffff802bc95d>] sget+0x383/0x395
  [<ffffffff802bc287>] set_bdev_super+0x0/0xf
  [<ffffffff802bc296>] test_bdev_super+0x0/0xd
  [<ffffffff802bd299>] get_sb_bdev+0xf8/0x152
  [<ffffffff802bcc48>] vfs_kern_mount+0x93/0x11a
  [<ffffffff802bcd11>] do_kern_mount+0x36/0x4d
  [<ffffffff802c52f7>] do_mount+0x68c/0x6ff
  [<ffffffff8022ae6d>] mntput_no_expire+0x19/0x8b
  [<ffffffff8020dd5f>] link_path_walk+0xd3/0xe5
  [<ffffffff8020c5d8>] bit_waitqueue+0x38/0x9b
  [<ffffffff88170033>] :ext3:ext3_delete_inode+0x0/0xd5
  [<ffffffff8023a1ca>] do_unlinkat+0xef/0x148
  [<ffffffff802aaccd>] zone_statistics+0x3e/0x6d
  [<ffffffff802265f0>] vfs_stat_fd+0x1b/0x4a
  [<ffffffff8020de4a>] __alloc_pages+0x5c/0x2a9
  [<ffffffff8023a1ca>] do_unlinkat+0xef/0x148
  [<ffffffff80248310>] sys_mount+0x8a/0xd7
  [<ffffffff802584d6>] system_call+0x7e/0x83

 XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1561 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff881fa6a7

 Call Trace:
  [<ffffffff881f8db0>] :xfs:xfs_free_ag_extent+0x19f/0x67f
  [<ffffffff881fa6a7>] :xfs:xfs_free_extent+0xa9/0xc9
  [<ffffffff88207416>] :xfs:xfs_bmap_finish+0xf0/0x169
  [<ffffffff8822500a>] :xfs:xfs_itruncate_finish+0x172/0x2b3
  [<ffffffff8823e436>] :xfs:xfs_inactive+0x22e/0x823
  [<ffffffff88242563>] :xfs:xfs_buf_read_flags+0x12/0x7f
  [<ffffffff88235ea6>] :xfs:xfs_trans_read_buf+0x4c/0x2c7
  [<ffffffff88247d9c>] :xfs:xfs_fs_clear_inode+0xa5/0xec
  [<ffffffff80220e47>] clear_inode+0xc5/0xf6
  [<ffffffff8022d3ad>] generic_delete_inode+0xde/0x143
  [<ffffffff8822f010>] :xfs:xlog_recover_process_iunlinks+0x1de/0x3cc
  [<ffffffff8822f3d6>] :xfs:xlog_recover_finish+0x1d8/0x241
  [<ffffffff88232dc4>] :xfs:xfs_mountfs+0xa29/0xc35
  [<ffffffff8020bce8>] _atomic_dec_and_lock+0x39/0x57
  [<ffffffff88238b68>] :xfs:xfs_mount+0x762/0x83b
  [<ffffffff8824816b>] :xfs:xfs_fs_fill_super+0x0/0x1e5
  [<ffffffff882481e9>] :xfs:xfs_fs_fill_super+0x7e/0x1e5
  [<ffffffff8025e244>] __down_write_nested+0x12/0x9a
  [<ffffffff802c3941>] get_filesystem+0x12/0x3b
  [<ffffffff802bc95d>] sget+0x383/0x395
  [<ffffffff802bc287>] set_bdev_super+0x0/0xf
  [<ffffffff802bc296>] test_bdev_super+0x0/0xd
  [<ffffffff802bd299>] get_sb_bdev+0xf8/0x152
  [<ffffffff802bcc48>] vfs_kern_mount+0x93/0x11a
  [<ffffffff802bcd11>] do_kern_mount+0x36/0x4d
  [<ffffffff802c52f7>] do_mount+0x68c/0x6ff
  [<ffffffff8022ae6d>] mntput_no_expire+0x19/0x8b
  [<ffffffff8020dd5f>] link_path_walk+0xd3/0xe5
  [<ffffffff8020c5d8>] bit_waitqueue+0x38/0x9b
  [<ffffffff88170033>] :ext3:ext3_delete_inode+0x0/0xd5
  [<ffffffff8023a1ca>] do_unlinkat+0xef/0x148
  [<ffffffff802aaccd>] zone_statistics+0x3e/0x6d
  [<ffffffff802265f0>] vfs_stat_fd+0x1b/0x4a
  [<ffffffff8020de4a>] __alloc_pages+0x5c/0x2a9
  [<ffffffff8023a1ca>] do_unlinkat+0xef/0x148
  [<ffffffff80248310>] sys_mount+0x8a/0xd7
  [<ffffffff802584d6>] system_call+0x7e/0x83

 xfs_force_shutdown(dm-3,0x8) called from line 4267 of file
fs/xfs/xfs_bmap.c.  Return address = 0xffffffff88207453
 Filesystem "dm-3": Corruption of in-memory data detected.  Shutting
down filesystem: dm-3
 Please umount the filesystem, and rectify the problem(s)
 Ending XFS recovery on filesystem: dm-3 (logdev: internal)

Let me know if more information is required.
Please CC me as I am not subscribed to this list.

Thank you
