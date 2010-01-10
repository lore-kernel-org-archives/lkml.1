Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001Ab0AJVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0AJVsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989Ab0AJVsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:48:17 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:56992 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab0AJVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:48:13 -0500
Date: Sun, 10 Jan 2010 16:47:03 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: 2.6.33RC3 hung task - jbd2/dm-1-8 (during raid rebuild)
To: linux-kernel@vger.kernel.org
Message-id: <4B4A4AD7.5090800@majjas.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_pc+hXSdyrItzbA9rQ7FMSA)"
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5)
 Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_pc+hXSdyrItzbA9rQ7FMSA)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

System crashed (watchdog reset).

Was doing a raid rebuild at the time (raid6).

I typed, 'yumdownloader --source virtlib' ... system froze, then 
rebooted on the watchdog reset.

I've attached the log extract from the event as well as dmesg.



--Boundary_(ID_pc+hXSdyrItzbA9rQ7FMSA)
Content-type: text/plain; name=messages
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=messages

Jan 10 16:17:26 mail radvd[3008]: resetting ipv6-allrouters membership on eth0
Jan 10 16:18:06 mail radvd[3008]: resetting ipv6-allrouters membership on eth0
Jan 10 16:18:55 mail radvd[3008]: resetting ipv6-allrouters membership on eth0
Jan 10 16:19:43 mail kernel: INFO: task jbd2/dm-1-8:1339 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: jbd2/dm-1-8   D ffff8800282af9a8     0  1339      2 0x00000000
Jan 10 16:19:43 mail kernel: ffff88032dc5db20 0000000000000046 0000000000000000 ffffffff8137d189
Jan 10 16:19:43 mail kernel: ffff88032dc5da90 ffffffff8145566b ffff88032dc5da90 ffff88032dc5dfd8
Jan 10 16:19:43 mail kernel: ffff88032dc5dfd8 ffff88032ce19b30 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff8137d189>] ? dm_table_unplug_all+0x58/0xc7
Jan 10 16:19:43 mail kernel: [<ffffffff8145566b>] ? _raw_read_lock_irqsave+0x28/0x41
Jan 10 16:19:43 mail kernel: [<ffffffff810c0397>] ? sync_page+0x0/0x4a
Jan 10 16:19:43 mail kernel: [<ffffffff810c0397>] ? sync_page+0x0/0x4a
Jan 10 16:19:43 mail kernel: [<ffffffff81453d51>] io_schedule+0x43/0x5d
Jan 10 16:19:43 mail kernel: [<ffffffff810c03dd>] sync_page+0x46/0x4a
Jan 10 16:19:43 mail kernel: [<ffffffff814542b0>] __wait_on_bit+0x48/0x7b
Jan 10 16:19:43 mail kernel: [<ffffffff810c05af>] wait_on_page_bit+0x72/0x79
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff810c8469>] ? pagevec_lookup_tag+0x25/0x2e
Jan 10 16:19:43 mail kernel: [<ffffffff810c0e50>] filemap_fdatawait_range+0xa4/0x165
Jan 10 16:19:43 mail kernel: [<ffffffff8123b3e2>] ? submit_bio+0xd2/0xef
Jan 10 16:19:43 mail kernel: [<ffffffff810c0f32>] filemap_fdatawait+0x21/0x23
Jan 10 16:19:43 mail kernel: [<ffffffff811a5d84>] jbd2_journal_commit_transaction+0xa79/0x141d
Jan 10 16:19:43 mail kernel: [<ffffffff81057828>] ? spin_unlock_irqrestore+0xe/0x10
Jan 10 16:19:43 mail kernel: [<ffffffff810578ef>] ? try_to_del_timer_sync+0x73/0x81
Jan 10 16:19:43 mail kernel: [<ffffffff811ab80d>] kjournald2+0x139/0x359
Jan 10 16:19:43 mail kernel: [<ffffffff81065053>] ? autoremove_wake_function+0x0/0x39
Jan 10 16:19:43 mail kernel: [<ffffffff811ab6d4>] ? kjournald2+0x0/0x359
Jan 10 16:19:43 mail kernel: [<ffffffff81064bd9>] kthread+0x7f/0x87
Jan 10 16:19:43 mail kernel: [<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
Jan 10 16:19:43 mail kernel: [<ffffffff81455afd>] ? restore_args+0x0/0x30
Jan 10 16:19:43 mail kernel: [<ffffffff81064b5a>] ? kthread+0x0/0x87
Jan 10 16:19:43 mail kernel: [<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10
Jan 10 16:19:43 mail kernel: INFO: task flush-253:1:1405 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: flush-253:1   D ffff88002820f9a8     0  1405      2 0x00000000
Jan 10 16:19:43 mail kernel: ffff88032ebb9690 0000000000000046 0000000000000000 ffff88032a250930
Jan 10 16:19:43 mail kernel: 0000000000000000 ffff88032cdf6000 000000032ebb9610 ffff88032ebb9fd8
Jan 10 16:19:43 mail kernel: ffff88032ebb9fd8 ffff88032b3be1b0 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff8119452b>] ext4_mb_mark_diskspace_used+0xa9/0x2b8
Jan 10 16:19:43 mail kernel: [<ffffffff811980cc>] ext4_mb_new_blocks+0x1e8/0x3d8
Jan 10 16:19:43 mail kernel: [<ffffffff8118eb69>] ? ext4_ext_find_extent+0x125/0x274
Jan 10 16:19:43 mail kernel: [<ffffffff81190e38>] ext4_ext_get_blocks+0x12f3/0x1553
Jan 10 16:19:43 mail kernel: [<ffffffff81250b2b>] ? __lookup_tag+0x6d/0x12d
Jan 10 16:19:43 mail kernel: [<ffffffff81251c03>] ? spin_unlock_irqrestore+0x9/0xb
Jan 10 16:19:43 mail kernel: [<ffffffff81173ec7>] ext4_get_blocks+0x120/0x33d
Jan 10 16:19:43 mail kernel: [<ffffffff810c8469>] ? pagevec_lookup_tag+0x25/0x2e
Jan 10 16:19:43 mail kernel: [<ffffffff81174551>] mpage_da_map_blocks+0x9e/0x31c
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f1e>] ? jbd2_journal_start+0x61/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f59>] ? jbd2_journal_start+0x9c/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff81174afb>] ext4_da_writepages+0x32c/0x525
Jan 10 16:19:43 mail kernel: [<ffffffff8103f4f7>] ? find_busiest_group+0x3be/0x7e4
Jan 10 16:19:43 mail kernel: [<ffffffff810c7115>] do_writepages+0x21/0x2a
Jan 10 16:19:43 mail kernel: [<ffffffff8111b62f>] writeback_single_inode+0xed/0x2e6
Jan 10 16:19:43 mail kernel: [<ffffffff8111beda>] writeback_inodes_wb+0x386/0x463
Jan 10 16:19:43 mail kernel: [<ffffffff8111c0e7>] wb_writeback+0x130/0x1ae
Jan 10 16:19:43 mail kernel: [<ffffffff8111c350>] wb_do_writeback+0x13c/0x152
Jan 10 16:19:43 mail kernel: [<ffffffff8111c3a5>] bdi_writeback_task+0x3f/0xaf
Jan 10 16:19:43 mail kernel: [<ffffffff810d4df1>] ? bdi_start_fn+0x0/0xc3
Jan 10 16:19:43 mail kernel: [<ffffffff810d4e54>] bdi_start_fn+0x63/0xc3
Jan 10 16:19:43 mail kernel: [<ffffffff810d4df1>] ? bdi_start_fn+0x0/0xc3
Jan 10 16:19:43 mail kernel: [<ffffffff81064bd9>] kthread+0x7f/0x87
Jan 10 16:19:43 mail kernel: [<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
Jan 10 16:19:43 mail kernel: [<ffffffff81455afd>] ? restore_args+0x0/0x30
Jan 10 16:19:43 mail kernel: [<ffffffff81064b5a>] ? kthread+0x0/0x87
Jan 10 16:19:43 mail kernel: [<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10
Jan 10 16:19:43 mail kernel: INFO: task auditd:2216 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: auditd        D ffff8802ba801380     0  2216      1 0x00000000
Jan 10 16:19:43 mail kernel: ffff88032011f868 0000000000000086 000000002011f7e8 ffff8802bd2d7440
Jan 10 16:19:43 mail kernel: 0000000000000000 0000000000000001 000000032a2dc6b0 ffff88032011ffd8
Jan 10 16:19:43 mail kernel: ffff88032011ffd8 ffff88032fd2e1b0 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff810650cd>] ? spin_unlock_irqrestore+0xe/0x10
Jan 10 16:19:43 mail kernel: [<ffffffff810652c3>] ? prepare_to_wait+0x76/0x81
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff8119452b>] ext4_mb_mark_diskspace_used+0xa9/0x2b8
Jan 10 16:19:43 mail kernel: [<ffffffff811980cc>] ext4_mb_new_blocks+0x1e8/0x3d8
Jan 10 16:19:43 mail kernel: [<ffffffff8118eb69>] ? ext4_ext_find_extent+0x125/0x274
Jan 10 16:19:43 mail kernel: [<ffffffff81190e38>] ext4_ext_get_blocks+0x12f3/0x1553
Jan 10 16:19:43 mail kernel: [<ffffffff81250b2b>] ? __lookup_tag+0x6d/0x12d
Jan 10 16:19:43 mail kernel: [<ffffffff81251c03>] ? spin_unlock_irqrestore+0x9/0xb
Jan 10 16:19:43 mail kernel: [<ffffffff81173ec7>] ext4_get_blocks+0x120/0x33d
Jan 10 16:19:43 mail kernel: [<ffffffff810c8469>] ? pagevec_lookup_tag+0x25/0x2e
Jan 10 16:19:43 mail kernel: [<ffffffff81174551>] mpage_da_map_blocks+0x9e/0x31c
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f1e>] ? jbd2_journal_start+0x61/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f59>] ? jbd2_journal_start+0x9c/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff81174afb>] ext4_da_writepages+0x32c/0x525
Jan 10 16:19:43 mail kernel: [<ffffffff812143b2>] ? superblock_has_perm+0x29/0x2b
Jan 10 16:19:43 mail kernel: [<ffffffff810c7115>] do_writepages+0x21/0x2a
Jan 10 16:19:43 mail kernel: [<ffffffff810c0f84>] __filemap_fdatawrite_range+0x50/0x52
Jan 10 16:19:43 mail kernel: [<ffffffff810c0fb3>] filemap_write_and_wait_range+0x2d/0x56
Jan 10 16:19:43 mail kernel: [<ffffffff8111f616>] vfs_fsync_range+0x5f/0xb2
Jan 10 16:19:43 mail kernel: [<ffffffff8111f6e0>] vfs_fsync+0x1d/0x1f
Jan 10 16:19:43 mail kernel: [<ffffffff8111f716>] do_fsync+0x34/0x49
Jan 10 16:19:43 mail kernel: [<ffffffff8111f752>] sys_fsync+0x10/0x14
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task rsyslogd:9495 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: rsyslogd      D ffff88002820f9a8     0  9495      1 0x00000080
Jan 10 16:19:43 mail kernel: ffff8802b590fa48 0000000000000082 0000000000000000 ffffffff810c01b9
Jan 10 16:19:43 mail kernel: ffff8802b590f9c8 ffffea000af8a630 ffff8802b590fa18 ffff8802b590ffd8
Jan 10 16:19:43 mail kernel: ffff8802b590ffd8 ffff8802bce132b0 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff810c01b9>] ? find_get_page+0x55/0x80
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff81171a7d>] ext4_reserve_inode_write+0x3c/0x7c
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f1e>] ? jbd2_journal_start+0x61/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff81171afb>] ext4_mark_inode_dirty+0x3e/0x18e
Jan 10 16:19:43 mail kernel: [<ffffffff81171d67>] ext4_dirty_inode+0x2f/0x43
Jan 10 16:19:43 mail kernel: [<ffffffff8111b9f7>] __mark_inode_dirty+0x34/0x15c
Jan 10 16:19:43 mail kernel: [<ffffffff811126ce>] file_update_time+0xfc/0x120
Jan 10 16:19:43 mail kernel: [<ffffffff810c12ad>] __generic_file_aio_write+0x164/0x281
Jan 10 16:19:43 mail kernel: [<ffffffff810c1427>] generic_file_aio_write+0x5d/0xa9
Jan 10 16:19:43 mail kernel: [<ffffffff8116e115>] ext4_file_write+0x8e/0x95
Jan 10 16:19:43 mail kernel: [<ffffffff8121566a>] ? file_has_perm+0xa4/0xc6
Jan 10 16:19:43 mail kernel: [<ffffffff81100789>] do_sync_write+0xc4/0x101
Jan 10 16:19:43 mail kernel: [<ffffffff81217bcf>] ? selinux_file_permission+0xa7/0xb3
Jan 10 16:19:43 mail kernel: [<ffffffff8120df41>] ? security_file_permission+0x16/0x18
Jan 10 16:19:43 mail kernel: [<ffffffff81100d05>] vfs_write+0xae/0x10b
Jan 10 16:19:43 mail kernel: [<ffffffff81100e22>] sys_write+0x4a/0x6e
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task ns-slapd:2536 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: ns-slapd      D ffff88002826f9a8     0  2536      1 0x00000080
Jan 10 16:19:43 mail kernel: ffff88031fdc1cc8 0000000000000086 0000000000000000 ffffffff8137d189
Jan 10 16:19:43 mail kernel: ffff88031fdc1c38 ffffffff8145566b ffff88031fdc1c38 ffff88031fdc1fd8
Jan 10 16:19:43 mail kernel: ffff88031fdc1fd8 ffff88031fe983b0 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff8137d189>] ? dm_table_unplug_all+0x58/0xc7
Jan 10 16:19:43 mail kernel: [<ffffffff8145566b>] ? _raw_read_lock_irqsave+0x28/0x41
Jan 10 16:19:43 mail kernel: [<ffffffff810c0397>] ? sync_page+0x0/0x4a
Jan 10 16:19:43 mail kernel: [<ffffffff810c0397>] ? sync_page+0x0/0x4a
Jan 10 16:19:43 mail kernel: [<ffffffff81453d51>] io_schedule+0x43/0x5d
Jan 10 16:19:43 mail kernel: [<ffffffff810c03dd>] sync_page+0x46/0x4a
Jan 10 16:19:43 mail kernel: [<ffffffff814542b0>] __wait_on_bit+0x48/0x7b
Jan 10 16:19:43 mail kernel: [<ffffffff810c05af>] wait_on_page_bit+0x72/0x79
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff810c8469>] ? pagevec_lookup_tag+0x25/0x2e
Jan 10 16:19:43 mail kernel: [<ffffffff810c0e50>] filemap_fdatawait_range+0xa4/0x165
Jan 10 16:19:43 mail kernel: [<ffffffff810c7115>] ? do_writepages+0x21/0x2a
Jan 10 16:19:43 mail kernel: [<ffffffff810c0f84>] ? __filemap_fdatawrite_range+0x50/0x52
Jan 10 16:19:43 mail kernel: [<ffffffff810c0fc9>] filemap_write_and_wait_range+0x43/0x56
Jan 10 16:19:43 mail kernel: [<ffffffff8111f616>] vfs_fsync_range+0x5f/0xb2
Jan 10 16:19:43 mail kernel: [<ffffffff8111f6e0>] vfs_fsync+0x1d/0x1f
Jan 10 16:19:43 mail kernel: [<ffffffff8111f716>] do_fsync+0x34/0x49
Jan 10 16:19:43 mail kernel: [<ffffffff8111f73e>] sys_fdatasync+0x13/0x17
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task psad:3854 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: psad          D ffff88002822f9a8     0  3854      1 0x00000080
Jan 10 16:19:43 mail kernel: ffff8802ec083a48 0000000000000086 0000000000000000 0000000000000292
Jan 10 16:19:43 mail kernel: ffff8802ec083998 ffffffff810650cd ffff8802ec0839b8 ffff8802ec083fd8
Jan 10 16:19:43 mail kernel: ffff8802ec083fd8 ffff88032fe7ca30 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff810650cd>] ? spin_unlock_irqrestore+0xe/0x10
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff81171a7d>] ext4_reserve_inode_write+0x3c/0x7c
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f1e>] ? jbd2_journal_start+0x61/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff81171afb>] ext4_mark_inode_dirty+0x3e/0x18e
Jan 10 16:19:43 mail kernel: [<ffffffff81171d67>] ext4_dirty_inode+0x2f/0x43
Jan 10 16:19:43 mail kernel: [<ffffffff8111b9f7>] __mark_inode_dirty+0x34/0x15c
Jan 10 16:19:43 mail kernel: [<ffffffff811126ce>] file_update_time+0xfc/0x120
Jan 10 16:19:43 mail kernel: [<ffffffff810c12ad>] __generic_file_aio_write+0x164/0x281
Jan 10 16:19:43 mail kernel: [<ffffffff8121556b>] ? inode_has_perm+0x7a/0x90
Jan 10 16:19:43 mail kernel: [<ffffffff810c1427>] generic_file_aio_write+0x5d/0xa9
Jan 10 16:19:43 mail kernel: [<ffffffff8116e115>] ext4_file_write+0x8e/0x95
Jan 10 16:19:43 mail kernel: [<ffffffff81100789>] do_sync_write+0xc4/0x101
Jan 10 16:19:43 mail kernel: [<ffffffff81217b84>] ? selinux_file_permission+0x5c/0xb3
Jan 10 16:19:43 mail kernel: [<ffffffff8120df41>] ? security_file_permission+0x16/0x18
Jan 10 16:19:43 mail kernel: [<ffffffff81100d05>] vfs_write+0xae/0x10b
Jan 10 16:19:43 mail kernel: [<ffffffff81100e22>] sys_write+0x4a/0x6e
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task postmaster:5454 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: postmaster    D ffff88002820f9a8     0  5454   5444 0x00000080
Jan 10 16:19:43 mail kernel: ffff8803309d3b28 0000000000000086 ffff8803309d3af0 ffff8803309d3aec
Jan 10 16:19:43 mail kernel: ffff8803309d3b88 0000000000000000 0000000000000400 ffff8803309d3fd8
Jan 10 16:19:43 mail kernel: ffff8803309d3fd8 ffff8802ec1283b0 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff8116f4a8>] ext4_new_inode+0x4cd/0xd07
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f59>] ? jbd2_journal_start+0x9c/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff8117a14e>] ext4_create+0xc8/0x158
Jan 10 16:19:43 mail kernel: [<ffffffff8110a251>] vfs_create+0x78/0x9a
Jan 10 16:19:43 mail kernel: [<ffffffff8110bcf1>] do_filp_open+0x34d/0xd57
Jan 10 16:19:43 mail kernel: [<ffffffff810f239d>] ? get_partial_node+0x22/0x84
Jan 10 16:19:43 mail kernel: [<ffffffff810f4937>] ? __slab_alloc+0xd0/0x3b2
Jan 10 16:19:43 mail kernel: [<ffffffff8125608a>] ? __strncpy_from_user+0x1e/0x49
Jan 10 16:19:43 mail kernel: [<ffffffff81114e4b>] ? alloc_fd+0x7b/0x123
Jan 10 16:19:43 mail kernel: [<ffffffff810fee76>] do_sys_open+0x63/0x10f
Jan 10 16:19:43 mail kernel: [<ffffffff810fef55>] sys_open+0x20/0x22
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task sendmail:11757 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: sendmail      D ffff88002824f9a8     0 11757   3595 0x00000080
Jan 10 16:19:43 mail kernel: ffff88031c33fc88 0000000000000082 0000000000000000 a24eea6ee2784733
Jan 10 16:19:43 mail kernel: ffff88031c33fbf8 ffff88031c33fcc8 ffff88031c33fc48 ffff88031c33ffd8
Jan 10 16:19:43 mail kernel: ffff88031c33ffd8 ffff8802b5991b30 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff8117a7d8>] ext4_orphan_add+0x85/0x21b
Jan 10 16:19:43 mail kernel: [<ffffffff8117b35b>] ext4_unlink+0x18d/0x1e3
Jan 10 16:19:43 mail kernel: [<ffffffff8110a40d>] vfs_unlink+0x7a/0xb5
Jan 10 16:19:43 mail kernel: [<ffffffff81108dcb>] ? lookup_hash+0x36/0x3a
Jan 10 16:19:43 mail kernel: [<ffffffff8110b1b3>] do_unlinkat+0xcd/0x15b
Jan 10 16:19:43 mail kernel: [<ffffffff81101ce5>] ? __fput+0x1b2/0x1c1
Jan 10 16:19:43 mail kernel: [<ffffffff810913a3>] ? audit_syscall_entry+0x11e/0x14a
Jan 10 16:19:43 mail kernel: [<ffffffff81455396>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Jan 10 16:19:43 mail kernel: [<ffffffff8110b257>] sys_unlink+0x16/0x18
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task postmaster:11896 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: postmaster    D ffff8800282af9a8     0 11896   5444 0x00000080
Jan 10 16:19:43 mail kernel: ffff8802ab0a1d28 0000000000000082 0000000000000000 ffffffff81039067
Jan 10 16:19:43 mail kernel: ffff8802ab0a1ca8 0000000000000000 ffffe8ff00000001 ffff8802ab0a1fd8
Jan 10 16:19:43 mail kernel: ffff8802ab0a1fd8 ffff88032deb32b0 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff81039067>] ? __wake_up+0x44/0x4d
Jan 10 16:19:43 mail kernel: [<ffffffff81454053>] schedule_timeout+0x36/0xe3
Jan 10 16:19:43 mail kernel: [<ffffffff8123b2b7>] ? generic_make_request+0x23b/0x294
Jan 10 16:19:43 mail kernel: [<ffffffff81453ebd>] wait_for_common+0xcc/0x13a
Jan 10 16:19:43 mail kernel: [<ffffffff81043858>] ? default_wake_function+0x0/0x14
Jan 10 16:19:43 mail kernel: [<ffffffff8123b3e2>] ? submit_bio+0xd2/0xef
Jan 10 16:19:43 mail kernel: [<ffffffff81453fce>] wait_for_completion+0x1d/0x1f
Jan 10 16:19:43 mail kernel: [<ffffffff8123ebde>] blkdev_issue_flush+0x82/0xc3
Jan 10 16:19:43 mail kernel: [<ffffffff8116e2d7>] ext4_sync_file+0x1bb/0x1ec
Jan 10 16:19:43 mail kernel: [<ffffffff8111f639>] vfs_fsync_range+0x82/0xb2
Jan 10 16:19:43 mail kernel: [<ffffffff8111f6e0>] vfs_fsync+0x1d/0x1f
Jan 10 16:19:43 mail kernel: [<ffffffff8111f716>] do_fsync+0x34/0x49
Jan 10 16:19:43 mail kernel: [<ffffffff8111f73e>] sys_fdatasync+0x13/0x17
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 10 16:19:43 mail kernel: INFO: task nmbd:11904 blocked for more than 120 seconds.
Jan 10 16:19:43 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 10 16:19:43 mail kernel: nmbd          D ffff8800282cf9a8     0 11904   3744 0x00000080
Jan 10 16:19:43 mail kernel: ffff8802d7a2fb28 0000000000000082 0000000000000000 000000000000d945
Jan 10 16:19:43 mail kernel: 0000000000000000 ffff88031f9a7c40 ffff8802d7a2fb08 ffff8802d7a2ffd8
Jan 10 16:19:43 mail kernel: ffff8802d7a2ffd8 ffff8802b5889b30 000000000000f9a8 00000000000157c0
Jan 10 16:19:43 mail kernel: Call Trace:
Jan 10 16:19:43 mail kernel: [<ffffffff811a42af>] do_get_write_access+0x223/0x411
Jan 10 16:19:43 mail kernel: [<ffffffff8106508c>] ? wake_bit_function+0x0/0x33
Jan 10 16:19:43 mail kernel: [<ffffffff811aa8f3>] ? jbd2_journal_add_journal_head+0x106/0x17c
Jan 10 16:19:43 mail kernel: [<ffffffff811a44c8>] jbd2_journal_get_write_access+0x2b/0x40
Jan 10 16:19:43 mail kernel: [<ffffffff81191b67>] __ext4_journal_get_write_access+0x55/0x5f
Jan 10 16:19:43 mail kernel: [<ffffffff8116f48c>] ext4_new_inode+0x4b1/0xd07
Jan 10 16:19:43 mail kernel: [<ffffffff811a4f59>] ? jbd2_journal_start+0x9c/0xcd
Jan 10 16:19:43 mail kernel: [<ffffffff8117a14e>] ext4_create+0xc8/0x158
Jan 10 16:19:43 mail kernel: [<ffffffff8110a251>] vfs_create+0x78/0x9a
Jan 10 16:19:43 mail kernel: [<ffffffff8110bcf1>] do_filp_open+0x34d/0xd57
Jan 10 16:19:43 mail kernel: [<ffffffff8125608a>] ? __strncpy_from_user+0x1e/0x49
Jan 10 16:19:43 mail kernel: [<ffffffff81114e4b>] ? alloc_fd+0x7b/0x123
Jan 10 16:19:43 mail kernel: [<ffffffff810fee76>] do_sys_open+0x63/0x10f
Jan 10 16:19:43 mail kernel: [<ffffffff810fef55>] sys_open+0x20/0x22
Jan 10 16:19:43 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b

--Boundary_(ID_pc+hXSdyrItzbA9rQ7FMSA)
Content-type: text/plain; name=dmesg.old
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=dmesg.old

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty (mbreuer@mail.majjas.com) (gcc version 4.4.2 20091222 (Red Hat 4.4.2-20) (GCC) ) #1 SMP Sat Jan 9 16:15:20 EST 2010
Command line: ro root=/dev/mapper/vg_00-LogVol02_root usbcore.autosuspend=1 crashkernel=128M SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us pcie_aspm=force intel_iommu=igfx_off 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4c00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
 BIOS-e820: 00000000bf780000 - 00000000bf798000 (ACPI data)
 BIOS-e820: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
 BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
No AGP bridge found
last_pfn = 0x340000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E3FFF write-protect
  E4000-EBFFF write-through
  EC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask E00000000 write-back
  1 base 200000000 mask F00000000 write-back
  2 base 300000000 mask FC0000000 write-back
  3 base 0C0000000 mask FC0000000 uncachable
  4 base 0BF800000 mask FFF800000 uncachable
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 8GB, type WB
reg 1, base: 8GB, range: 4GB, type WB
reg 2, base: 12GB, range: 1GB, type WB
reg 3, base: 3GB, range: 1GB, type UC
reg 4, base: 3064MB, range: 8MB, type UC
total RAM covered: 12280M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3064MB, range: 8MB, type UC
reg 3, base: 4GB, range: 4GB, type WB
reg 4, base: 8GB, range: 4GB, type WB
reg 5, base: 12GB, range: 1GB, type WB
e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf780 max_arch_pfn = 0x400000000
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009cc00 (usable)
 modified: 000000000009cc00 - 00000000000a0000 (reserved)
 modified: 00000000000e4c00 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000bf780000 (usable)
 modified: 00000000bf780000 - 00000000bf798000 (ACPI data)
 modified: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
 modified: 00000000bf7dc000 - 00000000c0000000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000ffe00000 - 0000000100000000 (reserved)
 modified: 0000000100000000 - 0000000340000000 (usable)
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000ff780] ff780
init_memory_mapping: 0000000000000000-00000000bf780000
 0000000000 - 00bf600000 page 2M
 00bf600000 - 00bf780000 page 4k
kernel direct mapping tables up to bf780000 @ 16000-1b000
init_memory_mapping: 0000000100000000-0000000340000000
 0100000000 - 0340000000 page 2M
kernel direct mapping tables up to 340000000 @ 19000-27000
RAMDISK: 376d9000 - 37fef76a
Reserving 128MB of memory at 32MB for crashkernel (System RAM: 13312MB)
ACPI: RSDP 00000000000fb1a0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000bf780100 00064 (v01 111209 XSDT1642 20091112 MSFT 00000097)
ACPI: FACP 00000000bf780290 000F4 (v03 111209 FACP1642 20091112 MSFT 00000097)
ACPI: DSDT 00000000bf7804b0 0B66D (v01  A1265 A1265001 00000001 INTL 20060113)
ACPI: FACS 00000000bf798000 00040
ACPI: APIC 00000000bf780390 000D8 (v01 111209 APIC1642 20091112 MSFT 00000097)
ACPI: MCFG 00000000bf780470 0003C (v01 111209 OEMMCFG  20091112 MSFT 00000097)
ACPI: OEMB 00000000bf798040 00072 (v01 111209 OEMB1642 20091112 MSFT 00000097)
ACPI: HPET 00000000bf78f4b0 00038 (v01 111209 OEMHPET  20091112 MSFT 00000097)
ACPI: DMAR 00000000bf7980c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
ACPI: OSFR 00000000bf78f4f0 000B0 (v01 111209 OEMOSFR  20091112 MSFT 00000097)
ACPI: SSDT 00000000bf79a470 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000340000000
Bootmem setup node 0 0000000000000000-0000000340000000
  NODE_DATA [0000000000022000 - 0000000000036fff]
  bootmap [0000000000100000 -  0000000000167fff] pages 68
(14 early reservations) ==> bootmem [0000000000 - 0340000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001da45e0]    TEXT DATA BSS ==> [0001000000 - 0001da45e0]
  #2 [00376d9000 - 0037fef76a]          RAMDISK ==> [00376d9000 - 0037fef76a]
  #3 [0001da5000 - 0001da5294]              BRK ==> [0001da5000 - 0001da5294]
  #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
  #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
  #6 [000009cc00 - 00000f1300]    BIOS reserved ==> [000009cc00 - 00000f1300]
  #7 [00000f14c4 - 00000ff780]    BIOS reserved ==> [00000f14c4 - 00000ff780]
  #8 [00000f1300 - 00000f14c4]     MP-table mpc ==> [00000f1300 - 00000f14c4]
  #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
  #10 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
  #11 [0000016000 - 0000019000]          PGTABLE ==> [0000016000 - 0000019000]
  #12 [0000019000 - 0000022000]          PGTABLE ==> [0000019000 - 0000022000]
  #13 [0002000000 - 000a000000]     CRASH KERNEL ==> [0002000000 - 000a000000]
 [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00340000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009c
    0: 0x00000100 -> 0x000bf780
    0: 0x00100000 -> 0x00340000
On node 0 totalpages: 3143436
  DMA zone: 56 pages used for memmap
  DMA zone: 117 pages reserved
  DMA zone: 3807 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765880 pages, LIFO batch:31
  Normal zone: 32256 pages used for memmap
  Normal zone: 2327040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 16 CPUs, 8 hotplug CPUs
nr_irqs_gsi: 48
Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Embedded 30 pages/cpu @ffff880028200000 s90520 r8192 d24168 u131072
pcpu-alloc: s90520 r8192 d24168 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096727
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_00-LogVol02_root usbcore.autosuspend=1 crashkernel=128M SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us pcie_aspm=force intel_iommu=igfx_off 3
PCIe ASPM is forcedly enabled
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 12179060k/13631488k available (4466k kernel code, 1057744k absent, 394684k reserved, 6697k data, 1516k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:4352 nr_irqs:944
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 125829120 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2672.947 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5345.89 BogoMIPS (lpj=2672947)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
using mwait in idle threads.
Performance Events: Nehalem/Corei7 events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20091214
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 22129 entries in 87 pages
DMAR: Host address width 39
DMAR: DRHD base: 0x000000fbfff000 flags: 0x0
IOMMU fbfff000: ver 1:0 cap c9008010e60262 ecap f0207a
DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
IOMMU fbffe000: ver 1:0 cap c90780106f0462 ecap f020fe
DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
DMAR: RMRR base: 0x000000bf7dc000 end: 0x000000bf7dbfff
DMAR: ATSR flags: 0x0
IOAPIC id 8 under DRHD base 0xfbffe000
IOAPIC id 9 under DRHD base 0xfbffe000
DRHD: handling fault status reg 3
Enabled Interrupt-remapping
Setting APIC routing to flat
  alloc irq_desc for 48 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 49 on node 0
  alloc kstat_irqs on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
alloc irq_2_iommu on node 0
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Booting Node   0, Processors  #1
CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #2
CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #3
CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
 #4
CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #5
CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #6
CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
 #7
CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Brought up 8 CPUs
Total of 8 processors activated (43186.20 BogoMIPS).
regulator: core version 0.5
Time: 19:53:43  Date: 01/10/10
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 00000000bf798200 01C0C (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
ACPI: SSDT 00000000bf799e10 00659 (v01  PmRef  P001Cst 00003001 INTL 20060113)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff] (ignored)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
IOH bus: [00, fb]
IOH bus: 00 index 0 io port: [0, efff]
IOH bus: 00 index 1 mmio: [d0000000, fbffffff]
pci 0000:00:1a.0: reg 20: [io  0x9800-0x981f]
pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
pci 0000:00:1a.2: reg 20: [io  0x9c00-0x9c1f]
pci 0000:00:1a.7: reg 10: [mem 0xf7fff000-0xf7fff3ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf7ff8000-0xf7ffbfff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x9080-0x909f]
pci 0000:00:1d.1: reg 20: [io  0x9400-0x941f]
pci 0000:00:1d.2: reg 20: [io  0x9480-0x949f]
pci 0000:00:1d.7: reg 10: [mem 0xf7ffe000-0xf7ffe3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
pci 0000:00:1f.2: reg 10: [io  0x8c00-0x8c07]
pci 0000:00:1f.2: reg 14: [io  0x8880-0x8883]
pci 0000:00:1f.2: reg 18: [io  0x8800-0x8807]
pci 0000:00:1f.2: reg 1c: [io  0x8480-0x8483]
pci 0000:00:1f.2: reg 20: [io  0x8400-0x841f]
pci 0000:00:1f.2: reg 24: [mem 0xf7ffc000-0xf7ffc7ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xf7ffd000-0xf7ffd0ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
PCI: peer root bus 00 res updated from pci conf
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:02:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:02:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
pci 0000:02:00.0: reg 24: [io  0xac00-0xac7f]
pci 0000:02:00.0: reg 30: [mem 0xfbae0000-0xfbafffff pref]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbafffff]
pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [mem 0xf6f00000-0xf6ffffff 64bit pref]
pci 0000:06:00.0: reg 10: [mem 0xfbdfc000-0xfbdfffff 64bit]
pci 0000:06:00.0: reg 18: [io  0xd800-0xd8ff]
pci 0000:06:00.0: reg 30: [mem 0xfbdc0000-0xfbddffff pref]
pci 0000:06:00.0: supports D1 D2
pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:05:00.0: reg 10: [io  0xcc00-0xcc07]
pci 0000:05:00.0: reg 14: [io  0xc880-0xc883]
pci 0000:05:00.0: reg 18: [io  0xc800-0xc807]
pci 0000:05:00.0: reg 1c: [io  0xc480-0xc483]
pci 0000:05:00.0: reg 20: [io  0xc400-0xc40f]
pci 0000:05:00.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
pci 0000:05:00.0: supports D1
pci 0000:05:00.0: PME# supported from D0 D1 D3hot
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:04:00.0: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
pci 0000:04:00.0: reg 18: [io  0xb800-0xb8ff]
pci 0000:04:00.0: reg 30: [mem 0xfbbc0000-0xfbbdffff pref]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:08:01.0: reg 10: [io  0xec00-0xec3f]
pci 0000:08:01.0: supports D2
pci 0000:08:02.0: reg 10: [mem 0xfbeff000-0xfbeff7ff]
pci 0000:08:02.0: reg 14: [io  0xe880-0xe8ff]
pci 0000:08:02.0: supports D2
pci 0000:08:02.0: PME# supported from D2 D3hot D3cold
pci 0000:08:02.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
system 00:06: [io  0x0290-0x029f] has been reserved
system 00:07: [io  0x04d0-0x04d1] has been reserved
system 00:07: [io  0x0800-0x087f] has been reserved
system 00:07: [io  0x0500-0x057f] could not be reserved
system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0e: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:0e: [mem 0xfed90000-0xffffffff] could not be reserved
pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf03fffff]
pci 0000:00:1c.2: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
pci 0000:00:1c.4: BAR 15: assigned [mem 0xf0600000-0xf07fffff 64bit pref]
pci 0000:00:1c.5: BAR 15: assigned [mem 0xf0800000-0xf09fffff 64bit pref]
pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbafffff]
pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf03fffff]
pci 0000:00:1c.0:   bridge window [mem 0xf6f00000-0xf6ffffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:1c.4:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 08-08]
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0106 -> 0107)
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 18 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xefff]
pci_bus 0000:00: resource 1 [mem 0xd0000000-0xfbffffff]
pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbafffff]
pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:07: resource 1 [mem 0xf0000000-0xf03fffff]
pci_bus 0000:07: resource 2 [mem 0xf6f00000-0xf6ffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:06: resource 1 [mem 0xfbd00000-0xfbdfffff]
pci_bus 0000:06: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xfbc00000-0xfbcfffff]
pci_bus 0000:05: resource 2 [mem 0xf0600000-0xf07fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:04: resource 1 [mem 0xfbb00000-0xfbbfffff]
pci_bus 0000:04: resource 2 [mem 0xf0800000-0xf09fffff 64bit pref]
pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
pci_bus 0000:08: resource 3 [io  0x0000-0xefff]
pci_bus 0000:08: resource 4 [mem 0xd0000000-0xfbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
NET: Registered protocol family 1
pci 0000:02:00.0: Boot video device
PCI: CLS 256 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 9305k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1263153222.874:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Btrfs loaded
msgmni has been set to 23805
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
  alloc irq_desc for 50 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:01.0: irq 50 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
  alloc irq_desc for 51 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:03.0: irq 51 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
  alloc irq_desc for 52 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:07.0: irq 52 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 53 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:1c.0: irq 53 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
  alloc irq_desc for 54 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:1c.2: irq 54 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
  alloc irq_desc for 55 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:1c.4: irq 55 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
  alloc irq_desc for 56 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
pcieport 0000:00:1c.5: irq 56 for MSI/MSI-X
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
pci-stub: invalid id string ""
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
  alloc irq_desc for 20 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
  alloc irq_desc for 57 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
ahci 0000:00:1f.2: irq 57 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems sxs 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc100 irq 57
ata2: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc180 irq 57
ata3: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc200 irq 57
ata4: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc280 irq 57
ata5: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc300 irq 57
ata6: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc380 irq 57
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fff000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7ffe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
  alloc irq_desc for 21 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009c00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009480
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
  Magic number: 10:75:900
rtc_cmos 00:03: setting system clock to 2010-01-10 19:53:43 UTC (1263153223)
Initalizing network drop monitor service
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb 1-5: New USB device found, idVendor=0409, idProduct=005a
usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-5:1.0: USB hub found
hub 1-5:1.0: 4 ports detected
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
usb 7-1: new full speed USB device using uhci_hcd and address 2
usb 7-1: New USB device found, idVendor=0733, idProduct=0430
usb 7-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 7-2: new low speed USB device using uhci_hcd and address 3
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
usb 7-2: New USB device found, idVendor=051d, idProduct=0002
usb 7-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 7-2: Product: Back-UPS ES 550 FW:843.K1d.D USB FW:K1d
usb 7-2: Manufacturer: APC
usb 7-2: SerialNumber: 3B1806X13792  
generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.10 Device [APC Back-UPS ES 550 FW:843.K1d.D USB FW:K1d] on usb-0000:00:1d.1-2/input0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-8: WDC WD10EADS-65L5B1, 01.01A01, max UDMA/133
ata5.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata5.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD10EADS-65L 01.0 PQ: 0 ANSI: 5
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-8: WDC WD10EADS-65L5B1, 01.01A01, max UDMA/133
ata6.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata6.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EADS-65L 01.0 PQ: 0 ANSI: 5
sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf:
sd 5:0:0:0: Attached scsi generic sg5 type 0
 sdf1
sd 5:0:0:0: [sdf] Attached SCSI disk
Freeing unused kernel memory: 1516k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1660k freed
Freeing unused kernel memory: 1880k freed
dracut: dracut-002-13.4.git8f397a9b.fc12
udev: starting version 147
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
  alloc irq_desc for 24 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
nouveau 0000:02:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
nouveau 0000:02:00.0: setting latency timer to 64
[drm] nouveau 0000:02:00.0: Detected an NV50 generation card (0x450300a2)
[drm] nouveau 0000:02:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:02:00.0: ... appears to be valid
[drm] nouveau 0000:02:00.0: BIT BIOS found
[drm] nouveau 0000:02:00.0: Bios version 60.80.18.00
[drm] nouveau 0000:02:00.0: TMDS table revision 2.0 not currently supported
[drm] nouveau 0000:02:00.0: BIT table 'd' not found
[drm] nouveau 0000:02:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:02:00.0: DCB connector table: VHER 0x40 5 14 2
[drm] nouveau 0000:02:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[drm] nouveau 0000:02:00.0:   1: 0x00002130: type 0x30 idx 1 tag 0x08
[drm] nouveau 0000:02:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[drm] nouveau 0000:02:00.0:   3: 0x00000211: type 0x11 idx 2 tag 0xff
[drm] nouveau 0000:02:00.0:   4: 0x00000213: type 0x13 idx 2 tag 0xff
[drm] nouveau 0000:02:00.0: Raw DCB entry 0: 04000320 00000028
[drm] nouveau 0000:02:00.0: Raw DCB entry 1: 01000322 00000030
[drm] nouveau 0000:02:00.0: Raw DCB entry 2: 02011310 00000028
[drm] nouveau 0000:02:00.0: Raw DCB entry 3: 02011312 00000030
[drm] nouveau 0000:02:00.0: Raw DCB entry 4: 010223f1 00c1c020
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 0 at offset 0xBFB4
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 1 at offset 0xC1BF
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 2 at offset 0xD37B
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 3 at offset 0xD46A
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table 4 at offset 0xD621
[drm] nouveau 0000:02:00.0: Parsing VBIOS init table at offset 0xD686
[drm] nouveau 0000:02:00.0: 0xD686: Condition still not met after 20ms, skipping following opcodes
[drm] nouveau 0000:02:00.0: 0xB284: parsing output script 0
[drm] nouveau 0000:02:00.0: 0xB284: parsing output script 0
[drm] nouveau 0000:02:00.0: 0xA8FA: parsing output script 0
[TTM] Zone  kernel: Available graphics memory: 6096712 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] nouveau 0000:02:00.0: 320 MiB VRAM
[drm] nouveau 0000:02:00.0: 512 MiB GART (aperture)
nouveau 0000:02:00.0: firmware: requesting nouveau/nv50.ctxprog
dracut: 
dracut: udevadm settle - timeout of 30 seconds reached, the event queue contains:
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0 (937)
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/controlD64 (1025)
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/card0 (1026)
dracut: /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-0 (1027)
dracut: Starting plymouth daemon
pata_marvell 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_marvell 0000:05:00.0: setting latency timer to 64
scsi6 : pata_marvell
scsi7 : pata_marvell
ata7: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 16
ata8: PATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 16
ata7.01: NODEV after polling detection
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.33-rc3WITHMMAPNODMAR-00147-g3c8ad49-dirty #1
Call Trace:
 <IRQ>  [<ffffffff81094ca7>] __report_bad_irq+0x3d/0x8c
 [<ffffffff81094e0e>] note_interrupt+0x118/0x17e
 [<ffffffff81095511>] handle_fasteoi_irq+0x9c/0xc1
 [<ffffffff8100c32f>] handle_irq+0x24/0x2d
 [<ffffffff8145a7ec>] do_IRQ+0x5c/0xc3
 [<ffffffff81455a93>] ret_from_intr+0x0/0x16
 <EOI>  [<ffffffff812a9d2a>] ? acpi_idle_enter_bm+0x256/0x28a
 [<ffffffff812a9d23>] ? acpi_idle_enter_bm+0x24f/0x28a
 [<ffffffff8138ee54>] cpuidle_idle_call+0x9e/0xfa
 [<ffffffff81008c05>] cpu_idle+0xb4/0xf6
 [<ffffffff8144ee27>] start_secondary+0x201/0x242
handlers:
[<ffffffff8133185e>] (usb_hcd_irq+0x0/0xa7)
[<ffffffff8131db12>] (ata_sff_interrupt+0x0/0x96)
Disabling IRQ #16
ata7.00: ATAPI: HP  DVD Writer 400, KH27, max UDMA/33
ata7.00: configured for UDMA/33
scsi 6:0:0:0: CD-ROM            HP       DVD Writer 400c  KH27 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr 6:0:0:0: Attached scsi generic sg6 type 5
[drm] nouveau 0000:02:00.0: No ctxprog for NV50
[drm] nouveau 0000:02:00.0: Detected a DAC output
[drm] nouveau 0000:02:00.0: Detected a TMDS output
[drm] nouveau 0000:02:00.0: Detected a DAC output
[drm] nouveau 0000:02:00.0: Detected a TMDS output
[drm] nouveau 0000:02:00.0: DCB encoder 1 unknown
[drm] nouveau 0000:02:00.0: Detected a DVI-I connector
[drm] nouveau 0000:02:00.0: Detected a DVI-I connector
[drm] nouveau 0000:02:00.0: allocated 1680x1050 fb: 0x40180000, bo ffff88032e655200
fb0: nouveaufb frame buffer device
registered panic notifier
[drm] Initialized nouveau 0.0.15 20090420 for 0000:02:00.0 on minor 0
dracut: Autoassembling MD Raid
md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
md: raid1 personality registered for level 1
raid1: raid set md0 active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 209649664
dracut: mdadm: /dev/md0 has been started with 2 drives.
 md0: unknown partition table
md: md1 stopped.
md: bind<sdb2>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sdf1>
md: bind<sde1>
md: bind<sda2>
async_tx: api initialized (async)
xor: automatically using best checksumming function: generic_sse
   generic_sse:  9012.000 MB/sec
xor: using function: generic_sse (9012.000 MB/sec)
raid6: int64x1   2425 MB/s
raid6: int64x2   2496 MB/s
raid6: int64x4   2015 MB/s
raid6: int64x8   1562 MB/s
raid6: sse2x1    5906 MB/s
raid6: sse2x2    6949 MB/s
raid6: sse2x4    8039 MB/s
raid6: using algorithm sse2x4 (8039 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: md1 is not clean -- starting background reconstruction
raid5: device sda2 operational as raid disk 0
raid5: device sde1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: allocated 6386kB for md1
0: w=1 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
5: w=2 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
4: w=3 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
3: w=4 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
2: w=5 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
1: w=6 pa=0 pr=6 m=2 a=2 r=6 op1=0 op2=0
raid5: raid level 6 set md1 active with 6 out of 6 devices, algorithm 2
RAID5 conf printout:
 --- rd:6 wd:6
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sdf1
 disk 5, o:1, dev:sde1
md1: detected capacity change from 0 to 3999969837056
dracut: mdadm: /dev/md1 has been started with 6 drives.
md: resync of RAID array md1
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 976555136 blocks.
 md1: unknown partition table
dracut: Scanning devices md1  for LVM volume groups 
dracut: Reading all physical volumes. This may take a while...
dracut: Found volume group "vg_00" using metadata type lvm2
dracut: 13 logical volume(s) in volume group "vg_00" now active
EXT4-fs (dm-3): INFO: recovery required on readonly filesystem
EXT4-fs (dm-3): write access will be enabled during recovery
EXT4-fs (dm-3): recovery complete
EXT4-fs (dm-3): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/mapper/vg_00-LogVol02_root
dracut: Loading SELinux policy
type=1404 audit(1263153291.180:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 131435 rules.
SELinux: 8192 avtab hash slots, 131435 rules.
SELinux:  8 users, 12 roles, 2787 types, 129 bools, 1 sens, 1024 cats
SELinux:  74 classes, 131435 rules
SELinux:  Permission module_request in class system not defined in policy.
SELinux:  Class tun_socket not defined in policy.
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-3, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1263153291.398:3): policy loaded auid=4294967295 ses=4294967295
dracut: Switching root
[drm] DAC-7: set mode 1680x1050 25
Console: switching to colour frame buffer device 210x65
[drm] nouveau 0000:02:00.0: 0x0FA9: parsing clock script 0
type=1400 audit(1263153292.301:4): avc:  denied  { associate } for  pid=689 comm="restorecon" name="ptmx" dev=devpts ino=2 scontext=system_u:object_r:ptmx_t:s0 tcontext=system_u:object_r:devpts_t:s0 tclass=filesystem
type=1400 audit(1263153292.618:5): avc:  denied  { associate } for  pid=733 comm="restorecon" name="ptmx" dev=devpts ino=2 scontext=system_u:object_r:ptmx_t:s0 tcontext=system_u:object_r:devpts_t:s0 tclass=filesystem
udev: starting version 147
ACPI: WMI: Mapper loaded
iTCO_vendor_support: vendor-support=0
input: PC Speaker as /devices/platform/pcspkr/input/input3
sky2 driver version 1.26
sky2 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:06:00.0: setting latency timer to 64
sky2 0000:06:00.0: Yukon-2 EC Ultra chip revision 3
  alloc irq_desc for 58 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
sky2 0000:06:00.0: irq 58 for MSI/MSI-X
sky2 eth0: addr 00:26:18:00:1c:3b
sky2 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
  alloc irq_desc for 59 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
sky2 0000:04:00.0: irq 59 for MSI/MSI-X
sky2 eth1: addr 00:26:18:00:1c:3a
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Linux video capture interface: v2.00
firewire_ohci 0000:08:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
gspca: main v2.8.0 registered
firewire_ohci: Added fw-ohci device 0000:08:02.0, OHCI version 1.10
gspca: probing 0733:0430
gspca: video0 created
usbcore: registered new interface driver spca505
spca505: registered
ENS1371 0000:08:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
  alloc irq_desc for 22 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
  alloc irq_desc for 60 on node -1
  alloc kstat_irqs on node -1
alloc irq_2_iommu on node -1
HDA Intel 0000:00:1b.0: irq 60 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
firewire_core: created device fw0: GUID 001e8c0001e5e584, S400
ALSA sound/pci/hda/hda_intel.c:694: azx_get_response timeout, switching to polling mode: last cmd=0x000f0000
hda_codec: AD1989B: BIOS auto-probing.
ALSA sound/pci/hda/hda_codec.c:4284: autoconfig: line_outs=4 (0x12/0x16/0x24/0x25/0x0)
ALSA sound/pci/hda/hda_codec.c:4288:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4292:    hp_outs=1 (0x11/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4293:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4296:    dig-out=0x1b/0x1d
ALSA sound/pci/hda/hda_codec.c:4304:    inputs: mic=0x17, fmic=0x14, line=0x15, fline=0x0, cd=0x18, aux=0x0
gameport: ES137x is pci0000:08:01.0/gameport0, io 0x200, speed 663kHz
device-mapper: multipath: version 1.1.1 loaded
EXT4-fs (dm-6): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-6, type ext4), uses xattr
EXT4-fs (dm-1): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-1, type ext4), uses xattr
EXT4-fs (dm-5): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-5, type ext4), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md0): using internal journal
EXT3-fs (md0): mounted filesystem with ordered data mode
SELinux: initialized (dev md0, type ext3), uses xattr
EXT4-fs (dm-7): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-7, type ext4), uses xattr
EXT4-fs (dm-8): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-8, type ext4), uses xattr
EXT4-fs (dm-4): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-4, type ext4), uses xattr
EXT4-fs (dm-2): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-2, type ext4), uses xattr
device fsid 834fc529ea4ea2c5-f9308b94bfd9cac devid 1 transid 23729 /dev/mapper/vg_00-kvm_guest_btrfs_test
SELinux: initialized (dev dm-9, type btrfs), uses xattr
EXT4-fs (dm-10): mounted filesystem with ordered data mode
SELinux: initialized (dev dm-10, type ext4), uses xattr
Adding 17432568k swap on /dev/mapper/vg_00-LogVol00_swap.  Priority:-1 extents:1 across:17432568k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

--Boundary_(ID_pc+hXSdyrItzbA9rQ7FMSA)--
