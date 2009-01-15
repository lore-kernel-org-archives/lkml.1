Return-Path: <linux-kernel-owner+w=401wt.eu-S1763990AbZAOLHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbZAOLHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZAOLGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:06:53 -0500
Received: from sh-spam-4.gradwell.net ([193.84.87.110]:41412 "EHLO
	sh-spam-4.gradwell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431AbZAOLGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:06:51 -0500
Date: Thu, 15 Jan 2009 11:06:44 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27, ext4 and bad USB disks
Message-ID: <20090115110644.377ebc38@lithium.local.net>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a couple of bad disks here which I just tested with ext4 over
USB 2.0. Bad disk errors doesn't appear to be handled gracefully at
all - I had this in the logs:
 
Jan 15 10:06:36 lithium kjournald2 starting.  Commit interval 5 seconds
Jan 15 10:06:36 lithium EXT4 FS on sda1, internal journal
Jan 15 10:06:36 lithium EXT4-fs: delayed allocation enabled
Jan 15 10:06:36 lithium EXT4-fs: file extents enabled
Jan 15 10:06:36 lithium EXT4-fs: mballoc enabled
Jan 15 10:06:36 lithium EXT4-fs: mounted filesystem with ordered data
mode.
Jan 15 10:31:47 lithium end_request: I/O error, dev sda, sector 19626288
Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453282
Jan 15 10:31:47 lithium lost page write due to I/O error on sda1
Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453283
Jan 15 10:31:47 lithium lost page write due to I/O error on sda1
Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453284
Jan 15 10:31:47 lithium lost page write due to I/O error on sda1
Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453285
Jan 15 10:31:47 lithium lost page write due to I/O error on sda1
Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453286
Jan 15 10:31:47 lithium lost page write due to I/O error on sda1
Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453287
Jan 15 10:31:47 lithium lost page write due to I/O error on sda1
...
...
...
...
Jan 15 10:33:40 lithium lost page write due to I/O error on sda1
Jan 15 10:33:40 lithium Buffer I/O error on device sda1, logical block 2453921
Jan 15 10:33:40 lithium lost page write due to I/O error on sda1
Jan 15 10:33:59 lithium INFO: task rsync:31719 blocked for more than 120 seconds.
Jan 15 10:33:59 lithium "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 15 10:33:59 lithium rsync         D f7b9cbb0     0 31719  31718
Jan 15 10:33:59 lithium f7040100 00000086 c200d980 f7b9cbb0 00000000 d736f4b0 d736f610 c2010b80
Jan 15 10:33:59 lithium 00000000 c0176e4a 00001000 0000179f 00000000 c03a3ad6 cb269d6c c2000578
Jan 15 10:33:59 lithium c012eb9b cb204600 cb269d6c c2000578 c33d0160 c01ed1b3 00000000 c3150e70
Jan 15 10:33:59 lithium Call Trace:
Jan 15 10:33:59 lithium [<c0176e4a>] __getblk+0x27/0x253
Jan 15 10:33:59 lithium [<c03a3ad6>] _spin_lock_irqsave+0x11/0x2a
Jan 15 10:33:59 lithium [<c012eb9b>] prepare_to_wait+0x12/0x49
Jan 15 10:33:59 lithium [<c01ed1b3>] do_get_write_access+0x242/0x466
Jan 15 10:33:59 lithium [<c012eabd>] wake_bit_function+0x0/0x3c
Jan 15 10:33:59 lithium [<c01ed3ef>] jbd2_journal_get_write_access+0x18/0x26
Jan 15 10:33:59 lithium [<c01dcf5d>] __ext4_journal_get_write_access+0x13/0x32
Jan 15 10:33:59 lithium [<c01cbc79>] ext4_reserve_inode_write+0x2d/0x5d
Jan 15 10:33:59 lithium [<c01cbcd7>] ext4_mark_inode_dirty+0x2e/0x16e
Jan 15 10:33:59 lithium [<c01cf594>] ext4_dirty_inode+0x50/0x63
Jan 15 10:33:59 lithium [<c0173d1a>] __mark_inode_dirty+0x21/0x13b
Jan 15 10:33:59 lithium [<c016bcdd>] file_update_time+0x88/0xb1
Jan 15 10:33:59 lithium [<c0140fc3>] __generic_file_aio_write_nolock+0x328/0x4ab
Jan 15 10:33:59 lithium [<c0141195>] generic_file_aio_write+0x4f/0xa6
Jan 15 10:33:59 lithium [<c01c9a12>] ext4_file_write+0xa7/0x11d
Jan 15 10:33:59 lithium [<c015b2fb>] do_sync_write+0xbf/0x100
Jan 15 10:33:59 lithium [<c012ea90>] autoremove_wake_function+0x0/0x2d
Jan 15 10:33:59 lithium [<c015b23c>] do_sync_write+0x0/0x100
Jan 15 10:33:59 lithium [<c015b9eb>] vfs_write+0x83/0xf6
Jan 15 10:33:59 lithium [<c015be12>] sys_write+0x3c/0x63
Jan 15 10:33:59 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
Jan 15 10:33:59 lithium =======================
Jan 15 10:34:02 lithium end_request: I/O error, dev sda, sector 19631568
Jan 15 10:34:02 lithium __ratelimit: 20 callbacks suppressed
Jan 15 10:34:02 lithium Buffer I/O error on device sda1, logical block 2453942
Jan 15 10:34:02 lithium lost page write due to I/O error on sda1
Jan 15 10:34:02 lithium Buffer I/O error on device sda1, logical block 2453943
Jan 15 10:34:02 lithium lost page write due to I/O error on sda1
Jan 15 10:34:02 lithium Buffer I/O error on device sda1, logical block 2453944
Jan 15 10:34:02 lithium lost page write due to I/O error on sda1
Jan 15 10:34:02 lithium Buffer I/O error on device sda1, logical block 2453945
Jan 15 10:34:02 lithium lost page write due to I/O error on sda1
...
...
...
Jan 15 10:34:49 lithium end_request: I/O error, dev sda, sector 19633008
Jan 15 10:34:49 lithium __ratelimit: 20 callbacks suppressed
Jan 15 10:34:49 lithium Buffer I/O error on device sda1, logical block
2454122
...
...
...
Jan 15 10:34:51 lithium end_request: I/O error, dev sda, sector 19633248
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 764696
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 764936
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 765176
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 765416
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 765656
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 765896
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 766136
Jan 15 10:34:52 lithium end_request: I/O error, dev sda, sector 766376
Jan 15 10:34:53 lithium JBD2: Detected IO errors while flushing file
data on sda1
...
...
...
Jan 15 10:38:16 lithium end_request: I/O error, dev sda, sector 4960
Jan 15 10:38:16 lithium end_request: I/O error, dev sda, sector 4960
Jan 15 10:38:16 lithium end_request: I/O error, dev sda, sector 4960
Jan 15 10:38:16 lithium end_request: I/O error, dev sda, sector 4960
(goes on like this until...)
Jan 15 10:55:55 lithium end_request: I/O error, dev sda, sector 4960
Jan 15 10:55:55 lithium sd 2:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
Jan 15 10:55:55 lithium end_request: I/O error, dev sda, sector 8705448
Jan 15 10:55:55 lithium Aborting journal on device sda1.
Jan 15 10:55:55 lithium sd 2:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
Jan 15 10:55:55 lithium end_request: I/O error, dev sda, sector 4960
Jan 15 10:55:55 lithium sd 2:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
Jan 15 10:55:55 lithium end_request: I/O error, dev sda, sector 8650784
Jan 15 10:55:55 lithium Buffer I/O error on device sda1, logical block 1081344
Jan 15 10:55:55 lithium lost page write due to I/O error on sda1
Jan 15 10:55:55 lithium JBD2: I/O error detected when updating journal superblock for sda1:8.
Jan 15 10:55:55 lithium usb 1-3.3: USB disconnect, address 6
Jan 15 10:55:55 lithium ext4_abort called.
Jan 15 10:55:55 lithium EXT4-fs error (device sda1): ext4_journal_start_sb: Detected aborted journal
Jan 15 10:55:55 lithium Remounting filesystem read-only
Jan 15 10:55:55 lithium EXT4-fs error (device sda1) in ext4_da_writepages: IO failure
Jan 15 10:55:55 lithium ext4_da_writepages: jbd2_start: 63307 pages, ino 86552; err -30
Jan 15 10:55:55 lithium Pid: 2126, comm: sync Tainted: P          2.6.27-gentoo-r7 #1
Jan 15 10:55:55 lithium [<c01cfddd>] ext4_da_writepages+0x118/0x2c7
Jan 15 10:55:55 lithium [<c011675c>] __wake_up+0x29/0x39
Jan 15 10:55:55 lithium [<c01cfddd>] ext4_da_writepages+0x118/0x2c7
Jan 15 10:55:55 lithium [<c011675c>] __wake_up+0x29/0x39
Jan 15 10:55:55 lithium [<c01ce910>] ext4_da_get_block_write+0x0/0x14a
Jan 15 10:55:55 lithium [<c01cfcc5>] ext4_da_writepages+0x0/0x2c7
Jan 15 10:55:55 lithium [<c0145236>] do_writepages+0x20/0x30
Jan 15 10:55:55 lithium [<c0173624>] __writeback_single_inode+0x12d/0x257
Jan 15 10:55:55 lithium [<c012eabd>] wake_bit_function+0x0/0x3c
Jan 15 10:55:55 lithium [<c0173a5b>] generic_sync_sb_inodes+0x189/0x254
Jan 15 10:55:55 lithium [<c0173bad>] sync_inodes_sb+0x82/0x8a
Jan 15 10:55:55 lithium [<c0173bff>] __sync_inodes+0x4a/0x8e
Jan 15 10:55:55 lithium [<c0175fd9>] do_sync+0x35/0x55
Jan 15 10:55:55 lithium [<c0176003>] sys_sync+0xa/0xf
Jan 15 10:55:55 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
Jan 15 10:55:55 lithium [<c03a0000>] check_tsc_warp+0xa7/0x167
Jan 15 10:55:55 lithium =======================
Jan 15 10:55:55 lithium Buffer I/O error on device sda1, logical block 6047
Jan 15 10:55:55 lithium lost page write due to I/O error on sda1
Jan 15 10:55:55 lithium ext4_da_writepages: jbd2_start: 183649 pages, ino 86552; err -30
Jan 15 10:55:55 lithium Pid: 2730, comm: umount Tainted: P          2.6.27-gentoo-r7 #1
Jan 15 10:55:55 lithium [<c01cfddd>] ext4_da_writepages+0x118/0x2c7
Jan 15 10:55:55 lithium [<c0169304>] dput+0x16/0xf3
Jan 15 10:55:55 lithium [<c01617eb>] __follow_mount+0x1e/0x60
Jan 15 10:55:55 lithium [<c0161940>] do_lookup+0x53/0x153
Jan 15 10:55:55 lithium [<c0115d72>] update_curr+0x41/0x65
Jan 15 10:55:55 lithium [<c0116848>] __dequeue_entity+0x1f/0x71
Jan 15 10:55:55 lithium [<c01cfcc5>] ext4_da_writepages+0x0/0x2c7
Jan 15 10:55:55 lithium [<c0145236>] do_writepages+0x20/0x30
Jan 15 10:55:55 lithium [<c0173624>] __writeback_single_inode+0x12d/0x257
Jan 15 10:55:55 lithium [<c03a3d91>] _spin_unlock_irq+0xd/0x20
Jan 15 10:55:55 lithium [<c0119910>] finish_task_switch+0x1f/0x69
Jan 15 10:55:55 lithium [<c03a2352>] schedule+0x5f6/0x60f
Jan 15 10:55:55 lithium [<c0173a5b>] generic_sync_sb_inodes+0x189/0x254
Jan 15 10:55:55 lithium [<c0173bad>] sync_inodes_sb+0x82/0x8a
Jan 15 10:55:55 lithium [<c015ca85>] __fsync_super+0xa/0x61
Jan 15 10:55:55 lithium [<c015cae4>] fsync_super+0x8/0x14
Jan 15 10:55:55 lithium [<c015cd23>] generic_shutdown_super+0x19/0xcb
Jan 15 10:55:55 lithium [<c0185f72>] vfs_quota_off+0x0/0x53d
Jan 15 10:55:55 lithium [<c015cde1>] kill_block_super+0xc/0x1b
Jan 15 10:55:55 lithium [<c015ce85>] deactivate_super+0x4e/0x63
Jan 15 10:55:55 lithium [<c016e108>] sys_umount+0x26a/0x2ac
Jan 15 10:55:55 lithium [<c016e155>] sys_oldumount+0xb/0xe
Jan 15 10:55:55 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
Jan 15 10:55:55 lithium [<c016e155>] sys_oldumount+0xb/0xe
Jan 15 10:55:55 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
Jan 15 10:55:55 lithium =======================
Jan 15 10:55:55 lithium ext4_da_writepages: jbd2_start: 183649 pages, ino 86552; err -30
Jan 15 10:55:55 lithium Pid: 2730, comm: umount Tainted: P          2.6.27-gentoo-r7 #1
Jan 15 10:55:55 lithium [<c01cfddd>] ext4_da_writepages+0x118/0x2c7
Jan 15 10:55:55 lithium [<c0145196>] write_cache_pages+0x231/0x290
Jan 15 10:55:55 lithium [<c0144bbd>] __writepage+0x0/0x1f
Jan 15 10:55:55 lithium [<c013f97e>] find_get_pages_tag+0x3f/0xf6
Jan 15 10:55:55 lithium [<c013f9f8>] find_get_pages_tag+0xb9/0xf6
Jan 15 10:55:55 lithium [<c01cfcc5>] ext4_da_writepages+0x0/0x2c7
Jan 15 10:55:55 lithium [<c0145236>] do_writepages+0x20/0x30
Jan 15 10:55:55 lithium [<c0173624>] __writeback_single_inode+0x12d/0x257
Jan 15 10:55:55 lithium [<c0140214>] wait_on_page_writeback_range+0xa9/0xf4
Jan 15 10:55:55 lithium [<c0173a5b>] generic_sync_sb_inodes+0x189/0x254
Jan 15 10:55:55 lithium [<c0173bad>] sync_inodes_sb+0x82/0x8a
Jan 15 10:55:55 lithium [<c015cae4>] fsync_super+0x8/0x14
Jan 15 10:55:55 lithium [<c015cd23>] generic_shutdown_super+0x19/0xcb
Jan 15 10:55:55 lithium [<c0185f72>] vfs_quota_off+0x0/0x53d
Jan 15 10:55:55 lithium [<c015cde1>] kill_block_super+0xc/0x1b
Jan 15 10:55:55 lithium [<c015ce85>] deactivate_super+0x4e/0x63
Jan 15 10:55:55 lithium [<c016e108>] sys_umount+0x26a/0x2ac
Jan 15 10:55:55 lithium [<c016e155>] sys_oldumount+0xb/0xe
Jan 15 10:55:55 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
Jan 15 10:55:55 lithium =======================
Jan 15 10:55:55 lithium EXT4-fs: mballoc: 1511988 blocks 35061 reqs (32032 success)
Jan 15 10:55:55 lithium EXT4-fs: mballoc: 7877 extents scanned, 858 goal hits, 1554 2^N hits, 18 breaks, 0 lost
Jan 15 10:55:55 lithium EXT4-fs: mballoc: 167 generated and it took 8987964
Jan 15 10:55:55 lithium EXT4-fs: mballoc: 859428 preallocated, 332130 discarded
Jan 15 10:55:55 lithium Buffer I/O error on device sda1, logical block 1081344
Jan 15 10:55:55 lithium lost page write due to I/O error on sda1
Jan 15 10:55:55 lithium JBD2: I/O error detected when updating journal
superblock for sda1:8.

Any thoughts? 
-- 
http://www.munted.org.uk

Fearsome grindings.
