Return-Path: <linux-kernel-owner+w=401wt.eu-S1422922AbXBATB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422922AbXBATB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422923AbXBATB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:01:59 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:56730 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422922AbXBATB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:01:57 -0500
Date: Thu, 1 Feb 2007 11:01:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-rc6-mm3
In-Reply-To: <20070131231253.fdebc9f5.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
 <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
 <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
 <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com>
 <20070131231253.fdebc9f5.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Andrew Morton wrote:

> But usually none of that is necessary, because io_schedule() does all the
> work for you.
> 
> err, this might help.

Well okay boot progresses further (maybe only on this boot) but system is 
still hung.

Traces (this was a backtrace of all processes on the system. I removed 
the irrelevant ones):

Delaying for 5 seconds...
All OS INIT slaves have reached rendezvous
Processes interrupted by INIT - 0 (cpu 0 task 0xa000000100b24000) 0 (cpu 1 
task 0xe00000b003bd8000) 0 (cpu 2 task 0xe000023c38248000) 0 (cpu 3 task 
0xe00000b003d00000) 0 (cpu 4 task 0xe000023c38258000) 0 (cpu 5 task 
0xe00000b003d10000) 0 (cpu 6 task 0xe000023c38268000) 0 (cpu 7 task 
0xe00000b003d20000) 0 (cpu 8 task 0xe000023c382e8000) 0 (cpu 9 task 
0xe00000b003d30000) 0 (cpu 10 task 0xe000023c38380000) 0 (cpu 11 task 
0xe00000b003d40000)


Backtrace of pid 1 (init)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000307bd178c0 bsp=e00000307bd11828
 [<a000000100797b20>] __down+0x240/0x280
                                sp=e00000307bd179d0 bsp=e00000307bd117e8
 [<a0000001003b8f10>] xfs_buf_iowait+0x50/0x80
                                sp=e00000307bd17a00 bsp=e00000307bd117c8
 [<a0000001003bb120>] xfs_buf_iostart+0x1a0/0x1c0
                                sp=e00000307bd17a00 bsp=e00000307bd117a0
 [<a0000001003bc140>] xfs_buf_read_flags+0xe0/0x160
                                sp=e00000307bd17a00 bsp=e00000307bd11768
 [<a00000010039e490>] xfs_trans_read_buf+0x50/0x6a0
                                sp=e00000307bd17a00 bsp=e00000307bd11710
 [<a0000001003420a0>] xfs_btree_read_bufl+0xe0/0x120
                                sp=e00000307bd17a00 bsp=e00000307bd116d0
 [<a000000100334de0>] xfs_bmap_read_extents+0x2c0/0x7e0
                                sp=e00000307bd17a10 bsp=e00000307bd11658
 [<a000000100376820>] xfs_iread_extents+0x160/0x1c0
                                sp=e00000307bd17a20 bsp=e00000307bd11618
 [<a000000100330b90>] xfs_bmapi+0x430/0x33a0
                                sp=e00000307bd17a20 bsp=e00000307bd114c8
 [<a00000010037d3e0>] xfs_iomap+0x3e0/0xb00
                                sp=e00000307bd17b60 bsp=e00000307bd11458
 [<a0000001003c5aa0>] xfs_bmap+0x40/0x60
                                sp=e00000307bd17bb0 bsp=e00000307bd11410
 [<a0000001003b4c30>] __xfs_get_blocks+0xd0/0x5c0
                                sp=e00000307bd17bb0 bsp=e00000307bd113a0
 [<a0000001003b51c0>] xfs_get_blocks+0x40/0x60
                                sp=e00000307bd17bf0 bsp=e00000307bd11368
 [<a0000001001b8d00>] __block_prepare_write+0x3e0/0xd20
                                sp=e00000307bd17bf0 bsp=e00000307bd112c8
 [<a0000001001ba740>] block_prepare_write+0x40/0xa0
                                sp=e00000307bd17c10 bsp=e00000307bd11290
 [<a0000001003b7af0>] xfs_vm_prepare_write+0x30/0x60
                                sp=e00000307bd17c10 bsp=e00000307bd11258
 [<a000000100109290>] generic_file_buffered_write+0x3d0/0xda0
                                sp=e00000307bd17c10 bsp=e00000307bd11170
 [<a0000001003c8100>] xfs_write+0xc60/0x1260
                                sp=e00000307bd17ca0 bsp=e00000307bd11088
 [<a0000001003bed00>] xfs_file_aio_write+0x120/0x140
                                sp=e00000307bd17d10 bsp=e00000307bd11050
 [<a000000100167ca0>] do_sync_write+0x180/0x200
                                sp=e00000307bd17d10 bsp=e00000307bd11018
 [<a000000100169130>] vfs_write+0x1b0/0x340
                                sp=e00000307bd17e20 bsp=e00000307bd10fc0
 [<a000000100169db0>] sys_write+0x70/0xe0
                                sp=e00000307bd17e20 bsp=e00000307bd10f48
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000307bd17e30 bsp=e00000307bd10f48
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000307bd18000 bsp=e00000307bd10f48

Backtrace of pid 1006 (xfsbufd)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000301527fc00 bsp=e000003015278e38
 [<a00000010079b5d0>] schedule_timeout+0x110/0x180
                                sp=e00000301527fd10 bsp=e000003015278e08
 [<a00000010079b6d0>] schedule_timeout_interruptible+0x30/0x60
                                sp=e00000301527fd40 bsp=e000003015278de0
 [<a0000001003bcf70>] xfsbufd+0x1b0/0x520
                                sp=e00000301527fd40 bsp=e000003015278d90
 [<a0000001000d2ac0>] kthread+0x220/0x2a0
                                sp=e00000301527fd50 bsp=e000003015278d48
 [<a000000100010a50>] kernel_thread_helper+0xd0/0x100
                                sp=e00000301527fe30 bsp=e000003015278d20
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e00000301527fe30 bsp=e000003015278d20

Backtrace of pid 1007 (xfssyncd)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000307bdc7c00 bsp=e00000307bdc0e20
 [<a00000010079b5d0>] schedule_timeout+0x110/0x180
                                sp=e00000307bdc7d10 bsp=e00000307bdc0de8
 [<a00000010079b6d0>] schedule_timeout_interruptible+0x30/0x60
                                sp=e00000307bdc7d40 bsp=e00000307bdc0dc8
 [<a0000001003c9910>] xfssyncd+0xb0/0x400
                                sp=e00000307bdc7d40 bsp=e00000307bdc0d90
 [<a0000001000d2ac0>] kthread+0x220/0x2a0
                                sp=e00000307bdc7d50 bsp=e00000307bdc0d48
 [<a000000100010a50>] kernel_thread_helper+0xd0/0x100
                                sp=e00000307bdc7e30 bsp=e00000307bdc0d20
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e00000307bdc7e30 bsp=e00000307bdc0d20

Backtrace of pid 1063 (udevd)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e000003015e1f950 bsp=e000003015e18f78
 [<a00000010079b500>] schedule_timeout+0x40/0x180
                                sp=e000003015e1fa60 bsp=e000003015e18f48
 [<a000000100186f60>] do_select+0x360/0x840
                                sp=e000003015e1fa90 bsp=e000003015e18e68
 [<a000000100187a50>] sys_select+0x610/0x9e0
                                sp=e000003015e1fce0 bsp=e000003015e18dc8
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000003015e1fe30 bsp=e000003015e18dc8
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000003015e20000 bsp=e000003015e18dc8

Backtrace of pid 2372 (ifup)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000307a47fd00 bsp=e00000307a478e58
 [<a0000001000aada0>] do_exit+0x1320/0x1380
                                sp=e00000307a47fe10 bsp=e00000307a478e08
 [<a0000001000aaf40>] do_group_exit+0x140/0x160
                                sp=e00000307a47fe30 bsp=e00000307a478dc8
 [<a0000001000aaf80>] sys_exit_group+0x20/0x40
                                sp=e00000307a47fe30 bsp=e00000307a478d70
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000307a47fe30 bsp=e00000307a478d70
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000307a480000 bsp=e00000307a478d70

Backtrace of pid 2421 (startpar)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000307a507d00 bsp=e00000307a500e28
 [<a0000001000aada0>] do_exit+0x1320/0x1380
                                sp=e00000307a507e10 bsp=e00000307a500dd0
 [<a0000001000aaf40>] do_group_exit+0x140/0x160
                                sp=e00000307a507e30 bsp=e00000307a500d98
 [<a0000001000aaf80>] sys_exit_group+0x20/0x40
                                sp=e00000307a507e30 bsp=e00000307a500d40
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000307a507e30 bsp=e00000307a500d40
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000307a508000 bsp=e00000307a500d40

Backtrace of pid 2450 (boot.ldconfig)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000307a55fd00 bsp=e00000307a558e58
 [<a0000001000aada0>] do_exit+0x1320/0x1380
                                sp=e00000307a55fe10 bsp=e00000307a558e08
 [<a0000001000aaf40>] do_group_exit+0x140/0x160
                                sp=e00000307a55fe30 bsp=e00000307a558dc8
 [<a0000001000aaf80>] sys_exit_group+0x20/0x40
                                sp=e00000307a55fe30 bsp=e00000307a558d70
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000307a55fe30 bsp=e00000307a558d70
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000307a560000 bsp=e00000307a558d70

Backtrace of pid 2452 (startpar)

Call Trace:
 [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
                                sp=e00000307a5ffd00 bsp=e00000307a5f8e28
 [<a0000001000aada0>] do_exit+0x1320/0x1380
                                sp=e00000307a5ffe10 bsp=e00000307a5f8dd0
 [<a0000001000aaf40>] do_group_exit+0x140/0x160
                                sp=e00000307a5ffe30 bsp=e00000307a5f8d98
 [<a0000001000aaf80>] sys_exit_group+0x20/0x40
                                sp=e00000307a5ffe30 bsp=e00000307a5f8d40
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000307a5ffe30 bsp=e00000307a5f8d40
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000307a600000 bsp=e00000307a5f8d40

