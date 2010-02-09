Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0BIImu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 03:42:50 -0500
Received: from smtp-out-166.synserver.de ([212.40.180.166]:1065 "HELO
	smtp-out-159.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752362Ab0BIIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 03:42:48 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 03:42:47 EST
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 19482
Date: Tue, 9 Feb 2010 09:36:05 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: latest git kernel: general protection fault: 0000 [#1]
Message-ID: <20100209083605.GA1766@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My machine unexpectedly hanged several times during the last days.
At first I thought the hangs would be Radeon-KMS related, because the
machine kept running while the display went blank (the monitor switched
off). There was nothing in the logs after these incidences, but today
the attached general protection faults were logged.
As all of this might point to bad memory, I ran memtest overnight and
a linpack stresstest for a few hours, without any errors at all.

Any hints what could be going on?

Feb  9 08:01:26 arch kernel: general protection fault: 0000 [#1] SMP
Feb  9 08:01:26 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/boot_vga
Feb  9 08:01:26 arch kernel: CPU 1
Feb  9 08:01:26 arch kernel: Pid: 11981, comm: rsync Not tainted 2.6.33-rc7-00034-g52c9ce8 #49 M4A78T-E/System Product Name
Feb  9 08:01:26 arch kernel: RIP: 0010:[<ffffffff810d177c>]  [<ffffffff810d177c>] __kmalloc_track_caller+0xfe/0x168
Feb  9 08:01:26 arch kernel: RSP: 0018:ffff88010fdfdb38  EFLAGS: 00010002
Feb  9 08:01:26 arch kernel: RAX: 0000000000000000 RBX: 04bddf78a860a9b3 RCX: 00000000000004d0
Feb  9 08:01:26 arch kernel: RDX: 00000000ffffffff RSI: 00000000000004d0 RDI: 000000000000000d
Feb  9 08:01:26 arch kernel: RBP: ffff88010fdfdb88 R08: ffff880028290090 R09: 00000000000004d0
Feb  9 08:01:26 arch kernel: R10: 00007fff003599a0 R11: 0000000000000246 R12: ffffffff81814f68
Feb  9 08:01:26 arch kernel: R13: 00000000000011f0 R14: 00000000000004d0 R15: 0000000000000202
Feb  9 08:01:26 arch kernel: FS:  00007fef948d0700(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Feb  9 08:01:26 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  9 08:01:26 arch kernel: CR2: 00007f3623e09000 CR3: 000000010f231000 CR4: 00000000000006e0
Feb  9 08:01:26 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  9 08:01:26 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 08:01:26 arch kernel: Process rsync (pid: 11981, threadinfo ffff88010fdfc000, task ffff88012cee9640)
Feb  9 08:01:26 arch kernel: Stack:
Feb  9 08:01:26 arch kernel: ffff88010fdfdb88 0000000000000202 000020002f424300 ffffffff81357539
Feb  9 08:01:26 arch kernel: <0> 0000000000000000 ffff880103165b00 0000000000001000 0000000000000000
Feb  9 08:01:26 arch kernel: <0> 0000000000001000 ffffffff81814a40 ffff88010fdfdbd8 ffffffff8135bdb1
Feb  9 08:01:26 arch kernel: Call Trace:
Feb  9 08:01:26 arch kernel: [<ffffffff81357539>] ? sock_alloc_send_pskb+0xc5/0x2de
Feb  9 08:01:26 arch kernel: [<ffffffff8135bdb1>] __alloc_skb+0x6e/0x15a
Feb  9 08:01:26 arch kernel: [<ffffffff81357539>] sock_alloc_send_pskb+0xc5/0x2de
Feb  9 08:01:26 arch kernel: [<ffffffff8104f74e>] ? __wake_up_sync_key+0x4e/0x57
Feb  9 08:01:26 arch kernel: [<ffffffff813c2cef>] ? wait_for_unix_gc+0xe/0x83
Feb  9 08:01:26 arch kernel: [<ffffffff81357767>] sock_alloc_send_skb+0x15/0x17
Feb  9 08:01:26 arch kernel: [<ffffffff813c0b6b>] unix_stream_sendmsg+0x163/0x310
Feb  9 08:01:26 arch kernel: [<ffffffff81353c89>] sock_aio_write+0xe2/0xf6
Feb  9 08:01:26 arch kernel: [<ffffffff810d5ae1>] do_sync_write+0xc4/0x101
Feb  9 08:01:26 arch kernel: [<ffffffff81060fa5>] ? set_normalized_timespec+0x9/0x38
Feb  9 08:01:26 arch kernel: [<ffffffff8107cc96>] ? ktime_get_ts+0xb2/0xbf
Feb  9 08:01:26 arch kernel: [<ffffffff81060fa5>] ? set_normalized_timespec+0x9/0x38
Feb  9 08:01:26 arch kernel: [<ffffffff810e2ebf>] ? poll_select_copy_remaining+0xcb/0xef
Feb  9 08:01:26 arch kernel: [<ffffffff810d64d8>] vfs_write+0xc5/0x177
Feb  9 08:01:26 arch kernel: [<ffffffff810d6d37>] ? fget_light+0xd/0xa1
Feb  9 08:01:26 arch kernel: [<ffffffff810d664d>] sys_write+0x4a/0x71
Feb  9 08:01:26 arch kernel: [<ffffffff8102b97b>] system_call_fastpath+0x16/0x1b
Feb  9 08:01:26 arch kernel: Code: 49 8b 18 48 85 db 75 1f 48 8b 4d c8 44 89 ce 83 ca ff 4c 89 e7 44 89 4d b8 e8 b7 f0 ff ff 44 8b 4d b8 48 89 c3 eb 0b 41 8b 40 14 <48> 8b 04 c3 49 89 00 41 57 9d 48 85 db 74 10 66 45 85 c9 79 0a
Feb  9 08:01:26 arch kernel: RIP  [<ffffffff810d177c>] __kmalloc_track_caller+0xfe/0x168
Feb  9 08:01:26 arch kernel: RSP <ffff88010fdfdb38>
Feb  9 08:01:26 arch kernel: ---[ end trace eea530048204cddd ]---
Feb  9 08:01:26 arch kernel: general protection fault: 0000 [#2] SMP
Feb  9 08:01:26 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/boot_vga
Feb  9 08:01:26 arch kernel: CPU 1
Feb  9 08:01:26 arch kernel: Pid: 1703, comm: multitail Tainted: G      D    2.6.33-rc7-00034-g52c9ce8 #49 M4A78T-E/System Product Name
Feb  9 08:01:26 arch kernel: RIP: 0010:[<ffffffff810d18e0>]  [<ffffffff810d18e0>] __kmalloc+0xfa/0x16c
Feb  9 08:01:26 arch kernel: RSP: 0018:ffff88012bf1bcf8  EFLAGS: 00010002
Feb  9 08:01:26 arch kernel: RAX: 0000000000000000 RBX: 04bddf78a860a9b3 RCX: ffffffff811f6495
Feb  9 08:01:26 arch kernel: RDX: 00000000ffffffff RSI: 0000000000000020 RDI: 000000000000000d
Feb  9 08:01:26 arch kernel: RBP: ffff88012bf1bd38 R08: ffff880028290090 R09: 0000000000000020
Feb  9 08:01:26 arch kernel: R10: 00000000ffffffff R11: 0000000000000246 R12: ffffffff81814f68
Feb  9 08:01:26 arch kernel: R13: 0000000000001028 R14: 0000000000000020 R15: 0000000000000002
Feb  9 08:01:26 arch kernel: FS:  00007f19b2aa2700(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Feb  9 08:01:26 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb  9 08:01:26 arch kernel: CR2: 00007f3ac5b7d3a8 CR3: 000000012d88c000 CR4: 00000000000006e0
Feb  9 08:01:26 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  9 08:01:26 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 08:01:26 arch kernel: Process multitail (pid: 1703, threadinfo ffff88012bf1a000, task ffff88012cde1640)
Feb  9 08:01:26 arch kernel: Stack:
Feb  9 08:01:26 arch kernel: 0000000200000000 0000000a00002000 ffffffffffffffff ffff88012fa9d000
Feb  9 08:01:26 arch kernel: <0> ffff88003866f000 0000000000000800 0000000000000800 0000000000000071
Feb  9 08:01:26 arch kernel: <0> ffff88012bf1bd88 ffffffff811f6495 0000000000000246 ffff88012fa9d178
Feb  9 08:01:26 arch kernel: Call Trace:
Feb  9 08:01:26 arch kernel: [<ffffffff811f6495>] tty_buffer_request_room+0xd7/0x157
Feb  9 08:01:26 arch kernel: [<ffffffff811f6684>] tty_insert_flip_string+0x39/0x91
Feb  9 08:01:26 arch kernel: [<ffffffff811f7333>] pty_write+0x38/0x59
Feb  9 08:01:26 arch kernel: [<ffffffff811f7111>] ? pty_write_room+0x9/0x2b
Feb  9 08:01:26 arch kernel: [<ffffffff811f279d>] n_tty_write+0x237/0x351
Feb  9 08:01:26 arch kernel: [<ffffffff810584f8>] ? default_wake_function+0x0/0x14
Feb  9 08:01:26 arch kernel: [<ffffffff811effae>] tty_write+0x19c/0x231
Feb  9 08:01:26 arch kernel: [<ffffffff813fe7f7>] ? schedule+0x9c6/0xab9
Feb  9 08:01:26 arch kernel: [<ffffffff811f2566>] ? n_tty_write+0x0/0x351
Feb  9 08:01:26 arch kernel: [<ffffffff810d64c5>] vfs_write+0xb2/0x177
Feb  9 08:01:26 arch kernel: [<ffffffff810d6d37>] ? fget_light+0xd/0xa1
Feb  9 08:01:26 arch kernel: [<ffffffff810d664d>] sys_write+0x4a/0x71
Feb  9 08:01:26 arch kernel: [<ffffffff8102b97b>] system_call_fastpath+0x16/0x1b
Feb  9 08:01:26 arch kernel: Code: 18 89 45 c8 49 8b 18 48 85 db 75 1b 44 89 ce 83 ca ff 4c 89 e7 44 89 4d c0 e8 53 ef ff ff 44 8b 4d c0 48 89 c3 eb 0b 41 8b 40 14 <48> 8b 04 c3 49 89 00 41 57 9d 48 85 db 74 10 66 45 85 c9 79 0a
Feb  9 08:01:26 arch kernel: RIP  [<ffffffff810d18e0>] __kmalloc+0xfa/0x16c
Feb  9 08:01:26 arch kernel: RSP <ffff88012bf1bcf8>
Feb  9 08:01:26 arch kernel: ---[ end trace eea530048204cdde ]---
Feb  9 08:05:35 arch kernel: general protection fault: 0000 [#3] SMP
Feb  9 08:05:35 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/boot_vga
Feb  9 08:05:35 arch kernel: CPU 1
Feb  9 08:05:35 arch kernel: Pid: 27689, comm: X Tainted: G      D    2.6.33-rc7-00034-g52c9ce8 #49 M4A78T-E/System Product Name
Feb  9 08:05:35 arch kernel: RIP: 0010:[<ffffffff810d18e0>]  [<ffffffff810d18e0>] __kmalloc+0xfa/0x16c
Feb  9 08:05:35 arch kernel: RSP: 0018:ffff88012cd27c18  EFLAGS: 00010002
Feb  9 08:05:35 arch kernel: RAX: 0000000000000000 RBX: 04bddf78a860a9b3 RCX: ffffffff81258b58
Feb  9 08:05:35 arch kernel: RDX: 00000000ffffffff RSI: 00000000000080d0 RDI: 000000000000000d
Feb  9 08:05:35 arch kernel: RBP: ffff88012cd27c58 R08: ffff880028290090 R09: 00000000000080d0
Feb  9 08:05:35 arch kernel: R10: dead000000200200 R11: dead000000100100 R12: ffffffff81814f68
Feb  9 08:05:35 arch kernel: R13: 0000000000001170 R14: 00000000000080d0 R15: 0000000000000202
Feb  9 08:05:35 arch kernel: FS:  00007f8dd9409700(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Feb  9 08:05:35 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb  9 08:05:35 arch kernel: CR2: 00007f8dd926b000 CR3: 000000012db70000 CR4: 00000000000006e0
Feb  9 08:05:35 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  9 08:05:35 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 08:05:35 arch kernel: Process X (pid: 27689, threadinfo ffff88012cd26000, task ffff8800869fd900)
Feb  9 08:05:35 arch kernel: Stack:
Feb  9 08:05:35 arch kernel: ffff88012cd27c38 0000000000002000 ffff88004007d888 ffff88012cd27cd8
Feb  9 08:05:35 arch kernel: <0> ffff88012ee90e68 ffff88012ee90000 0000000000000000 ffff88012bfcbbb8
Feb  9 08:05:35 arch kernel: <0> ffff88012cd27cb8 ffffffff81258b58 ffff88012cd27cb8 ffffffff8125817e
Feb  9 08:05:35 arch kernel: Call Trace:
Feb  9 08:05:35 arch kernel: [<ffffffff81258b58>] radeon_cs_parser_relocs+0x78/0x203
Feb  9 08:05:35 arch kernel: [<ffffffff8125817e>] ? radeon_ib_get+0x199/0x1c7
Feb  9 08:05:35 arch kernel: [<ffffffff81258db4>] radeon_cs_ioctl+0xd1/0x1a9
Feb  9 08:05:35 arch kernel: [<ffffffff8120f1fd>] drm_ioctl+0x275/0x339
Feb  9 08:05:35 arch kernel: [<ffffffff81258ce3>] ? radeon_cs_ioctl+0x0/0x1a9
Feb  9 08:05:35 arch kernel: [<ffffffff810e1fe3>] vfs_ioctl+0x32/0xa6
Feb  9 08:05:35 arch kernel: [<ffffffff810e2506>] do_vfs_ioctl+0x433/0x479
Feb  9 08:05:35 arch kernel: [<ffffffff81196e8a>] ? __up_read+0xa6/0xaf
Feb  9 08:05:35 arch kernel: [<ffffffff8107989e>] ? up_read+0xe/0x10
Feb  9 08:05:35 arch kernel: [<ffffffff810e2593>] sys_ioctl+0x47/0x6a
Feb  9 08:05:35 arch kernel: [<ffffffff8102b97b>] system_call_fastpath+0x16/0x1b
Feb  9 08:05:35 arch kernel: Code: 18 89 45 c8 49 8b 18 48 85 db 75 1b 44 89 ce 83 ca ff 4c 89 e7 44 89 4d c0 e8 53 ef ff ff 44 8b 4d c0 48 89 c3 eb 0b 41 8b 40 14 <48> 8b 04 c3 49 89 00 41 57 9d 48 85 db 74 10 66 45 85 c9 79 0a
Feb  9 08:05:35 arch kernel: RIP  [<ffffffff810d18e0>] __kmalloc+0xfa/0x16c
Feb  9 08:05:35 arch kernel: RSP <ffff88012cd27c18>
Feb  9 08:05:35 arch kernel: ---[ end trace eea530048204cddf ]---
Feb  9 08:05:35 arch kernel: [drm:drm_release] *ERROR* Device busy: 1


-- 
Markus
