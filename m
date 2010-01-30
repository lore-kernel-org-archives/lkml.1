Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427Ab0A3TVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0A3TVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983Ab0A3TVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:21:04 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:35164 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0A3TVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:21:03 -0500
Date: Sat, 30 Jan 2010 14:21:11 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Regressionhung task during raid rebuild 2.6.33 rc5 was: Re: 2.6.33RC3
 hung task - jbd2/dm-1-8 (during raid rebuild)
In-reply-to: <4B4A4AD7.5090800@majjas.com>
To: linux-kernel@vger.kernel.org
Message-id: <4B6486A7.8030404@majjas.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_S/WY06BssgOxbDGAmlN4Og)"
References: <4B4A4AD7.5090800@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_S/WY06BssgOxbDGAmlN4Og)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

On 1/10/2010 4:47 PM, Michael Breuer wrote:
> System crashed (watchdog reset).
>
> Was doing a raid rebuild at the time (raid6).
>
> I typed, 'yumdownloader --source virtlib' ... system froze, then 
> rebooted on the watchdog reset.
>
> I've attached the log extract from the event as well as dmesg.
>
>
Hit this again - system doesn't crash now - just get the hung task 
warning (log extract attached). System seems to keep running (albeit the 
rebuild is incredibly slow on 2.6.33 rc5 - approx 6500K/sec vs. about 
80,000K/sec on 2.6.32.4.

Looks like it may be triggered by disk io during the rebuild. This time 
I had typed, "sync." "sync" hung for a long while but did eventually 
complete.

--Boundary_(ID_S/WY06BssgOxbDGAmlN4Og)
Content-type: text/plain; name=messages
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=messages

Jan 30 13:46:17 mail kernel: INFO: task jbd2/dm-6-8:1296 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: jbd2/dm-6-8   D 0000000000000002     0  1296      2 0x00000000
Jan 30 13:46:17 mail kernel: ffff88025d689be0 0000000000000046 ffff88025d689b30 ffff880269894800
Jan 30 13:46:17 mail kernel: ffff88025d689ba0 ffffffff81383991 ffff88025d689fd8 ffff88025d689fd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88026b32e1b0 ffffffff81010115
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff81383991>] ? dm_table_unplug_all+0x58/0xc7
Jan 30 13:46:17 mail kernel: [<ffffffff81010115>] ? read_tsc+0x9/0x1b
Jan 30 13:46:17 mail kernel: [<ffffffff8106d52b>] ? ktime_get_ts+0x85/0x8e
Jan 30 13:46:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:46:17 mail kernel: [<ffffffff8112256a>] sync_buffer+0x40/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:46:17 mail kernel: [<ffffffff8123c38c>] ? submit_bio+0xd2/0xef
Jan 30 13:46:17 mail kernel: [<ffffffff8145b2a8>] out_of_line_wait_on_bit+0x6e/0x79
Jan 30 13:46:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff811224ac>] __wait_on_buffer+0x24/0x26
Jan 30 13:46:17 mail kernel: [<ffffffff811a59eb>] wait_on_buffer+0x2b/0x2d
Jan 30 13:46:17 mail kernel: [<ffffffff811a6b3c>] jbd2_journal_commit_transaction+0xe51/0x1429
Jan 30 13:46:17 mail kernel: [<ffffffff8105789a>] ? spin_unlock_irqrestore+0xe/0x10
Jan 30 13:46:17 mail kernel: [<ffffffff81057961>] ? try_to_del_timer_sync+0x73/0x81
Jan 30 13:46:17 mail kernel: [<ffffffff811ac227>] kjournald2+0x139/0x359
Jan 30 13:46:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:46:17 mail kernel: [<ffffffff811ac0ee>] ? kjournald2+0x0/0x359
Jan 30 13:46:17 mail kernel: [<ffffffff81064ca5>] kthread+0x7f/0x87
Jan 30 13:46:17 mail kernel: [<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
Jan 30 13:46:17 mail kernel: [<ffffffff8145ca3d>] ? restore_args+0x0/0x30
Jan 30 13:46:17 mail kernel: [<ffffffff81064c26>] ? kthread+0x0/0x87
Jan 30 13:46:17 mail kernel: [<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10
Jan 30 13:46:17 mail kernel: INFO: task jbd2/dm-1-8:1305 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: jbd2/dm-1-8   D 0000000000000002     0  1305      2 0x00000000
Jan 30 13:46:17 mail kernel: ffff88025f5dfbe0 0000000000000046 ffff88025f5dfb30 ffff88026a284e00
Jan 30 13:46:17 mail kernel: ffff88025f5dfba0 ffffffff81383991 ffff88025f5dffd8 ffff88025f5dffd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88026b3bb2b0 ffffffff81010115
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff81383991>] ? dm_table_unplug_all+0x58/0xc7
Jan 30 13:46:17 mail kernel: [<ffffffff81010115>] ? read_tsc+0x9/0x1b
Jan 30 13:46:17 mail kernel: [<ffffffff8106d52b>] ? ktime_get_ts+0x85/0x8e
Jan 30 13:46:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:46:17 mail kernel: [<ffffffff8112256a>] sync_buffer+0x40/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:46:17 mail kernel: [<ffffffff8123c38c>] ? submit_bio+0xd2/0xef
Jan 30 13:46:17 mail kernel: [<ffffffff8145b2a8>] out_of_line_wait_on_bit+0x6e/0x79
Jan 30 13:46:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:46:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff811224ac>] __wait_on_buffer+0x24/0x26
Jan 30 13:46:17 mail kernel: [<ffffffff811a59eb>] wait_on_buffer+0x2b/0x2d
Jan 30 13:46:17 mail kernel: [<ffffffff811a6b3c>] jbd2_journal_commit_transaction+0xe51/0x1429
Jan 30 13:46:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:46:17 mail kernel: [<ffffffff811ac227>] kjournald2+0x139/0x359
Jan 30 13:46:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:46:17 mail kernel: [<ffffffff811ac0ee>] ? kjournald2+0x0/0x359
Jan 30 13:46:17 mail kernel: [<ffffffff81064ca5>] kthread+0x7f/0x87
Jan 30 13:46:17 mail kernel: [<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
Jan 30 13:46:17 mail kernel: [<ffffffff8145ca3d>] ? restore_args+0x0/0x30
Jan 30 13:46:17 mail kernel: [<ffffffff81064c26>] ? kthread+0x0/0x87
Jan 30 13:46:17 mail kernel: [<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10
Jan 30 13:46:17 mail kernel: INFO: task auditd:2195 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: auditd        D 0000000000000002     0  2195      1 0x00000000
Jan 30 13:46:17 mail kernel: ffff88025d43dcc8 0000000000000086 ffff88025d43dc38 ffffffff8145c5cb
Jan 30 13:46:17 mail kernel: ffff88025d43dc38 0000000000000296 ffff88025d43dfd8 ffff88025d43dfd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff880330ecca30 ffffffff81010115
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff8145c5cb>] ? _raw_read_lock_irqsave+0x28/0x41
Jan 30 13:46:17 mail kernel: [<ffffffff81010115>] ? read_tsc+0x9/0x1b
Jan 30 13:46:17 mail kernel: [<ffffffff8106d52b>] ? ktime_get_ts+0x85/0x8e
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:46:17 mail kernel: [<ffffffff810c0981>] sync_page+0x46/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:46:17 mail kernel: [<ffffffff810c0b53>] wait_on_page_bit+0x72/0x79
Jan 30 13:46:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff810c8ad1>] ? pagevec_lookup_tag+0x25/0x2e
Jan 30 13:46:17 mail kernel: [<ffffffff810c1447>] filemap_fdatawait_range+0xa4/0x165
Jan 30 13:46:17 mail kernel: [<ffffffff810c7755>] ? do_writepages+0x21/0x2a
Jan 30 13:46:17 mail kernel: [<ffffffff810c157b>] ? __filemap_fdatawrite_range+0x50/0x52
Jan 30 13:46:17 mail kernel: [<ffffffff810c15c0>] filemap_write_and_wait_range+0x43/0x56
Jan 30 13:46:17 mail kernel: [<ffffffff8111fdae>] vfs_fsync_range+0x5f/0xb2
Jan 30 13:46:17 mail kernel: [<ffffffff8111fe78>] vfs_fsync+0x1d/0x1f
Jan 30 13:46:17 mail kernel: [<ffffffff8111feae>] do_fsync+0x34/0x49
Jan 30 13:46:17 mail kernel: [<ffffffff8111feea>] sys_fsync+0x10/0x14
Jan 30 13:46:17 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 30 13:46:17 mail kernel: INFO: task postmaster:3431 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: postmaster    D ffff88002822f9a8     0  3431   3360 0x00000080
Jan 30 13:46:17 mail kernel: ffff880266275ae8 0000000000000082 0000000000000000 ffffffff8145c5cb
Jan 30 13:46:17 mail kernel: ffff880266275a58 0000000000000292 ffff880266275fd8 ffff880266275fd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88026622b2b0 0000000100c0f605
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff8145c5cb>] ? _raw_read_lock_irqsave+0x28/0x41
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:46:17 mail kernel: [<ffffffff810c0981>] sync_page+0x46/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:46:17 mail kernel: [<ffffffff810c0b53>] wait_on_page_bit+0x72/0x79
Jan 30 13:46:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff810c95ea>] wait_on_page_writeback+0x1b/0x1d
Jan 30 13:46:17 mail kernel: [<ffffffff810c9e47>] truncate_inode_pages_range+0x29f/0x309
Jan 30 13:46:17 mail kernel: [<ffffffff8120ee25>] ? security_inode_getsecid+0x16/0x18
Jan 30 13:46:17 mail kernel: [<ffffffff8108f13b>] ? audit_copy_inode+0x54/0xb1
Jan 30 13:46:17 mail kernel: [<ffffffff811a39a5>] ? spin_lock+0xe/0x10
Jan 30 13:46:17 mail kernel: [<ffffffff81177415>] ? ext4_delete_inode+0x0/0x254
Jan 30 13:46:17 mail kernel: [<ffffffff810c9ec3>] truncate_inode_pages+0x12/0x14
Jan 30 13:46:17 mail kernel: [<ffffffff81177478>] ext4_delete_inode+0x63/0x254
Jan 30 13:46:17 mail kernel: [<ffffffff81177415>] ? ext4_delete_inode+0x0/0x254
Jan 30 13:46:17 mail kernel: [<ffffffff81113dcb>] generic_delete_inode+0xe2/0x163
Jan 30 13:46:17 mail kernel: [<ffffffff81113e68>] generic_drop_inode+0x1c/0x5c
Jan 30 13:46:17 mail kernel: [<ffffffff81112fbe>] iput+0x66/0x6a
Jan 30 13:46:17 mail kernel: [<ffffffff811104aa>] dentry_iput+0xb6/0xc6
Jan 30 13:46:17 mail kernel: [<ffffffff811105a3>] d_kill+0x48/0x68
Jan 30 13:46:17 mail kernel: [<ffffffff81110ec2>] dput+0x155/0x162
Jan 30 13:46:17 mail kernel: [<ffffffff8110c44d>] sys_renameat+0x1aa/0x20c
Jan 30 13:46:17 mail kernel: [<ffffffff810dcf9b>] ? tlb_finish_mmu+0x37/0x42
Jan 30 13:46:17 mail kernel: [<ffffffff810f4075>] ? virt_to_head_page+0xe/0x2f
Jan 30 13:46:17 mail kernel: [<ffffffff810dd12e>] ? remove_vma+0x77/0x7f
Jan 30 13:46:17 mail kernel: [<ffffffff81091747>] ? audit_syscall_entry+0x11e/0x14a
Jan 30 13:46:17 mail kernel: [<ffffffff8110c4ca>] sys_rename+0x1b/0x1d
Jan 30 13:46:17 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 30 13:46:17 mail kernel: INFO: task psad:3877 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: psad          D 0000000000000002     0  3877      1 0x00000080
Jan 30 13:46:17 mail kernel: ffff8802219bfae8 0000000000000086 ffff8802219bfa58 ffffffff8145c5cb
Jan 30 13:46:17 mail kernel: ffff8802219bfa58 0000000000000292 ffff8802219bffd8 ffff8802219bffd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff8802219783b0 ffffffff81010115
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff8145c5cb>] ? _raw_read_lock_irqsave+0x28/0x41
Jan 30 13:46:17 mail kernel: [<ffffffff81010115>] ? read_tsc+0x9/0x1b
Jan 30 13:46:17 mail kernel: [<ffffffff8106d52b>] ? ktime_get_ts+0x85/0x8e
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:46:17 mail kernel: [<ffffffff810c0981>] sync_page+0x46/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:46:17 mail kernel: [<ffffffff810c0b53>] wait_on_page_bit+0x72/0x79
Jan 30 13:46:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff810c95ea>] wait_on_page_writeback+0x1b/0x1d
Jan 30 13:46:17 mail kernel: [<ffffffff810c9e47>] truncate_inode_pages_range+0x29f/0x309
Jan 30 13:46:17 mail kernel: [<ffffffff8120ee25>] ? security_inode_getsecid+0x16/0x18
Jan 30 13:46:17 mail kernel: [<ffffffff8108f13b>] ? audit_copy_inode+0x54/0xb1
Jan 30 13:46:17 mail kernel: [<ffffffff811a39a5>] ? spin_lock+0xe/0x10
Jan 30 13:46:17 mail kernel: [<ffffffff81177415>] ? ext4_delete_inode+0x0/0x254
Jan 30 13:46:17 mail kernel: [<ffffffff810c9ec3>] truncate_inode_pages+0x12/0x14
Jan 30 13:46:17 mail kernel: [<ffffffff81177478>] ext4_delete_inode+0x63/0x254
Jan 30 13:46:17 mail kernel: [<ffffffff81177415>] ? ext4_delete_inode+0x0/0x254
Jan 30 13:46:17 mail kernel: [<ffffffff81113dcb>] generic_delete_inode+0xe2/0x163
Jan 30 13:46:17 mail kernel: [<ffffffff81113e68>] generic_drop_inode+0x1c/0x5c
Jan 30 13:46:17 mail kernel: [<ffffffff81112fbe>] iput+0x66/0x6a
Jan 30 13:46:17 mail kernel: [<ffffffff811104aa>] dentry_iput+0xb6/0xc6
Jan 30 13:46:17 mail kernel: [<ffffffff811105a3>] d_kill+0x48/0x68
Jan 30 13:46:17 mail kernel: [<ffffffff81110ec2>] dput+0x155/0x162
Jan 30 13:46:17 mail kernel: [<ffffffff8110c44d>] sys_renameat+0x1aa/0x20c
Jan 30 13:46:17 mail kernel: [<ffffffff81104a9d>] ? cp_new_stat+0xf7/0x10d
Jan 30 13:46:17 mail kernel: [<ffffffff81091747>] ? audit_syscall_entry+0x11e/0x14a
Jan 30 13:46:17 mail kernel: [<ffffffff8110c4ca>] sys_rename+0x1b/0x1d
Jan 30 13:46:17 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 30 13:46:17 mail kernel: INFO: task yum:17188 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: yum           D ffff88002824f9a8     0 17188   8261 0x00000080
Jan 30 13:46:17 mail kernel: ffff880207dafd28 0000000000000082 0000000000000000 0000000000000000
Jan 30 13:46:17 mail kernel: ffff880207dafcd8 0000000000000000 ffff880207daffd8 ffff880207daffd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88022324ca30 0000000100c0f5f7
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff8145afaa>] schedule_timeout+0x36/0xe3
Jan 30 13:46:17 mail kernel: [<ffffffff8123c261>] ? generic_make_request+0x23b/0x294
Jan 30 13:46:17 mail kernel: [<ffffffff8145ae08>] wait_for_common+0xcc/0x146
Jan 30 13:46:17 mail kernel: [<ffffffff810438d2>] ? default_wake_function+0x0/0x14
Jan 30 13:46:17 mail kernel: [<ffffffff8123c38c>] ? submit_bio+0xd2/0xef
Jan 30 13:46:17 mail kernel: [<ffffffff8145af25>] wait_for_completion+0x1d/0x1f
Jan 30 13:46:17 mail kernel: [<ffffffff8123fb8a>] blkdev_issue_flush+0x82/0xc3
Jan 30 13:46:17 mail kernel: [<ffffffff8116eb5b>] ext4_sync_file+0x1bb/0x1ec
Jan 30 13:46:17 mail kernel: [<ffffffff8111fdd1>] vfs_fsync_range+0x82/0xb2
Jan 30 13:46:17 mail kernel: [<ffffffff8111fe78>] vfs_fsync+0x1d/0x1f
Jan 30 13:46:17 mail kernel: [<ffffffff8111feae>] do_fsync+0x34/0x49
Jan 30 13:46:17 mail kernel: [<ffffffff8111fed6>] sys_fdatasync+0x13/0x17
Jan 30 13:46:17 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 30 13:46:17 mail kernel: INFO: task postmaster:19417 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: postmaster    D ffff8800282cf9a8     0 19417   3360 0x00000080
Jan 30 13:46:17 mail kernel: ffff88025e641cc8 0000000000000082 ffff88025e641c90 ffff88025e641c8c
Jan 30 13:46:17 mail kernel: 0000000000000000 00000000000002ff ffff88025e641fd8 ffff88025e641fd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88025d1ee1b0 0000000100c0f5f7
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff810c093b>] ? sync_page+0x0/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:46:17 mail kernel: [<ffffffff810c0981>] sync_page+0x46/0x4a
Jan 30 13:46:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:46:17 mail kernel: [<ffffffff810c0b53>] wait_on_page_bit+0x72/0x79
Jan 30 13:46:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff810c8ad1>] ? pagevec_lookup_tag+0x25/0x2e
Jan 30 13:46:17 mail kernel: [<ffffffff810c1447>] filemap_fdatawait_range+0xa4/0x165
Jan 30 13:46:17 mail kernel: [<ffffffff810c7755>] ? do_writepages+0x21/0x2a
Jan 30 13:46:17 mail kernel: [<ffffffff810c157b>] ? __filemap_fdatawrite_range+0x50/0x52
Jan 30 13:46:17 mail kernel: [<ffffffff810c15c0>] filemap_write_and_wait_range+0x43/0x56
Jan 30 13:46:17 mail kernel: [<ffffffff8111fdae>] vfs_fsync_range+0x5f/0xb2
Jan 30 13:46:17 mail kernel: [<ffffffff8111fe78>] vfs_fsync+0x1d/0x1f
Jan 30 13:46:17 mail kernel: [<ffffffff8111feae>] do_fsync+0x34/0x49
Jan 30 13:46:17 mail kernel: [<ffffffff8111fed6>] sys_fdatasync+0x13/0x17
Jan 30 13:46:17 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 30 13:46:17 mail kernel: INFO: task sync:19575 blocked for more than 120 seconds.
Jan 30 13:46:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:46:17 mail kernel: sync          D ffff8800282af9a8     0 19575  19026 0x00000080
Jan 30 13:46:17 mail kernel: ffff8801acbd9e08 0000000000000082 0000000000000000 ffff8802690525b8
Jan 30 13:46:17 mail kernel: ffff8801acbd9db8 ffffffff810c04ec ffff8801acbd9fd8 ffff8801acbd9fd8
Jan 30 13:46:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88020c9be1b0 0000000100c0f1f2
Jan 30 13:46:17 mail kernel: Call Trace:
Jan 30 13:46:17 mail kernel: [<ffffffff810c04ec>] ? find_get_pages_tag+0x3b/0xdb
Jan 30 13:46:17 mail kernel: [<ffffffff811abaf6>] jbd2_log_wait_commit+0x13c/0x18e
Jan 30 13:46:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:46:17 mail kernel: [<ffffffff81182c2d>] ext4_sync_fs+0x7f/0x8e
Jan 30 13:46:17 mail kernel: [<ffffffff81146919>] sync_quota_sb+0x53/0x101
Jan 30 13:46:17 mail kernel: [<ffffffff8111ff8b>] __sync_filesystem+0x46/0x77
Jan 30 13:46:17 mail kernel: [<ffffffff81120063>] sync_filesystems+0xa7/0xf3
Jan 30 13:46:17 mail kernel: [<ffffffff81120109>] sys_sync+0x21/0x33
Jan 30 13:46:17 mail kernel: [<ffffffff81009bf2>] system_call_fastpath+0x16/0x1b
Jan 30 13:46:34 mail snmpd[2990]: error on subcontainer 'ia_addr' insert (-1)
Jan 30 13:47:04 mail snmpd[2990]: error on subcontainer 'ia_addr' insert (-1)
Jan 30 13:47:34 mail snmpd[2990]: error on subcontainer 'ia_addr' insert (-1)
Jan 30 13:48:04 mail snmpd[2990]: error on subcontainer 'ia_addr' insert (-1)
Jan 30 13:48:09 mail kernel: SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
Jan 30 13:48:09 mail kernel: SELinux: initialized (dev proc, type proc), uses genfs_contexts
Jan 30 13:48:09 mail kernel: lo: Disabled Privacy Extensions
Jan 30 13:48:09 mail kernel: sit0: Disabled Privacy Extensions
Jan 30 13:48:09 mail kernel: Failed to create cgroup 2: -22
Jan 30 13:48:17 mail kernel: INFO: task jbd2/dm-6-8:1296 blocked for more than 120 seconds.
Jan 30 13:48:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:48:17 mail kernel: jbd2/dm-6-8   D 0000000000000002     0  1296      2 0x00000000
Jan 30 13:48:17 mail kernel: ffff88025d689be0 0000000000000046 ffff88025d689b30 ffff880269894800
Jan 30 13:48:17 mail kernel: ffff88025d689ba0 ffffffff81383991 ffff88025d689fd8 ffff88025d689fd8
Jan 30 13:48:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88026b32e1b0 ffffffff81010115
Jan 30 13:48:17 mail kernel: Call Trace:
Jan 30 13:48:17 mail kernel: [<ffffffff81383991>] ? dm_table_unplug_all+0x58/0xc7
Jan 30 13:48:17 mail kernel: [<ffffffff81010115>] ? read_tsc+0x9/0x1b
Jan 30 13:48:17 mail kernel: [<ffffffff8106d52b>] ? ktime_get_ts+0x85/0x8e
Jan 30 13:48:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:48:17 mail kernel: [<ffffffff8112256a>] sync_buffer+0x40/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:48:17 mail kernel: [<ffffffff8123c38c>] ? submit_bio+0xd2/0xef
Jan 30 13:48:17 mail kernel: [<ffffffff8145b2a8>] out_of_line_wait_on_bit+0x6e/0x79
Jan 30 13:48:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:48:17 mail kernel: [<ffffffff811224ac>] __wait_on_buffer+0x24/0x26
Jan 30 13:48:17 mail kernel: [<ffffffff811a59eb>] wait_on_buffer+0x2b/0x2d
Jan 30 13:48:17 mail kernel: [<ffffffff811a6b3c>] jbd2_journal_commit_transaction+0xe51/0x1429
Jan 30 13:48:17 mail kernel: [<ffffffff8105789a>] ? spin_unlock_irqrestore+0xe/0x10
Jan 30 13:48:17 mail kernel: [<ffffffff81057961>] ? try_to_del_timer_sync+0x73/0x81
Jan 30 13:48:17 mail kernel: [<ffffffff811ac227>] kjournald2+0x139/0x359
Jan 30 13:48:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:48:17 mail kernel: [<ffffffff811ac0ee>] ? kjournald2+0x0/0x359
Jan 30 13:48:17 mail kernel: [<ffffffff81064ca5>] kthread+0x7f/0x87
Jan 30 13:48:17 mail kernel: [<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
Jan 30 13:48:17 mail kernel: [<ffffffff8145ca3d>] ? restore_args+0x0/0x30
Jan 30 13:48:17 mail kernel: [<ffffffff81064c26>] ? kthread+0x0/0x87
Jan 30 13:48:17 mail kernel: [<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10
Jan 30 13:48:17 mail kernel: INFO: task jbd2/dm-1-8:1305 blocked for more than 120 seconds.
Jan 30 13:48:17 mail kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 30 13:48:17 mail kernel: jbd2/dm-1-8   D 0000000000000002     0  1305      2 0x00000000
Jan 30 13:48:17 mail kernel: ffff88025f5dfbe0 0000000000000046 ffff88025f5dfb30 ffff88026a284e00
Jan 30 13:48:17 mail kernel: ffff88025f5dfba0 ffffffff81383991 ffff88025f5dffd8 ffff88025f5dffd8
Jan 30 13:48:17 mail kernel: 000000000000f9a8 00000000000157c0 ffff88026b3bb2b0 ffffffff81010115
Jan 30 13:48:17 mail kernel: Call Trace:
Jan 30 13:48:17 mail kernel: [<ffffffff81383991>] ? dm_table_unplug_all+0x58/0xc7
Jan 30 13:48:17 mail kernel: [<ffffffff81010115>] ? read_tsc+0x9/0x1b
Jan 30 13:48:17 mail kernel: [<ffffffff8106d52b>] ? ktime_get_ts+0x85/0x8e
Jan 30 13:48:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff8145ac9c>] io_schedule+0x43/0x5d
Jan 30 13:48:17 mail kernel: [<ffffffff8112256a>] sync_buffer+0x40/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff8145b207>] __wait_on_bit+0x48/0x7b
Jan 30 13:48:17 mail kernel: [<ffffffff8123c38c>] ? submit_bio+0xd2/0xef
Jan 30 13:48:17 mail kernel: [<ffffffff8145b2a8>] out_of_line_wait_on_bit+0x6e/0x79
Jan 30 13:48:17 mail kernel: [<ffffffff8112252a>] ? sync_buffer+0x0/0x44
Jan 30 13:48:17 mail kernel: [<ffffffff81065158>] ? wake_bit_function+0x0/0x33
Jan 30 13:48:17 mail kernel: [<ffffffff811224ac>] __wait_on_buffer+0x24/0x26
Jan 30 13:48:17 mail kernel: [<ffffffff811a59eb>] wait_on_buffer+0x2b/0x2d
Jan 30 13:48:17 mail kernel: [<ffffffff811a6b3c>] jbd2_journal_commit_transaction+0xe51/0x1429
Jan 30 13:48:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:48:17 mail kernel: [<ffffffff811ac227>] kjournald2+0x139/0x359
Jan 30 13:48:17 mail kernel: [<ffffffff8106511f>] ? autoremove_wake_function+0x0/0x39
Jan 30 13:48:17 mail kernel: [<ffffffff811ac0ee>] ? kjournald2+0x0/0x359
Jan 30 13:48:17 mail kernel: [<ffffffff81064ca5>] kthread+0x7f/0x87
Jan 30 13:48:17 mail kernel: [<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
Jan 30 13:48:17 mail kernel: [<ffffffff8145ca3d>] ? restore_args+0x0/0x30
Jan 30 13:48:17 mail kernel: [<ffffffff81064c26>] ? kthread+0x0/0x87
Jan 30 13:48:17 mail kernel: [<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10

--Boundary_(ID_S/WY06BssgOxbDGAmlN4Og)--
