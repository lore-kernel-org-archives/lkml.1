Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZHFTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZHFTq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZHFTq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:46:56 -0400
Received: from 216-235-106-HCC-115.hcc.net ([216.235.106.115]:34228 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZHFTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:46:44 -0400
Message-ID: <4A7B331E.8010703@howardsilvan.com>
Date: Thu, 06 Aug 2009 12:46:38 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: how to debug: BUG: soft lockup - CPU#3 stuck for 61s!]
References: <4A6F67E3.60201@howardsilvan.com> <200907282330.53059.rjw@sisk.pl> <4A6F7A51.8070601@howardsilvan.com>
In-Reply-To: <4A6F7A51.8070601@howardsilvan.com>
Content-Type: multipart/mixed;
 boundary="------------020005020808070306030808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020005020808070306030808
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Lee Howard wrote:
> Rafael J. Wysocki wrote:
>> On Tuesday 28 July 2009, Lee Howard wrote:
>>  
>>> I installed Fedora 11 and I'm getting the same thing there, too (kernel
>>> 2.6.29.6-213.fc11.x86_64).
>>>
>>> What can I do to help fix this?
>>>     
>>
>> Please test the last 2.6.30.y from kernel.org.  If the bug is still 
>> there, test
>> 2.6.31-rc4 or later.  If the bug is still there, please report it 
>> here or at
>> bugzilla.kernel.org.
>>
>> If the bug is not present in 2.6.30.y, try to find the commit that 
>> fixed it
>> (using git-bisect, but marking good commits as 'bad' and bad commits 
>> as 'good')
>> and point the Fedora kernel maintainer(s) to it.  Same for 2.6.31-rc4 
>> or later.
>
> Thank you for your reply.  I have now installed kernel 
> 2.6.31-0.94.rc4.fc12.x86_64 from Fedora development.  If the problem 
> continues I will report it.

The problem continues with 2.6.31-0.94.rc4.fc12.x86_64.  Please see the 
attached log text file which has the kernel messages.

Also note that the incident only occurred during "md: data-check of RAID 
array md2".  The soft lockups ended as soon as "md: md2: data-check done."

I don't monitor the list (too much traffic), so I kindly request that 
you include me directly in all replies with the list.

Thanks,

Lee.


--------------020005020808070306030808
Content-Type: text/plain;
 name="messages.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages.txt"

Aug  4 03:33:01 fangorn kernel: md: data-check of RAID array md0
Aug  4 03:33:01 fangorn kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Aug  4 03:33:01 fangorn kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Aug  4 03:33:01 fangorn kernel: md: using 128k window, over a total of 102336 blocks.
Aug  4 03:33:01 fangorn kernel: md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
Aug  4 03:33:01 fangorn kernel: md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
Aug  4 03:33:04 fangorn kernel: md: md0: data-check done.
Aug  4 03:33:04 fangorn kernel: md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
Aug  4 03:33:04 fangorn kernel: md: data-check of RAID array md1
Aug  4 03:33:04 fangorn kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Aug  4 03:33:04 fangorn kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Aug  4 03:33:04 fangorn kernel: md: using 128k window, over a total of 4095936 blocks.
Aug  4 03:34:34 fangorn kernel: md: md1: data-check done.
Aug  4 03:34:34 fangorn kernel: md: data-check of RAID array md2
Aug  4 03:34:34 fangorn kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Aug  4 03:34:34 fangorn kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Aug  4 03:34:34 fangorn kernel: md: using 128k window, over a total of 484185536 blocks.
Aug  4 03:35:39 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:35:39 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:35:39 fangorn kernel: irq event stamp: 781230972
Aug  4 03:35:39 fangorn kernel: hardirqs last  enabled at (781230971): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:35:39 fangorn kernel: hardirqs last disabled at (781230972): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:35:39 fangorn kernel: softirqs last  enabled at (781230554): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:35:39 fangorn kernel: softirqs last disabled at (781230503): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:35:39 fangorn kernel: CPU 1:
Aug  4 03:35:39 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:35:39 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:35:39 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 03:35:39 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 03:35:39 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:35:39 fangorn kernel: RDX: 00000000000005d8 RSI: ffff88003ad9ca28 RDI: ffff8800d64dfa28
Aug  4 03:35:39 fangorn kernel: RBP: ffffffff81013bee R08: ffff880083cc9740 R09: 0000000000000002
Aug  4 03:35:39 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:35:39 fangorn kernel: R13: ffff880083cc9740 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:35:39 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:35:39 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:35:39 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:35:39 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:35:39 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:35:39 fangorn kernel: Call Trace:
Aug  4 03:35:39 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:35:39 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:35:39 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:35:39 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:35:39 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:35:39 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:35:39 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:35:39 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:35:39 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:35:39 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:36:44 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:36:44 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:36:44 fangorn kernel: irq event stamp: 805690654
Aug  4 03:36:44 fangorn kernel: hardirqs last  enabled at (805690653): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:36:44 fangorn kernel: hardirqs last disabled at (805690654): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:36:44 fangorn kernel: softirqs last  enabled at (805690234): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:36:44 fangorn kernel: softirqs last disabled at (805690187): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:36:44 fangorn kernel: CPU 1:
Aug  4 03:36:44 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:36:44 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:36:44 fangorn kernel: RIP: 0010:[<ffffffff81277dfe>]  [<ffffffff81277dfe>] memcmp+0x2f/0x49
Aug  4 03:36:44 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 03:36:44 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:36:44 fangorn kernel: RDX: 00000000000002bf RSI: ffff880024c05d41 RDI: ffff88002027cd41
Aug  4 03:36:44 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801207fe808 R09: 0000000000000002
Aug  4 03:36:44 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:36:44 fangorn kernel: R13: ffff8801207fe808 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:36:44 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:36:44 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:36:44 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:36:44 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:36:44 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:36:44 fangorn kernel: Call Trace:
Aug  4 03:36:44 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:36:44 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:36:44 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:36:44 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:36:44 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:36:44 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:36:44 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:36:44 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:36:44 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:36:44 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:37:27 fangorn kernel: INFO: task pdflush:44 blocked for more than 120 seconds.
Aug  4 03:37:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:37:27 fangorn kernel: pdflush       D 0000000000000000  2800    44      2 0x00000000
Aug  4 03:37:27 fangorn kernel: ffff8801211f76c0 0000000000000082 ffff8801211f7630 ffffffff8109651e
Aug  4 03:37:27 fangorn kernel: ffff880120501c58 0000000011224523 0000000000000246 ffff880120501c40
Aug  4 03:37:27 fangorn kernel: ffff880121202890 000000000000fa20 ffff880121202890 00000000001d5bc0
Aug  4 03:37:27 fangorn kernel: Call Trace:
Aug  4 03:37:27 fangorn kernel: [<ffffffff8109651e>] ? trace_hardirqs_on_caller+0x139/0x175
Aug  4 03:37:27 fangorn kernel: [<ffffffff813ed825>] md_write_start+0x147/0x173
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffffa0003963>] make_request+0x46/0x68b [raid1]
Aug  4 03:37:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:37:27 fangorn kernel: [<ffffffff813ee602>] md_make_request+0xde/0x130
Aug  4 03:37:27 fangorn kernel: [<ffffffff81259918>] generic_make_request+0x29e/0x2fc
Aug  4 03:37:27 fangorn kernel: [<ffffffff81259a59>] submit_bio+0xe3/0x100
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116829d>] submit_bh+0x103/0x13c
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116af3c>] __block_write_full_page+0x1e5/0x2e3
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116de05>] ? blkdev_get_block+0x0/0x8d
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116b80d>] ? end_buffer_async_write+0x0/0x175
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116b80d>] ? end_buffer_async_write+0x0/0x175
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116de05>] ? blkdev_get_block+0x0/0x8d
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116b0d2>] block_write_full_page_endio+0x98/0xbb
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116b11d>] block_write_full_page+0x28/0x3e
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116ef50>] blkdev_writepage+0x2b/0x41
Aug  4 03:37:27 fangorn kernel: [<ffffffff81101378>] __writepage+0x29/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffff81101bc9>] write_cache_pages+0x27b/0x415
Aug  4 03:37:27 fangorn kernel: [<ffffffff8110134f>] ? __writepage+0x0/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffff8109747e>] ? __lock_acquire+0x33f/0xc0e
Aug  4 03:37:27 fangorn kernel: [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
Aug  4 03:37:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:37:27 fangorn kernel: [<ffffffff81101d9b>] generic_writepages+0x38/0x4e
Aug  4 03:37:27 fangorn kernel: [<ffffffff81101dee>] do_writepages+0x3d/0x63
Aug  4 03:37:27 fangorn kernel: [<ffffffff811625fd>] writeback_single_inode+0x169/0x29d
Aug  4 03:37:27 fangorn kernel: [<ffffffffa000010b>] ? __rcu_read_unlock+0x34/0x4a [raid1]
Aug  4 03:37:27 fangorn kernel: [<ffffffffa00005c1>] ? raid1_congested+0x9e/0xc4 [raid1]
Aug  4 03:37:27 fangorn kernel: [<ffffffff81162b89>] generic_sync_sb_inodes+0x21d/0x37f
Aug  4 03:37:27 fangorn kernel: [<ffffffff81162e3c>] ? writeback_inodes+0xa0/0x125
Aug  4 03:37:27 fangorn kernel: [<ffffffff81162e52>] writeback_inodes+0xb6/0x125
Aug  4 03:37:27 fangorn kernel: [<ffffffff81102027>] wb_kupdate+0xc0/0x147
Aug  4 03:37:27 fangorn kernel: [<ffffffff81102f7f>] ? pdflush+0x0/0x26c
Aug  4 03:37:27 fangorn kernel: [<ffffffff811030ef>] pdflush+0x170/0x26c
Aug  4 03:37:27 fangorn kernel: [<ffffffff81101f67>] ? wb_kupdate+0x0/0x147
Aug  4 03:37:27 fangorn kernel: [<ffffffff810816b9>] kthread+0xa5/0xad
Aug  4 03:37:27 fangorn kernel: [<ffffffff8101412a>] child_rip+0xa/0x20
Aug  4 03:37:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:37:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:37:27 fangorn kernel: 1 lock held by pdflush/44:
Aug  4 03:37:27 fangorn kernel: #0:  (&type->s_umount_key#24){.+.+..}, at: [<ffffffff81162e3c>] writeback_inodes+0xa0/0x125
Aug  4 03:37:27 fangorn kernel: INFO: task kjournald:117 blocked for more than 120 seconds.
Aug  4 03:37:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:37:27 fangorn kernel: kjournald     D 0000000000000000  3472   117      2 0x00000000
Aug  4 03:37:27 fangorn kernel: ffff8801201d5a20 0000000000000086 ffff8801201d5990 ffffffff8109651e
Aug  4 03:37:27 fangorn kernel: ffff880120501c58 000000007aea7e2a 0000000000000246 ffff880120501c40
Aug  4 03:37:27 fangorn kernel: ffff8801205783f0 000000000000fa20 ffff8801205783f0 00000000001d5bc0
Aug  4 03:37:27 fangorn kernel: Call Trace:
Aug  4 03:37:27 fangorn kernel: [<ffffffff8109651e>] ? trace_hardirqs_on_caller+0x139/0x175
Aug  4 03:37:27 fangorn kernel: [<ffffffff813ed825>] md_write_start+0x147/0x173
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffffa0003963>] make_request+0x46/0x68b [raid1]
Aug  4 03:37:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:37:27 fangorn kernel: [<ffffffff813ee602>] md_make_request+0xde/0x130
Aug  4 03:37:27 fangorn kernel: [<ffffffff81259918>] generic_make_request+0x29e/0x2fc
Aug  4 03:37:27 fangorn kernel: [<ffffffff81259a59>] submit_bio+0xe3/0x100
Aug  4 03:37:27 fangorn kernel: [<ffffffff8116829d>] submit_bh+0x103/0x13c
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f7796>] journal_do_submit_data+0x4f/0x73
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f7ead>] journal_commit_transaction+0x4b1/0xed4
Aug  4 03:37:27 fangorn kernel: [<ffffffff81072683>] ? try_to_del_timer_sync+0x5f/0x81
Aug  4 03:37:27 fangorn kernel: [<ffffffff81072c62>] ? del_timer_sync+0xa2/0xcb
Aug  4 03:37:27 fangorn kernel: [<ffffffff81072bc0>] ? del_timer_sync+0x0/0xcb
Aug  4 03:37:27 fangorn kernel: [<ffffffff811fc166>] kjournald+0x10b/0x273
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffff811fc05b>] ? kjournald+0x0/0x273
Aug  4 03:37:27 fangorn kernel: [<ffffffff810816b9>] kthread+0xa5/0xad
Aug  4 03:37:27 fangorn kernel: [<ffffffff8101412a>] child_rip+0xa/0x20
Aug  4 03:37:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:37:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:37:27 fangorn kernel: no locks held by kjournald/117.
Aug  4 03:37:27 fangorn kernel: INFO: task rsyslogd:27158 blocked for more than 120 seconds.
Aug  4 03:37:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:37:27 fangorn kernel: rsyslogd      D 0000000000000000  3848 27158      1 0x00000080
Aug  4 03:37:27 fangorn kernel: ffff880114e3d7c8 0000000000000086 ffff880114e3d728 ffffffff8108bc82
Aug  4 03:37:27 fangorn kernel: ffff880114e3d778 000000004e09c69b ffff880114e3d758 ffffffff8108c092
Aug  4 03:37:27 fangorn kernel: ffff880114fb03f0 000000000000fa20 ffff880114fb03f0 00000000001d5bc0
Aug  4 03:37:27 fangorn kernel: Call Trace:
Aug  4 03:37:27 fangorn kernel: [<ffffffff8108bc82>] ? clocksource_read+0x22/0x38
Aug  4 03:37:27 fangorn kernel: [<ffffffff8108c092>] ? getnstimeofday+0x6e/0xd8
Aug  4 03:37:27 fangorn kernel: [<ffffffff81085e99>] ? ktime_get_ts+0x61/0x7d
Aug  4 03:37:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:37:27 fangorn kernel: [<ffffffff814f7f68>] io_schedule+0x44/0x6b
Aug  4 03:37:27 fangorn kernel: [<ffffffff81169a17>] sync_buffer+0x56/0x6e
Aug  4 03:37:27 fangorn kernel: [<ffffffff814f85a3>] __wait_on_bit_lock+0x55/0xb2
Aug  4 03:37:27 fangorn kernel: [<ffffffff814f867d>] out_of_line_wait_on_bit_lock+0x7d/0x9c
Aug  4 03:37:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b66>] ? wake_bit_function+0x0/0x5a
Aug  4 03:37:27 fangorn kernel: [<ffffffff81169c56>] __lock_buffer+0x3d/0x53
Aug  4 03:37:27 fangorn kernel: [<ffffffff81169cb5>] lock_buffer+0x49/0x64
Aug  4 03:37:27 fangorn kernel: [<ffffffff81169d6b>] sync_dirty_buffer+0x40/0xbc
Aug  4 03:37:27 fangorn kernel: [<ffffffff814fa6fe>] ? _spin_unlock+0x3a/0x55
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f65fd>] journal_dirty_data+0xe0/0x1c9
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b1dab>] ext3_journal_dirty_data+0x2a/0x69
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b1e17>] journal_dirty_data_fn+0x2d/0x43
Aug  4 03:37:27 fangorn kernel: [<ffffffff811af4f4>] walk_page_buffers+0x70/0xba
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b1dea>] ? journal_dirty_data_fn+0x0/0x43
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b155b>] ext3_ordered_write_end+0x89/0x143
Aug  4 03:37:27 fangorn kernel: [<ffffffff810fa4fd>] generic_file_buffered_write+0x1bf/0x33c
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b0909>] ? ext3_dirty_inode+0x88/0xa7
Aug  4 03:37:27 fangorn kernel: [<ffffffff810faae9>] __generic_file_aio_write_nolock+0x287/0x2d3
Aug  4 03:37:27 fangorn kernel: [<ffffffff810faefe>] generic_file_aio_write+0x7b/0xef
Aug  4 03:37:27 fangorn kernel: [<ffffffff811ae192>] ext3_file_write+0x33/0xcd
Aug  4 03:37:27 fangorn kernel: [<ffffffff811415a5>] do_sync_write+0xfa/0x14b
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:37:27 fangorn kernel: [<ffffffff81223a64>] ? security_file_permission+0x29/0x3f
Aug  4 03:37:27 fangorn kernel: [<ffffffff81141c59>] vfs_write+0xbd/0x12e
Aug  4 03:37:27 fangorn kernel: [<ffffffff81142ec3>] ? fget_light+0x63/0xfd
Aug  4 03:37:27 fangorn kernel: [<ffffffff81141dbc>] sys_write+0x59/0x91
Aug  4 03:37:27 fangorn kernel: [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
Aug  4 03:37:27 fangorn kernel: 2 locks held by rsyslogd/27158:
Aug  4 03:37:27 fangorn kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810faee7>] generic_file_aio_write+0x64/0xef
Aug  4 03:37:27 fangorn kernel: #1:  (jbd_handle){+.+...}, at: [<ffffffff811f761e>] journal_start+0x103/0x144
Aug  4 03:37:27 fangorn kernel: INFO: task perl:2003 blocked for more than 120 seconds.
Aug  4 03:37:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:37:27 fangorn kernel: perl          D 0000000000000002  3032  2003      1 0x00000080
Aug  4 03:37:27 fangorn kernel: ffff880115c297e8 0000000000000082 ffff880115c29748 ffffffff8108bc82
Aug  4 03:37:27 fangorn kernel: ffff880115c29798 00000000547a2693 ffff880115c29778 ffffffff8108c092
Aug  4 03:37:27 fangorn kernel: ffff88011760a890 000000000000fa20 ffff88011760a890 00000000001d5bc0
Aug  4 03:37:27 fangorn kernel: Call Trace:
Aug  4 03:37:27 fangorn kernel: [<ffffffff8108bc82>] ? clocksource_read+0x22/0x38
Aug  4 03:37:27 fangorn kernel: [<ffffffff8108c092>] ? getnstimeofday+0x6e/0xd8
Aug  4 03:37:27 fangorn kernel: [<ffffffff81085e99>] ? ktime_get_ts+0x61/0x7d
Aug  4 03:37:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:37:27 fangorn kernel: [<ffffffff814f7f68>] io_schedule+0x44/0x6b
Aug  4 03:37:27 fangorn kernel: [<ffffffff81169a17>] sync_buffer+0x56/0x6e
Aug  4 03:37:27 fangorn kernel: [<ffffffff814f85a3>] __wait_on_bit_lock+0x55/0xb2
Aug  4 03:37:27 fangorn kernel: [<ffffffff814f867d>] out_of_line_wait_on_bit_lock+0x7d/0x9c
Aug  4 03:37:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b66>] ? wake_bit_function+0x0/0x5a
Aug  4 03:37:27 fangorn kernel: [<ffffffff81169c56>] __lock_buffer+0x3d/0x53
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f5cf5>] lock_buffer+0x49/0x64
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f68a6>] do_get_write_access+0x84/0x410
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f6c6c>] journal_get_write_access+0x3a/0x65
Aug  4 03:37:27 fangorn kernel: [<ffffffff811be4a9>] __ext3_journal_get_write_access+0x34/0x74
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b06a6>] ext3_reserve_inode_write+0x50/0xaa
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f763d>] ? journal_start+0x122/0x144
Aug  4 03:37:27 fangorn kernel: [<ffffffff811f761e>] ? journal_start+0x103/0x144
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b074f>] ext3_mark_inode_dirty+0x4f/0x80
Aug  4 03:37:27 fangorn kernel: [<ffffffff811b08fa>] ext3_dirty_inode+0x79/0xa7
Aug  4 03:37:27 fangorn kernel: [<ffffffff81162fda>] __mark_inode_dirty+0x43/0x10d
Aug  4 03:37:27 fangorn kernel: [<ffffffff81156fb2>] file_update_time+0xc3/0x118
Aug  4 03:37:27 fangorn kernel: [<ffffffff810fa9e4>] __generic_file_aio_write_nolock+0x182/0x2d3
Aug  4 03:37:27 fangorn kernel: [<ffffffff810faefe>] generic_file_aio_write+0x7b/0xef
Aug  4 03:37:27 fangorn kernel: [<ffffffff811ae192>] ext3_file_write+0x33/0xcd
Aug  4 03:37:27 fangorn kernel: [<ffffffff811415a5>] do_sync_write+0xfa/0x14b
Aug  4 03:37:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:37:27 fangorn kernel: [<ffffffff8114b37b>] ? mntput+0x30/0x46
Aug  4 03:37:27 fangorn kernel: [<ffffffff811460e4>] ? cp_new_stat+0xf9/0x11a
Aug  4 03:37:27 fangorn kernel: [<ffffffff81223a64>] ? security_file_permission+0x29/0x3f
Aug  4 03:37:27 fangorn kernel: [<ffffffff81141c59>] vfs_write+0xbd/0x12e
Aug  4 03:37:27 fangorn kernel: [<ffffffff81141dbc>] sys_write+0x59/0x91
Aug  4 03:37:27 fangorn kernel: [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
Aug  4 03:37:27 fangorn kernel: 2 locks held by perl/2003:
Aug  4 03:37:27 fangorn kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810faee7>] generic_file_aio_write+0x64/0xef
Aug  4 03:37:27 fangorn kernel: #1:  (jbd_handle){+.+...}, at: [<ffffffff811f761e>] journal_start+0x103/0x144
Aug  4 03:37:50 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:37:50 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:37:50 fangorn kernel: irq event stamp: 830281086
Aug  4 03:37:50 fangorn kernel: hardirqs last  enabled at (830281085): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:37:50 fangorn kernel: hardirqs last disabled at (830281086): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:37:50 fangorn kernel: softirqs last  enabled at (830280794): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:37:50 fangorn kernel: softirqs last disabled at (830280743): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:37:50 fangorn kernel: CPU 1:
Aug  4 03:37:50 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:37:50 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:37:50 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 03:37:50 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 03:37:50 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:37:50 fangorn kernel: RDX: 00000000000004dd RSI: ffff88011d359b23 RDI: ffff880043efdb23
Aug  4 03:37:50 fangorn kernel: RBP: ffffffff81013bee R08: ffff880117969358 R09: 0000000000000002
Aug  4 03:37:50 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 03:37:50 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 03:37:50 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:37:50 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:37:50 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:37:50 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:37:50 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:37:50 fangorn kernel: Call Trace:
Aug  4 03:37:50 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:37:50 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:37:50 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:37:50 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:37:50 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:37:50 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:37:50 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:37:50 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:37:50 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:37:50 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:38:55 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:38:55 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:38:55 fangorn kernel: irq event stamp: 854920248
Aug  4 03:38:55 fangorn kernel: hardirqs last  enabled at (854920247): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:38:55 fangorn kernel: hardirqs last disabled at (854920248): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:38:55 fangorn kernel: softirqs last  enabled at (854920246): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:38:55 fangorn kernel: softirqs last disabled at (854920219): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:38:55 fangorn kernel: CPU 1:
Aug  4 03:38:55 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:38:55 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:38:55 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 03:38:55 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 03:38:55 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:38:55 fangorn kernel: RDX: 0000000000000ef5 RSI: ffff8800d505d10b RDI: ffff8800b559510b
Aug  4 03:38:55 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801201324e8 R09: 0000000000000003
Aug  4 03:38:55 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 03:38:55 fangorn kernel: R13: ffff8801201324e8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:38:55 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:38:55 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:38:55 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:38:55 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:38:55 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:38:55 fangorn kernel: Call Trace:
Aug  4 03:38:55 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:38:55 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:38:55 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:38:55 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:38:55 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:38:55 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:38:55 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:38:55 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:38:55 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:38:55 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:39:27 fangorn kernel: INFO: task pdflush:44 blocked for more than 120 seconds.
Aug  4 03:39:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:39:27 fangorn kernel: pdflush       D 0000000000000000  2800    44      2 0x00000000
Aug  4 03:39:27 fangorn kernel: ffff8801211f76c0 0000000000000082 ffff8801211f7630 ffffffff8109651e
Aug  4 03:39:27 fangorn kernel: ffff880120501c58 0000000011224523 0000000000000246 ffff880120501c40
Aug  4 03:39:27 fangorn kernel: ffff880121202890 000000000000fa20 ffff880121202890 00000000001d5bc0
Aug  4 03:39:27 fangorn kernel: Call Trace:
Aug  4 03:39:27 fangorn kernel: [<ffffffff8109651e>] ? trace_hardirqs_on_caller+0x139/0x175
Aug  4 03:39:27 fangorn kernel: [<ffffffff813ed825>] md_write_start+0x147/0x173
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffffa0003963>] make_request+0x46/0x68b [raid1]
Aug  4 03:39:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:39:27 fangorn kernel: [<ffffffff813ee602>] md_make_request+0xde/0x130
Aug  4 03:39:27 fangorn kernel: [<ffffffff81259918>] generic_make_request+0x29e/0x2fc
Aug  4 03:39:27 fangorn kernel: [<ffffffff81259a59>] submit_bio+0xe3/0x100
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116829d>] submit_bh+0x103/0x13c
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116af3c>] __block_write_full_page+0x1e5/0x2e3
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116de05>] ? blkdev_get_block+0x0/0x8d
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116b80d>] ? end_buffer_async_write+0x0/0x175
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116b80d>] ? end_buffer_async_write+0x0/0x175
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116de05>] ? blkdev_get_block+0x0/0x8d
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116b0d2>] block_write_full_page_endio+0x98/0xbb
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116b11d>] block_write_full_page+0x28/0x3e
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116ef50>] blkdev_writepage+0x2b/0x41
Aug  4 03:39:27 fangorn kernel: [<ffffffff81101378>] __writepage+0x29/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffff81101bc9>] write_cache_pages+0x27b/0x415
Aug  4 03:39:27 fangorn kernel: [<ffffffff8110134f>] ? __writepage+0x0/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffff8109747e>] ? __lock_acquire+0x33f/0xc0e
Aug  4 03:39:27 fangorn kernel: [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
Aug  4 03:39:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:39:27 fangorn kernel: [<ffffffff81101d9b>] generic_writepages+0x38/0x4e
Aug  4 03:39:27 fangorn kernel: [<ffffffff81101dee>] do_writepages+0x3d/0x63
Aug  4 03:39:27 fangorn kernel: [<ffffffff811625fd>] writeback_single_inode+0x169/0x29d
Aug  4 03:39:27 fangorn kernel: [<ffffffffa000010b>] ? __rcu_read_unlock+0x34/0x4a [raid1]
Aug  4 03:39:27 fangorn kernel: [<ffffffffa00005c1>] ? raid1_congested+0x9e/0xc4 [raid1]
Aug  4 03:39:27 fangorn kernel: [<ffffffff81162b89>] generic_sync_sb_inodes+0x21d/0x37f
Aug  4 03:39:27 fangorn kernel: [<ffffffff81162e3c>] ? writeback_inodes+0xa0/0x125
Aug  4 03:39:27 fangorn kernel: [<ffffffff81162e52>] writeback_inodes+0xb6/0x125
Aug  4 03:39:27 fangorn kernel: [<ffffffff81102027>] wb_kupdate+0xc0/0x147
Aug  4 03:39:27 fangorn kernel: [<ffffffff81102f7f>] ? pdflush+0x0/0x26c
Aug  4 03:39:27 fangorn kernel: [<ffffffff811030ef>] pdflush+0x170/0x26c
Aug  4 03:39:27 fangorn kernel: [<ffffffff81101f67>] ? wb_kupdate+0x0/0x147
Aug  4 03:39:27 fangorn kernel: [<ffffffff810816b9>] kthread+0xa5/0xad
Aug  4 03:39:27 fangorn kernel: [<ffffffff8101412a>] child_rip+0xa/0x20
Aug  4 03:39:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:39:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:39:27 fangorn kernel: 1 lock held by pdflush/44:
Aug  4 03:39:27 fangorn kernel: #0:  (&type->s_umount_key#24){.+.+..}, at: [<ffffffff81162e3c>] writeback_inodes+0xa0/0x125
Aug  4 03:39:27 fangorn kernel: INFO: task kjournald:117 blocked for more than 120 seconds.
Aug  4 03:39:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:39:27 fangorn kernel: kjournald     D 0000000000000000  3472   117      2 0x00000000
Aug  4 03:39:27 fangorn kernel: ffff8801201d5a20 0000000000000086 ffff8801201d5990 ffffffff8109651e
Aug  4 03:39:27 fangorn kernel: ffff880120501c58 000000007aea7e2a 0000000000000246 ffff880120501c40
Aug  4 03:39:27 fangorn kernel: ffff8801205783f0 000000000000fa20 ffff8801205783f0 00000000001d5bc0
Aug  4 03:39:27 fangorn kernel: Call Trace:
Aug  4 03:39:27 fangorn kernel: [<ffffffff8109651e>] ? trace_hardirqs_on_caller+0x139/0x175
Aug  4 03:39:27 fangorn kernel: [<ffffffff813ed825>] md_write_start+0x147/0x173
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffffa0003963>] make_request+0x46/0x68b [raid1]
Aug  4 03:39:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:39:27 fangorn kernel: [<ffffffff813ee602>] md_make_request+0xde/0x130
Aug  4 03:39:27 fangorn kernel: [<ffffffff81259918>] generic_make_request+0x29e/0x2fc
Aug  4 03:39:27 fangorn kernel: [<ffffffff81259a59>] submit_bio+0xe3/0x100
Aug  4 03:39:27 fangorn kernel: [<ffffffff8116829d>] submit_bh+0x103/0x13c
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f7796>] journal_do_submit_data+0x4f/0x73
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f7ead>] journal_commit_transaction+0x4b1/0xed4
Aug  4 03:39:27 fangorn kernel: [<ffffffff81072683>] ? try_to_del_timer_sync+0x5f/0x81
Aug  4 03:39:27 fangorn kernel: [<ffffffff81072c62>] ? del_timer_sync+0xa2/0xcb
Aug  4 03:39:27 fangorn kernel: [<ffffffff81072bc0>] ? del_timer_sync+0x0/0xcb
Aug  4 03:39:27 fangorn kernel: [<ffffffff811fc166>] kjournald+0x10b/0x273
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffff811fc05b>] ? kjournald+0x0/0x273
Aug  4 03:39:27 fangorn kernel: [<ffffffff810816b9>] kthread+0xa5/0xad
Aug  4 03:39:27 fangorn kernel: [<ffffffff8101412a>] child_rip+0xa/0x20
Aug  4 03:39:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:39:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:39:27 fangorn kernel: no locks held by kjournald/117.
Aug  4 03:39:27 fangorn kernel: INFO: task rsyslogd:27158 blocked for more than 120 seconds.
Aug  4 03:39:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:39:27 fangorn kernel: rsyslogd      D 0000000000000000  3848 27158      1 0x00000080
Aug  4 03:39:27 fangorn kernel: ffff880114e3d7c8 0000000000000086 ffff880114e3d728 ffffffff8108bc82
Aug  4 03:39:27 fangorn kernel: ffff880114e3d778 000000004e09c69b ffff880114e3d758 ffffffff8108c092
Aug  4 03:39:27 fangorn kernel: ffff880114fb03f0 000000000000fa20 ffff880114fb03f0 00000000001d5bc0
Aug  4 03:39:27 fangorn kernel: Call Trace:
Aug  4 03:39:27 fangorn kernel: [<ffffffff8108bc82>] ? clocksource_read+0x22/0x38
Aug  4 03:39:27 fangorn kernel: [<ffffffff8108c092>] ? getnstimeofday+0x6e/0xd8
Aug  4 03:39:27 fangorn kernel: [<ffffffff81085e99>] ? ktime_get_ts+0x61/0x7d
Aug  4 03:39:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:39:27 fangorn kernel: [<ffffffff814f7f68>] io_schedule+0x44/0x6b
Aug  4 03:39:27 fangorn kernel: [<ffffffff81169a17>] sync_buffer+0x56/0x6e
Aug  4 03:39:27 fangorn kernel: [<ffffffff814f85a3>] __wait_on_bit_lock+0x55/0xb2
Aug  4 03:39:27 fangorn kernel: [<ffffffff814f867d>] out_of_line_wait_on_bit_lock+0x7d/0x9c
Aug  4 03:39:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b66>] ? wake_bit_function+0x0/0x5a
Aug  4 03:39:27 fangorn kernel: [<ffffffff81169c56>] __lock_buffer+0x3d/0x53
Aug  4 03:39:27 fangorn kernel: [<ffffffff81169cb5>] lock_buffer+0x49/0x64
Aug  4 03:39:27 fangorn kernel: [<ffffffff81169d6b>] sync_dirty_buffer+0x40/0xbc
Aug  4 03:39:27 fangorn kernel: [<ffffffff814fa6fe>] ? _spin_unlock+0x3a/0x55
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f65fd>] journal_dirty_data+0xe0/0x1c9
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b1dab>] ext3_journal_dirty_data+0x2a/0x69
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b1e17>] journal_dirty_data_fn+0x2d/0x43
Aug  4 03:39:27 fangorn kernel: [<ffffffff811af4f4>] walk_page_buffers+0x70/0xba
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b1dea>] ? journal_dirty_data_fn+0x0/0x43
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b155b>] ext3_ordered_write_end+0x89/0x143
Aug  4 03:39:27 fangorn kernel: [<ffffffff810fa4fd>] generic_file_buffered_write+0x1bf/0x33c
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b0909>] ? ext3_dirty_inode+0x88/0xa7
Aug  4 03:39:27 fangorn kernel: [<ffffffff810faae9>] __generic_file_aio_write_nolock+0x287/0x2d3
Aug  4 03:39:27 fangorn kernel: [<ffffffff810faefe>] generic_file_aio_write+0x7b/0xef
Aug  4 03:39:27 fangorn kernel: [<ffffffff811ae192>] ext3_file_write+0x33/0xcd
Aug  4 03:39:27 fangorn kernel: [<ffffffff811415a5>] do_sync_write+0xfa/0x14b
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:39:27 fangorn kernel: [<ffffffff81223a64>] ? security_file_permission+0x29/0x3f
Aug  4 03:39:27 fangorn kernel: [<ffffffff81141c59>] vfs_write+0xbd/0x12e
Aug  4 03:39:27 fangorn kernel: [<ffffffff81142ec3>] ? fget_light+0x63/0xfd
Aug  4 03:39:27 fangorn kernel: [<ffffffff81141dbc>] sys_write+0x59/0x91
Aug  4 03:39:27 fangorn kernel: [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
Aug  4 03:39:27 fangorn kernel: 2 locks held by rsyslogd/27158:
Aug  4 03:39:27 fangorn kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810faee7>] generic_file_aio_write+0x64/0xef
Aug  4 03:39:27 fangorn kernel: #1:  (jbd_handle){+.+...}, at: [<ffffffff811f761e>] journal_start+0x103/0x144
Aug  4 03:39:27 fangorn kernel: INFO: task perl:2003 blocked for more than 120 seconds.
Aug  4 03:39:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:39:27 fangorn kernel: perl          D 0000000000000002  3032  2003      1 0x00000080
Aug  4 03:39:27 fangorn kernel: ffff880115c297e8 0000000000000082 ffff880115c29748 ffffffff8108bc82
Aug  4 03:39:27 fangorn kernel: ffff880115c29798 00000000547a2693 ffff880115c29778 ffffffff8108c092
Aug  4 03:39:27 fangorn kernel: ffff88011760a890 000000000000fa20 ffff88011760a890 00000000001d5bc0
Aug  4 03:39:27 fangorn kernel: Call Trace:
Aug  4 03:39:27 fangorn kernel: [<ffffffff8108bc82>] ? clocksource_read+0x22/0x38
Aug  4 03:39:27 fangorn kernel: [<ffffffff8108c092>] ? getnstimeofday+0x6e/0xd8
Aug  4 03:39:27 fangorn kernel: [<ffffffff81085e99>] ? ktime_get_ts+0x61/0x7d
Aug  4 03:39:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:39:27 fangorn kernel: [<ffffffff814f7f68>] io_schedule+0x44/0x6b
Aug  4 03:39:27 fangorn kernel: [<ffffffff81169a17>] sync_buffer+0x56/0x6e
Aug  4 03:39:27 fangorn kernel: [<ffffffff814f85a3>] __wait_on_bit_lock+0x55/0xb2
Aug  4 03:39:27 fangorn kernel: [<ffffffff814f867d>] out_of_line_wait_on_bit_lock+0x7d/0x9c
Aug  4 03:39:27 fangorn kernel: [<ffffffff811699c1>] ? sync_buffer+0x0/0x6e
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b66>] ? wake_bit_function+0x0/0x5a
Aug  4 03:39:27 fangorn kernel: [<ffffffff81169c56>] __lock_buffer+0x3d/0x53
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f5cf5>] lock_buffer+0x49/0x64
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f68a6>] do_get_write_access+0x84/0x410
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f6c6c>] journal_get_write_access+0x3a/0x65
Aug  4 03:39:27 fangorn kernel: [<ffffffff811be4a9>] __ext3_journal_get_write_access+0x34/0x74
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b06a6>] ext3_reserve_inode_write+0x50/0xaa
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f763d>] ? journal_start+0x122/0x144
Aug  4 03:39:27 fangorn kernel: [<ffffffff811f761e>] ? journal_start+0x103/0x144
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b074f>] ext3_mark_inode_dirty+0x4f/0x80
Aug  4 03:39:27 fangorn kernel: [<ffffffff811b08fa>] ext3_dirty_inode+0x79/0xa7
Aug  4 03:39:27 fangorn kernel: [<ffffffff81162fda>] __mark_inode_dirty+0x43/0x10d
Aug  4 03:39:27 fangorn kernel: [<ffffffff81156fb2>] file_update_time+0xc3/0x118
Aug  4 03:39:27 fangorn kernel: [<ffffffff810fa9e4>] __generic_file_aio_write_nolock+0x182/0x2d3
Aug  4 03:39:27 fangorn kernel: [<ffffffff810faefe>] generic_file_aio_write+0x7b/0xef
Aug  4 03:39:27 fangorn kernel: [<ffffffff811ae192>] ext3_file_write+0x33/0xcd
Aug  4 03:39:27 fangorn kernel: [<ffffffff811415a5>] do_sync_write+0xfa/0x14b
Aug  4 03:39:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:39:27 fangorn kernel: [<ffffffff8114b37b>] ? mntput+0x30/0x46
Aug  4 03:39:27 fangorn kernel: [<ffffffff811460e4>] ? cp_new_stat+0xf9/0x11a
Aug  4 03:39:27 fangorn kernel: [<ffffffff81223a64>] ? security_file_permission+0x29/0x3f
Aug  4 03:39:27 fangorn kernel: [<ffffffff81141c59>] vfs_write+0xbd/0x12e
Aug  4 03:39:27 fangorn kernel: [<ffffffff81141dbc>] sys_write+0x59/0x91
Aug  4 03:39:27 fangorn kernel: [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
Aug  4 03:39:27 fangorn kernel: 2 locks held by perl/2003:
Aug  4 03:39:27 fangorn kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810faee7>] generic_file_aio_write+0x64/0xef
Aug  4 03:39:27 fangorn kernel: #1:  (jbd_handle){+.+...}, at: [<ffffffff811f761e>] journal_start+0x103/0x144
Aug  4 03:40:01 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:40:01 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:40:01 fangorn kernel: irq event stamp: 879736312
Aug  4 03:40:01 fangorn kernel: hardirqs last  enabled at (879736311): [<ffffffff810ffd7b>] free_hot_cold_page+0x1b7/0x1e5
Aug  4 03:40:01 fangorn kernel: hardirqs last disabled at (879736312): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:40:01 fangorn kernel: softirqs last  enabled at (879735936): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:40:01 fangorn kernel: softirqs last disabled at (879735885): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:40:01 fangorn kernel: CPU 1:
Aug  4 03:40:01 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:40:01 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:40:01 fangorn kernel: RIP: 0010:[<ffffffff810ffd81>]  [<ffffffff810ffd81>] free_hot_cold_page+0x1bd/0x1e5
Aug  4 03:40:01 fangorn kernel: RSP: 0018:ffff880120709b70  EFLAGS: 00000246
Aug  4 03:40:01 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709bc0 RCX: 00000000000000f0
Aug  4 03:40:01 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000246
Aug  4 03:40:01 fangorn kernel: RBP: ffffffff81013bee R08: 0000000000000000 R09: 000000009cc9ebcb
Aug  4 03:40:01 fangorn kernel: R10: ffffffff81dcc6f0 R11: 0000000000000000 R12: 0000000000000000
Aug  4 03:40:01 fangorn kernel: R13: ffffffff814fa6fe R14: ffff880120709b00 R15: ffff8800000156d0
Aug  4 03:40:01 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:40:01 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:40:01 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:40:01 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:40:01 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:40:01 fangorn kernel: Call Trace:
Aug  4 03:40:01 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 03:40:01 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 03:40:01 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 03:40:01 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 03:40:01 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 03:40:01 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 03:40:01 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:40:01 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:40:01 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:40:01 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:40:01 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:40:01 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:40:01 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:40:01 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:40:01 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:41:06 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:41:06 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:41:06 fangorn kernel: irq event stamp: 904237882
Aug  4 03:41:06 fangorn kernel: hardirqs last  enabled at (904237881): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:41:06 fangorn kernel: hardirqs last disabled at (904237882): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:41:06 fangorn kernel: softirqs last  enabled at (904237862): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:41:06 fangorn kernel: softirqs last disabled at (904237837): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:41:06 fangorn kernel: CPU 1:
Aug  4 03:41:06 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:41:06 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:41:06 fangorn kernel: RIP: 0010:[<ffffffff81277df8>]  [<ffffffff81277df8>] memcmp+0x29/0x49
Aug  4 03:41:06 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000282
Aug  4 03:41:06 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:41:06 fangorn kernel: RDX: 00000000000000aa RSI: ffff8800b56eef57 RDI: ffff880004794f57
Aug  4 03:41:06 fangorn kernel: RBP: ffffffff81013bee R08: ffff880083cc9b28 R09: 0000000000000002
Aug  4 03:41:06 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 03:41:06 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 03:41:06 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:41:06 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:41:06 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:41:06 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:41:06 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:41:06 fangorn kernel: Call Trace:
Aug  4 03:41:06 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:41:06 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:41:06 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:41:06 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:41:06 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:41:06 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:41:06 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:41:06 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:41:06 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:41:06 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:41:27 fangorn kernel: INFO: task pdflush:44 blocked for more than 120 seconds.
Aug  4 03:41:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:41:27 fangorn kernel: pdflush       D 0000000000000000  2800    44      2 0x00000000
Aug  4 03:41:27 fangorn kernel: ffff8801211f76c0 0000000000000082 ffff8801211f7630 ffffffff8109651e
Aug  4 03:41:27 fangorn kernel: ffff880120501c58 0000000011224523 0000000000000246 ffff880120501c40
Aug  4 03:41:27 fangorn kernel: ffff880121202890 000000000000fa20 ffff880121202890 00000000001d5bc0
Aug  4 03:41:27 fangorn kernel: Call Trace:
Aug  4 03:41:27 fangorn kernel: [<ffffffff8109651e>] ? trace_hardirqs_on_caller+0x139/0x175
Aug  4 03:41:27 fangorn kernel: [<ffffffff813ed825>] md_write_start+0x147/0x173
Aug  4 03:41:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:41:27 fangorn kernel: [<ffffffffa0003963>] make_request+0x46/0x68b [raid1]
Aug  4 03:41:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:41:27 fangorn kernel: [<ffffffff813ee602>] md_make_request+0xde/0x130
Aug  4 03:41:27 fangorn kernel: [<ffffffff81259918>] generic_make_request+0x29e/0x2fc
Aug  4 03:41:27 fangorn kernel: [<ffffffff81259a59>] submit_bio+0xe3/0x100
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116829d>] submit_bh+0x103/0x13c
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116af3c>] __block_write_full_page+0x1e5/0x2e3
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116de05>] ? blkdev_get_block+0x0/0x8d
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116b80d>] ? end_buffer_async_write+0x0/0x175
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116b80d>] ? end_buffer_async_write+0x0/0x175
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116de05>] ? blkdev_get_block+0x0/0x8d
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116b0d2>] block_write_full_page_endio+0x98/0xbb
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116b11d>] block_write_full_page+0x28/0x3e
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116ef50>] blkdev_writepage+0x2b/0x41
Aug  4 03:41:27 fangorn kernel: [<ffffffff81101378>] __writepage+0x29/0x5f
Aug  4 03:41:27 fangorn kernel: [<ffffffff81101bc9>] write_cache_pages+0x27b/0x415
Aug  4 03:41:27 fangorn kernel: [<ffffffff8110134f>] ? __writepage+0x0/0x5f
Aug  4 03:41:27 fangorn kernel: [<ffffffff8109747e>] ? __lock_acquire+0x33f/0xc0e
Aug  4 03:41:27 fangorn kernel: [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
Aug  4 03:41:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:41:27 fangorn kernel: [<ffffffff81101d9b>] generic_writepages+0x38/0x4e
Aug  4 03:41:27 fangorn kernel: [<ffffffff81101dee>] do_writepages+0x3d/0x63
Aug  4 03:41:27 fangorn kernel: [<ffffffff811625fd>] writeback_single_inode+0x169/0x29d
Aug  4 03:41:27 fangorn kernel: [<ffffffffa000010b>] ? __rcu_read_unlock+0x34/0x4a [raid1]
Aug  4 03:41:27 fangorn kernel: [<ffffffffa00005c1>] ? raid1_congested+0x9e/0xc4 [raid1]
Aug  4 03:41:27 fangorn kernel: [<ffffffff81162b89>] generic_sync_sb_inodes+0x21d/0x37f
Aug  4 03:41:27 fangorn kernel: [<ffffffff81162e3c>] ? writeback_inodes+0xa0/0x125
Aug  4 03:41:27 fangorn kernel: [<ffffffff81162e52>] writeback_inodes+0xb6/0x125
Aug  4 03:41:27 fangorn kernel: [<ffffffff81102027>] wb_kupdate+0xc0/0x147
Aug  4 03:41:27 fangorn kernel: [<ffffffff81102f7f>] ? pdflush+0x0/0x26c
Aug  4 03:41:27 fangorn kernel: [<ffffffff811030ef>] pdflush+0x170/0x26c
Aug  4 03:41:27 fangorn kernel: [<ffffffff81101f67>] ? wb_kupdate+0x0/0x147
Aug  4 03:41:27 fangorn kernel: [<ffffffff810816b9>] kthread+0xa5/0xad
Aug  4 03:41:27 fangorn kernel: [<ffffffff8101412a>] child_rip+0xa/0x20
Aug  4 03:41:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:41:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:41:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:41:27 fangorn kernel: 1 lock held by pdflush/44:
Aug  4 03:41:27 fangorn kernel: #0:  (&type->s_umount_key#24){.+.+..}, at: [<ffffffff81162e3c>] writeback_inodes+0xa0/0x125
Aug  4 03:41:27 fangorn kernel: INFO: task kjournald:117 blocked for more than 120 seconds.
Aug  4 03:41:27 fangorn kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 03:41:27 fangorn kernel: kjournald     D 0000000000000000  3472   117      2 0x00000000
Aug  4 03:41:27 fangorn kernel: ffff8801201d5a20 0000000000000086 ffff8801201d5990 ffffffff8109651e
Aug  4 03:41:27 fangorn kernel: ffff880120501c58 000000007aea7e2a 0000000000000246 ffff880120501c40
Aug  4 03:41:27 fangorn kernel: ffff8801205783f0 000000000000fa20 ffff8801205783f0 00000000001d5bc0
Aug  4 03:41:27 fangorn kernel: Call Trace:
Aug  4 03:41:27 fangorn kernel: [<ffffffff8109651e>] ? trace_hardirqs_on_caller+0x139/0x175
Aug  4 03:41:27 fangorn kernel: [<ffffffff813ed825>] md_write_start+0x147/0x173
Aug  4 03:41:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:41:27 fangorn kernel: [<ffffffffa0003963>] make_request+0x46/0x68b [raid1]
Aug  4 03:41:27 fangorn kernel: [<ffffffff81094949>] ? lock_release_holdtime+0x3f/0x146
Aug  4 03:41:27 fangorn kernel: [<ffffffff813ee602>] md_make_request+0xde/0x130
Aug  4 03:41:27 fangorn kernel: [<ffffffff81259918>] generic_make_request+0x29e/0x2fc
Aug  4 03:41:27 fangorn kernel: [<ffffffff81259a59>] submit_bio+0xe3/0x100
Aug  4 03:41:27 fangorn kernel: [<ffffffff8116829d>] submit_bh+0x103/0x13c
Aug  4 03:41:27 fangorn kernel: [<ffffffff811f7796>] journal_do_submit_data+0x4f/0x73
Aug  4 03:41:27 fangorn kernel: [<ffffffff811f7ead>] journal_commit_transaction+0x4b1/0xed4
Aug  4 03:41:27 fangorn kernel: [<ffffffff81072683>] ? try_to_del_timer_sync+0x5f/0x81
Aug  4 03:41:27 fangorn kernel: [<ffffffff81072c62>] ? del_timer_sync+0xa2/0xcb
Aug  4 03:41:27 fangorn kernel: [<ffffffff81072bc0>] ? del_timer_sync+0x0/0xcb
Aug  4 03:41:27 fangorn kernel: [<ffffffff811fc166>] kjournald+0x10b/0x273
Aug  4 03:41:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:41:27 fangorn kernel: [<ffffffff811fc05b>] ? kjournald+0x0/0x273
Aug  4 03:41:27 fangorn kernel: [<ffffffff810816b9>] kthread+0xa5/0xad
Aug  4 03:41:27 fangorn kernel: [<ffffffff8101412a>] child_rip+0xa/0x20
Aug  4 03:41:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:41:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:41:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:41:27 fangorn kernel: no locks held by kjournald/117.
Aug  4 03:42:12 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:42:12 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:42:12 fangorn kernel: irq event stamp: 929107698
Aug  4 03:42:12 fangorn kernel: hardirqs last  enabled at (929107697): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:42:12 fangorn kernel: hardirqs last disabled at (929107698): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:42:12 fangorn kernel: softirqs last  enabled at (929107558): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:42:12 fangorn kernel: softirqs last disabled at (929107507): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:42:12 fangorn kernel: CPU 1:
Aug  4 03:42:12 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:42:12 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:42:12 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 03:42:12 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 03:42:12 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 03:42:12 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 03:42:12 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff825d1d38 R09: 000000009cc9ebcb
Aug  4 03:42:12 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 03:42:12 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 03:42:12 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:42:12 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:42:12 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:42:12 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:42:12 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:42:12 fangorn kernel: Call Trace:
Aug  4 03:42:12 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 03:42:12 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 03:42:12 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 03:42:12 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 03:42:12 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 03:42:12 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 03:42:12 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 03:42:12 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 03:42:12 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:42:12 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:42:12 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:42:12 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:42:12 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:42:12 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:42:12 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:42:12 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:42:12 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:43:17 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:43:17 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:43:17 fangorn kernel: irq event stamp: 953861484
Aug  4 03:43:17 fangorn kernel: hardirqs last  enabled at (953861483): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:43:17 fangorn kernel: hardirqs last disabled at (953861484): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:43:17 fangorn kernel: softirqs last  enabled at (953861064): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:43:17 fangorn kernel: softirqs last disabled at (953860999): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:43:17 fangorn kernel: CPU 1:
Aug  4 03:43:17 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:43:17 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:43:17 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 03:43:17 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 03:43:17 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:43:17 fangorn kernel: RDX: 0000000000000a12 RSI: ffff88001e46b5ee RDI: ffff8800d48055ee
Aug  4 03:43:17 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801207fea60 R09: 0000000000000002
Aug  4 03:43:17 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:43:17 fangorn kernel: R13: ffff8801207fea60 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:43:17 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:43:17 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:43:17 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:43:17 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:43:17 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:43:17 fangorn kernel: Call Trace:
Aug  4 03:43:17 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:43:17 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:43:17 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:43:17 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:43:17 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:43:17 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:43:17 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:43:17 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:43:17 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:43:17 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:44:23 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:44:23 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:44:23 fangorn kernel: irq event stamp: 978371291
Aug  4 03:44:23 fangorn kernel: hardirqs last  enabled at (978371290): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:44:23 fangorn kernel: hardirqs last disabled at (978371291): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:44:23 fangorn kernel: softirqs last  enabled at (978371248): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:44:23 fangorn kernel: softirqs last disabled at (978371257): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:44:23 fangorn kernel: CPU 1:
Aug  4 03:44:23 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:44:23 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:44:23 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 03:44:23 fangorn kernel: RSP: 0018:ffff88002f1e1bb0  EFLAGS: 00000246
Aug  4 03:44:23 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1bd0 RCX: 00000000000000d9
Aug  4 03:44:23 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f1e1b50 RDI: 0000000000000246
Aug  4 03:44:23 fangorn kernel: RBP: ffffffff81013bf3 R08: ffffffff817744f0 R09: 000000009cc9ebcb
Aug  4 03:44:23 fangorn kernel: R10: 000000005f86038f R11: ffffffff8260a8c8 R12: ffff88002f1e1b30
Aug  4 03:44:23 fangorn kernel: R13: ffffffff817744d8 R14: 0000000000000246 R15: 000000009cc9ebcb
Aug  4 03:44:23 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:44:23 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:44:23 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:44:23 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:44:23 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:44:23 fangorn kernel: Call Trace:
Aug  4 03:44:23 fangorn kernel: <IRQ>  [<ffffffff81310151>] ? mix_pool_bytes_extract+0x14f/0x172
Aug  4 03:44:23 fangorn kernel: [<ffffffff813104e0>] ? add_timer_randomness+0x8b/0x135
Aug  4 03:44:23 fangorn kernel: [<ffffffff813105cb>] ? add_disk_randomness+0x41/0x57
Aug  4 03:44:23 fangorn kernel: [<ffffffff81259452>] ? blk_update_bidi_request+0x5a/0x7f
Aug  4 03:44:23 fangorn kernel: [<ffffffff8125b2da>] ? blk_end_bidi_request+0x32/0x88
Aug  4 03:44:23 fangorn kernel: [<ffffffff8125b3a6>] ? blk_end_request+0x23/0x39
Aug  4 03:44:23 fangorn kernel: [<ffffffff8135e16f>] ? scsi_io_completion+0x1b4/0x439
Aug  4 03:44:23 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 03:44:23 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 03:44:23 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 03:44:23 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 03:44:23 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 03:44:23 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 03:44:23 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 03:44:23 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 03:44:23 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 03:44:23 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 03:44:23 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 03:44:23 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:44:23 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:44:23 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:44:23 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:44:23 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:44:23 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:44:23 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:44:23 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:44:23 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:44:23 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:46:02 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:46:02 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:46:02 fangorn kernel: irq event stamp: 1014545329
Aug  4 03:46:02 fangorn kernel: hardirqs last  enabled at (1014545328): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 03:46:02 fangorn kernel: hardirqs last disabled at (1014545329): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:46:02 fangorn kernel: softirqs last  enabled at (1014545022): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:46:02 fangorn kernel: softirqs last disabled at (1014545327): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:46:02 fangorn kernel: CPU 1:
Aug  4 03:46:02 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:46:02 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:46:02 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 03:46:02 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 03:46:02 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 03:46:02 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 03:46:02 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 03:46:02 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 03:46:02 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 03:46:02 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:46:02 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:46:02 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:46:02 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:46:02 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:46:02 fangorn kernel: Call Trace:
Aug  4 03:46:02 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 03:46:02 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 03:46:02 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 03:46:02 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 03:46:02 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 03:46:02 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 03:46:02 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 03:46:02 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:46:02 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:46:02 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:46:02 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:46:02 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:46:02 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:46:02 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:46:02 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:46:02 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:46:02 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:47:07 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:47:07 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:47:07 fangorn kernel: irq event stamp: 1039052929
Aug  4 03:47:07 fangorn kernel: hardirqs last  enabled at (1039052928): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 03:47:07 fangorn kernel: hardirqs last disabled at (1039052929): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:47:07 fangorn kernel: softirqs last  enabled at (1039052536): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:47:07 fangorn kernel: softirqs last disabled at (1039052927): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:47:07 fangorn kernel: CPU 1:
Aug  4 03:47:07 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:47:07 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:47:07 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 03:47:07 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 03:47:07 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 03:47:07 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 03:47:07 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 03:47:07 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 03:47:07 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 03:47:07 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:47:07 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:47:07 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:47:07 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:47:07 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:47:07 fangorn kernel: Call Trace:
Aug  4 03:47:07 fangorn kernel: <IRQ>  [<ffffffff8116dce2>] ? bvec_free_bs+0x4a/0x60
Aug  4 03:47:07 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 03:47:07 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 03:47:07 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 03:47:07 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 03:47:07 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 03:47:07 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 03:47:07 fangorn kernel: <EOI>  [<ffffffff81136279>] ? kmem_cache_free+0xe4/0x13a
Aug  4 03:47:07 fangorn kernel: [<ffffffff8116dce2>] ? bvec_free_bs+0x4a/0x60
Aug  4 03:47:07 fangorn kernel: [<ffffffff8116dd3f>] ? bio_free+0x47/0x94
Aug  4 03:47:07 fangorn kernel: [<ffffffff8116ddb4>] ? bio_fs_destructor+0x28/0x40
Aug  4 03:47:07 fangorn kernel: [<ffffffff8116bfbf>] ? bio_put+0x40/0x56
Aug  4 03:47:07 fangorn kernel: [<ffffffffa0000f6c>] ? r1buf_pool_free+0x97/0xc9 [raid1]
Aug  4 03:47:07 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 03:47:07 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 03:47:07 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 03:47:07 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:47:07 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:47:07 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:47:07 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:47:07 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:47:07 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:47:07 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:47:07 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:47:07 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:48:13 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:48:13 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:48:13 fangorn kernel: irq event stamp: 1063489307
Aug  4 03:48:13 fangorn kernel: hardirqs last  enabled at (1063489306): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 03:48:13 fangorn kernel: hardirqs last disabled at (1063489307): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:48:13 fangorn kernel: softirqs last  enabled at (1063488884): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:48:13 fangorn kernel: softirqs last disabled at (1063489305): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:48:13 fangorn kernel: CPU 1:
Aug  4 03:48:13 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:48:13 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:48:13 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 03:48:13 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 03:48:13 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 03:48:13 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 03:48:13 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 03:48:13 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 03:48:13 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 03:48:13 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:48:13 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:48:13 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:48:13 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:48:13 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:48:13 fangorn kernel: Call Trace:
Aug  4 03:48:13 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 03:48:13 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 03:48:13 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 03:48:13 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 03:48:13 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 03:48:13 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 03:48:13 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 03:48:13 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:48:13 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:48:13 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:48:13 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:48:13 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:48:13 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:48:13 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:48:13 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:48:13 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:48:13 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:49:18 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:49:18 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:49:18 fangorn kernel: irq event stamp: 1088092934
Aug  4 03:49:18 fangorn kernel: hardirqs last  enabled at (1088092933): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:49:18 fangorn kernel: hardirqs last disabled at (1088092934): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:49:18 fangorn kernel: softirqs last  enabled at (1088092514): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:49:18 fangorn kernel: softirqs last disabled at (1088092451): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:49:18 fangorn kernel: CPU 1:
Aug  4 03:49:18 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:49:18 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:49:18 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 03:49:18 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 03:49:18 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:49:18 fangorn kernel: RDX: 0000000000000ba2 RSI: ffff88005a1c145e RDI: ffff880022ce045e
Aug  4 03:49:18 fangorn kernel: RBP: ffffffff81013bee R08: ffff88009e6d2100 R09: 0000000000000002
Aug  4 03:49:18 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:49:18 fangorn kernel: R13: ffff88009e6d2100 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:49:18 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:49:18 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:49:18 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:49:18 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:49:18 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:49:18 fangorn kernel: Call Trace:
Aug  4 03:49:18 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:49:18 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:49:18 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:49:18 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:49:18 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:49:18 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:49:18 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:49:18 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:49:18 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:49:18 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:50:24 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:50:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:50:24 fangorn kernel: irq event stamp: 1112519192
Aug  4 03:50:24 fangorn kernel: hardirqs last  enabled at (1112519191): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:50:24 fangorn kernel: hardirqs last disabled at (1112519192): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:50:24 fangorn kernel: softirqs last  enabled at (1112518778): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:50:24 fangorn kernel: softirqs last disabled at (1112518727): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:50:24 fangorn kernel: CPU 1:
Aug  4 03:50:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:50:24 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:50:24 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 03:50:24 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 03:50:24 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:50:24 fangorn kernel: RDX: 00000000000003b1 RSI: ffff8800bdc69c4f RDI: ffff8800a9948c4f
Aug  4 03:50:24 fangorn kernel: RBP: ffffffff81013bee R08: ffff880083cc9cb8 R09: 0000000000000001
Aug  4 03:50:24 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 03:50:24 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 03:50:24 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:50:24 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:50:24 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:50:24 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:50:24 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:50:24 fangorn kernel: Call Trace:
Aug  4 03:50:24 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:50:24 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:50:24 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:50:24 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:50:24 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:50:24 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:50:24 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:50:24 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:50:24 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:50:24 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:51:29 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:51:29 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:51:29 fangorn kernel: irq event stamp: 1137151404
Aug  4 03:51:29 fangorn kernel: hardirqs last  enabled at (1137151403): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:51:29 fangorn kernel: hardirqs last disabled at (1137151404): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:51:29 fangorn kernel: softirqs last  enabled at (1137151402): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:51:29 fangorn kernel: softirqs last disabled at (1137151375): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:51:29 fangorn kernel: CPU 1:
Aug  4 03:51:29 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:51:29 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:51:29 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 03:51:29 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 03:51:29 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:51:29 fangorn kernel: RDX: 0000000000000828 RSI: ffff88005acaa7d8 RDI: ffff880056c6f7d8
Aug  4 03:51:29 fangorn kernel: RBP: ffffffff81013bee R08: ffff880114b0a290 R09: 0000000000000003
Aug  4 03:51:29 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 03:51:29 fangorn kernel: R13: ffff880114b0a290 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:51:29 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:51:29 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:51:29 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:51:29 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:51:29 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:51:29 fangorn kernel: Call Trace:
Aug  4 03:51:29 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:51:29 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:51:29 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:51:29 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:51:29 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:51:29 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:51:29 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:51:29 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:51:29 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:51:29 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:52:35 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:52:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:52:35 fangorn kernel: irq event stamp: 1161862750
Aug  4 03:52:35 fangorn kernel: hardirqs last  enabled at (1161862749): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:52:35 fangorn kernel: hardirqs last disabled at (1161862750): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:52:35 fangorn kernel: softirqs last  enabled at (1161862368): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:52:35 fangorn kernel: softirqs last disabled at (1161862355): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:52:35 fangorn kernel: CPU 1:
Aug  4 03:52:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:52:35 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:52:35 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 03:52:35 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 03:52:35 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 03:52:35 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 03:52:35 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff82505378 R09: 000000009cc9ebcb
Aug  4 03:52:35 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 03:52:35 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 03:52:35 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:52:35 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:52:35 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:52:35 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:52:35 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:52:35 fangorn kernel: Call Trace:
Aug  4 03:52:35 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 03:52:35 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 03:52:35 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 03:52:35 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 03:52:35 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 03:52:35 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 03:52:35 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 03:52:35 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 03:52:35 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:52:35 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:52:35 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:52:35 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:52:35 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:52:35 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:52:35 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:52:35 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:52:35 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:53:40 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:53:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:53:40 fangorn kernel: irq event stamp: 1186390920
Aug  4 03:53:40 fangorn kernel: hardirqs last  enabled at (1186390919): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:53:40 fangorn kernel: hardirqs last disabled at (1186390920): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:53:40 fangorn kernel: softirqs last  enabled at (1186390504): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:53:40 fangorn kernel: softirqs last disabled at (1186390453): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:53:40 fangorn kernel: CPU 1:
Aug  4 03:53:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:53:40 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:53:40 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 03:53:40 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 03:53:40 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:53:40 fangorn kernel: RDX: 0000000000000ed7 RSI: ffff88011db2c129 RDI: ffff88011dd53129
Aug  4 03:53:40 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a99ac808 R09: 0000000000000002
Aug  4 03:53:40 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:53:40 fangorn kernel: R13: ffff8800a99ac808 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:53:40 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:53:40 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:53:40 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:53:40 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:53:40 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:53:40 fangorn kernel: Call Trace:
Aug  4 03:53:40 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:53:40 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:53:40 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:53:40 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:53:40 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:53:40 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:53:40 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:53:40 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:53:40 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:53:40 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:54:46 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:54:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:54:46 fangorn kernel: irq event stamp: 1210951329
Aug  4 03:54:46 fangorn kernel: hardirqs last  enabled at (1210951328): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:54:46 fangorn kernel: hardirqs last disabled at (1210951329): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:54:46 fangorn kernel: softirqs last  enabled at (1210950876): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:54:46 fangorn kernel: softirqs last disabled at (1210951295): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:54:46 fangorn kernel: CPU 1:
Aug  4 03:54:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:54:46 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:54:46 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 03:54:46 fangorn kernel: RSP: 0018:ffff88002f1e1b50  EFLAGS: 00000246
Aug  4 03:54:46 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1b70 RCX: 0000000000000064
Aug  4 03:54:46 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f1e1af0 RDI: 0000000000000246
Aug  4 03:54:46 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff8800ca7bb400 R09: 000000009cc9ebcb
Aug  4 03:54:46 fangorn kernel: R10: ffffffff81dfd3c0 R11: 0000000000000000 R12: ffff88002f1e1ad0
Aug  4 03:54:46 fangorn kernel: R13: ffff8801213663e8 R14: 0000000000000246 R15: 000000009cc9ebcb
Aug  4 03:54:46 fangorn kernel: FS:  00007f2772bf67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:54:46 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:54:46 fangorn kernel: CR2: 00007f2772c0b000 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:54:46 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:54:46 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:54:46 fangorn kernel: Call Trace:
Aug  4 03:54:46 fangorn kernel: <IRQ>  [<ffffffff8135625e>] ? scsi_dispatch_cmd+0x1d4/0x25f
Aug  4 03:54:46 fangorn kernel: [<ffffffff8135d24d>] ? scsi_request_fn+0x483/0x4c4
Aug  4 03:54:46 fangorn kernel: [<ffffffff8125bb1b>] ? __blk_run_queue+0x54/0x9a
Aug  4 03:54:46 fangorn kernel: [<ffffffff8125bc52>] ? blk_run_queue+0x39/0x63
Aug  4 03:54:46 fangorn kernel: [<ffffffff8135c430>] ? scsi_run_queue+0x315/0x3de
Aug  4 03:54:46 fangorn kernel: [<ffffffff8135d53c>] ? scsi_next_command+0x4a/0x71
Aug  4 03:54:46 fangorn kernel: [<ffffffff8135e1c1>] ? scsi_io_completion+0x206/0x439
Aug  4 03:54:46 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 03:54:46 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:54:46 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 03:54:46 fangorn kernel: [<ffffffff810cadf3>] ? handle_fasteoi_irq+0xc1/0xf9
Aug  4 03:54:46 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 03:54:46 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 03:54:46 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 03:54:46 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 03:54:46 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 03:54:46 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 03:54:46 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 03:54:46 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 03:54:46 fangorn kernel: <EOI>  [<ffffffff81277de8>] ? memcmp+0x19/0x49
Aug  4 03:54:46 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:54:46 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:54:46 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:54:46 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:54:46 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:54:46 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:54:46 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:54:46 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:54:46 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:54:46 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:56:27 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:56:27 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:56:27 fangorn kernel: irq event stamp: 1247816598
Aug  4 03:56:27 fangorn kernel: hardirqs last  enabled at (1247816597): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 03:56:27 fangorn kernel: hardirqs last disabled at (1247816598): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:56:27 fangorn kernel: softirqs last  enabled at (1247816458): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:56:27 fangorn kernel: softirqs last disabled at (1247816407): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:56:27 fangorn kernel: CPU 1:
Aug  4 03:56:27 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:56:27 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:56:27 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 03:56:27 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 03:56:27 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 03:56:27 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 03:56:27 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff82574b28 R09: 000000009cc9ebcb
Aug  4 03:56:27 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 03:56:27 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 03:56:27 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:56:27 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:56:27 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:56:27 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:56:27 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:56:27 fangorn kernel: Call Trace:
Aug  4 03:56:27 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 03:56:27 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 03:56:27 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 03:56:27 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 03:56:27 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 03:56:27 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 03:56:27 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 03:56:27 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 03:56:27 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:56:27 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:56:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:56:27 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:56:27 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:56:27 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:56:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:56:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:56:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:57:32 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:57:32 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:57:32 fangorn kernel: irq event stamp: 1272379900
Aug  4 03:57:32 fangorn kernel: hardirqs last  enabled at (1272379899): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:57:32 fangorn kernel: hardirqs last disabled at (1272379900): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:57:32 fangorn kernel: softirqs last  enabled at (1272379848): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:57:32 fangorn kernel: softirqs last disabled at (1272379823): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:57:32 fangorn kernel: CPU 1:
Aug  4 03:57:32 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:57:32 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:57:32 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 03:57:32 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 03:57:32 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:57:32 fangorn kernel: RDX: 00000000000007b9 RSI: ffff88011414a847 RDI: ffff880022448847
Aug  4 03:57:32 fangorn kernel: RBP: ffffffff81013bee R08: ffff88011f117bf0 R09: 0000000000000002
Aug  4 03:57:32 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:57:32 fangorn kernel: R13: ffff88011f117bf0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:57:32 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:57:32 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:57:32 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:57:32 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:57:32 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:57:32 fangorn kernel: Call Trace:
Aug  4 03:57:32 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:57:32 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:57:32 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:57:32 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:57:32 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:57:32 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:57:32 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:57:32 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:57:32 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:57:32 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:58:38 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:58:38 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:58:38 fangorn kernel: irq event stamp: 1296661476
Aug  4 03:58:38 fangorn kernel: hardirqs last  enabled at (1296661475): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:58:38 fangorn kernel: hardirqs last disabled at (1296661476): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:58:38 fangorn kernel: softirqs last  enabled at (1296661154): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:58:38 fangorn kernel: softirqs last disabled at (1296661091): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:58:38 fangorn kernel: CPU 1:
Aug  4 03:58:38 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:58:38 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:58:38 fangorn kernel: RIP: 0010:[<ffffffff81277df0>]  [<ffffffff81277df0>] memcmp+0x21/0x49
Aug  4 03:58:38 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 03:58:38 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:58:38 fangorn kernel: RDX: 0000000000000714 RSI: ffff8800063408ec RDI: ffff88001365e8ec
Aug  4 03:58:38 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800ab8bca60 R09: 0000000000000003
Aug  4 03:58:38 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 03:58:38 fangorn kernel: R13: ffff8800ab8bca60 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:58:38 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:58:38 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:58:38 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:58:38 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:58:38 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:58:38 fangorn kernel: Call Trace:
Aug  4 03:58:38 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:58:38 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:58:38 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:58:38 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:58:38 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:58:38 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:58:38 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:58:38 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:58:38 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:58:38 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 03:59:43 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 03:59:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:59:43 fangorn kernel: irq event stamp: 1321025000
Aug  4 03:59:43 fangorn kernel: hardirqs last  enabled at (1321024999): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 03:59:43 fangorn kernel: hardirqs last disabled at (1321025000): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 03:59:43 fangorn kernel: softirqs last  enabled at (1321024998): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 03:59:43 fangorn kernel: softirqs last disabled at (1321024971): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 03:59:43 fangorn kernel: CPU 1:
Aug  4 03:59:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 03:59:43 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 03:59:43 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 03:59:43 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 03:59:43 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 03:59:43 fangorn kernel: RDX: 0000000000000e14 RSI: ffff8800ca64b1ec RDI: ffff8800badc51ec
Aug  4 03:59:43 fangorn kernel: RBP: ffffffff81013bee R08: ffff88012050ccb8 R09: 0000000000000002
Aug  4 03:59:43 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 03:59:43 fangorn kernel: R13: ffff88012050ccb8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 03:59:43 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 03:59:43 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 03:59:43 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 03:59:43 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 03:59:43 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 03:59:43 fangorn kernel: Call Trace:
Aug  4 03:59:43 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 03:59:43 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 03:59:43 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 03:59:43 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 03:59:43 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 03:59:43 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 03:59:43 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 03:59:43 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 03:59:43 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 03:59:43 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:00:49 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:00:49 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:00:49 fangorn kernel: irq event stamp: 1345553575
Aug  4 04:00:49 fangorn kernel: hardirqs last  enabled at (1345553574): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:00:49 fangorn kernel: hardirqs last disabled at (1345553575): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:00:49 fangorn kernel: softirqs last  enabled at (1345553152): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:00:49 fangorn kernel: softirqs last disabled at (1345553573): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:00:49 fangorn kernel: CPU 1:
Aug  4 04:00:49 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:00:49 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:00:49 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:00:49 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:00:49 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:00:49 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:00:49 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:00:49 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:00:49 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:00:49 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:00:49 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:00:49 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:00:49 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:00:49 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:00:49 fangorn kernel: Call Trace:
Aug  4 04:00:49 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:00:49 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:00:49 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:00:49 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:00:49 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:00:49 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:00:49 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 04:00:49 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:00:49 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:00:49 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:00:49 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:00:49 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:00:49 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:00:49 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:00:49 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:00:49 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:00:49 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:01:54 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:01:54 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:01:54 fangorn kernel: irq event stamp: 1369914494
Aug  4 04:01:54 fangorn kernel: hardirqs last  enabled at (1369914493): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:01:54 fangorn kernel: hardirqs last disabled at (1369914494): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:01:54 fangorn kernel: softirqs last  enabled at (1369914074): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:01:54 fangorn kernel: softirqs last disabled at (1369914009): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:01:54 fangorn kernel: CPU 1:
Aug  4 04:01:54 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:01:54 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:01:54 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:01:54 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:01:54 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:01:54 fangorn kernel: RDX: 0000000000000009 RSI: ffff880082312ff7 RDI: ffff88001eb3bff7
Aug  4 04:01:54 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800c44eb998 R09: 0000000000000003
Aug  4 04:01:54 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:01:54 fangorn kernel: R13: ffff8800c44eb998 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:01:54 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:01:54 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:01:54 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:01:54 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:01:54 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:01:54 fangorn kernel: Call Trace:
Aug  4 04:01:54 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:01:54 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:01:54 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:01:54 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:01:54 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:01:54 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:01:54 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:01:54 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:01:54 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:01:54 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:03:00 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:03:00 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:03:00 fangorn kernel: irq event stamp: 1394288806
Aug  4 04:03:00 fangorn kernel: hardirqs last  enabled at (1394288805): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:03:00 fangorn kernel: hardirqs last disabled at (1394288806): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:03:00 fangorn kernel: softirqs last  enabled at (1394288804): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:03:00 fangorn kernel: softirqs last disabled at (1394288753): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:03:00 fangorn kernel: CPU 1:
Aug  4 04:03:00 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:03:00 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:03:00 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:03:00 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:03:00 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:03:00 fangorn kernel: RDX: 00000000000004d2 RSI: ffff880104cebb2e RDI: ffff880104c9ab2e
Aug  4 04:03:00 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1678 R09: 0000000000000003
Aug  4 04:03:00 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 04:03:00 fangorn kernel: R13: ffff8800b86b1678 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:03:00 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:03:00 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:03:00 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:03:00 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:03:00 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:03:00 fangorn kernel: Call Trace:
Aug  4 04:03:00 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:03:00 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:03:00 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:03:00 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:03:00 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:03:00 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:03:00 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:03:00 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:03:00 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:03:00 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:04:05 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:04:05 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:04:05 fangorn kernel: irq event stamp: 1418695481
Aug  4 04:04:05 fangorn kernel: hardirqs last  enabled at (1418695480): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:04:05 fangorn kernel: hardirqs last disabled at (1418695481): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:04:05 fangorn kernel: softirqs last  enabled at (1418695438): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:04:05 fangorn kernel: softirqs last disabled at (1418695441): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:04:05 fangorn kernel: CPU 1:
Aug  4 04:04:05 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:04:05 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:04:05 fangorn kernel: RIP: 0010:[<ffffffff814fa627>]  [<ffffffff814fa627>] _spin_unlock_irq+0x43/0x61
Aug  4 04:04:05 fangorn kernel: RSP: 0018:ffff88002f1e1b90  EFLAGS: 00000246
Aug  4 04:04:05 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1bb0 RCX: 0000000000000061
Aug  4 04:04:05 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f1e1b30 RDI: 000000009cc9ebcb
Aug  4 04:04:05 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff8801205a0400 R09: 000000009cc9ebcb
Aug  4 04:04:05 fangorn kernel: R10: ffffffff81dfdd70 R11: 0000000000000000 R12: ffff88002f1e1b10
Aug  4 04:04:05 fangorn kernel: R13: ffff8801205a0000 R14: ffff8801205a0400 R15: 000000009cc9ebcb
Aug  4 04:04:05 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:04:05 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:04:05 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:04:05 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:04:05 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:04:05 fangorn kernel: Call Trace:
Aug  4 04:04:05 fangorn kernel: <IRQ>  [<ffffffff8135d1a3>] ? scsi_request_fn+0x3d9/0x4c4
Aug  4 04:04:05 fangorn kernel: [<ffffffff8125bb1b>] ? __blk_run_queue+0x54/0x9a
Aug  4 04:04:05 fangorn kernel: [<ffffffff8125bc52>] ? blk_run_queue+0x39/0x63
Aug  4 04:04:05 fangorn kernel: [<ffffffff8135c430>] ? scsi_run_queue+0x315/0x3de
Aug  4 04:04:05 fangorn kernel: [<ffffffff8135d53c>] ? scsi_next_command+0x4a/0x71
Aug  4 04:04:05 fangorn kernel: [<ffffffff8135e1c1>] ? scsi_io_completion+0x206/0x439
Aug  4 04:04:05 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 04:04:05 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:04:05 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 04:04:05 fangorn kernel: [<ffffffff810cadf3>] ? handle_fasteoi_irq+0xc1/0xf9
Aug  4 04:04:05 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 04:04:05 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 04:04:05 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:04:05 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:04:05 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:04:05 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:04:05 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:04:05 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:04:05 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 04:04:05 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:04:05 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:04:05 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:04:05 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:04:05 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:04:05 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:04:05 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:04:05 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:04:05 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:04:05 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:05:11 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:05:11 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:05:11 fangorn kernel: irq event stamp: 1443261849
Aug  4 04:05:11 fangorn kernel: hardirqs last  enabled at (1443261848): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:05:11 fangorn kernel: hardirqs last disabled at (1443261849): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:05:11 fangorn kernel: softirqs last  enabled at (1443261706): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:05:11 fangorn kernel: softirqs last disabled at (1443261847): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:05:11 fangorn kernel: CPU 1:
Aug  4 04:05:11 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:05:11 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:05:11 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:05:11 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:05:11 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:05:11 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:05:11 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:05:11 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:05:11 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:05:11 fangorn kernel: FS:  00007fcff91cd7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:05:11 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:05:11 fangorn kernel: CR2: 0000000002425348 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:05:11 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:05:11 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:05:11 fangorn kernel: Call Trace:
Aug  4 04:05:11 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:05:11 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:05:11 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:05:11 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:05:11 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:05:11 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:05:11 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:05:11 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:05:11 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:05:11 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:05:11 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:05:11 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:05:11 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:05:11 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:05:11 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:05:11 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:05:11 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:06:53 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:06:53 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:06:53 fangorn kernel: irq event stamp: 1480896837
Aug  4 04:06:53 fangorn kernel: hardirqs last  enabled at (1480896836): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:06:53 fangorn kernel: hardirqs last disabled at (1480896837): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:06:53 fangorn kernel: softirqs last  enabled at (1480896614): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:06:53 fangorn kernel: softirqs last disabled at (1480896835): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:06:53 fangorn kernel: CPU 1:
Aug  4 04:06:53 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:06:53 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:06:53 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:06:53 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:06:53 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:06:53 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:06:53 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:06:53 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:06:53 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:06:53 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:06:53 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:06:53 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:06:53 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:06:53 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:06:53 fangorn kernel: Call Trace:
Aug  4 04:06:53 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:06:53 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:06:53 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:06:53 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:06:53 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:06:53 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:06:53 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:06:53 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:06:53 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:06:53 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:06:53 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:06:53 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:06:53 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:06:53 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:06:53 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:06:53 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:06:53 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:07:58 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:07:58 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:07:58 fangorn kernel: irq event stamp: 1505441514
Aug  4 04:07:58 fangorn kernel: hardirqs last  enabled at (1505441513): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:07:58 fangorn kernel: hardirqs last disabled at (1505441514): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:07:58 fangorn kernel: softirqs last  enabled at (1505441096): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:07:58 fangorn kernel: softirqs last disabled at (1505441035): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:07:58 fangorn kernel: CPU 1:
Aug  4 04:07:58 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:07:58 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:07:58 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:07:58 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:07:58 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:07:58 fangorn kernel: RDX: 0000000000000fdc RSI: ffff8800c0103024 RDI: ffff8800aa8b8024
Aug  4 04:07:58 fangorn kernel: RBP: ffffffff81013bee R08: ffff880056685678 R09: 0000000000000002
Aug  4 04:07:58 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:07:58 fangorn kernel: R13: ffff880056685678 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:07:58 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:07:58 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:07:58 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:07:58 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:07:58 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:07:58 fangorn kernel: Call Trace:
Aug  4 04:07:58 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:07:58 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:07:58 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:07:58 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:07:58 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:07:58 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:07:58 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:07:58 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:07:58 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:07:58 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:09:04 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:09:04 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:09:04 fangorn kernel: irq event stamp: 1530124308
Aug  4 04:09:04 fangorn kernel: hardirqs last  enabled at (1530124307): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:09:04 fangorn kernel: hardirqs last disabled at (1530124308): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:09:04 fangorn kernel: softirqs last  enabled at (1530124286): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:09:04 fangorn kernel: softirqs last disabled at (1530124261): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:09:04 fangorn kernel: CPU 1:
Aug  4 04:09:04 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:09:04 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:09:04 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 04:09:04 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:09:04 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:09:04 fangorn kernel: RDX: 0000000000000c27 RSI: ffff8800329853d9 RDI: ffff8800104693d9
Aug  4 04:09:04 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1bf0 R09: 0000000000000002
Aug  4 04:09:04 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:09:04 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:09:04 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:09:04 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:09:04 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:09:04 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:09:04 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:09:04 fangorn kernel: Call Trace:
Aug  4 04:09:04 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:09:04 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:09:04 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:09:04 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:09:04 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:09:04 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:09:04 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:09:04 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:09:04 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:09:04 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:10:09 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:10:09 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:10:09 fangorn kernel: irq event stamp: 1554881791
Aug  4 04:10:09 fangorn kernel: hardirqs last  enabled at (1554881790): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:10:09 fangorn kernel: hardirqs last disabled at (1554881791): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:10:09 fangorn kernel: softirqs last  enabled at (1554881578): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:10:09 fangorn kernel: softirqs last disabled at (1554881789): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:10:09 fangorn kernel: CPU 1:
Aug  4 04:10:09 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:10:09 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:10:09 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:10:09 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:10:09 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:10:09 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:10:09 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:10:09 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:10:09 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:10:09 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:10:09 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:10:09 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:10:09 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:10:09 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:10:09 fangorn kernel: Call Trace:
Aug  4 04:10:09 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:10:09 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:10:09 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:10:09 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:10:09 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:10:09 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:10:09 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 04:10:09 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:10:09 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:10:09 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:10:09 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:10:09 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:10:09 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:10:09 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:10:09 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:10:09 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:10:09 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:11:15 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:11:15 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:11:15 fangorn kernel: irq event stamp: 1579756193
Aug  4 04:11:15 fangorn kernel: hardirqs last  enabled at (1579756192): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:11:15 fangorn kernel: hardirqs last disabled at (1579756193): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:11:15 fangorn kernel: softirqs last  enabled at (1579756178): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:11:15 fangorn kernel: softirqs last disabled at (1579756191): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:11:15 fangorn kernel: CPU 1:
Aug  4 04:11:15 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:11:15 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:11:15 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:11:15 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:11:15 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:11:15 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:11:15 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:11:15 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:11:15 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:11:15 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:11:15 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:11:15 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:11:15 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:11:15 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:11:15 fangorn kernel: Call Trace:
Aug  4 04:11:15 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:11:15 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:11:15 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:11:15 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:11:15 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:11:15 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:11:15 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:11:15 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:11:15 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:11:15 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:11:15 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:11:15 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:11:15 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:11:15 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:11:15 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:11:15 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:11:15 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:12:20 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:12:20 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:12:20 fangorn kernel: irq event stamp: 1604468156
Aug  4 04:12:20 fangorn kernel: hardirqs last  enabled at (1604468155): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:12:20 fangorn kernel: hardirqs last disabled at (1604468156): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:12:20 fangorn kernel: softirqs last  enabled at (1604467738): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:12:20 fangorn kernel: softirqs last disabled at (1604467677): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:12:20 fangorn kernel: CPU 1:
Aug  4 04:12:20 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:12:20 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:12:20 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:12:20 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 04:12:20 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:12:20 fangorn kernel: RDX: 00000000000007f1 RSI: ffff8800d4f8880f RDI: ffff8800140b780f
Aug  4 04:12:20 fangorn kernel: RBP: ffffffff81013bee R08: ffff88009e6d2420 R09: 0000000000000002
Aug  4 04:12:20 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:12:20 fangorn kernel: R13: ffff88009e6d2420 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:12:20 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:12:20 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:12:20 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:12:20 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:12:20 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:12:20 fangorn kernel: Call Trace:
Aug  4 04:12:20 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:12:20 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:12:20 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:12:20 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:12:20 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:12:20 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:12:20 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:12:20 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:12:20 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:12:20 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:13:26 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:13:26 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:13:26 fangorn kernel: irq event stamp: 1629058918
Aug  4 04:13:26 fangorn kernel: hardirqs last  enabled at (1629058917): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:13:26 fangorn kernel: hardirqs last disabled at (1629058918): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:13:26 fangorn kernel: softirqs last  enabled at (1629058500): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:13:26 fangorn kernel: softirqs last disabled at (1629058439): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:13:26 fangorn kernel: CPU 1:
Aug  4 04:13:26 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:13:26 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:13:26 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:13:26 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:13:26 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:13:26 fangorn kernel: RDX: 0000000000000fb1 RSI: ffff88001e46004f RDI: ffff88003f06304f
Aug  4 04:13:26 fangorn kernel: RBP: ffffffff81013bee R08: ffff880056685cb8 R09: 0000000000000002
Aug  4 04:13:26 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:13:26 fangorn kernel: R13: ffff880056685cb8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:13:26 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:13:26 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:13:26 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:13:26 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:13:26 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:13:26 fangorn kernel: Call Trace:
Aug  4 04:13:26 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:13:26 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:13:26 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:13:26 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:13:26 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:13:26 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:13:26 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:13:26 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:13:26 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:13:26 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:14:31 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:14:31 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:14:31 fangorn kernel: irq event stamp: 1653726052
Aug  4 04:14:31 fangorn kernel: hardirqs last  enabled at (1653726051): [<ffffffff814fa623>] _spin_unlock_irq+0x3f/0x61
Aug  4 04:14:31 fangorn kernel: hardirqs last disabled at (1653726052): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:14:31 fangorn kernel: softirqs last  enabled at (1653725640): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:14:31 fangorn kernel: softirqs last disabled at (1653725589): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:14:31 fangorn kernel: CPU 1:
Aug  4 04:14:31 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:14:31 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:14:31 fangorn kernel: RIP: 0010:[<ffffffff814fa627>]  [<ffffffff814fa627>] _spin_unlock_irq+0x43/0x61
Aug  4 04:14:31 fangorn kernel: RSP: 0018:ffff880120709c70  EFLAGS: 00000246
Aug  4 04:14:31 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709c90 RCX: 0000000000000063
Aug  4 04:14:31 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709c10 RDI: 000000009cc9ebcb
Aug  4 04:14:31 fangorn kernel: RBP: ffffffff81013bee R08: ffff880120ead938 R09: 000000009cc9ebcb
Aug  4 04:14:31 fangorn kernel: R10: ffffffff81e02ed0 R11: 0000000000000000 R12: ffff880120709c10
Aug  4 04:14:31 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709be0 R15: ffffffff8101aa23
Aug  4 04:14:31 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:14:31 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:14:31 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:14:31 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:14:31 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:14:31 fangorn kernel: Call Trace:
Aug  4 04:14:31 fangorn kernel: [<ffffffffa00025a2>] ? flush_pending_writes+0x9c/0xbd [raid1]
Aug  4 04:14:31 fangorn kernel: [<ffffffffa00026d7>] ? raid1d+0x62/0xea5 [raid1]
Aug  4 04:14:31 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:14:31 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:14:31 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:14:31 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:14:31 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:14:31 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:14:31 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:14:31 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:14:31 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:15:37 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:15:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:15:37 fangorn kernel: irq event stamp: 1678460718
Aug  4 04:15:37 fangorn kernel: hardirqs last  enabled at (1678460717): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:15:37 fangorn kernel: hardirqs last disabled at (1678460718): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:15:37 fangorn kernel: softirqs last  enabled at (1678460304): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:15:37 fangorn kernel: softirqs last disabled at (1678460253): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:15:37 fangorn kernel: CPU 1:
Aug  4 04:15:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:15:37 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:15:37 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:15:37 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:15:37 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:15:37 fangorn kernel: RDX: 0000000000000e47 RSI: ffff88011c6151b9 RDI: ffff88011b9a51b9
Aug  4 04:15:37 fangorn kernel: RBP: ffffffff81013bee R08: ffff88011f742678 R09: 0000000000000001
Aug  4 04:15:37 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:15:37 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:15:37 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:15:37 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:15:37 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:15:37 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:15:37 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:15:37 fangorn kernel: Call Trace:
Aug  4 04:15:37 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:15:37 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:15:37 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:15:37 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:15:37 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:15:37 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:15:37 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:15:37 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:15:37 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:15:37 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:17:13 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:17:13 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:17:13 fangorn kernel: irq event stamp: 1714321666
Aug  4 04:17:13 fangorn kernel: hardirqs last  enabled at (1714321665): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:17:13 fangorn kernel: hardirqs last disabled at (1714321666): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:17:13 fangorn kernel: softirqs last  enabled at (1714321252): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:17:13 fangorn kernel: softirqs last disabled at (1714321201): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:17:13 fangorn kernel: CPU 1:
Aug  4 04:17:13 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:17:13 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:17:13 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:17:13 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 04:17:13 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:17:13 fangorn kernel: RDX: 000000000000019e RSI: ffff88001fc8ce62 RDI: ffff880022ccfe62
Aug  4 04:17:13 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b15b0 R09: 0000000000000001
Aug  4 04:17:13 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:17:13 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:17:13 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:17:13 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:17:13 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:17:13 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:17:13 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:17:13 fangorn kernel: Call Trace:
Aug  4 04:17:13 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:17:13 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:17:13 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:17:13 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:17:13 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:17:13 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:17:13 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:17:13 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:17:13 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:17:13 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:18:19 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:18:19 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:18:19 fangorn kernel: irq event stamp: 1739192848
Aug  4 04:18:19 fangorn kernel: hardirqs last  enabled at (1739192847): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:18:19 fangorn kernel: hardirqs last disabled at (1739192848): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:18:19 fangorn kernel: softirqs last  enabled at (1739192492): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:18:19 fangorn kernel: softirqs last disabled at (1739192465): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:18:19 fangorn kernel: CPU 1:
Aug  4 04:18:19 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:18:19 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:18:19 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:18:19 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 04:18:19 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 04:18:19 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 04:18:19 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff825859b8 R09: 000000009cc9ebcb
Aug  4 04:18:19 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 04:18:19 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 04:18:19 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:18:19 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:18:19 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:18:19 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:18:19 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:18:19 fangorn kernel: Call Trace:
Aug  4 04:18:19 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 04:18:19 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 04:18:19 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:18:19 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:18:19 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:18:19 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:18:19 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:18:19 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:18:19 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:18:19 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:18:19 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:18:19 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:18:19 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:18:19 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:18:19 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:18:19 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:18:19 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:19:24 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:19:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:19:24 fangorn kernel: irq event stamp: 1763918526
Aug  4 04:19:24 fangorn kernel: hardirqs last  enabled at (1763918525): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:19:24 fangorn kernel: hardirqs last disabled at (1763918526): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:19:24 fangorn kernel: softirqs last  enabled at (1763918108): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:19:24 fangorn kernel: softirqs last disabled at (1763918077): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:19:24 fangorn kernel: CPU 1:
Aug  4 04:19:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:19:24 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:19:24 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 04:19:24 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 04:19:24 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:19:24 fangorn kernel: RDX: 000000000000051a RSI: ffff8800acef5ae6 RDI: ffff880008c49ae6
Aug  4 04:19:24 fangorn kernel: RBP: ffffffff81013bee R08: ffff880118083d80 R09: 0000000000000002
Aug  4 04:19:24 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:19:24 fangorn kernel: R13: ffff880118083d80 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:19:24 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:19:24 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:19:24 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:19:24 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:19:24 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:19:24 fangorn kernel: Call Trace:
Aug  4 04:19:24 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:19:24 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:19:24 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:19:24 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:19:24 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:19:24 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:19:24 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:19:24 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:19:24 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:19:24 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:20:30 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:20:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:20:30 fangorn kernel: irq event stamp: 1788461430
Aug  4 04:20:30 fangorn kernel: hardirqs last  enabled at (1788461429): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:20:30 fangorn kernel: hardirqs last disabled at (1788461430): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:20:30 fangorn kernel: softirqs last  enabled at (1788461424): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:20:30 fangorn kernel: softirqs last disabled at (1788461373): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:20:30 fangorn kernel: CPU 1:
Aug  4 04:20:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:20:30 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:20:30 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:20:30 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:20:30 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:20:30 fangorn kernel: RDX: 0000000000000cfb RSI: ffff8800b3daf305 RDI: ffff8800748b1305
Aug  4 04:20:30 fangorn kernel: RBP: ffffffff81013bee R08: ffff880056685b28 R09: 0000000000000003
Aug  4 04:20:30 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:20:30 fangorn kernel: R13: ffff880056685b28 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:20:30 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:20:30 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:20:30 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:20:30 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:20:30 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:20:30 fangorn kernel: Call Trace:
Aug  4 04:20:30 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:20:30 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:20:30 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:20:30 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:20:30 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:20:30 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:20:30 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:20:30 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:20:30 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:20:30 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:21:35 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:21:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:21:35 fangorn kernel: irq event stamp: 1813168045
Aug  4 04:21:35 fangorn kernel: hardirqs last  enabled at (1813168044): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:21:35 fangorn kernel: hardirqs last disabled at (1813168045): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:21:35 fangorn kernel: softirqs last  enabled at (1813167906): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:21:35 fangorn kernel: softirqs last disabled at (1813168043): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:21:35 fangorn kernel: CPU 1:
Aug  4 04:21:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:21:35 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:21:35 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:21:35 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:21:35 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:21:35 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:21:35 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:21:35 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:21:35 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:21:35 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:21:35 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:21:35 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:21:35 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:21:35 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:21:35 fangorn kernel: Call Trace:
Aug  4 04:21:35 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:21:35 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:21:35 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:21:35 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:21:35 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:21:35 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:21:35 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:21:35 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:21:35 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:21:35 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:21:35 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:21:35 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:21:35 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:21:35 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:21:35 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:21:35 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:21:35 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:22:41 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:22:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:22:41 fangorn kernel: irq event stamp: 1838039885
Aug  4 04:22:41 fangorn kernel: hardirqs last  enabled at (1838039884): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:22:41 fangorn kernel: hardirqs last disabled at (1838039885): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:22:41 fangorn kernel: softirqs last  enabled at (1838039462): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:22:41 fangorn kernel: softirqs last disabled at (1838039883): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:22:41 fangorn kernel: CPU 1:
Aug  4 04:22:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:22:41 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:22:41 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:22:41 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:22:41 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:22:41 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:22:41 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:22:41 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:22:41 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:22:41 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:22:41 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:22:41 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:22:41 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:22:41 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:22:41 fangorn kernel: Call Trace:
Aug  4 04:22:41 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:22:41 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:22:41 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:22:41 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:22:41 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:22:41 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:22:41 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 04:22:41 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:22:41 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:22:41 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:22:41 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:22:41 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:22:41 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:22:41 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:22:41 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:22:41 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:22:41 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:23:46 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:23:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:23:46 fangorn kernel: irq event stamp: 1862739670
Aug  4 04:23:46 fangorn kernel: hardirqs last  enabled at (1862739669): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:23:46 fangorn kernel: hardirqs last disabled at (1862739670): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:23:46 fangorn kernel: softirqs last  enabled at (1862739256): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:23:46 fangorn kernel: softirqs last disabled at (1862739205): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:23:46 fangorn kernel: CPU 1:
Aug  4 04:23:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:23:46 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:23:46 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 04:23:46 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:23:46 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:23:46 fangorn kernel: RDX: 0000000000000ad8 RSI: ffff880106142528 RDI: ffff880102df5528
Aug  4 04:23:46 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a99acd80 R09: 0000000000000002
Aug  4 04:23:46 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:23:46 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:23:46 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:23:46 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:23:46 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:23:46 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:23:46 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:23:46 fangorn kernel: Call Trace:
Aug  4 04:23:46 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:23:46 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:23:46 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:23:46 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:23:46 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:23:46 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:23:46 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:23:46 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:23:46 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:23:46 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:24:52 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:24:52 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:24:52 fangorn kernel: irq event stamp: 1887435820
Aug  4 04:24:52 fangorn kernel: hardirqs last  enabled at (1887435819): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:24:52 fangorn kernel: hardirqs last disabled at (1887435820): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:24:52 fangorn kernel: softirqs last  enabled at (1887435402): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:24:52 fangorn kernel: softirqs last disabled at (1887435351): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:24:52 fangorn kernel: CPU 1:
Aug  4 04:24:52 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:24:52 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:24:52 fangorn kernel: RIP: 0010:[<ffffffff81277dee>]  [<ffffffff81277dee>] memcmp+0x1f/0x49
Aug  4 04:24:52 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:24:52 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:24:52 fangorn kernel: RDX: 0000000000001000 RSI: ffff88010917a000 RDI: ffff8800c00ea000
Aug  4 04:24:52 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a99ac8d0 R09: 0000000000000002
Aug  4 04:24:52 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:24:52 fangorn kernel: R13: ffff8800a99ac8d0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:24:52 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:24:52 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:24:52 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:24:52 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:24:52 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:24:52 fangorn kernel: Call Trace:
Aug  4 04:24:52 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:24:52 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:24:52 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:24:52 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:24:52 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:24:52 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:24:52 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:24:52 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:24:52 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:24:52 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:25:57 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:25:57 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:25:57 fangorn kernel: irq event stamp: 1912257615
Aug  4 04:25:57 fangorn kernel: hardirqs last  enabled at (1912257614): [<ffffffff814fa623>] _spin_unlock_irq+0x3f/0x61
Aug  4 04:25:57 fangorn kernel: hardirqs last disabled at (1912257615): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:25:57 fangorn kernel: softirqs last  enabled at (1912257164): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:25:57 fangorn kernel: softirqs last disabled at (1912257583): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:25:57 fangorn kernel: CPU 1:
Aug  4 04:25:57 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:25:57 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:25:57 fangorn kernel: RIP: 0010:[<ffffffff814fa627>]  [<ffffffff814fa627>] _spin_unlock_irq+0x43/0x61
Aug  4 04:25:57 fangorn kernel: RSP: 0018:ffff88002f1e1b90  EFLAGS: 00000246
Aug  4 04:25:57 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1bb0 RCX: 0000000000000064
Aug  4 04:25:57 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f1e1b30 RDI: 000000009cc9ebcb
Aug  4 04:25:57 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88005a772990 R09: 000000009cc9ebcb
Aug  4 04:25:57 fangorn kernel: R10: ffffffff81dfd3c0 R11: 0000000000000000 R12: ffff88002f1e1b10
Aug  4 04:25:57 fangorn kernel: R13: ffff8801205b0000 R14: ffff880121366c30 R15: 000000009cc9ebcb
Aug  4 04:25:57 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:25:57 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:25:57 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:25:57 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:25:57 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:25:57 fangorn kernel: Call Trace:
Aug  4 04:25:57 fangorn kernel: <IRQ>  [<ffffffff8135d23b>] ? scsi_request_fn+0x471/0x4c4
Aug  4 04:25:57 fangorn kernel: [<ffffffff8125bb1b>] ? __blk_run_queue+0x54/0x9a
Aug  4 04:25:57 fangorn kernel: [<ffffffff8125bc52>] ? blk_run_queue+0x39/0x63
Aug  4 04:25:57 fangorn kernel: [<ffffffff8135c430>] ? scsi_run_queue+0x315/0x3de
Aug  4 04:25:57 fangorn kernel: [<ffffffff8135d53c>] ? scsi_next_command+0x4a/0x71
Aug  4 04:25:57 fangorn kernel: [<ffffffff8135e1c1>] ? scsi_io_completion+0x206/0x439
Aug  4 04:25:57 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 04:25:57 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:25:57 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 04:25:57 fangorn kernel: [<ffffffff810cadf3>] ? handle_fasteoi_irq+0xc1/0xf9
Aug  4 04:25:57 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 04:25:57 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 04:25:57 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:25:57 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:25:57 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:25:57 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:25:57 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:25:57 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:25:57 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:25:57 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:25:57 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:25:57 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:25:57 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:25:57 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:25:57 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:25:57 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:25:57 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:25:57 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:25:57 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:27:32 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:27:32 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:27:32 fangorn kernel: irq event stamp: 1951862669
Aug  4 04:27:32 fangorn kernel: hardirqs last  enabled at (1951862668): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:27:32 fangorn kernel: hardirqs last disabled at (1951862669): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:27:32 fangorn kernel: softirqs last  enabled at (1951862646): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:27:32 fangorn kernel: softirqs last disabled at (1951862667): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:27:32 fangorn kernel: CPU 3:
Aug  4 04:27:32 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:27:32 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:27:32 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:27:32 fangorn kernel: RSP: 0018:ffff88002f59dea0  EFLAGS: 00000246
Aug  4 04:27:32 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f59df00 RCX: ffff880120cf6910
Aug  4 04:27:32 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:27:32 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f59de90 R09: 000000009cc9ebcb
Aug  4 04:27:32 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f59de20
Aug  4 04:27:32 fangorn kernel: R13: 0000000000000091 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:27:32 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:27:32 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:27:32 fangorn kernel: CR2: 00007fa9ecc1a000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:27:32 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:27:32 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:27:32 fangorn kernel: Call Trace:
Aug  4 04:27:32 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:27:32 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:27:32 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:27:32 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:27:32 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:27:32 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:27:32 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:27:32 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:27:32 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:27:32 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:27:32 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:27:32 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:27:32 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:27:32 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:27:32 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:27:32 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:27:32 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:28:37 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:28:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:28:37 fangorn kernel: irq event stamp: 1981079362
Aug  4 04:28:37 fangorn kernel: hardirqs last  enabled at (1981079361): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:28:37 fangorn kernel: hardirqs last disabled at (1981079362): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:28:37 fangorn kernel: softirqs last  enabled at (1981079360): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:28:37 fangorn kernel: softirqs last disabled at (1981079335): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:28:37 fangorn kernel: CPU 3:
Aug  4 04:28:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:28:37 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:28:37 fangorn kernel: RIP: 0010:[<ffffffff8105071d>]  [<ffffffff8105071d>] __wake_up+0x57/0x70
Aug  4 04:28:37 fangorn kernel: RSP: 0018:ffff880120709c30  EFLAGS: 00000246
Aug  4 04:28:37 fangorn kernel: RAX: 000000009cc9ebcb RBX: ffff880120709c70 RCX: 0000000000000072
Aug  4 04:28:37 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000246 RDI: 000000009cc9ebcb
Aug  4 04:28:37 fangorn kernel: RBP: ffffffff81013bee R08: ffff880120eada20 R09: 000000009cc9ebcb
Aug  4 04:28:37 fangorn kernel: R10: ffffffff81dd69b0 R11: 0000000000000000 R12: ffff880120eada20
Aug  4 04:28:37 fangorn kernel: R13: 000000009cc9ebcb R14: ffffffff81dd69b0 R15: 0000000000000000
Aug  4 04:28:37 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:28:37 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:28:37 fangorn kernel: CR2: 00007fa9ecc1a000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:28:37 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:28:37 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:28:37 fangorn kernel: Call Trace:
Aug  4 04:28:37 fangorn kernel: [<ffffffffa00008bb>] ? lower_barrier+0x5a/0x75 [raid1]
Aug  4 04:28:37 fangorn kernel: [<ffffffffa00011d9>] ? put_buf+0x87/0xa2 [raid1]
Aug  4 04:28:37 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:28:37 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:28:37 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:28:37 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:28:37 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:28:37 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:28:37 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:28:37 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:28:37 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:28:37 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:29:43 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:29:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:29:43 fangorn kernel: irq event stamp: 2010211249
Aug  4 04:29:43 fangorn kernel: hardirqs last  enabled at (2010211248): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:29:43 fangorn kernel: hardirqs last disabled at (2010211249): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:29:43 fangorn kernel: softirqs last  enabled at (2010211040): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:29:43 fangorn kernel: softirqs last disabled at (2010211237): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:29:43 fangorn kernel: CPU 3:
Aug  4 04:29:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:29:43 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:29:43 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:29:43 fangorn kernel: RSP: 0018:ffff88002f59dcd0  EFLAGS: 00000246
Aug  4 04:29:43 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f59dcf0 RCX: 0000000000000061
Aug  4 04:29:43 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f59dc70 RDI: 0000000000000246
Aug  4 04:29:43 fangorn kernel: RBP: ffffffff81013bf3 R08: 0000000000000003 R09: 000000009cc9ebcb
Aug  4 04:29:43 fangorn kernel: R10: ffff88002f59dc20 R11: 000000009cc9ebcb R12: ffff88002f59dc50
Aug  4 04:29:43 fangorn kernel: R13: ffff8801205b0ed8 R14: 0000000000000246 R15: 000000009cc9ebcb
Aug  4 04:29:43 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:29:43 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:29:43 fangorn kernel: CR2: 00007fa9ecc1a000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:29:43 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:29:43 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:29:43 fangorn kernel: Call Trace:
Aug  4 04:29:43 fangorn kernel: <IRQ>  [<ffffffff8125b30d>] ? blk_end_bidi_request+0x65/0x88
Aug  4 04:29:43 fangorn kernel: [<ffffffff8125b3a6>] ? blk_end_request+0x23/0x39
Aug  4 04:29:43 fangorn kernel: [<ffffffff8135e16f>] ? scsi_io_completion+0x1b4/0x439
Aug  4 04:29:43 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 04:29:43 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 04:29:43 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 04:29:43 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 04:29:43 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:29:43 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:29:43 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:29:43 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:29:43 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:29:43 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:29:43 fangorn kernel: <EOI>  [<ffffffff810fe616>] ? free_pages_check+0x32/0x72
Aug  4 04:29:43 fangorn kernel: [<ffffffff810ffc21>] ? free_hot_cold_page+0x5d/0x1e5
Aug  4 04:29:43 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:29:43 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:29:43 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:29:43 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:29:43 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:29:43 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:29:43 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:29:43 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:29:43 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:29:43 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:29:43 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:29:43 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:29:43 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:29:43 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:29:43 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:30:48 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:30:48 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:30:48 fangorn kernel: irq event stamp: 2039364604
Aug  4 04:30:48 fangorn kernel: hardirqs last  enabled at (2039364603): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:30:48 fangorn kernel: hardirqs last disabled at (2039364604): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:30:48 fangorn kernel: softirqs last  enabled at (2039364598): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:30:48 fangorn kernel: softirqs last disabled at (2039364567): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:30:48 fangorn kernel: CPU 3:
Aug  4 04:30:48 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:30:48 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:30:48 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:30:48 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:30:48 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:30:48 fangorn kernel: RDX: 0000000000000650 RSI: ffff88005a7659b0 RDI: ffff88007f7c99b0
Aug  4 04:30:48 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a19e44e8 R09: 0000000000000003
Aug  4 04:30:48 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:30:48 fangorn kernel: R13: ffff8800a19e44e8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:30:48 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:30:48 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:30:48 fangorn kernel: CR2: 00007fa9ecc1a000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:30:48 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:30:48 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:30:48 fangorn kernel: Call Trace:
Aug  4 04:30:48 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:30:48 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:30:48 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:30:48 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:30:48 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:30:48 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:30:48 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:30:48 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:30:48 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:30:48 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:31:54 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:31:54 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:31:54 fangorn kernel: irq event stamp: 2068349813
Aug  4 04:31:54 fangorn kernel: hardirqs last  enabled at (2068349812): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:31:54 fangorn kernel: hardirqs last disabled at (2068349813): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:31:54 fangorn kernel: softirqs last  enabled at (2068349808): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:31:54 fangorn kernel: softirqs last disabled at (2068349811): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:31:54 fangorn kernel: CPU 3:
Aug  4 04:31:54 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:31:54 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:31:54 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:31:54 fangorn kernel: RSP: 0018:ffff88002f59dea0  EFLAGS: 00000246
Aug  4 04:31:54 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f59df00 RCX: ffff880120cf6910
Aug  4 04:31:54 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:31:54 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f59de90 R09: 000000009cc9ebcb
Aug  4 04:31:54 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f59de20
Aug  4 04:31:54 fangorn kernel: R13: 0000000000000091 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:31:54 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:31:54 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:31:54 fangorn kernel: CR2: 00007fa9ecc1a000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:31:54 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:31:54 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:31:54 fangorn kernel: Call Trace:
Aug  4 04:31:54 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:31:54 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:31:54 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:31:54 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:31:54 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:31:54 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:31:54 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 04:31:54 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:31:54 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:31:54 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:31:54 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:31:54 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:31:54 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:31:54 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:31:54 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:31:54 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:31:54 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:32:59 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:32:59 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:32:59 fangorn kernel: irq event stamp: 2097680966
Aug  4 04:32:59 fangorn kernel: hardirqs last  enabled at (2097680965): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:32:59 fangorn kernel: hardirqs last disabled at (2097680966): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:32:59 fangorn kernel: softirqs last  enabled at (2097680546): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:32:59 fangorn kernel: softirqs last disabled at (2097680515): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:32:59 fangorn kernel: CPU 3:
Aug  4 04:32:59 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:32:59 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:32:59 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:32:59 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:32:59 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:32:59 fangorn kernel: RDX: 000000000000036a RSI: ffff8800cd75fc96 RDI: ffff88002456ec96
Aug  4 04:32:59 fangorn kernel: RBP: ffffffff81013bee R08: ffff880114b0a678 R09: 0000000000000001
Aug  4 04:32:59 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:32:59 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:32:59 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:32:59 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:32:59 fangorn kernel: CR2: 00007fa9ecc1a000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:32:59 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:32:59 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:32:59 fangorn kernel: Call Trace:
Aug  4 04:32:59 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:32:59 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:32:59 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:32:59 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:32:59 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:32:59 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:32:59 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:32:59 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:32:59 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:32:59 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:34:38 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:34:38 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:34:38 fangorn kernel: irq event stamp: 2141517942
Aug  4 04:34:38 fangorn kernel: hardirqs last  enabled at (2141517941): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:34:38 fangorn kernel: hardirqs last disabled at (2141517942): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:34:38 fangorn kernel: softirqs last  enabled at (2141517676): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:34:38 fangorn kernel: softirqs last disabled at (2141517645): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:34:38 fangorn kernel: CPU 3:
Aug  4 04:34:38 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:34:38 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:34:38 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:34:38 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 04:34:38 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 04:34:38 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 04:34:38 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff824bdb58 R09: 000000009cc9ebcb
Aug  4 04:34:38 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 04:34:38 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 04:34:38 fangorn kernel: FS:  00007fb2172a4910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:34:38 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:34:38 fangorn kernel: CR2: 00007f2c88832000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:34:38 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:34:38 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:34:38 fangorn kernel: Call Trace:
Aug  4 04:34:38 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 04:34:38 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 04:34:38 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:34:38 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:34:38 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:34:38 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:34:38 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:34:38 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:34:38 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:34:38 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:34:38 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:34:38 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:34:38 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:34:38 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:34:38 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:34:38 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:34:38 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:36:24 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:36:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:36:24 fangorn kernel: irq event stamp: 2182558586
Aug  4 04:36:24 fangorn kernel: hardirqs last  enabled at (2182558585): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:36:24 fangorn kernel: hardirqs last disabled at (2182558586): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:36:24 fangorn kernel: softirqs last  enabled at (2182558502): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:36:24 fangorn kernel: softirqs last disabled at (2182558477): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:36:24 fangorn kernel: CPU 1:
Aug  4 04:36:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:36:24 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:36:24 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:36:24 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:36:24 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:36:24 fangorn kernel: RDX: 0000000000000efe RSI: ffff88008233b102 RDI: ffff88007fb80102
Aug  4 04:36:24 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a3a00998 R09: 0000000000000001
Aug  4 04:36:24 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:36:24 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:36:24 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:36:24 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:36:24 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:36:24 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:36:24 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:36:24 fangorn kernel: Call Trace:
Aug  4 04:36:24 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:36:24 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:36:24 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:36:24 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:36:24 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:36:24 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:36:24 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:36:24 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:36:24 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:36:24 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:37:30 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:37:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:37:30 fangorn kernel: irq event stamp: 2207163978
Aug  4 04:37:30 fangorn kernel: hardirqs last  enabled at (2207163977): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:37:30 fangorn kernel: hardirqs last disabled at (2207163978): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:37:30 fangorn kernel: softirqs last  enabled at (2207163646): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:37:30 fangorn kernel: softirqs last disabled at (2207163595): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:37:30 fangorn kernel: CPU 1:
Aug  4 04:37:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:37:30 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:37:30 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:37:30 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 04:37:30 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 04:37:30 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 04:37:30 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff824be848 R09: 000000009cc9ebcb
Aug  4 04:37:30 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 04:37:30 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 04:37:30 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:37:30 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:37:30 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:37:30 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:37:30 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:37:30 fangorn kernel: Call Trace:
Aug  4 04:37:30 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 04:37:30 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 04:37:30 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:37:30 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:37:30 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:37:30 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:37:30 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:37:30 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:37:30 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:37:30 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:37:30 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:37:30 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:37:30 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:37:30 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:37:30 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:37:30 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:37:30 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:38:35 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:38:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:38:35 fangorn kernel: irq event stamp: 2231808278
Aug  4 04:38:35 fangorn kernel: hardirqs last  enabled at (2231808277): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:38:35 fangorn kernel: hardirqs last disabled at (2231808278): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:38:35 fangorn kernel: softirqs last  enabled at (2231808112): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:38:35 fangorn kernel: softirqs last disabled at (2231808085): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:38:35 fangorn kernel: CPU 1:
Aug  4 04:38:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:38:35 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:38:35 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:38:35 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 04:38:35 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 04:38:35 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 04:38:35 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff82556b58 R09: 000000009cc9ebcb
Aug  4 04:38:35 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 04:38:35 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 04:38:35 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:38:35 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:38:35 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:38:35 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:38:35 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:38:35 fangorn kernel: Call Trace:
Aug  4 04:38:35 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 04:38:35 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 04:38:35 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:38:35 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:38:35 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:38:35 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:38:35 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:38:35 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:38:35 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:38:35 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:38:35 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:38:35 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:38:35 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:38:35 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:38:35 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:38:35 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:38:35 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:39:41 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:39:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:39:41 fangorn kernel: irq event stamp: 2256282666
Aug  4 04:39:41 fangorn kernel: hardirqs last  enabled at (2256282665): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:39:41 fangorn kernel: hardirqs last disabled at (2256282666): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:39:41 fangorn kernel: softirqs last  enabled at (2256282652): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:39:41 fangorn kernel: softirqs last disabled at (2256282601): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:39:41 fangorn kernel: CPU 1:
Aug  4 04:39:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:39:41 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:39:41 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:39:41 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 04:39:41 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 04:39:41 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 04:39:41 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff824c1818 R09: 000000009cc9ebcb
Aug  4 04:39:41 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 04:39:41 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 04:39:41 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:39:41 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:39:41 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:39:41 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:39:41 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:39:41 fangorn kernel: Call Trace:
Aug  4 04:39:41 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 04:39:41 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 04:39:41 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:39:41 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:39:41 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:39:41 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:39:41 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:39:41 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:39:41 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:39:41 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:39:41 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:39:41 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:39:41 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:39:41 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:39:41 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:39:41 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:39:41 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:40:46 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:40:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:40:46 fangorn kernel: irq event stamp: 2280673848
Aug  4 04:40:46 fangorn kernel: hardirqs last  enabled at (2280673847): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:40:46 fangorn kernel: hardirqs last disabled at (2280673848): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:40:46 fangorn kernel: softirqs last  enabled at (2280673778): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:40:46 fangorn kernel: softirqs last disabled at (2280673753): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:40:46 fangorn kernel: CPU 1:
Aug  4 04:40:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:40:46 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:40:46 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 04:40:46 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 04:40:46 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:40:46 fangorn kernel: RDX: 0000000000000e61 RSI: ffff88001fc8519f RDI: ffff88007fa2c19f
Aug  4 04:40:46 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801206531c8 R09: 0000000000000003
Aug  4 04:40:46 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: 0000000000000000
Aug  4 04:40:46 fangorn kernel: R13: 00000000000001ab R14: ffff880120708000 R15: 0000000000000000
Aug  4 04:40:46 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:40:46 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:40:46 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:40:46 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:40:46 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:40:46 fangorn kernel: Call Trace:
Aug  4 04:40:46 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:40:46 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:40:46 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:40:46 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:40:46 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:40:46 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:40:46 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:40:46 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:40:46 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:40:46 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:42:59 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:42:59 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:42:59 fangorn kernel: irq event stamp: 2329737110
Aug  4 04:42:59 fangorn kernel: hardirqs last  enabled at (2329737109): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:42:59 fangorn kernel: hardirqs last disabled at (2329737110): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:42:59 fangorn kernel: softirqs last  enabled at (2329736690): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:42:59 fangorn kernel: softirqs last disabled at (2329736677): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:42:59 fangorn kernel: CPU 1:
Aug  4 04:42:59 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:42:59 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:42:59 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:42:59 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:42:59 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:42:59 fangorn kernel: RDX: 000000000000030e RSI: ffff880020b20cf2 RDI: ffff88005a76ccf2
Aug  4 04:42:59 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1740 R09: 0000000000000003
Aug  4 04:42:59 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 04:42:59 fangorn kernel: R13: ffff8800b86b1740 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:42:59 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:42:59 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:42:59 fangorn kernel: CR2: 00007ff978682730 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:42:59 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:42:59 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:42:59 fangorn kernel: Call Trace:
Aug  4 04:42:59 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:42:59 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:42:59 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:42:59 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:42:59 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:42:59 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:42:59 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:42:59 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:42:59 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:42:59 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:44:05 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:44:05 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:44:05 fangorn kernel: irq event stamp: 2354432171
Aug  4 04:44:05 fangorn kernel: hardirqs last  enabled at (2354432170): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:44:05 fangorn kernel: hardirqs last disabled at (2354432171): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:44:05 fangorn kernel: softirqs last  enabled at (2354432156): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:44:05 fangorn kernel: softirqs last disabled at (2354432165): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:44:05 fangorn kernel: CPU 1:
Aug  4 04:44:05 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:44:05 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:44:05 fangorn kernel: RIP: 0010:[<ffffffff8135ddfc>]  [<ffffffff8135ddfc>] scsi_device_unbusy+0x37/0xd8
Aug  4 04:44:05 fangorn kernel: RSP: 0018:ffff88002f1e1da0  EFLAGS: 00000246
Aug  4 04:44:05 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1dd0 RCX: ffff88002f1e1e60
Aug  4 04:44:05 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000002002 RDI: ffff8801213663e8
Aug  4 04:44:05 fangorn kernel: RBP: ffffffff81013bf3 R08: 0000000000000002 R09: 000000009cc9ebcb
Aug  4 04:44:05 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1d20
Aug  4 04:44:05 fangorn kernel: R13: ffff880120e49090 R14: ffff880121366360 R15: 000000009cc9ebcb
Aug  4 04:44:05 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:44:05 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:44:05 fangorn kernel: CR2: 00007ff978682730 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:44:05 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:44:05 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:44:05 fangorn kernel: Call Trace:
Aug  4 04:44:05 fangorn kernel: <IRQ>  [<ffffffff81355e36>] ? scsi_finish_command+0x3b/0x127
Aug  4 04:44:05 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 04:44:05 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 04:44:05 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 04:44:05 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:44:05 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:44:05 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:44:05 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:44:05 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:44:05 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:44:05 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 04:44:05 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:44:05 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:44:05 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:44:05 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:44:05 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:44:05 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:44:05 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:44:05 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:44:05 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:44:05 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:45:10 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:45:10 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:45:10 fangorn kernel: irq event stamp: 2379156699
Aug  4 04:45:10 fangorn kernel: hardirqs last  enabled at (2379156698): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:45:10 fangorn kernel: hardirqs last disabled at (2379156699): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:45:10 fangorn kernel: softirqs last  enabled at (2379156682): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:45:10 fangorn kernel: softirqs last disabled at (2379156697): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:45:10 fangorn kernel: CPU 1:
Aug  4 04:45:10 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:45:10 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:45:10 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:45:10 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:45:10 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:45:10 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:45:10 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:45:10 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:45:10 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:45:10 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:45:10 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:45:10 fangorn kernel: CR2: 00007ff978682730 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:45:10 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:45:10 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:45:10 fangorn kernel: Call Trace:
Aug  4 04:45:10 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:45:10 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:45:10 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:45:10 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:45:10 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:45:10 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:45:10 fangorn kernel: <EOI>  [<ffffffff81277dee>] ? memcmp+0x1f/0x49
Aug  4 04:45:10 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:45:10 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:45:10 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:45:10 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:45:10 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:45:10 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:45:10 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:45:10 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:45:10 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:45:10 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:46:50 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:46:50 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:46:50 fangorn kernel: irq event stamp: 2420534450
Aug  4 04:46:50 fangorn kernel: hardirqs last  enabled at (2420534449): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:46:50 fangorn kernel: hardirqs last disabled at (2420534450): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:46:50 fangorn kernel: softirqs last  enabled at (2420534444): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:46:50 fangorn kernel: softirqs last disabled at (2420534413): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:46:50 fangorn kernel: CPU 3:
Aug  4 04:46:50 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:46:50 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:46:50 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:46:50 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:46:50 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:46:50 fangorn kernel: RDX: 0000000000000587 RSI: ffff8800d4fefa79 RDI: ffff88008927fa79
Aug  4 04:46:50 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a3a00b28 R09: 0000000000000003
Aug  4 04:46:50 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:46:50 fangorn kernel: R13: ffff8800a3a00b28 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:46:50 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:46:50 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:46:50 fangorn kernel: CR2: 00007f87ade5c000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:46:50 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:46:50 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:46:50 fangorn kernel: Call Trace:
Aug  4 04:46:50 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:46:50 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:46:50 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:46:50 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:46:50 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:46:50 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:46:50 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:46:50 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:46:50 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:46:50 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:47:56 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:47:56 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:47:56 fangorn kernel: irq event stamp: 2449898424
Aug  4 04:47:56 fangorn kernel: hardirqs last  enabled at (2449898423): [<ffffffff810ffd7b>] free_hot_cold_page+0x1b7/0x1e5
Aug  4 04:47:56 fangorn kernel: hardirqs last disabled at (2449898424): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:47:56 fangorn kernel: softirqs last  enabled at (2449898230): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:47:56 fangorn kernel: softirqs last disabled at (2449898199): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:47:56 fangorn kernel: CPU 3:
Aug  4 04:47:56 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:47:56 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:47:56 fangorn kernel: RIP: 0010:[<ffffffff810ffd81>]  [<ffffffff810ffd81>] free_hot_cold_page+0x1bd/0x1e5
Aug  4 04:47:56 fangorn kernel: RSP: 0018:ffff880120709b70  EFLAGS: 00000246
Aug  4 04:47:56 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709bc0 RCX: 00000000000000fe
Aug  4 04:47:56 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000246
Aug  4 04:47:56 fangorn kernel: RBP: ffffffff81013bee R08: 0000000000000000 R09: 000000009cc9ebcb
Aug  4 04:47:56 fangorn kernel: R10: ffffffff81dcc6f0 R11: 0000000000000000 R12: 0000000000000000
Aug  4 04:47:56 fangorn kernel: R13: ffffffff814fa6fe R14: ffff880120709b00 R15: ffff8800000156d0
Aug  4 04:47:56 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:47:56 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:47:56 fangorn kernel: CR2: 00007f87ade5c000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:47:56 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:47:56 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:47:56 fangorn kernel: Call Trace:
Aug  4 04:47:56 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 04:47:56 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 04:47:56 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 04:47:56 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 04:47:56 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 04:47:56 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 04:47:56 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:47:56 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:47:56 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:47:56 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:47:56 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:47:56 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:47:56 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:47:56 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:47:56 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:49:01 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:49:01 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:49:01 fangorn kernel: irq event stamp: 2479426562
Aug  4 04:49:01 fangorn kernel: hardirqs last  enabled at (2479426561): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:49:01 fangorn kernel: hardirqs last disabled at (2479426562): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:49:01 fangorn kernel: softirqs last  enabled at (2479426540): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:49:01 fangorn kernel: softirqs last disabled at (2479426509): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:49:01 fangorn kernel: CPU 3:
Aug  4 04:49:01 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:49:01 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:49:01 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:49:01 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 04:49:01 fangorn kernel: RAX: 0000000000000038 RBX: ffff880120709cd0 RCX: 0000000000000058
Aug  4 04:49:01 fangorn kernel: RDX: 00000000000006f4 RSI: ffff88010331790c RDI: ffff8800aa90190c
Aug  4 04:49:01 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800566854e8 R09: 0000000000000002
Aug  4 04:49:01 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:49:01 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:49:01 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:49:01 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:49:01 fangorn kernel: CR2: 00007f87ade5c000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:49:01 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:49:01 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:49:01 fangorn kernel: Call Trace:
Aug  4 04:49:01 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:49:01 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:49:01 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:49:01 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:49:01 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:49:01 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:49:01 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:49:01 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:49:01 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:49:01 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:50:07 fangorn kernel: BUG: soft lockup - CPU#3 stuck for 61s! [md2_raid1:111]
Aug  4 04:50:07 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:50:07 fangorn kernel: irq event stamp: 2509012063
Aug  4 04:50:07 fangorn kernel: hardirqs last  enabled at (2509012062): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:50:07 fangorn kernel: hardirqs last disabled at (2509012063): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:50:07 fangorn kernel: softirqs last  enabled at (2509012048): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:50:07 fangorn kernel: softirqs last disabled at (2509012051): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:50:07 fangorn kernel: CPU 3:
Aug  4 04:50:07 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:50:07 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:50:07 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 04:50:07 fangorn kernel: RSP: 0018:ffff88002f59daf0  EFLAGS: 00000246
Aug  4 04:50:07 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f59db10 RCX: 0000000000000072
Aug  4 04:50:07 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f59da90 RDI: 0000000000000246
Aug  4 04:50:07 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88012050cd70 R09: 000000009cc9ebcb
Aug  4 04:50:07 fangorn kernel: R10: ffffffff81dd69b0 R11: 0000000000000000 R12: ffff88002f59da70
Aug  4 04:50:07 fangorn kernel: R13: ffff88012050cd58 R14: 0000000000000246 R15: 000000009cc9ebcb
Aug  4 04:50:07 fangorn kernel: FS:  00007fb2186a6910(0000) GS:ffff88002f59a000(0000) knlGS:0000000000000000
Aug  4 04:50:07 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:50:07 fangorn kernel: CR2: 00007f87ade5c000 CR3: 0000000118092000 CR4: 00000000000006e0
Aug  4 04:50:07 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:50:07 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:50:07 fangorn kernel: Call Trace:
Aug  4 04:50:07 fangorn kernel: <IRQ>  [<ffffffff81050719>] ? __wake_up+0x53/0x70
Aug  4 04:50:07 fangorn kernel: [<ffffffff813e9704>] ? md_wakeup_thread+0x3b/0x51
Aug  4 04:50:07 fangorn kernel: [<ffffffffa00017c6>] ? reschedule_retry+0x8a/0xad [raid1]
Aug  4 04:50:07 fangorn kernel: [<ffffffffa0001865>] ? end_sync_read+0x7c/0x92 [raid1]
Aug  4 04:50:07 fangorn kernel: [<ffffffff8116be23>] ? bio_endio+0x3e/0x54
Aug  4 04:50:07 fangorn kernel: [<ffffffff81259064>] ? req_bio_endio+0xae/0xe4
Aug  4 04:50:07 fangorn kernel: [<ffffffff81259246>] ? blk_update_request+0x1ac/0x35e
Aug  4 04:50:07 fangorn kernel: [<ffffffff81259427>] ? blk_update_bidi_request+0x2f/0x7f
Aug  4 04:50:07 fangorn kernel: [<ffffffff8125b2da>] ? blk_end_bidi_request+0x32/0x88
Aug  4 04:50:07 fangorn kernel: [<ffffffff8125b3a6>] ? blk_end_request+0x23/0x39
Aug  4 04:50:07 fangorn kernel: [<ffffffff8135e16f>] ? scsi_io_completion+0x1b4/0x439
Aug  4 04:50:07 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 04:50:07 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 04:50:07 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 04:50:07 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 04:50:07 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:50:07 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:50:07 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:50:07 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:50:07 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:50:07 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:50:07 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 04:50:07 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:50:07 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:50:07 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:50:07 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:50:07 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:50:07 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:50:07 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:50:07 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:50:07 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:50:07 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:51:21 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:51:21 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:51:21 fangorn kernel: irq event stamp: 2536443056
Aug  4 04:51:21 fangorn kernel: hardirqs last  enabled at (2536443055): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:51:21 fangorn kernel: hardirqs last disabled at (2536443056): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:51:21 fangorn kernel: softirqs last  enabled at (2536442642): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:51:21 fangorn kernel: softirqs last disabled at (2536442591): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:51:21 fangorn kernel: CPU 1:
Aug  4 04:51:21 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:51:21 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:51:21 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:51:21 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:51:21 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:51:21 fangorn kernel: RDX: 00000000000004f7 RSI: ffff8800c7cb9b09 RDI: ffff880022ce3b09
Aug  4 04:51:21 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801207fe998 R09: 0000000000000001
Aug  4 04:51:21 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:51:21 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:51:21 fangorn kernel: FS:  00007ff7eb91a7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:51:21 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:51:21 fangorn kernel: CR2: 00007fd80aa0b000 CR3: 00000000d50bc000 CR4: 00000000000006e0
Aug  4 04:51:21 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:51:21 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:51:21 fangorn kernel: Call Trace:
Aug  4 04:51:21 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:51:21 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:51:21 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:51:21 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:51:21 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:51:21 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:51:21 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:51:21 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:51:21 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:51:21 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:52:26 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:52:26 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:52:26 fangorn kernel: irq event stamp: 2561282768
Aug  4 04:52:26 fangorn kernel: hardirqs last  enabled at (2561282767): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:52:26 fangorn kernel: hardirqs last disabled at (2561282768): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:52:26 fangorn kernel: softirqs last  enabled at (2561282350): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:52:26 fangorn kernel: softirqs last disabled at (2561282287): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:52:26 fangorn kernel: CPU 1:
Aug  4 04:52:26 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:52:26 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:52:26 fangorn kernel: RIP: 0010:[<ffffffff81277df5>]  [<ffffffff81277df5>] memcmp+0x26/0x49
Aug  4 04:52:26 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000282
Aug  4 04:52:26 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:52:26 fangorn kernel: RDX: 0000000000000072 RSI: ffff8800c5df5f8e RDI: ffff880083c2af8f
Aug  4 04:52:26 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801180835b0 R09: 0000000000000002
Aug  4 04:52:26 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:52:26 fangorn kernel: R13: ffff8801180835b0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:52:26 fangorn kernel: FS:  00007ff7eb91a7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:52:26 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:52:26 fangorn kernel: CR2: 00007fd80aa0b000 CR3: 00000000d50bc000 CR4: 00000000000006e0
Aug  4 04:52:26 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:52:26 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:52:26 fangorn kernel: Call Trace:
Aug  4 04:52:26 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:52:26 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:52:26 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:52:26 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:52:26 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:52:26 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:52:26 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:52:26 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:52:26 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:52:26 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:53:32 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:53:32 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:53:32 fangorn kernel: irq event stamp: 2586124928
Aug  4 04:53:32 fangorn kernel: hardirqs last  enabled at (2586124927): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 04:53:32 fangorn kernel: hardirqs last disabled at (2586124928): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:53:32 fangorn kernel: softirqs last  enabled at (2586124786): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:53:32 fangorn kernel: softirqs last disabled at (2586124761): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:53:32 fangorn kernel: CPU 1:
Aug  4 04:53:32 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:53:32 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:53:32 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 04:53:32 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 04:53:32 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:53:32 fangorn kernel: RDX: 00000000000004d3 RSI: ffff8800625bab2d RDI: ffff8800ab661b2d
Aug  4 04:53:32 fangorn kernel: RBP: ffffffff81013bee R08: ffff880118083e48 R09: 0000000000000001
Aug  4 04:53:32 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 04:53:32 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 04:53:32 fangorn kernel: FS:  00007ff7eb91a7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:53:32 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:53:32 fangorn kernel: CR2: 00007fd80aa0b000 CR3: 00000000d50bc000 CR4: 00000000000006e0
Aug  4 04:53:32 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:53:32 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:53:32 fangorn kernel: Call Trace:
Aug  4 04:53:32 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:53:32 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:53:32 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:53:32 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:53:32 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:53:32 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:53:32 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:53:32 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:53:32 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:53:32 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:54:37 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:54:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:54:37 fangorn kernel: irq event stamp: 2610785538
Aug  4 04:54:37 fangorn kernel: hardirqs last  enabled at (2610785537): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:54:37 fangorn kernel: hardirqs last disabled at (2610785538): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:54:37 fangorn kernel: softirqs last  enabled at (2610785158): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:54:37 fangorn kernel: softirqs last disabled at (2610785095): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:54:37 fangorn kernel: CPU 1:
Aug  4 04:54:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:54:37 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:54:37 fangorn kernel: RIP: 0010:[<ffffffff81277df0>]  [<ffffffff81277df0>] memcmp+0x21/0x49
Aug  4 04:54:37 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:54:37 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:54:37 fangorn kernel: RDX: 0000000000000ea0 RSI: ffff8800ca7ad160 RDI: ffff88005ad2d160
Aug  4 04:54:37 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801206534e8 R09: 0000000000000003
Aug  4 04:54:37 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:54:37 fangorn kernel: R13: ffff8801206534e8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:54:37 fangorn kernel: FS:  00007ff7eb91a7b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:54:37 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:54:37 fangorn kernel: CR2: 00007fd80aa0b000 CR3: 00000000d50bc000 CR4: 00000000000006e0
Aug  4 04:54:37 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:54:37 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:54:37 fangorn kernel: Call Trace:
Aug  4 04:54:37 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:54:37 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:54:37 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:54:37 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:54:37 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:54:37 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:54:37 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:54:37 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:54:37 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:54:37 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:56:24 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:56:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:56:24 fangorn kernel: irq event stamp: 2650058191
Aug  4 04:56:24 fangorn kernel: hardirqs last  enabled at (2650058190): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 04:56:24 fangorn kernel: hardirqs last disabled at (2650058191): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:56:24 fangorn kernel: softirqs last  enabled at (2650057830): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:56:24 fangorn kernel: softirqs last disabled at (2650058189): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:56:24 fangorn kernel: CPU 1:
Aug  4 04:56:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:56:24 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:56:24 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 04:56:24 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 04:56:24 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 04:56:24 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 04:56:24 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 04:56:24 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 04:56:24 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 04:56:24 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:56:24 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:56:24 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:56:24 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:56:24 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:56:24 fangorn kernel: Call Trace:
Aug  4 04:56:24 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:56:24 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:56:24 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:56:24 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:56:24 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:56:24 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:56:24 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 04:56:24 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:56:24 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:56:24 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:56:24 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:56:24 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:56:24 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:56:24 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:56:24 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:56:24 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:56:24 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:57:29 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:57:29 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:57:29 fangorn kernel: irq event stamp: 2674860685
Aug  4 04:57:29 fangorn kernel: hardirqs last  enabled at (2674860684): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:57:29 fangorn kernel: hardirqs last disabled at (2674860685): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:57:29 fangorn kernel: softirqs last  enabled at (2674860670): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:57:29 fangorn kernel: softirqs last disabled at (2674860679): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:57:29 fangorn kernel: CPU 1:
Aug  4 04:57:29 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:57:29 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:57:29 fangorn kernel: RIP: 0010:[<ffffffff8135e461>]  [<ffffffff8135e461>] scsi_softirq_done+0x31/0x146
Aug  4 04:57:29 fangorn kernel: RSP: 0018:ffff88002f1e1e20  EFLAGS: 00000246
Aug  4 04:57:29 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1e50 RCX: ffff88002f1e1e60
Aug  4 04:57:29 fangorn kernel: RDX: ffff88002f1e1e60 RSI: ffffffff810cadf3 RDI: ffff8800ab8b6cc0
Aug  4 04:57:29 fangorn kernel: RBP: ffffffff81013bf3 R08: 0000000000000002 R09: 000000009cc9ebcb
Aug  4 04:57:29 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1da0
Aug  4 04:57:29 fangorn kernel: R13: 0000000000000004 R14: ffff880058a572c0 R15: 000000009cc9ebcb
Aug  4 04:57:29 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:57:29 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:57:29 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:57:29 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:57:29 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:57:29 fangorn kernel: Call Trace:
Aug  4 04:57:29 fangorn kernel: <IRQ>  [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 04:57:29 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 04:57:29 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 04:57:29 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 04:57:29 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 04:57:29 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 04:57:29 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 04:57:29 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 04:57:29 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 04:57:29 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:57:29 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:57:29 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:57:29 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:57:29 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:57:29 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:57:29 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:57:29 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:57:29 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:57:29 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:58:35 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:58:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:58:35 fangorn kernel: irq event stamp: 2699404362
Aug  4 04:58:35 fangorn kernel: hardirqs last  enabled at (2699404361): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:58:35 fangorn kernel: hardirqs last disabled at (2699404362): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:58:35 fangorn kernel: softirqs last  enabled at (2699403942): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:58:35 fangorn kernel: softirqs last disabled at (2699403877): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:58:35 fangorn kernel: CPU 1:
Aug  4 04:58:35 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:58:35 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:58:35 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 04:58:35 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 04:58:35 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:58:35 fangorn kernel: RDX: 000000000000082e RSI: ffff8800572f17d2 RDI: ffff88007f95b7d2
Aug  4 04:58:35 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d4d3cf10 R09: 0000000000000003
Aug  4 04:58:35 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:58:35 fangorn kernel: R13: ffff8800d4d3cf10 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:58:35 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:58:35 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:58:35 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:58:35 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:58:35 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:58:35 fangorn kernel: Call Trace:
Aug  4 04:58:35 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:58:35 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:58:35 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:58:35 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:58:35 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:58:35 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:58:35 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:58:35 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:58:35 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:58:35 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 04:59:40 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 04:59:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:59:40 fangorn kernel: irq event stamp: 2724059846
Aug  4 04:59:40 fangorn kernel: hardirqs last  enabled at (2724059845): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 04:59:40 fangorn kernel: hardirqs last disabled at (2724059846): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 04:59:40 fangorn kernel: softirqs last  enabled at (2724059430): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 04:59:40 fangorn kernel: softirqs last disabled at (2724059379): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 04:59:40 fangorn kernel: CPU 1:
Aug  4 04:59:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 04:59:40 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 04:59:40 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 04:59:40 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 04:59:40 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 04:59:40 fangorn kernel: RDX: 0000000000000a54 RSI: ffff8800225815ac RDI: ffff8800231cb5ac
Aug  4 04:59:40 fangorn kernel: RBP: ffffffff81013bee R08: ffff88012050ccb8 R09: 0000000000000002
Aug  4 04:59:40 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 04:59:40 fangorn kernel: R13: ffff88012050ccb8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 04:59:40 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 04:59:40 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 04:59:40 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 04:59:40 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 04:59:40 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 04:59:40 fangorn kernel: Call Trace:
Aug  4 04:59:40 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 04:59:40 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 04:59:40 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 04:59:40 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 04:59:40 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 04:59:40 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 04:59:40 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 04:59:40 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 04:59:40 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 04:59:40 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:00:46 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:00:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:00:46 fangorn kernel: irq event stamp: 2748631974
Aug  4 05:00:46 fangorn kernel: hardirqs last  enabled at (2748631973): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:00:46 fangorn kernel: hardirqs last disabled at (2748631974): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:00:46 fangorn kernel: softirqs last  enabled at (2748631556): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:00:46 fangorn kernel: softirqs last disabled at (2748631493): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:00:46 fangorn kernel: CPU 1:
Aug  4 05:00:46 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:00:46 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:00:46 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:00:46 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:00:46 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:00:46 fangorn kernel: RDX: 0000000000000419 RSI: ffff880105c6abe7 RDI: ffff88011fedebe7
Aug  4 05:00:46 fangorn kernel: RBP: ffffffff81013bee R08: ffff88009e6d2358 R09: 0000000000000002
Aug  4 05:00:46 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:00:46 fangorn kernel: R13: ffff88009e6d2358 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:00:46 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:00:46 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:00:46 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:00:46 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:00:46 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:00:46 fangorn kernel: Call Trace:
Aug  4 05:00:46 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:00:46 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:00:46 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:00:46 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:00:46 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:00:46 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:00:46 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:00:46 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:00:46 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:00:46 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:01:51 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:01:51 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:01:51 fangorn kernel: irq event stamp: 2773411654
Aug  4 05:01:51 fangorn kernel: hardirqs last  enabled at (2773411653): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:01:51 fangorn kernel: hardirqs last disabled at (2773411654): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:01:51 fangorn kernel: softirqs last  enabled at (2773411236): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:01:51 fangorn kernel: softirqs last disabled at (2773411185): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:01:51 fangorn kernel: CPU 1:
Aug  4 05:01:51 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:01:51 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:01:51 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:01:51 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:01:51 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:01:51 fangorn kernel: RDX: 000000000000036f RSI: ffff88001fd6cc91 RDI: ffff8800ba6a4c91
Aug  4 05:01:51 fangorn kernel: RBP: ffffffff81013bee R08: ffff880017503290 R09: 0000000000000002
Aug  4 05:01:51 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:01:51 fangorn kernel: R13: ffff880017503290 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:01:51 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:01:51 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:01:51 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:01:51 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:01:51 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:01:51 fangorn kernel: Call Trace:
Aug  4 05:01:51 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:01:51 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:01:51 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:01:51 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:01:51 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:01:51 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:01:51 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:01:51 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:01:51 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:01:51 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:02:57 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:02:57 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:02:57 fangorn kernel: irq event stamp: 2798367574
Aug  4 05:02:57 fangorn kernel: hardirqs last  enabled at (2798367573): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:02:57 fangorn kernel: hardirqs last disabled at (2798367574): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:02:57 fangorn kernel: softirqs last  enabled at (2798367156): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:02:57 fangorn kernel: softirqs last disabled at (2798367093): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:02:57 fangorn kernel: CPU 1:
Aug  4 05:02:57 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:02:57 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:02:57 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:02:57 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:02:57 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:02:57 fangorn kernel: RDX: 000000000000026b RSI: ffff8800c980dd95 RDI: ffff88005a094d95
Aug  4 05:02:57 fangorn kernel: RBP: ffffffff81013bee R08: ffff880017503cb8 R09: 0000000000000002
Aug  4 05:02:57 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:02:57 fangorn kernel: R13: ffff880017503cb8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:02:57 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:02:57 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:02:57 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:02:57 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:02:57 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:02:57 fangorn kernel: Call Trace:
Aug  4 05:02:57 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:02:57 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:02:57 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:02:57 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:02:57 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:02:57 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:02:57 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:02:57 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:02:57 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:02:57 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:04:02 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:04:02 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:04:02 fangorn kernel: irq event stamp: 2823358402
Aug  4 05:04:02 fangorn kernel: hardirqs last  enabled at (2823358401): [<ffffffff810966cd>] debug_check_no_locks_freed+0x13d/0x16a
Aug  4 05:04:02 fangorn kernel: hardirqs last disabled at (2823358402): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:04:02 fangorn kernel: softirqs last  enabled at (2823358072): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:04:02 fangorn kernel: softirqs last disabled at (2823358047): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:04:02 fangorn kernel: CPU 1:
Aug  4 05:04:02 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:04:02 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:04:02 fangorn kernel: RIP: 0010:[<ffffffff812806d1>]  [<ffffffff812806d1>] debug_check_no_obj_freed+0x5c/0x1ce
Aug  4 05:04:02 fangorn kernel: RSP: 0018:ffff880120709b00  EFLAGS: 00000202
Aug  4 05:04:02 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709b60 RCX: ffff880120709b00
Aug  4 05:04:02 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff88011e49d000
Aug  4 05:04:02 fangorn kernel: RBP: ffffffff81013bee R08: ffff880120709b00 R09: 000000009cc9ebcb
Aug  4 05:04:02 fangorn kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff880120709aa0
Aug  4 05:04:02 fangorn kernel: R13: ffffffff825021e0 R14: ffff88010a3ff000 R15: ffffffff814fa69f
Aug  4 05:04:02 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:04:02 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:04:02 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:04:02 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:04:02 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:04:02 fangorn kernel: Call Trace:
Aug  4 05:04:02 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 05:04:02 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 05:04:02 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 05:04:02 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 05:04:02 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:04:02 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 05:04:02 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 05:04:02 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:04:02 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:04:02 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:04:02 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:04:02 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:04:02 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:04:02 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:04:02 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:04:02 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:05:08 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:05:08 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:05:08 fangorn kernel: irq event stamp: 2848125792
Aug  4 05:05:08 fangorn kernel: hardirqs last  enabled at (2848125791): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:05:08 fangorn kernel: hardirqs last disabled at (2848125792): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:05:08 fangorn kernel: softirqs last  enabled at (2848125374): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:05:08 fangorn kernel: softirqs last disabled at (2848125311): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:05:08 fangorn kernel: CPU 1:
Aug  4 05:05:08 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:05:08 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:05:08 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:05:08 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:05:08 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:05:08 fangorn kernel: RDX: 0000000000000520 RSI: ffff880008c49ae0 RDI: ffff880022d1fae0
Aug  4 05:05:08 fangorn kernel: RBP: ffffffff81013bee R08: ffff880017503038 R09: 0000000000000002
Aug  4 05:05:08 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 05:05:08 fangorn kernel: R13: ffff880017503038 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:05:08 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:05:08 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:05:08 fangorn kernel: CR2: 00007f28fe892ae8 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:05:08 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:05:08 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:05:08 fangorn kernel: Call Trace:
Aug  4 05:05:08 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:05:08 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:05:08 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:05:08 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:05:08 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:05:08 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:05:08 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:05:08 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:05:08 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:05:08 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:06:43 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:06:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:06:43 fangorn kernel: irq event stamp: 2883472494
Aug  4 05:06:43 fangorn kernel: hardirqs last  enabled at (2883472493): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:06:43 fangorn kernel: hardirqs last disabled at (2883472494): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:06:43 fangorn kernel: softirqs last  enabled at (2883472074): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:06:43 fangorn kernel: softirqs last disabled at (2883472013): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:06:43 fangorn kernel: CPU 1:
Aug  4 05:06:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:06:43 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:06:43 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:06:43 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:06:43 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:06:43 fangorn kernel: RDX: 00000000000009e8 RSI: ffff88007e328618 RDI: ffff8800a08b7618
Aug  4 05:06:43 fangorn kernel: RBP: ffffffff81013bee R08: ffff880117969d80 R09: 0000000000000002
Aug  4 05:06:43 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:06:43 fangorn kernel: R13: ffff880117969d80 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:06:43 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:06:43 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:06:43 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:06:43 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:06:43 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:06:43 fangorn kernel: Call Trace:
Aug  4 05:06:43 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:06:43 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:06:43 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:06:43 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:06:43 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:06:43 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:06:43 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:06:43 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:06:43 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:06:43 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:07:49 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:07:49 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:07:49 fangorn kernel: irq event stamp: 2908157106
Aug  4 05:07:49 fangorn kernel: hardirqs last  enabled at (2908157105): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:07:49 fangorn kernel: hardirqs last disabled at (2908157106): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:07:49 fangorn kernel: softirqs last  enabled at (2908156688): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:07:49 fangorn kernel: softirqs last disabled at (2908156625): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:07:49 fangorn kernel: CPU 1:
Aug  4 05:07:49 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:07:49 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:07:49 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:07:49 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:07:49 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:07:49 fangorn kernel: RDX: 0000000000000ff6 RSI: ffff8800d51cc00a RDI: ffff88007fa7000a
Aug  4 05:07:49 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1808 R09: 0000000000000002
Aug  4 05:07:49 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:07:49 fangorn kernel: R13: ffff8800b86b1808 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:07:49 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:07:49 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:07:49 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:07:49 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:07:49 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:07:49 fangorn kernel: Call Trace:
Aug  4 05:07:49 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:07:49 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:07:49 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:07:49 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:07:49 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:07:49 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:07:49 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:07:49 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:07:49 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:07:49 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:08:54 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:08:54 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:08:54 fangorn kernel: irq event stamp: 2932867886
Aug  4 05:08:54 fangorn kernel: hardirqs last  enabled at (2932867885): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:08:54 fangorn kernel: hardirqs last disabled at (2932867886): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:08:54 fangorn kernel: softirqs last  enabled at (2932867472): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:08:54 fangorn kernel: softirqs last disabled at (2932867421): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:08:54 fangorn kernel: CPU 1:
Aug  4 05:08:54 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:08:54 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:08:54 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:08:54 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:08:54 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:08:54 fangorn kernel: RDX: 0000000000000286 RSI: ffff880020a80d7a RDI: ffff88001eb22d7a
Aug  4 05:08:54 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d6d8b100 R09: 0000000000000001
Aug  4 05:08:54 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:08:54 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:08:54 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:08:54 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:08:54 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:08:54 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:08:54 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:08:54 fangorn kernel: Call Trace:
Aug  4 05:08:54 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:08:54 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:08:54 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:08:54 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:08:54 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:08:54 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:08:54 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:08:54 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:08:54 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:08:54 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:10:00 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:10:00 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:10:00 fangorn kernel: irq event stamp: 2957696429
Aug  4 05:10:00 fangorn kernel: hardirqs last  enabled at (2957696428): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 05:10:00 fangorn kernel: hardirqs last disabled at (2957696429): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:10:00 fangorn kernel: softirqs last  enabled at (2957696126): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:10:00 fangorn kernel: softirqs last disabled at (2957696427): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:10:00 fangorn kernel: CPU 1:
Aug  4 05:10:00 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:10:00 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:10:00 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 05:10:00 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 05:10:00 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 05:10:00 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 05:10:00 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 05:10:00 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 05:10:00 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 05:10:00 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:10:00 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:10:00 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:10:00 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:10:00 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:10:00 fangorn kernel: Call Trace:
Aug  4 05:10:00 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 05:10:00 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 05:10:00 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 05:10:00 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 05:10:00 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 05:10:00 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 05:10:00 fangorn kernel: <EOI>  [<ffffffff81277dee>] ? memcmp+0x1f/0x49
Aug  4 05:10:00 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:10:00 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:10:00 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:10:00 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:10:00 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:10:00 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:10:00 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:10:00 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:10:00 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:10:00 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:11:05 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:11:05 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:11:05 fangorn kernel: irq event stamp: 2982405008
Aug  4 05:11:05 fangorn kernel: hardirqs last  enabled at (2982405007): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:11:05 fangorn kernel: hardirqs last disabled at (2982405008): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:11:05 fangorn kernel: softirqs last  enabled at (2982404588): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:11:05 fangorn kernel: softirqs last disabled at (2982404573): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:11:05 fangorn kernel: CPU 1:
Aug  4 05:11:05 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:11:05 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:11:05 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:11:05 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:11:05 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:11:05 fangorn kernel: RDX: 000000000000070c RSI: ffff8800827ba8f4 RDI: ffff8800ca16e8f4
Aug  4 05:11:05 fangorn kernel: RBP: ffffffff81013bee R08: ffff880056685358 R09: 0000000000000003
Aug  4 05:11:05 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 05:11:05 fangorn kernel: R13: ffff880056685358 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:11:05 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:11:05 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:11:05 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:11:05 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:11:05 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:11:05 fangorn kernel: Call Trace:
Aug  4 05:11:05 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:11:05 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:11:05 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:11:05 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:11:05 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:11:05 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:11:05 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:11:05 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:11:05 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:11:05 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:12:11 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:12:11 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:12:11 fangorn kernel: irq event stamp: 3007284972
Aug  4 05:12:11 fangorn kernel: hardirqs last  enabled at (3007284971): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:12:11 fangorn kernel: hardirqs last disabled at (3007284972): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:12:11 fangorn kernel: softirqs last  enabled at (3007284554): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:12:11 fangorn kernel: softirqs last disabled at (3007284507): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:12:11 fangorn kernel: CPU 1:
Aug  4 05:12:11 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:12:11 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:12:11 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:12:11 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:12:11 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:12:11 fangorn kernel: RDX: 0000000000000fbd RSI: ffff88007d849043 RDI: ffff880089945043
Aug  4 05:12:11 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800822db678 R09: 0000000000000002
Aug  4 05:12:11 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 05:12:11 fangorn kernel: R13: ffff8800822db678 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:12:11 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:12:11 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:12:11 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:12:11 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:12:11 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:12:11 fangorn kernel: Call Trace:
Aug  4 05:12:11 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:12:11 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:12:11 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:12:11 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:12:11 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:12:11 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:12:11 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:12:11 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:12:11 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:12:11 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:13:16 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:13:16 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:13:16 fangorn kernel: irq event stamp: 3032145692
Aug  4 05:13:16 fangorn kernel: hardirqs last  enabled at (3032145691): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:13:16 fangorn kernel: hardirqs last disabled at (3032145692): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:13:16 fangorn kernel: softirqs last  enabled at (3032145272): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:13:16 fangorn kernel: softirqs last disabled at (3032145257): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:13:16 fangorn kernel: CPU 1:
Aug  4 05:13:16 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:13:16 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:13:16 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:13:16 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:13:16 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:13:16 fangorn kernel: RDX: 00000000000003ad RSI: ffff8800b57aec53 RDI: ffff880093f12c53
Aug  4 05:13:16 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d4d3c100 R09: 0000000000000003
Aug  4 05:13:16 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 05:13:16 fangorn kernel: R13: ffff8800d4d3c100 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:13:16 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:13:16 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:13:16 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:13:16 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:13:16 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:13:16 fangorn kernel: Call Trace:
Aug  4 05:13:16 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:13:16 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:13:16 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:13:16 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:13:16 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:13:16 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:13:16 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:13:16 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:13:16 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:13:16 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:14:22 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:14:22 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:14:22 fangorn kernel: irq event stamp: 3056832826
Aug  4 05:14:22 fangorn kernel: hardirqs last  enabled at (3056832825): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:14:22 fangorn kernel: hardirqs last disabled at (3056832826): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:14:22 fangorn kernel: softirqs last  enabled at (3056832410): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:14:22 fangorn kernel: softirqs last disabled at (3056832359): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:14:22 fangorn kernel: CPU 1:
Aug  4 05:14:22 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:14:22 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:14:22 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:14:22 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:14:22 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:14:22 fangorn kernel: RDX: 0000000000000b26 RSI: ffff8800d50bf4da RDI: ffff880099b774da
Aug  4 05:14:22 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d6d8b038 R09: 0000000000000002
Aug  4 05:14:22 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:14:22 fangorn kernel: R13: ffff8800d6d8b038 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:14:22 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:14:22 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:14:22 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:14:22 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:14:22 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:14:22 fangorn kernel: Call Trace:
Aug  4 05:14:22 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:14:22 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:14:22 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:14:22 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:14:22 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:14:22 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:14:22 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:14:22 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:14:22 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:14:22 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:15:27 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:15:27 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:15:27 fangorn kernel: irq event stamp: 3081757780
Aug  4 05:15:27 fangorn kernel: hardirqs last  enabled at (3081757779): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:15:27 fangorn kernel: hardirqs last disabled at (3081757780): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:15:27 fangorn kernel: softirqs last  enabled at (3081757692): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:15:27 fangorn kernel: softirqs last disabled at (3081757667): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:15:27 fangorn kernel: CPU 1:
Aug  4 05:15:27 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:15:27 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:15:27 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:15:27 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:15:27 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:15:27 fangorn kernel: RDX: 000000000000097b RSI: ffff88003282a685 RDI: ffff88000a4df685
Aug  4 05:15:27 fangorn kernel: RBP: ffffffff81013bee R08: ffff880056685358 R09: 0000000000000002
Aug  4 05:15:27 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:15:27 fangorn kernel: R13: ffff880056685358 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:15:27 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:15:27 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:15:27 fangorn kernel: CR2: 00000036442d6080 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:15:27 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:15:27 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:15:27 fangorn kernel: Call Trace:
Aug  4 05:15:27 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:15:27 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:15:27 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:15:27 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:15:27 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:15:27 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:15:27 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:15:27 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:15:27 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:15:27 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:17:01 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:17:01 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:17:01 fangorn kernel: irq event stamp: 3116470729
Aug  4 05:17:01 fangorn kernel: hardirqs last  enabled at (3116470728): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:17:01 fangorn kernel: hardirqs last disabled at (3116470729): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:17:01 fangorn kernel: softirqs last  enabled at (3116470276): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:17:01 fangorn kernel: softirqs last disabled at (3116470695): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:17:01 fangorn kernel: CPU 1:
Aug  4 05:17:01 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:17:01 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:17:01 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 05:17:01 fangorn kernel: RSP: 0018:ffff88002f1e1b50  EFLAGS: 00000246
Aug  4 05:17:01 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1b70 RCX: 0000000000000064
Aug  4 05:17:01 fangorn kernel: RDX: 0000000000000000 RSI: ffff88002f1e1af0 RDI: 0000000000000246
Aug  4 05:17:01 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88012053af00 R09: 000000009cc9ebcb
Aug  4 05:17:01 fangorn kernel: R10: ffffffff81dfd3c0 R11: 0000000000000000 R12: ffff88002f1e1ad0
Aug  4 05:17:01 fangorn kernel: R13: ffff880121366c30 R14: 0000000000000246 R15: 000000009cc9ebcb
Aug  4 05:17:01 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:17:01 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:17:01 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:17:01 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:17:01 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:17:01 fangorn kernel: Call Trace:
Aug  4 05:17:01 fangorn kernel: <IRQ>  [<ffffffff8135625e>] ? scsi_dispatch_cmd+0x1d4/0x25f
Aug  4 05:17:01 fangorn kernel: [<ffffffff8135d24d>] ? scsi_request_fn+0x483/0x4c4
Aug  4 05:17:01 fangorn kernel: [<ffffffff8125bb1b>] ? __blk_run_queue+0x54/0x9a
Aug  4 05:17:01 fangorn kernel: [<ffffffff8125bc52>] ? blk_run_queue+0x39/0x63
Aug  4 05:17:01 fangorn kernel: [<ffffffff8135c430>] ? scsi_run_queue+0x315/0x3de
Aug  4 05:17:01 fangorn kernel: [<ffffffff8135d53c>] ? scsi_next_command+0x4a/0x71
Aug  4 05:17:01 fangorn kernel: [<ffffffff8135e1c1>] ? scsi_io_completion+0x206/0x439
Aug  4 05:17:01 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:17:01 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 05:17:01 fangorn kernel: [<ffffffff810cadf3>] ? handle_fasteoi_irq+0xc1/0xf9
Aug  4 05:17:01 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 05:17:01 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 05:17:01 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 05:17:01 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 05:17:01 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 05:17:01 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 05:17:01 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 05:17:01 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 05:17:01 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 05:17:01 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 05:17:01 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:17:01 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:17:01 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:17:01 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:17:01 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:17:01 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:17:01 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:17:01 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:17:01 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:17:01 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:18:06 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:18:06 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:18:06 fangorn kernel: irq event stamp: 3141398728
Aug  4 05:18:06 fangorn kernel: hardirqs last  enabled at (3141398727): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:18:06 fangorn kernel: hardirqs last disabled at (3141398728): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:18:06 fangorn kernel: softirqs last  enabled at (3141398508): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:18:06 fangorn kernel: softirqs last disabled at (3141398447): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:18:06 fangorn kernel: CPU 1:
Aug  4 05:18:06 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:18:06 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:18:06 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:18:06 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:18:06 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:18:06 fangorn kernel: RDX: 00000000000001b0 RSI: ffff8800a9fb6e50 RDI: ffff8800c1cc8e50
Aug  4 05:18:06 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1a60 R09: 0000000000000003
Aug  4 05:18:06 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:18:06 fangorn kernel: R13: ffff8800b86b1a60 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:18:06 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:18:06 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:18:06 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:18:06 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:18:06 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:18:06 fangorn kernel: Call Trace:
Aug  4 05:18:06 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:18:06 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:18:06 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:18:06 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:18:06 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:18:06 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:18:06 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:18:06 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:18:06 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:18:06 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:19:12 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:19:12 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:19:12 fangorn kernel: irq event stamp: 3166134724
Aug  4 05:19:12 fangorn kernel: hardirqs last  enabled at (3166134723): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:19:12 fangorn kernel: hardirqs last disabled at (3166134724): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:19:12 fangorn kernel: softirqs last  enabled at (3166134386): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:19:12 fangorn kernel: softirqs last disabled at (3166134335): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:19:12 fangorn kernel: CPU 1:
Aug  4 05:19:12 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:19:12 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:19:12 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 05:19:12 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 05:19:12 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 05:19:12 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 05:19:12 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff825abae8 R09: 000000009cc9ebcb
Aug  4 05:19:12 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 05:19:12 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 05:19:12 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:19:12 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:19:12 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:19:12 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:19:12 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:19:12 fangorn kernel: Call Trace:
Aug  4 05:19:12 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 05:19:12 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 05:19:12 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 05:19:12 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 05:19:12 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 05:19:12 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:19:12 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 05:19:12 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 05:19:12 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:19:12 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:19:12 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:19:12 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:19:12 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:19:12 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:19:12 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:19:12 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:19:12 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:20:17 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:20:17 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:20:17 fangorn kernel: irq event stamp: 3190960488
Aug  4 05:20:17 fangorn kernel: hardirqs last  enabled at (3190960487): [<ffffffff810966cd>] debug_check_no_locks_freed+0x13d/0x16a
Aug  4 05:20:17 fangorn kernel: hardirqs last disabled at (3190960488): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:20:17 fangorn kernel: softirqs last  enabled at (3190960410): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:20:17 fangorn kernel: softirqs last disabled at (3190960359): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:20:17 fangorn kernel: CPU 1:
Aug  4 05:20:17 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:20:17 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:20:17 fangorn kernel: RIP: 0010:[<ffffffff8127ffb3>]  [<ffffffff8127ffb3>] get_bucket+0xb/0x74
Aug  4 05:20:17 fangorn kernel: RSP: 0018:ffff880120709af0  EFLAGS: 00000216
Aug  4 05:20:17 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709b60 RCX: 000ffff8800bf64d
Aug  4 05:20:17 fangorn kernel: RDX: 0000000000000000 RSI: 000ffff8800bf64d RDI: 000ffff8800bf64d
Aug  4 05:20:17 fangorn kernel: RBP: ffffffff81013bee R08: ffff880120f42ce8 R09: 000000009cc9ebcb
Aug  4 05:20:17 fangorn kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800d2685000
Aug  4 05:20:17 fangorn kernel: R13: ffffffff814fa69f R14: ffff880120f424a0 R15: 000000009cc9ebcb
Aug  4 05:20:17 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:20:17 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:20:17 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:20:17 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:20:17 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:20:17 fangorn kernel: Call Trace:
Aug  4 05:20:17 fangorn kernel: [<ffffffff812806d6>] ? debug_check_no_obj_freed+0x61/0x1ce
Aug  4 05:20:17 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 05:20:17 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 05:20:17 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 05:20:17 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 05:20:17 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:20:17 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 05:20:17 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 05:20:17 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:20:17 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:20:17 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:20:17 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:20:17 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:20:17 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:20:17 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:20:17 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:20:17 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:21:23 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:21:23 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:21:23 fangorn kernel: irq event stamp: 3215761054
Aug  4 05:21:23 fangorn kernel: hardirqs last  enabled at (3215761053): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:21:23 fangorn kernel: hardirqs last disabled at (3215761054): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:21:23 fangorn kernel: softirqs last  enabled at (3215761036): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:21:23 fangorn kernel: softirqs last disabled at (3215761011): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:21:23 fangorn kernel: CPU 1:
Aug  4 05:21:23 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:21:23 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:21:23 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:21:23 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:21:23 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000007
Aug  4 05:21:23 fangorn kernel: RDX: 0000000000001000 RSI: ffff8800b128f000 RDI: ffff8800c79b7000
Aug  4 05:21:23 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1a60 R09: 0000000000000001
Aug  4 05:21:23 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:21:23 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:21:23 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:21:23 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:21:23 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:21:23 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:21:23 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:21:23 fangorn kernel: Call Trace:
Aug  4 05:21:23 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:21:23 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:21:23 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:21:23 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:21:23 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:21:23 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:21:23 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:21:23 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:21:23 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:21:23 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:22:28 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:22:28 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:22:28 fangorn kernel: irq event stamp: 3240591522
Aug  4 05:22:28 fangorn kernel: hardirqs last  enabled at (3240591521): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:22:28 fangorn kernel: hardirqs last disabled at (3240591522): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:22:28 fangorn kernel: softirqs last  enabled at (3240591108): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:22:28 fangorn kernel: softirqs last disabled at (3240591057): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:22:28 fangorn kernel: CPU 1:
Aug  4 05:22:28 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:22:28 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:22:28 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:22:28 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:22:28 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:22:28 fangorn kernel: RDX: 0000000000000c79 RSI: ffff8800821fb387 RDI: ffff8800abe97387
Aug  4 05:22:28 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d6d8bbf0 R09: 0000000000000001
Aug  4 05:22:28 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:22:28 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:22:28 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:22:28 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:22:28 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:22:28 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:22:28 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:22:28 fangorn kernel: Call Trace:
Aug  4 05:22:28 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:22:28 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:22:28 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:22:28 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:22:28 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:22:28 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:22:28 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:22:28 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:22:28 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:22:28 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:23:34 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:23:34 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:23:34 fangorn kernel: irq event stamp: 3265408664
Aug  4 05:23:34 fangorn kernel: hardirqs last  enabled at (3265408663): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:23:34 fangorn kernel: hardirqs last disabled at (3265408664): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:23:34 fangorn kernel: softirqs last  enabled at (3265408546): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:23:34 fangorn kernel: softirqs last disabled at (3265408521): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:23:34 fangorn kernel: CPU 1:
Aug  4 05:23:34 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:23:34 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:23:34 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:23:34 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:23:34 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:23:34 fangorn kernel: RDX: 000000000000001b RSI: ffff88005723afe5 RDI: ffff88007e87ffe5
Aug  4 05:23:34 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d4d3c038 R09: 0000000000000001
Aug  4 05:23:34 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:23:34 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:23:34 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:23:34 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:23:34 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:23:34 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:23:34 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:23:34 fangorn kernel: Call Trace:
Aug  4 05:23:34 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:23:34 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:23:34 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:23:34 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:23:34 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:23:34 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:23:34 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:23:34 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:23:34 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:23:34 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:24:39 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:24:39 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:24:39 fangorn kernel: irq event stamp: 3289929598
Aug  4 05:24:39 fangorn kernel: hardirqs last  enabled at (3289929597): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:24:39 fangorn kernel: hardirqs last disabled at (3289929598): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:24:39 fangorn kernel: softirqs last  enabled at (3289929582): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:24:39 fangorn kernel: softirqs last disabled at (3289929557): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:24:39 fangorn kernel: CPU 1:
Aug  4 05:24:39 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:24:39 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:24:39 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:24:39 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:24:39 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:24:39 fangorn kernel: RDX: 0000000000000fe3 RSI: ffff88001675001d RDI: ffff88000e34701d
Aug  4 05:24:39 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801179694e8 R09: 0000000000000003
Aug  4 05:24:39 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:24:39 fangorn kernel: R13: ffff8801179694e8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:24:39 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:24:39 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:24:39 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:24:39 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:24:39 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:24:39 fangorn kernel: Call Trace:
Aug  4 05:24:39 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:24:39 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:24:39 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:24:39 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:24:39 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:24:39 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:24:39 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:24:39 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:24:39 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:24:39 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:25:45 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:25:45 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:25:45 fangorn kernel: irq event stamp: 3314515948
Aug  4 05:25:45 fangorn kernel: hardirqs last  enabled at (3314515947): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:25:45 fangorn kernel: hardirqs last disabled at (3314515948): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:25:45 fangorn kernel: softirqs last  enabled at (3314515528): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:25:45 fangorn kernel: softirqs last disabled at (3314515461): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:25:45 fangorn kernel: CPU 1:
Aug  4 05:25:45 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:25:45 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:25:45 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:25:45 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:25:45 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:25:45 fangorn kernel: RDX: 0000000000000e60 RSI: ffff88001897b1a0 RDI: ffff88001051b1a0
Aug  4 05:25:45 fangorn kernel: RBP: ffffffff81013bee R08: ffff880117969a60 R09: 0000000000000003
Aug  4 05:25:45 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:25:45 fangorn kernel: R13: ffff880117969a60 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:25:45 fangorn kernel: FS:  00007f32158566f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:25:45 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:25:45 fangorn kernel: CR2: 00000000004b9eb0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:25:45 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:25:45 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:25:45 fangorn kernel: Call Trace:
Aug  4 05:25:45 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:25:45 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:25:45 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:25:45 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:25:45 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:25:45 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:25:45 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:25:45 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:25:45 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:25:45 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:27:19 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:27:19 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:27:19 fangorn kernel: irq event stamp: 3349458302
Aug  4 05:27:19 fangorn kernel: hardirqs last  enabled at (3349458301): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:27:19 fangorn kernel: hardirqs last disabled at (3349458302): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:27:19 fangorn kernel: softirqs last  enabled at (3349457884): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:27:19 fangorn kernel: softirqs last disabled at (3349457823): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:27:19 fangorn kernel: CPU 1:
Aug  4 05:27:19 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:27:19 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:27:19 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:27:19 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:27:19 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:27:19 fangorn kernel: RDX: 000000000000068b RSI: ffff880023087975 RDI: ffff88006cea1975
Aug  4 05:27:19 fangorn kernel: RBP: ffffffff81013bee R08: ffff880056685d80 R09: 0000000000000002
Aug  4 05:27:19 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:27:19 fangorn kernel: R13: ffff880056685d80 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:27:19 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:27:19 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:27:19 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:27:19 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:27:19 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:27:19 fangorn kernel: Call Trace:
Aug  4 05:27:19 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:27:19 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:27:19 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:27:19 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:27:19 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:27:19 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:27:19 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:27:19 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:27:19 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:27:19 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:28:25 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:28:25 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:28:25 fangorn kernel: irq event stamp: 3374306276
Aug  4 05:28:25 fangorn kernel: hardirqs last  enabled at (3374306275): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:28:25 fangorn kernel: hardirqs last disabled at (3374306276): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:28:25 fangorn kernel: softirqs last  enabled at (3374305856): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:28:25 fangorn kernel: softirqs last disabled at (3374305841): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:28:25 fangorn kernel: CPU 1:
Aug  4 05:28:25 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:28:25 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:28:25 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:28:25 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:28:25 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:28:25 fangorn kernel: RDX: 00000000000002a8 RSI: ffff8800042e1d58 RDI: ffff8800d5179d58
Aug  4 05:28:25 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801207fe740 R09: 0000000000000003
Aug  4 05:28:25 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 05:28:25 fangorn kernel: R13: ffff8801207fe740 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:28:25 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:28:25 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:28:25 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:28:25 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:28:25 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:28:25 fangorn kernel: Call Trace:
Aug  4 05:28:25 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:28:25 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:28:25 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:28:25 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:28:25 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:28:25 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:28:25 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:28:25 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:28:25 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:28:25 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:29:30 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:29:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:29:30 fangorn kernel: irq event stamp: 3399113542
Aug  4 05:29:30 fangorn kernel: hardirqs last  enabled at (3399113541): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:29:30 fangorn kernel: hardirqs last disabled at (3399113542): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:29:30 fangorn kernel: softirqs last  enabled at (3399113128): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:29:30 fangorn kernel: softirqs last disabled at (3399113077): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:29:30 fangorn kernel: CPU 1:
Aug  4 05:29:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:29:30 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:29:30 fangorn kernel: RIP: 0010:[<ffffffff81277df0>]  [<ffffffff81277df0>] memcmp+0x21/0x49
Aug  4 05:29:30 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:29:30 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000020
Aug  4 05:29:30 fangorn kernel: RDX: 000000000000012b RSI: ffff8800d507ced5 RDI: ffff88005caeeed5
Aug  4 05:29:30 fangorn kernel: RBP: ffffffff81013bee R08: ffff88011795ae48 R09: 0000000000000002
Aug  4 05:29:30 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:29:30 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:29:30 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:29:30 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:29:30 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:29:30 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:29:30 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:29:30 fangorn kernel: Call Trace:
Aug  4 05:29:30 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:29:30 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:29:30 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:29:30 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:29:30 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:29:30 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:29:30 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:29:30 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:29:30 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:29:30 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:30:36 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:30:36 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:30:36 fangorn kernel: irq event stamp: 3424029828
Aug  4 05:30:36 fangorn kernel: hardirqs last  enabled at (3424029827): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:30:36 fangorn kernel: hardirqs last disabled at (3424029828): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:30:36 fangorn kernel: softirqs last  enabled at (3424029414): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:30:36 fangorn kernel: softirqs last disabled at (3424029363): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:30:36 fangorn kernel: CPU 1:
Aug  4 05:30:36 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:30:36 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:30:36 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:30:36 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:30:36 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:30:36 fangorn kernel: RDX: 0000000000000b13 RSI: ffff8800d5c184ed RDI: ffff880089a734ed
Aug  4 05:30:36 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800c44eb358 R09: 0000000000000001
Aug  4 05:30:36 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:30:36 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:30:36 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:30:36 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:30:36 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:30:36 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:30:36 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:30:36 fangorn kernel: Call Trace:
Aug  4 05:30:36 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:30:36 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:30:36 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:30:36 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:30:36 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:30:36 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:30:36 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:30:36 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:30:36 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:30:36 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:31:41 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:31:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:31:41 fangorn kernel: irq event stamp: 3448836917
Aug  4 05:31:41 fangorn kernel: hardirqs last  enabled at (3448836916): [<ffffffff81136274>] kmem_cache_free+0xdf/0x13a
Aug  4 05:31:41 fangorn kernel: hardirqs last disabled at (3448836917): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:31:41 fangorn kernel: softirqs last  enabled at (3448836812): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:31:41 fangorn kernel: softirqs last disabled at (3448836895): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:31:41 fangorn kernel: CPU 1:
Aug  4 05:31:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:31:41 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:31:41 fangorn kernel: RIP: 0010:[<ffffffff81136279>]  [<ffffffff81136279>] kmem_cache_free+0xe4/0x13a
Aug  4 05:31:41 fangorn kernel: RSP: 0018:ffff88002f1e1c10  EFLAGS: 00000246
Aug  4 05:31:41 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1c60 RCX: 0000000000190003
Aug  4 05:31:41 fangorn kernel: RDX: 0000000000000000 RSI: ffffea00045b5170 RDI: 0000000000000246
Aug  4 05:31:41 fangorn kernel: RBP: ffffffff81013bf3 R08: 0000000000000000 R09: 000000009cc9ebcb
Aug  4 05:31:41 fangorn kernel: R10: ffffffff816698a2 R11: 0000000000000000 R12: ffff88002f1e1b90
Aug  4 05:31:41 fangorn kernel: R13: ffff880120db4090 R14: ffff8800ab966780 R15: 000000009cc9ebcb
Aug  4 05:31:41 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:31:41 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:31:41 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:31:41 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:31:41 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:31:41 fangorn kernel: Call Trace:
Aug  4 05:31:41 fangorn kernel: <IRQ>  [<ffffffff81356575>] ? scsi_pool_free_command+0x57/0x74
Aug  4 05:31:41 fangorn kernel: [<ffffffff81356aa8>] ? __scsi_put_command+0x77/0xa2
Aug  4 05:31:41 fangorn kernel: [<ffffffff81356b4b>] ? scsi_put_command+0x78/0x94
Aug  4 05:31:41 fangorn kernel: [<ffffffff8135d534>] ? scsi_next_command+0x42/0x71
Aug  4 05:31:41 fangorn kernel: [<ffffffff8135e1c1>] ? scsi_io_completion+0x206/0x439
Aug  4 05:31:41 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:31:41 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 05:31:41 fangorn kernel: [<ffffffff810cadf3>] ? handle_fasteoi_irq+0xc1/0xf9
Aug  4 05:31:41 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 05:31:41 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 05:31:41 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 05:31:41 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 05:31:41 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 05:31:41 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 05:31:41 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 05:31:41 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 05:31:41 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 05:31:41 fangorn kernel: <EOI>  [<ffffffff810ffd81>] ? free_hot_cold_page+0x1bd/0x1e5
Aug  4 05:31:41 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 05:31:41 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 05:31:41 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 05:31:41 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:31:41 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 05:31:41 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 05:31:41 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:31:41 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:31:41 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:31:41 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:31:41 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:31:41 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:31:41 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:31:41 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:31:41 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:32:47 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:32:47 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:32:47 fangorn kernel: irq event stamp: 3473491083
Aug  4 05:32:47 fangorn kernel: hardirqs last  enabled at (3473491082): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 05:32:47 fangorn kernel: hardirqs last disabled at (3473491083): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:32:47 fangorn kernel: softirqs last  enabled at (3473490682): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:32:47 fangorn kernel: softirqs last disabled at (3473491081): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:32:47 fangorn kernel: CPU 1:
Aug  4 05:32:47 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:32:47 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:32:47 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 05:32:47 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 05:32:47 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 05:32:47 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 05:32:47 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 05:32:47 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 05:32:47 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 05:32:47 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:32:47 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:32:47 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:32:47 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:32:47 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:32:47 fangorn kernel: Call Trace:
Aug  4 05:32:47 fangorn kernel: <IRQ>  [<ffffffff8116dce2>] ? bvec_free_bs+0x4a/0x60
Aug  4 05:32:47 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 05:32:47 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 05:32:47 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 05:32:47 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 05:32:47 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 05:32:47 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 05:32:47 fangorn kernel: <EOI>  [<ffffffff81136279>] ? kmem_cache_free+0xe4/0x13a
Aug  4 05:32:47 fangorn kernel: [<ffffffff8116dce2>] ? bvec_free_bs+0x4a/0x60
Aug  4 05:32:47 fangorn kernel: [<ffffffff8116dd3f>] ? bio_free+0x47/0x94
Aug  4 05:32:47 fangorn kernel: [<ffffffff8116ddb4>] ? bio_fs_destructor+0x28/0x40
Aug  4 05:32:47 fangorn kernel: [<ffffffff8116bfbf>] ? bio_put+0x40/0x56
Aug  4 05:32:47 fangorn kernel: [<ffffffffa0000f6c>] ? r1buf_pool_free+0x97/0xc9 [raid1]
Aug  4 05:32:47 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:32:47 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 05:32:47 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 05:32:47 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:32:47 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:32:47 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:32:47 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:32:47 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:32:47 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:32:47 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:32:47 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:32:47 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:33:52 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:33:52 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:33:52 fangorn kernel: irq event stamp: 3498058458
Aug  4 05:33:52 fangorn kernel: hardirqs last  enabled at (3498058457): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:33:52 fangorn kernel: hardirqs last disabled at (3498058458): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:33:52 fangorn kernel: softirqs last  enabled at (3498058040): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:33:52 fangorn kernel: softirqs last disabled at (3498057979): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:33:52 fangorn kernel: CPU 1:
Aug  4 05:33:52 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:33:52 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:33:52 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:33:52 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:33:52 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 000000000000005f
Aug  4 05:33:52 fangorn kernel: RDX: 0000000000000eac RSI: ffff8800b783d154 RDI: ffff88007afd7154
Aug  4 05:33:52 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800b86b1740 R09: 0000000000000002
Aug  4 05:33:52 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:33:52 fangorn kernel: R13: ffff8800b86b1740 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:33:52 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:33:52 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:33:52 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:33:52 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:33:52 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:33:52 fangorn kernel: Call Trace:
Aug  4 05:33:52 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:33:52 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:33:52 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:33:52 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:33:52 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:33:52 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:33:52 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:33:52 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:33:52 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:33:52 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:34:58 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:34:58 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:34:58 fangorn kernel: irq event stamp: 3522648880
Aug  4 05:34:58 fangorn kernel: hardirqs last  enabled at (3522648879): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:34:58 fangorn kernel: hardirqs last disabled at (3522648880): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:34:58 fangorn kernel: softirqs last  enabled at (3522648462): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:34:58 fangorn kernel: softirqs last disabled at (3522648399): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:34:58 fangorn kernel: CPU 1:
Aug  4 05:34:58 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:34:58 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:34:58 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:34:58 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:34:58 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000009
Aug  4 05:34:58 fangorn kernel: RDX: 0000000000000be0 RSI: ffff8800822e6420 RDI: ffff88009d852420
Aug  4 05:34:58 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800566854e8 R09: 0000000000000002
Aug  4 05:34:58 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:34:58 fangorn kernel: R13: ffff8800566854e8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:34:58 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:34:58 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:34:58 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:34:58 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:34:58 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:34:58 fangorn kernel: Call Trace:
Aug  4 05:34:58 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:34:58 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:34:58 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:34:58 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:34:58 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:34:58 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:34:58 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:34:58 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:34:58 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:34:58 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:36:03 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:36:03 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:36:03 fangorn kernel: irq event stamp: 3547155528
Aug  4 05:36:03 fangorn kernel: hardirqs last  enabled at (3547155527): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:36:03 fangorn kernel: hardirqs last disabled at (3547155528): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:36:03 fangorn kernel: softirqs last  enabled at (3547155110): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:36:03 fangorn kernel: softirqs last disabled at (3547155059): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:36:03 fangorn kernel: CPU 1:
Aug  4 05:36:03 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:36:03 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:36:03 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:36:03 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:36:03 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000074
Aug  4 05:36:03 fangorn kernel: RDX: 000000000000036d RSI: ffff880108202c93 RDI: ffff880114ea4c93
Aug  4 05:36:03 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800c44eb8d0 R09: 0000000000000002
Aug  4 05:36:03 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:36:03 fangorn kernel: R13: ffff8800c44eb8d0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:36:03 fangorn kernel: FS:  00007f86a52c67b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:36:03 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:36:03 fangorn kernel: CR2: 00007f86a53268e0 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:36:03 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:36:03 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:36:03 fangorn kernel: Call Trace:
Aug  4 05:36:03 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:36:03 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:36:03 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:36:03 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:36:03 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:36:03 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:36:03 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:36:03 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:36:03 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:36:03 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:37:40 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:37:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:37:40 fangorn kernel: irq event stamp: 3582604510
Aug  4 05:37:40 fangorn kernel: hardirqs last  enabled at (3582604509): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:37:40 fangorn kernel: hardirqs last disabled at (3582604510): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:37:40 fangorn kernel: softirqs last  enabled at (3582604408): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:37:40 fangorn kernel: softirqs last disabled at (3582604383): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:37:40 fangorn kernel: CPU 1:
Aug  4 05:37:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:37:40 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:37:40 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:37:40 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:37:40 fangorn kernel: RAX: 0000000000000074 RBX: ffff880120709cd0 RCX: 0000000000000069
Aug  4 05:37:40 fangorn kernel: RDX: 0000000000000f43 RSI: ffff8800748620bd RDI: ffff88007e93b0bd
Aug  4 05:37:40 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801180838d0 R09: 0000000000000003
Aug  4 05:37:40 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:37:40 fangorn kernel: R13: ffff8801180838d0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:37:40 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:37:40 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:37:40 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:37:40 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:37:40 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:37:40 fangorn kernel: Call Trace:
Aug  4 05:37:40 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:37:40 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:37:40 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:37:40 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:37:40 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:37:40 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:37:40 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:37:40 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:37:40 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:37:40 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:38:45 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:38:45 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:38:45 fangorn kernel: irq event stamp: 3607460596
Aug  4 05:38:45 fangorn kernel: hardirqs last  enabled at (3607460595): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:38:45 fangorn kernel: hardirqs last disabled at (3607460596): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:38:45 fangorn kernel: softirqs last  enabled at (3607460176): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:38:45 fangorn kernel: softirqs last disabled at (3607460163): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:38:45 fangorn kernel: CPU 1:
Aug  4 05:38:45 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:38:45 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:38:45 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:38:45 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:38:45 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:38:45 fangorn kernel: RDX: 00000000000005cd RSI: ffff8800adf8ea33 RDI: ffff8800d5167a33
Aug  4 05:38:45 fangorn kernel: RBP: ffffffff81013bee R08: ffff880058085678 R09: 0000000000000003
Aug  4 05:38:45 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff88002f1e1f28
Aug  4 05:38:45 fangorn kernel: R13: ffff880058085678 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:38:45 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:38:45 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:38:45 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:38:45 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:38:45 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:38:45 fangorn kernel: Call Trace:
Aug  4 05:38:45 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:38:45 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:38:45 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:38:45 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:38:45 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:38:45 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:38:45 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:38:45 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:38:45 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:38:45 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:39:51 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:39:51 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:39:51 fangorn kernel: irq event stamp: 3632268560
Aug  4 05:39:51 fangorn kernel: hardirqs last  enabled at (3632268559): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:39:51 fangorn kernel: hardirqs last disabled at (3632268560): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:39:51 fangorn kernel: softirqs last  enabled at (3632268146): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:39:51 fangorn kernel: softirqs last disabled at (3632268095): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:39:51 fangorn kernel: CPU 1:
Aug  4 05:39:51 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:39:51 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:39:51 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:39:51 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:39:51 fangorn kernel: RAX: 0000000000000028 RBX: ffff880120709cd0 RCX: 0000000000000064
Aug  4 05:39:51 fangorn kernel: RDX: 0000000000000176 RSI: ffff8800ab9c8e8a RDI: ffff880061bc8e8a
Aug  4 05:39:51 fangorn kernel: RBP: ffffffff81013bee R08: ffff880020bf7038 R09: 0000000000000002
Aug  4 05:39:51 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:39:51 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:39:51 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:39:51 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:39:51 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:39:51 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:39:51 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:39:51 fangorn kernel: Call Trace:
Aug  4 05:39:51 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:39:51 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:39:51 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:39:51 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:39:51 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:39:51 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:39:51 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:39:51 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:39:51 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:39:51 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:40:56 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:40:56 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:40:56 fangorn kernel: irq event stamp: 3656961708
Aug  4 05:40:56 fangorn kernel: hardirqs last  enabled at (3656961707): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:40:56 fangorn kernel: hardirqs last disabled at (3656961708): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:40:56 fangorn kernel: softirqs last  enabled at (3656961706): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:40:56 fangorn kernel: softirqs last disabled at (3656961655): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:40:56 fangorn kernel: CPU 1:
Aug  4 05:40:56 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:40:56 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:40:56 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:40:56 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:40:56 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000027
Aug  4 05:40:56 fangorn kernel: RDX: 000000000000000e RSI: ffff8800b96d5ff2 RDI: ffff8800748b9ff2
Aug  4 05:40:56 fangorn kernel: RBP: ffffffff81013bee R08: ffff880115f911c8 R09: 0000000000000003
Aug  4 05:40:56 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 05:40:56 fangorn kernel: R13: ffff880115f911c8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:40:56 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:40:56 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:40:56 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:40:56 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:40:56 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:40:56 fangorn kernel: Call Trace:
Aug  4 05:40:56 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:40:56 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:40:56 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:40:56 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:40:56 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:40:56 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:40:56 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:40:56 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:40:56 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:40:56 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:42:02 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:42:02 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:42:02 fangorn kernel: irq event stamp: 3681620744
Aug  4 05:42:02 fangorn kernel: hardirqs last  enabled at (3681620743): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:42:02 fangorn kernel: hardirqs last disabled at (3681620744): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:42:02 fangorn kernel: softirqs last  enabled at (3681620330): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:42:02 fangorn kernel: softirqs last disabled at (3681620305): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:42:02 fangorn kernel: CPU 1:
Aug  4 05:42:02 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:42:02 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:42:02 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:42:02 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:42:02 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:42:02 fangorn kernel: RDX: 00000000000000e7 RSI: ffff8800badc5f19 RDI: ffff88001e98ef19
Aug  4 05:42:02 fangorn kernel: RBP: ffffffff81013bee R08: ffff880115e7f1c8 R09: 0000000000000001
Aug  4 05:42:02 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:42:02 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:42:02 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:42:02 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:42:02 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:42:02 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:42:02 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:42:02 fangorn kernel: Call Trace:
Aug  4 05:42:02 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:42:02 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:42:02 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:42:02 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:42:02 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:42:02 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:42:02 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:42:02 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:42:02 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:42:02 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:43:07 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:43:07 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:43:07 fangorn kernel: irq event stamp: 3706415058
Aug  4 05:43:07 fangorn kernel: hardirqs last  enabled at (3706415057): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:43:07 fangorn kernel: hardirqs last disabled at (3706415058): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:43:07 fangorn kernel: softirqs last  enabled at (3706414640): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:43:07 fangorn kernel: softirqs last disabled at (3706414589): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:43:07 fangorn kernel: CPU 1:
Aug  4 05:43:07 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:43:07 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:43:07 fangorn kernel: RIP: 0010:[<ffffffff81277de8>]  [<ffffffff81277de8>] memcmp+0x19/0x49
Aug  4 05:43:07 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:43:07 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:43:07 fangorn kernel: RDX: 0000000000000cad RSI: ffff88003cb89353 RDI: ffff880016ca9353
Aug  4 05:43:07 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801207fe8d0 R09: 0000000000000002
Aug  4 05:43:07 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:43:07 fangorn kernel: R13: ffff8801207fe8d0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:43:07 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:43:07 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:43:07 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:43:07 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:43:07 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:43:07 fangorn kernel: Call Trace:
Aug  4 05:43:07 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:43:07 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:43:07 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:43:07 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:43:07 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:43:07 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:43:07 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:43:07 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:43:07 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:43:07 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:44:13 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:44:13 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:44:13 fangorn kernel: irq event stamp: 3731352223
Aug  4 05:44:13 fangorn kernel: hardirqs last  enabled at (3731352222): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 05:44:13 fangorn kernel: hardirqs last disabled at (3731352223): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:44:13 fangorn kernel: softirqs last  enabled at (3731352042): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:44:13 fangorn kernel: softirqs last disabled at (3731352221): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:44:13 fangorn kernel: CPU 1:
Aug  4 05:44:13 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:44:13 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:44:13 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 05:44:13 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 05:44:13 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 05:44:13 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 05:44:13 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 05:44:13 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 05:44:13 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 05:44:13 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:44:13 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:44:13 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:44:13 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:44:13 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:44:13 fangorn kernel: Call Trace:
Aug  4 05:44:13 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 05:44:13 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 05:44:13 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 05:44:13 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 05:44:13 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 05:44:13 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 05:44:13 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 05:44:13 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:44:13 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:44:13 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:44:13 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:44:13 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:44:13 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:44:13 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:44:13 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:44:13 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:44:13 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:45:18 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:45:18 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:45:18 fangorn kernel: irq event stamp: 3756191636
Aug  4 05:45:18 fangorn kernel: hardirqs last  enabled at (3756191635): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:45:18 fangorn kernel: hardirqs last disabled at (3756191636): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:45:18 fangorn kernel: softirqs last  enabled at (3756191634): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:45:18 fangorn kernel: softirqs last disabled at (3756191583): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:45:18 fangorn kernel: CPU 1:
Aug  4 05:45:18 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:45:18 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:45:18 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:45:18 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:45:18 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:45:18 fangorn kernel: RDX: 0000000000000607 RSI: ffff8800d51cc9f9 RDI: ffff8800822aa9f9
Aug  4 05:45:18 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800a3a00100 R09: 0000000000000003
Aug  4 05:45:18 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 05:45:18 fangorn kernel: R13: ffff8800a3a00100 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:45:18 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:45:18 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:45:18 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:45:18 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:45:18 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:45:18 fangorn kernel: Call Trace:
Aug  4 05:45:18 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:45:18 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:45:18 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:45:18 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:45:18 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:45:18 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:45:18 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:45:18 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:45:18 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:45:18 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:46:24 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:46:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:46:24 fangorn kernel: irq event stamp: 3781045164
Aug  4 05:46:24 fangorn kernel: hardirqs last  enabled at (3781045163): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:46:24 fangorn kernel: hardirqs last disabled at (3781045164): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:46:24 fangorn kernel: softirqs last  enabled at (3781045162): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:46:24 fangorn kernel: softirqs last disabled at (3781045111): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:46:24 fangorn kernel: CPU 1:
Aug  4 05:46:24 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:46:24 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:46:24 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:46:24 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:46:24 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:46:24 fangorn kernel: RDX: 0000000000000988 RSI: ffff880102d86678 RDI: ffff880082125678
Aug  4 05:46:24 fangorn kernel: RBP: ffffffff81013bee R08: ffff8801207feb28 R09: 0000000000000003
Aug  4 05:46:24 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff81015dc3
Aug  4 05:46:24 fangorn kernel: R13: ffff8801207feb28 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:46:24 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:46:24 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:46:24 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:46:24 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:46:24 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:46:24 fangorn kernel: Call Trace:
Aug  4 05:46:24 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:46:24 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:46:24 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:46:24 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:46:24 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:46:24 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:46:24 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:46:24 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:46:24 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:46:24 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:47:57 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:47:57 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:47:57 fangorn kernel: irq event stamp: 3815663562
Aug  4 05:47:57 fangorn kernel: hardirqs last  enabled at (3815663561): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:47:57 fangorn kernel: hardirqs last disabled at (3815663562): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:47:57 fangorn kernel: softirqs last  enabled at (3815663148): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:47:57 fangorn kernel: softirqs last disabled at (3815663097): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:47:57 fangorn kernel: CPU 1:
Aug  4 05:47:57 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:47:57 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:47:57 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:47:57 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:47:57 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:47:57 fangorn kernel: RDX: 0000000000000e8a RSI: ffff88008c704176 RDI: ffff8800bf621176
Aug  4 05:47:57 fangorn kernel: RBP: ffffffff81013bee R08: ffff880120653998 R09: 0000000000000001
Aug  4 05:47:57 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:47:57 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:47:57 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:47:57 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:47:57 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:47:57 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:47:57 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:47:57 fangorn kernel: Call Trace:
Aug  4 05:47:57 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:47:57 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:47:57 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:47:57 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:47:57 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:47:57 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:47:57 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:47:57 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:47:57 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:47:57 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:49:03 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:49:03 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:49:03 fangorn kernel: irq event stamp: 3840494950
Aug  4 05:49:03 fangorn kernel: hardirqs last  enabled at (3840494949): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:49:03 fangorn kernel: hardirqs last disabled at (3840494950): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:49:03 fangorn kernel: softirqs last  enabled at (3840494530): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:49:03 fangorn kernel: softirqs last disabled at (3840494467): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:49:03 fangorn kernel: CPU 1:
Aug  4 05:49:03 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:49:03 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:49:03 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:49:03 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:49:03 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:49:03 fangorn kernel: RDX: 0000000000000383 RSI: ffff8800adad5c7d RDI: ffff8800822f0c7d
Aug  4 05:49:03 fangorn kernel: RBP: ffffffff81013bee R08: ffff880093f38290 R09: 0000000000000002
Aug  4 05:49:03 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:49:03 fangorn kernel: R13: ffff880093f38290 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:49:03 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:49:03 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:49:03 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:49:03 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:49:03 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:49:03 fangorn kernel: Call Trace:
Aug  4 05:49:03 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:49:03 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:49:03 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:49:03 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:49:03 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:49:03 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:49:03 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:49:03 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:49:03 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:49:03 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:50:08 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:50:08 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:50:08 fangorn kernel: irq event stamp: 3865295866
Aug  4 05:50:08 fangorn kernel: hardirqs last  enabled at (3865295865): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:50:08 fangorn kernel: hardirqs last disabled at (3865295866): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:50:08 fangorn kernel: softirqs last  enabled at (3865295452): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:50:08 fangorn kernel: softirqs last disabled at (3865295401): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:50:08 fangorn kernel: CPU 1:
Aug  4 05:50:08 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:50:08 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:50:08 fangorn kernel: RIP: 0010:[<ffffffff81277de8>]  [<ffffffff81277de8>] memcmp+0x19/0x49
Aug  4 05:50:08 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:50:08 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:50:08 fangorn kernel: RDX: 0000000000000309 RSI: ffff880089b64cf7 RDI: ffff880020a49cf7
Aug  4 05:50:08 fangorn kernel: RBP: ffffffff81013bee R08: ffff880117969038 R09: 0000000000000001
Aug  4 05:50:08 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:50:08 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:50:08 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:50:08 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:50:08 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:50:08 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:50:08 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:50:08 fangorn kernel: Call Trace:
Aug  4 05:50:08 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:50:08 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:50:08 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:50:08 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:50:08 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:50:08 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:50:08 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:50:08 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:50:08 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:50:08 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:51:14 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:51:14 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:51:14 fangorn kernel: irq event stamp: 3890120410
Aug  4 05:51:14 fangorn kernel: hardirqs last  enabled at (3890120409): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:51:14 fangorn kernel: hardirqs last disabled at (3890120410): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:51:14 fangorn kernel: softirqs last  enabled at (3890119992): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:51:14 fangorn kernel: softirqs last disabled at (3890119931): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:51:14 fangorn kernel: CPU 1:
Aug  4 05:51:14 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:51:14 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:51:14 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:51:14 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:51:14 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:51:14 fangorn kernel: RDX: 0000000000000e3d RSI: ffff8800b3ffd1c3 RDI: ffff88007d9301c3
Aug  4 05:51:14 fangorn kernel: RBP: ffffffff81013bee R08: ffff880058085358 R09: 0000000000000002
Aug  4 05:51:14 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:51:14 fangorn kernel: R13: ffff880058085358 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:51:14 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:51:14 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:51:14 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:51:14 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:51:14 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:51:14 fangorn kernel: Call Trace:
Aug  4 05:51:14 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:51:14 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:51:14 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:51:14 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:51:14 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:51:14 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:51:14 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:51:14 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:51:14 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:51:14 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:52:19 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:52:19 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:52:19 fangorn kernel: irq event stamp: 3915224318
Aug  4 05:52:19 fangorn kernel: hardirqs last  enabled at (3915224317): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:52:19 fangorn kernel: hardirqs last disabled at (3915224318): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:52:19 fangorn kernel: softirqs last  enabled at (3915223898): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:52:19 fangorn kernel: softirqs last disabled at (3915223837): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:52:19 fangorn kernel: CPU 1:
Aug  4 05:52:19 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:52:19 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:52:19 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 05:52:19 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:52:19 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:52:19 fangorn kernel: RDX: 000000000000090e RSI: ffff88007483f6f2 RDI: ffff8800b53656f2
Aug  4 05:52:19 fangorn kernel: RBP: ffffffff81013bee R08: ffff880020bf78d0 R09: 0000000000000002
Aug  4 05:52:19 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:52:19 fangorn kernel: R13: ffff880020bf78d0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:52:19 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:52:19 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:52:19 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:52:19 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:52:19 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:52:19 fangorn kernel: Call Trace:
Aug  4 05:52:19 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:52:19 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:52:19 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:52:19 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:52:19 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:52:19 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:52:19 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:52:19 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:52:19 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:52:19 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:53:25 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:53:25 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:53:25 fangorn kernel: irq event stamp: 3940345058
Aug  4 05:53:25 fangorn kernel: hardirqs last  enabled at (3940345057): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:53:25 fangorn kernel: hardirqs last disabled at (3940345058): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:53:25 fangorn kernel: softirqs last  enabled at (3940344644): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:53:25 fangorn kernel: softirqs last disabled at (3940344593): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:53:25 fangorn kernel: CPU 1:
Aug  4 05:53:25 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:53:25 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:53:25 fangorn kernel: RIP: 0010:[<ffffffff81277df2>]  [<ffffffff81277df2>] memcmp+0x23/0x49
Aug  4 05:53:25 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000246
Aug  4 05:53:25 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:53:25 fangorn kernel: RDX: 0000000000000d9b RSI: ffff880084a91265 RDI: ffff880020ba8265
Aug  4 05:53:25 fangorn kernel: RBP: ffffffff81013bee R08: ffff880117969bf0 R09: 0000000000000001
Aug  4 05:53:25 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:53:25 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:53:25 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:53:25 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:53:25 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:53:25 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:53:25 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:53:25 fangorn kernel: Call Trace:
Aug  4 05:53:25 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:53:25 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:53:25 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:53:25 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:53:25 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:53:25 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:53:25 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:53:25 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:53:25 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:53:25 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:54:30 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:54:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:54:30 fangorn kernel: irq event stamp: 3965433172
Aug  4 05:54:30 fangorn kernel: hardirqs last  enabled at (3965433171): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 05:54:30 fangorn kernel: hardirqs last disabled at (3965433172): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:54:30 fangorn kernel: softirqs last  enabled at (3965432754): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:54:30 fangorn kernel: softirqs last disabled at (3965432703): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:54:30 fangorn kernel: CPU 1:
Aug  4 05:54:30 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:54:30 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:54:30 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:54:30 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:54:30 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:54:30 fangorn kernel: RDX: 000000000000087b RSI: ffff88001e460785 RDI: ffff88009e2fb785
Aug  4 05:54:30 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800d4d3c290 R09: 0000000000000002
Aug  4 05:54:30 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 05:54:30 fangorn kernel: R13: ffff8800d4d3c290 R14: ffff880120708000 R15: 0000000000000001
Aug  4 05:54:30 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:54:30 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:54:30 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:54:30 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:54:30 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:54:30 fangorn kernel: Call Trace:
Aug  4 05:54:30 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:54:30 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:54:30 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:54:30 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:54:30 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:54:30 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:54:30 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:54:30 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:54:30 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:54:30 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:55:36 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:55:36 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:55:36 fangorn kernel: irq event stamp: 3990214020
Aug  4 05:55:36 fangorn kernel: hardirqs last  enabled at (3990214019): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:55:36 fangorn kernel: hardirqs last disabled at (3990214020): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:55:36 fangorn kernel: softirqs last  enabled at (3990214000): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:55:36 fangorn kernel: softirqs last disabled at (3990213975): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:55:36 fangorn kernel: CPU 1:
Aug  4 05:55:36 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:55:36 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:55:36 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:55:36 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 05:55:36 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:55:36 fangorn kernel: RDX: 0000000000000cee RSI: ffff880024c05312 RDI: ffff880089109312
Aug  4 05:55:36 fangorn kernel: RBP: ffffffff81013bee R08: ffff880114b0a808 R09: 0000000000000001
Aug  4 05:55:36 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:55:36 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:55:36 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:55:36 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:55:36 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:55:36 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:55:36 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:55:36 fangorn kernel: Call Trace:
Aug  4 05:55:36 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:55:36 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:55:36 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:55:36 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:55:36 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:55:36 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:55:36 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:55:36 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:55:36 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:55:36 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:56:41 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:56:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:56:41 fangorn kernel: irq event stamp: 4015044375
Aug  4 05:56:41 fangorn kernel: hardirqs last  enabled at (4015044374): [<ffffffff81136274>] kmem_cache_free+0xdf/0x13a
Aug  4 05:56:41 fangorn kernel: hardirqs last disabled at (4015044375): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:56:41 fangorn kernel: softirqs last  enabled at (4015044328): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:56:41 fangorn kernel: softirqs last disabled at (4015044337): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:56:41 fangorn kernel: CPU 1:
Aug  4 05:56:41 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:56:41 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:56:41 fangorn kernel: RIP: 0010:[<ffffffff81136279>]  [<ffffffff81136279>] kmem_cache_free+0xe4/0x13a
Aug  4 05:56:41 fangorn kernel: RSP: 0018:ffff88002f1e1c00  EFLAGS: 00000246
Aug  4 05:56:41 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1c50 RCX: 0000000000150002
Aug  4 05:56:41 fangorn kernel: RDX: 0000000000000000 RSI: ffffea0002f5d580 RDI: 0000000000000246
Aug  4 05:56:41 fangorn kernel: RBP: ffffffff81013bf3 R08: 0000000000000000 R09: 000000009cc9ebcb
Aug  4 05:56:41 fangorn kernel: R10: ffffffff816698a2 R11: 0000000000000000 R12: ffff88002f1e1b80
Aug  4 05:56:41 fangorn kernel: R13: ffff880123260000 R14: ffff880074973000 R15: 000000009cc9ebcb
Aug  4 05:56:41 fangorn kernel: FS:  00007f396b97e6f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:56:41 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:56:41 fangorn kernel: CR2: 00007f28ff296a98 CR3: 0000000111026000 CR4: 00000000000006e0
Aug  4 05:56:41 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:56:41 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:56:41 fangorn kernel: Call Trace:
Aug  4 05:56:41 fangorn kernel: <IRQ>  [<ffffffff810fb8a4>] ? mempool_free_slab+0x2a/0x40
Aug  4 05:56:41 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:56:41 fangorn kernel: [<ffffffff8135d73b>] ? scsi_sg_free+0x5d/0x73
Aug  4 05:56:41 fangorn kernel: [<ffffffff8127da8c>] ? __sg_free_table+0x64/0x9c
Aug  4 05:56:41 fangorn kernel: [<ffffffff8135d6de>] ? scsi_sg_free+0x0/0x73
Aug  4 05:56:41 fangorn kernel: [<ffffffff8135d804>] ? __scsi_release_buffers+0x40/0xec
Aug  4 05:56:41 fangorn kernel: [<ffffffff8135e1b9>] ? scsi_io_completion+0x1fe/0x439
Aug  4 05:56:41 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 05:56:41 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 05:56:41 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 05:56:41 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 05:56:41 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 05:56:41 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 05:56:41 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 05:56:41 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 05:56:41 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 05:56:41 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 05:56:41 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 05:56:41 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:56:41 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:56:41 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:56:41 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:56:41 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:56:41 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:56:41 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:56:41 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:56:41 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:56:41 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:58:12 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:58:12 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:58:12 fangorn kernel: irq event stamp: 4049191632
Aug  4 05:58:12 fangorn kernel: hardirqs last  enabled at (4049191631): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 05:58:12 fangorn kernel: hardirqs last disabled at (4049191632): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:58:12 fangorn kernel: softirqs last  enabled at (4049191218): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:58:12 fangorn kernel: softirqs last disabled at (4049191167): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:58:12 fangorn kernel: CPU 1:
Aug  4 05:58:12 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:58:12 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:58:12 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 05:58:12 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 05:58:12 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 05:58:12 fangorn kernel: RDX: 00000000000001b3 RSI: ffff8800d65c1e4d RDI: ffff8800d5a4be4d
Aug  4 05:58:12 fangorn kernel: RBP: ffffffff81013bee R08: ffff88011f271420 R09: 0000000000000002
Aug  4 05:58:12 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 05:58:12 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 05:58:12 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:58:12 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:58:12 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:58:12 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:58:12 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:58:12 fangorn kernel: Call Trace:
Aug  4 05:58:12 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 05:58:12 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:58:12 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:58:12 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:58:12 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:58:12 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:58:12 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:58:12 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:58:12 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:58:12 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 05:59:18 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 05:59:18 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:59:18 fangorn kernel: irq event stamp: 4074012748
Aug  4 05:59:18 fangorn kernel: hardirqs last  enabled at (4074012747): [<ffffffff81136274>] kmem_cache_free+0xdf/0x13a
Aug  4 05:59:18 fangorn kernel: hardirqs last disabled at (4074012748): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 05:59:18 fangorn kernel: softirqs last  enabled at (4074012346): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 05:59:18 fangorn kernel: softirqs last disabled at (4074012295): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 05:59:18 fangorn kernel: CPU 1:
Aug  4 05:59:18 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 05:59:18 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 05:59:18 fangorn kernel: RIP: 0010:[<ffffffff81136279>]  [<ffffffff81136279>] kmem_cache_free+0xe4/0x13a
Aug  4 05:59:18 fangorn kernel: RSP: 0018:ffff880120709b50  EFLAGS: 00000246
Aug  4 05:59:18 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709ba0 RCX: 0000000000150010
Aug  4 05:59:18 fangorn kernel: RDX: 0000000000000000 RSI: ffffea0002ef20b0 RDI: 0000000000000246
Aug  4 05:59:18 fangorn kernel: RBP: ffffffff81013bee R08: 0000000000000000 R09: 000000009cc9ebcb
Aug  4 05:59:18 fangorn kernel: R10: ffffffff816698a2 R11: 0000000000000000 R12: ffffea0002ef20b0
Aug  4 05:59:18 fangorn kernel: R13: 000000009cc9ebcb R14: 0000000000000021 R15: 000000009cc9ebcb
Aug  4 05:59:18 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 05:59:18 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 05:59:18 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 05:59:18 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 05:59:18 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 05:59:18 fangorn kernel: Call Trace:
Aug  4 05:59:18 fangorn kernel: [<ffffffff8116dce2>] ? bvec_free_bs+0x4a/0x60
Aug  4 05:59:18 fangorn kernel: [<ffffffff8116dd3f>] ? bio_free+0x47/0x94
Aug  4 05:59:18 fangorn kernel: [<ffffffff8116ddb4>] ? bio_fs_destructor+0x28/0x40
Aug  4 05:59:18 fangorn kernel: [<ffffffff8116bfbf>] ? bio_put+0x40/0x56
Aug  4 05:59:18 fangorn kernel: [<ffffffffa0000f6c>] ? r1buf_pool_free+0x97/0xc9 [raid1]
Aug  4 05:59:18 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 05:59:18 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 05:59:18 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 05:59:18 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 05:59:18 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 05:59:18 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 05:59:18 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 05:59:18 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 05:59:18 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 05:59:18 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 05:59:18 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 05:59:18 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:00:23 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:00:23 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:00:23 fangorn kernel: irq event stamp: 4098717664
Aug  4 06:00:23 fangorn kernel: hardirqs last  enabled at (4098717663): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 06:00:23 fangorn kernel: hardirqs last disabled at (4098717664): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:00:23 fangorn kernel: softirqs last  enabled at (4098717248): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:00:23 fangorn kernel: softirqs last disabled at (4098717197): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:00:23 fangorn kernel: CPU 1:
Aug  4 06:00:23 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:00:23 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:00:23 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 06:00:23 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 06:00:23 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:00:23 fangorn kernel: RDX: 00000000000002ca RSI: ffff8800d5037d36 RDI: ffff8800cc50fd36
Aug  4 06:00:23 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800c44eb358 R09: 0000000000000002
Aug  4 06:00:23 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 06:00:23 fangorn kernel: R13: ffff8800c44eb358 R14: ffff880120708000 R15: 0000000000000001
Aug  4 06:00:23 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:00:23 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:00:23 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:00:23 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:00:23 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:00:23 fangorn kernel: Call Trace:
Aug  4 06:00:23 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:00:23 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:00:23 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:00:23 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:00:23 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:00:23 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:00:23 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:00:23 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:00:23 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:00:23 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:01:29 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:01:29 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:01:29 fangorn kernel: irq event stamp: 4123422930
Aug  4 06:01:29 fangorn kernel: hardirqs last  enabled at (4123422929): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 06:01:29 fangorn kernel: hardirqs last disabled at (4123422930): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:01:29 fangorn kernel: softirqs last  enabled at (4123422908): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:01:29 fangorn kernel: softirqs last disabled at (4123422883): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:01:29 fangorn kernel: CPU 1:
Aug  4 06:01:29 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:01:29 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:01:29 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 06:01:29 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 06:01:29 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:01:29 fangorn kernel: RDX: 000000000000021b RSI: ffff88010671dde5 RDI: ffff88010c718de5
Aug  4 06:01:29 fangorn kernel: RBP: ffffffff81013bee R08: ffff88009e6d2038 R09: 0000000000000003
Aug  4 06:01:29 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 06:01:29 fangorn kernel: R13: ffff88009e6d2038 R14: ffff880120708000 R15: 0000000000000001
Aug  4 06:01:29 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:01:29 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:01:29 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:01:29 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:01:29 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:01:29 fangorn kernel: Call Trace:
Aug  4 06:01:29 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:01:29 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:01:29 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:01:29 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:01:29 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:01:29 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:01:29 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:01:29 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:01:29 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:01:29 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:02:34 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:02:34 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:02:34 fangorn kernel: irq event stamp: 4148267368
Aug  4 06:02:34 fangorn kernel: hardirqs last  enabled at (4148267367): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 06:02:34 fangorn kernel: hardirqs last disabled at (4148267368): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:02:34 fangorn kernel: softirqs last  enabled at (4148267266): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:02:34 fangorn kernel: softirqs last disabled at (4148267241): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:02:34 fangorn kernel: CPU 1:
Aug  4 06:02:34 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:02:34 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:02:34 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 06:02:34 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 06:02:34 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:02:34 fangorn kernel: RDX: 0000000000000703 RSI: ffff88007fa708fd RDI: ffff8800c1bef8fd
Aug  4 06:02:34 fangorn kernel: RBP: ffffffff81013bee R08: ffff88009e6d2420 R09: 0000000000000001
Aug  4 06:02:34 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 06:02:34 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 06:02:34 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:02:34 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:02:34 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:02:34 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:02:34 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:02:34 fangorn kernel: Call Trace:
Aug  4 06:02:34 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:02:34 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:02:34 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:02:34 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:02:34 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:02:34 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:02:34 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:02:34 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:02:34 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:02:34 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:03:40 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:03:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:03:40 fangorn kernel: irq event stamp: 4172922612
Aug  4 06:03:40 fangorn kernel: hardirqs last  enabled at (4172922611): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 06:03:40 fangorn kernel: hardirqs last disabled at (4172922612): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:03:40 fangorn kernel: softirqs last  enabled at (4172922192): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:03:40 fangorn kernel: softirqs last disabled at (4172922127): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:03:40 fangorn kernel: CPU 1:
Aug  4 06:03:40 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:03:40 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:03:40 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 06:03:40 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 06:03:40 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:03:40 fangorn kernel: RDX: 000000000000049d RSI: ffff8800821fbb63 RDI: ffff8800bf675b63
Aug  4 06:03:40 fangorn kernel: RBP: ffffffff81013bee R08: ffff880115f915b0 R09: 0000000000000003
Aug  4 06:03:40 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 06:03:40 fangorn kernel: R13: ffff880115f915b0 R14: ffff880120708000 R15: 0000000000000001
Aug  4 06:03:40 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:03:40 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:03:40 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:03:40 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:03:40 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:03:40 fangorn kernel: Call Trace:
Aug  4 06:03:40 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:03:40 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:03:40 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:03:40 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:03:40 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:03:40 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:03:40 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:03:40 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:03:40 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:03:40 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:04:45 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:04:45 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:04:45 fangorn kernel: irq event stamp: 4197608583
Aug  4 06:04:45 fangorn kernel: hardirqs last  enabled at (4197608582): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 06:04:45 fangorn kernel: hardirqs last disabled at (4197608583): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:04:45 fangorn kernel: softirqs last  enabled at (4197608180): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:04:45 fangorn kernel: softirqs last disabled at (4197608581): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:04:45 fangorn kernel: CPU 1:
Aug  4 06:04:45 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:04:45 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:04:45 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 06:04:45 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 06:04:45 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 06:04:45 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 06:04:45 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 06:04:45 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 06:04:45 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 06:04:45 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:04:45 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:04:45 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:04:45 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:04:45 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:04:45 fangorn kernel: Call Trace:
Aug  4 06:04:45 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 06:04:45 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 06:04:45 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 06:04:45 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 06:04:45 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 06:04:45 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 06:04:45 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 06:04:45 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:04:45 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:04:45 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:04:45 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:04:45 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:04:45 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:04:45 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:04:45 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:04:45 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:04:45 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:05:51 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:05:51 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:05:51 fangorn kernel: irq event stamp: 4222327223
Aug  4 06:05:51 fangorn kernel: hardirqs last  enabled at (4222327222): [<ffffffff81136274>] kmem_cache_free+0xdf/0x13a
Aug  4 06:05:51 fangorn kernel: hardirqs last disabled at (4222327223): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:05:51 fangorn kernel: softirqs last  enabled at (4222327176): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:05:51 fangorn kernel: softirqs last disabled at (4222327185): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:05:51 fangorn kernel: CPU 1:
Aug  4 06:05:51 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:05:51 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:05:51 fangorn kernel: RIP: 0010:[<ffffffff81356aec>]  [<ffffffff81356aec>] scsi_put_command+0x19/0x94
Aug  4 06:05:51 fangorn kernel: RSP: 0018:ffff88002f1e1cf0  EFLAGS: 00000286
Aug  4 06:05:51 fangorn kernel: RAX: 000000009cc9ebcb RBX: ffff88002f1e1d10 RCX: 0000000000000000
Aug  4 06:05:51 fangorn kernel: RDX: 0000000000000000 RSI: ffffea0007647a40 RDI: ffff880040bd2c80
Aug  4 06:05:51 fangorn kernel: RBP: ffffffff81013bf3 R08: 000000009cc9ebcb R09: 000000009cc9ebcb
Aug  4 06:05:51 fangorn kernel: R10: ffffffff816698a2 R11: 0000000000000000 R12: ffff88002f1e1c70
Aug  4 06:05:51 fangorn kernel: R13: ffff880040bd2c80 R14: ffff880120d589d0 R15: 000000009cc9ebcb
Aug  4 06:05:51 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:05:51 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:05:51 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:05:51 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:05:51 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:05:51 fangorn kernel: Call Trace:
Aug  4 06:05:51 fangorn kernel: <IRQ>  [<ffffffff813421d7>] ? get_device+0x2a/0x44
Aug  4 06:05:51 fangorn kernel: [<ffffffff8135d534>] ? scsi_next_command+0x42/0x71
Aug  4 06:05:51 fangorn kernel: [<ffffffff8135e1c1>] ? scsi_io_completion+0x206/0x439
Aug  4 06:05:51 fangorn kernel: [<ffffffff81355f03>] ? scsi_finish_command+0x108/0x127
Aug  4 06:05:51 fangorn kernel: [<ffffffff8135e557>] ? scsi_softirq_done+0x127/0x146
Aug  4 06:05:51 fangorn kernel: [<ffffffff8126330d>] ? blk_done_softirq+0x91/0xb5
Aug  4 06:05:51 fangorn kernel: [<ffffffff8106c8a3>] ? __do_softirq+0xf6/0x1f0
Aug  4 06:05:51 fangorn kernel: [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 06:05:51 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 06:05:51 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 06:05:51 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 06:05:51 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 06:05:51 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 06:05:51 fangorn kernel: <EOI>  [<ffffffff81277df2>] ? memcmp+0x23/0x49
Aug  4 06:05:51 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:05:51 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:05:51 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:05:51 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:05:51 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:05:51 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:05:51 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:05:51 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:05:51 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:05:51 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:06:56 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:06:56 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:06:56 fangorn kernel: irq event stamp: 4247009268
Aug  4 06:06:56 fangorn kernel: hardirqs last  enabled at (4247009267): [<ffffffff81013a90>] restore_args+0x0/0x30
Aug  4 06:06:56 fangorn kernel: hardirqs last disabled at (4247009268): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:06:56 fangorn kernel: softirqs last  enabled at (4247008848): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:06:56 fangorn kernel: softirqs last disabled at (4247008823): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:06:56 fangorn kernel: CPU 1:
Aug  4 06:06:56 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:06:56 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:06:56 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 06:06:56 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 06:06:56 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:06:56 fangorn kernel: RDX: 0000000000000dda RSI: ffff8800b96db226 RDI: ffff880016309226
Aug  4 06:06:56 fangorn kernel: RBP: ffffffff81013bee R08: ffff880115f911c8 R09: 0000000000000002
Aug  4 06:06:56 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffffffff8101422c
Aug  4 06:06:56 fangorn kernel: R13: ffff880115f911c8 R14: ffff880120708000 R15: 0000000000000001
Aug  4 06:06:56 fangorn kernel: FS:  00007f8b0fba46f0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:06:56 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:06:56 fangorn kernel: CR2: 0000000000412830 CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:06:56 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:06:56 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:06:56 fangorn kernel: Call Trace:
Aug  4 06:06:56 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:06:56 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:06:56 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:06:56 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:06:56 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:06:56 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:06:56 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:06:56 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:06:56 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:06:56 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:08:31 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:08:31 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:08:31 fangorn kernel: irq event stamp: 4282101650
Aug  4 06:08:31 fangorn kernel: hardirqs last  enabled at (4282101649): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 06:08:31 fangorn kernel: hardirqs last disabled at (4282101650): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:08:31 fangorn kernel: softirqs last  enabled at (4282101236): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:08:31 fangorn kernel: softirqs last disabled at (4282101185): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:08:31 fangorn kernel: CPU 1:
Aug  4 06:08:31 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:08:31 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:08:31 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 06:08:31 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 06:08:31 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:08:31 fangorn kernel: RDX: 0000000000000b7b RSI: ffff880017c9d485 RDI: ffff880032880485
Aug  4 06:08:31 fangorn kernel: RBP: ffffffff81013bee R08: ffff8800aa972740 R09: 0000000000000001
Aug  4 06:08:31 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 06:08:31 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 06:08:31 fangorn kernel: FS:  00007f39dd9e57b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:08:31 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:08:31 fangorn kernel: CR2: 00007f5f9a034ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:08:31 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:08:31 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:08:31 fangorn kernel: Call Trace:
Aug  4 06:08:31 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:08:31 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:08:31 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:08:31 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:08:31 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:08:31 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:08:31 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:08:31 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:08:31 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:08:31 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:09:36 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:09:36 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:09:36 fangorn kernel: irq event stamp: 12098740
Aug  4 06:09:36 fangorn kernel: hardirqs last  enabled at (12098739): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 06:09:36 fangorn kernel: hardirqs last disabled at (12098740): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:09:36 fangorn kernel: softirqs last  enabled at (12098326): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:09:36 fangorn kernel: softirqs last disabled at (12098275): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:09:36 fangorn kernel: CPU 1:
Aug  4 06:09:36 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:09:36 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:09:36 fangorn kernel: RIP: 0010:[<ffffffff81277deb>]  [<ffffffff81277deb>] memcmp+0x1c/0x49
Aug  4 06:09:36 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000202
Aug  4 06:09:36 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:09:36 fangorn kernel: RDX: 0000000000000ca4 RSI: ffff8800a52b535c RDI: ffff880041bd935c
Aug  4 06:09:36 fangorn kernel: RBP: ffffffff81013bee R08: ffff880115f91740 R09: 0000000000000002
Aug  4 06:09:36 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 06:09:36 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 06:09:36 fangorn kernel: FS:  00007f39dd9e57b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:09:36 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:09:36 fangorn kernel: CR2: 00007f5f9a034ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:09:36 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:09:36 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:09:36 fangorn kernel: Call Trace:
Aug  4 06:09:36 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:09:36 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:09:36 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:09:36 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:09:36 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:09:36 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:09:36 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:09:36 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:09:36 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:09:36 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:10:42 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:10:42 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:10:42 fangorn kernel: irq event stamp: 37109204
Aug  4 06:10:42 fangorn kernel: hardirqs last  enabled at (37109203): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 06:10:42 fangorn kernel: hardirqs last disabled at (37109204): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:10:42 fangorn kernel: softirqs last  enabled at (37109188): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:10:42 fangorn kernel: softirqs last disabled at (37109163): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:10:42 fangorn kernel: CPU 1:
Aug  4 06:10:42 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:10:42 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:10:42 fangorn kernel: RIP: 0010:[<ffffffff81277dfb>]  [<ffffffff81277dfb>] memcmp+0x2c/0x49
Aug  4 06:10:42 fangorn kernel: RSP: 0018:ffff880120709cc0  EFLAGS: 00000206
Aug  4 06:10:42 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709cd0 RCX: 0000000000000000
Aug  4 06:10:42 fangorn kernel: RDX: 0000000000000c14 RSI: ffff880061a2b3ec RDI: ffff8800898953ec
Aug  4 06:10:42 fangorn kernel: RBP: ffffffff81013bee R08: ffff880093f384e8 R09: 0000000000000001
Aug  4 06:10:42 fangorn kernel: R10: 0000000000000080 R11: ffff880120501a70 R12: ffff880120f424a0
Aug  4 06:10:42 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709c50 R15: 000000009cc9ebcb
Aug  4 06:10:42 fangorn kernel: FS:  00007f39dd9e57b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:10:42 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:10:42 fangorn kernel: CR2: 00007f5f9a034ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:10:42 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:10:42 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:10:42 fangorn kernel: Call Trace:
Aug  4 06:10:42 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:10:42 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:10:42 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:10:42 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:10:42 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:10:42 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:10:42 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:10:42 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:10:42 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:10:42 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:11:47 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:11:47 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:11:47 fangorn kernel: irq event stamp: 62255003
Aug  4 06:11:47 fangorn kernel: hardirqs last  enabled at (62255002): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 06:11:47 fangorn kernel: hardirqs last disabled at (62255003): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:11:47 fangorn kernel: softirqs last  enabled at (62254970): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:11:47 fangorn kernel: softirqs last disabled at (62255001): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:11:47 fangorn kernel: CPU 1:
Aug  4 06:11:47 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:11:47 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:11:47 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 06:11:47 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 06:11:47 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 06:11:47 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 06:11:47 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 06:11:47 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 06:11:47 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 06:11:47 fangorn kernel: FS:  00007f39dd9e57b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:11:47 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:11:47 fangorn kernel: CR2: 00007f5f9a034ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:11:47 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:11:47 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:11:47 fangorn kernel: Call Trace:
Aug  4 06:11:47 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 06:11:47 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 06:11:47 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 06:11:47 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 06:11:47 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 06:11:47 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 06:11:47 fangorn kernel: <EOI>  [<ffffffff81277deb>] ? memcmp+0x1c/0x49
Aug  4 06:11:47 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:11:47 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:11:47 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:11:47 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:11:47 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:11:47 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:11:47 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:11:47 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:11:47 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:11:47 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:12:53 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:12:53 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:12:53 fangorn kernel: irq event stamp: 87217557
Aug  4 06:12:53 fangorn kernel: hardirqs last  enabled at (87217556): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 06:12:53 fangorn kernel: hardirqs last disabled at (87217557): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:12:53 fangorn kernel: softirqs last  enabled at (87217134): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:12:53 fangorn kernel: softirqs last disabled at (87217555): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:12:53 fangorn kernel: CPU 1:
Aug  4 06:12:53 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:12:53 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:12:53 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 06:12:53 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 06:12:53 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 06:12:53 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 06:12:53 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 06:12:53 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 06:12:53 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 06:12:53 fangorn kernel: FS:  00007f39dd9e57b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:12:53 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:12:53 fangorn kernel: CR2: 00007f5f9a034ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:12:53 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:12:53 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:12:53 fangorn kernel: Call Trace:
Aug  4 06:12:53 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 06:12:53 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 06:12:53 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 06:12:53 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 06:12:53 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 06:12:53 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 06:12:53 fangorn kernel: <EOI>  [<ffffffff81277df5>] ? memcmp+0x26/0x49
Aug  4 06:12:53 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:12:53 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:12:53 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:12:53 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:12:53 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:12:53 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:12:53 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:12:53 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:12:53 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:12:53 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:13:58 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:13:58 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:13:58 fangorn kernel: irq event stamp: 112180177
Aug  4 06:13:58 fangorn kernel: hardirqs last  enabled at (112180176): [<ffffffff8106c81d>] __do_softirq+0x70/0x1f0
Aug  4 06:13:58 fangorn kernel: hardirqs last disabled at (112180177): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:13:58 fangorn kernel: softirqs last  enabled at (112180098): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:13:58 fangorn kernel: softirqs last disabled at (112180175): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:13:58 fangorn kernel: CPU 1:
Aug  4 06:13:58 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:13:58 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:13:58 fangorn kernel: RIP: 0010:[<ffffffff8106c821>]  [<ffffffff8106c821>] __do_softirq+0x74/0x1f0
Aug  4 06:13:58 fangorn kernel: RSP: 0018:ffff88002f1e1ea0  EFLAGS: 00000246
Aug  4 06:13:58 fangorn kernel: RAX: 0000000000000000 RBX: ffff88002f1e1f00 RCX: ffff880120c6dff0
Aug  4 06:13:58 fangorn kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000009cc9ebcb
Aug  4 06:13:58 fangorn kernel: RBP: ffffffff81013bf3 R08: ffff88002f1e1e90 R09: 000000009cc9ebcb
Aug  4 06:13:58 fangorn kernel: R10: 000000009cc9ebcb R11: 0000000000000000 R12: ffff88002f1e1e20
Aug  4 06:13:58 fangorn kernel: R13: 0000000000000089 R14: 0000000000000046 R15: 000000009cc9ebcb
Aug  4 06:13:58 fangorn kernel: FS:  00007f39dd9e57b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:13:58 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:13:58 fangorn kernel: CR2: 00007f5f9a034ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:13:58 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:13:58 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:13:58 fangorn kernel: Call Trace:
Aug  4 06:13:58 fangorn kernel: <IRQ>  [<ffffffff8101422c>] ? call_softirq+0x1c/0x30
Aug  4 06:13:58 fangorn kernel: [<ffffffff81015d77>] ? do_softirq+0x5f/0xd7
Aug  4 06:13:58 fangorn kernel: [<ffffffff8106c1ba>] ? irq_exit+0x66/0xbc
Aug  4 06:13:58 fangorn kernel: [<ffffffff814fa074>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Aug  4 06:13:58 fangorn kernel: [<ffffffff81015406>] ? do_IRQ+0xb8/0xe5
Aug  4 06:13:58 fangorn kernel: [<ffffffff810139d3>] ? ret_from_intr+0x0/0x16
Aug  4 06:13:58 fangorn kernel: <EOI>  [<ffffffff81277dfb>] ? memcmp+0x2c/0x49
Aug  4 06:13:58 fangorn kernel: [<ffffffffa000293b>] ? raid1d+0x2c6/0xea5 [raid1]
Aug  4 06:13:58 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:13:58 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:13:58 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:13:58 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:13:58 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:13:58 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:13:58 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:13:58 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:13:58 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:15:37 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:15:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:15:37 fangorn kernel: irq event stamp: 149229874
Aug  4 06:15:37 fangorn kernel: hardirqs last  enabled at (149229873): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 06:15:37 fangorn kernel: hardirqs last disabled at (149229874): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:15:37 fangorn kernel: softirqs last  enabled at (149229770): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:15:37 fangorn kernel: softirqs last disabled at (149229743): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:15:37 fangorn kernel: CPU 1:
Aug  4 06:15:37 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:15:37 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:15:37 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 06:15:37 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 06:15:37 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 06:15:37 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 06:15:37 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff824dfd88 R09: 000000009cc9ebcb
Aug  4 06:15:37 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 06:15:37 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 06:15:37 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:15:37 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:15:37 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:15:37 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:15:37 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:15:37 fangorn kernel: Call Trace:
Aug  4 06:15:37 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 06:15:37 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 06:15:37 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 06:15:37 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 06:15:37 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 06:15:37 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 06:15:37 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 06:15:37 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 06:15:37 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:15:37 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:15:37 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:15:37 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:15:37 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:15:37 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:15:37 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:15:37 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:15:37 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:16:43 fangorn kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md2_raid1:111]
Aug  4 06:16:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:16:43 fangorn kernel: irq event stamp: 174491106
Aug  4 06:16:43 fangorn kernel: hardirqs last  enabled at (174491105): [<ffffffff814fa69f>] _spin_unlock_irqrestore+0x5a/0x7f
Aug  4 06:16:43 fangorn kernel: hardirqs last disabled at (174491106): [<ffffffff81012dba>] save_args+0x6a/0x70
Aug  4 06:16:43 fangorn kernel: softirqs last  enabled at (174490924): [<ffffffff8106c971>] __do_softirq+0x1c4/0x1f0
Aug  4 06:16:43 fangorn kernel: softirqs last disabled at (174490897): [<ffffffff8101422c>] call_softirq+0x1c/0x30
Aug  4 06:16:43 fangorn kernel: CPU 1:
Aug  4 06:16:43 fangorn kernel: Modules linked in: dme1737 hwmon_vid hwmon ipv6 cpufreq_ondemand powernow_k8 freq_table dm_multipath i2c_nforce2 amd64_edac_mod i2c_core forcedeth pcspkr edac_core pata_amd serio_raw ata_generic pata_acpi sata_nv raid1 [last unloaded: scsi_wait_scan]
Aug  4 06:16:43 fangorn kernel: Pid: 111, comm: md2_raid1 Not tainted 2.6.31-0.94.rc4.fc12.x86_64 #1 empty
Aug  4 06:16:43 fangorn kernel: RIP: 0010:[<ffffffff814fa6a4>]  [<ffffffff814fa6a4>] _spin_unlock_irqrestore+0x5f/0x7f
Aug  4 06:16:43 fangorn kernel: RSP: 0018:ffff880120709ad0  EFLAGS: 00000246
Aug  4 06:16:43 fangorn kernel: RAX: 0000000000000000 RBX: ffff880120709af0 RCX: 0000000000000061
Aug  4 06:16:43 fangorn kernel: RDX: 0000000000000000 RSI: ffff880120709a70 RDI: 0000000000000246
Aug  4 06:16:43 fangorn kernel: RBP: ffffffff81013bee R08: ffffffff825a7f48 R09: 000000009cc9ebcb
Aug  4 06:16:43 fangorn kernel: R10: ffffffff81dcc500 R11: 0000000000000000 R12: ffff880120709a70
Aug  4 06:16:43 fangorn kernel: R13: 000000009cc9ebcb R14: ffff880120709a40 R15: ffffffff8101aa23
Aug  4 06:16:43 fangorn kernel: FS:  00007f28fe6547b0(0000) GS:ffff88002f1de000(0000) knlGS:0000000000000000
Aug  4 06:16:43 fangorn kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Aug  4 06:16:43 fangorn kernel: CR2: 00007f28fc0b7ecc CR3: 0000000001001000 CR4: 00000000000006e0
Aug  4 06:16:43 fangorn kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 06:16:43 fangorn kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 06:16:43 fangorn kernel: Call Trace:
Aug  4 06:16:43 fangorn kernel: [<ffffffff812807be>] ? debug_check_no_obj_freed+0x149/0x1ce
Aug  4 06:16:43 fangorn kernel: [<ffffffff810ffc7c>] ? free_hot_cold_page+0xb8/0x1e5
Aug  4 06:16:43 fangorn kernel: [<ffffffff810ffe72>] ? free_hot_page+0x23/0x39
Aug  4 06:16:43 fangorn kernel: [<ffffffff81104aa2>] ? put_page+0xb2/0xd5
Aug  4 06:16:43 fangorn kernel: [<ffffffffa0000f44>] ? r1buf_pool_free+0x6f/0xc9 [raid1]
Aug  4 06:16:43 fangorn kernel: [<ffffffff810fb981>] ? mempool_free+0x89/0xa4
Aug  4 06:16:43 fangorn kernel: [<ffffffffa00011d1>] ? put_buf+0x7f/0xa2 [raid1]
Aug  4 06:16:43 fangorn kernel: [<ffffffffa0002e9f>] ? raid1d+0x82a/0xea5 [raid1]
Aug  4 06:16:43 fangorn kernel: [<ffffffff8109657a>] ? trace_hardirqs_on+0x20/0x36
Aug  4 06:16:43 fangorn kernel: [<ffffffff813efd38>] ? md_thread+0x100/0x132
Aug  4 06:16:43 fangorn kernel: [<ffffffff81081b07>] ? autoremove_wake_function+0x0/0x5f
Aug  4 06:16:43 fangorn kernel: [<ffffffff813efc38>] ? md_thread+0x0/0x132
Aug  4 06:16:43 fangorn kernel: [<ffffffff810816b9>] ? kthread+0xa5/0xad
Aug  4 06:16:43 fangorn kernel: [<ffffffff8101412a>] ? child_rip+0xa/0x20
Aug  4 06:16:43 fangorn kernel: [<ffffffff81013a90>] ? restore_args+0x0/0x30
Aug  4 06:16:43 fangorn kernel: [<ffffffff81081614>] ? kthread+0x0/0xad
Aug  4 06:16:43 fangorn kernel: [<ffffffff81014120>] ? child_rip+0x0/0x20
Aug  4 06:17:37 fangorn kernel: md: md2: data-check done.

--------------020005020808070306030808--
