Return-Path: <linux-kernel-owner+w=401wt.eu-S1422981AbXBAUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422981AbXBAUSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422982AbXBAUSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:18:46 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:59344 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422984AbXBAUSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:18:45 -0500
Date: Thu, 1 Feb 2007 12:18:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
In-Reply-To: <20070201191857.GQ10305@kernel.dk>
Message-ID: <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
 <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
 <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
 <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com>
 <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com>
 <20070201191857.GQ10305@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Jens Axboe wrote:

> for xfs_buf_wait_unpin() and xfs_buf_lock(). Does this fix it?

No it still hangs consistently. This time at an earlier spot.


All OS INIT slaves have reached rendezvous
Processes interrupted by INIT - 0 (cpu 0 task 0xa000000100b24000) 0 (cpu 1 
task 0xe00000b003bd8000) 0 (cpu 2 task 0xe000023c38248000) 0 (cpu 3 task 
0xe00000b003d00000) 0 (cpu 4 task 0xe000023c38258000) 0 (cpu 5 task 
0xe00000b003d10000) 0 (cpu 6 task 0xe000023c38268000) 0 (cpu 7 task 
0xe00000b003d20000) 0 (cpu 8 task 0xe000023c382e8000) 0 (cpu 9 task 
0xe00000b003d30000) 0 (cpu 10 task 0xe000023c38380000) 0 (cpu 11 task 
0xe00000b003d40000)


Backtrace of pid 223 (pdflush)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e0000030156879d0 bsp=e0000030156811a8
 [<a0000001000db490>] synchronize_qrcu+0x170/0x1e0
                                sp=e000003015687ae0 bsp=e000003015681170
 [<a0000001003f6bc0>] __make_request+0x160/0x880
                                sp=e000003015687b10 bsp=e000003015681130
 [<a0000001003f17c0>] generic_make_request+0x4a0/0x520
                                sp=e000003015687b30 bsp=e0000030156810f8
 [<a0000001003f78f0>] submit_bio+0x2f0/0x320
                                sp=e000003015687b50 bsp=e0000030156810b0
 [<a0000001003bab20>] xfs_buf_iorequest+0x740/0x820
                                sp=e000003015687b70 bsp=e000003015681040
 [<a0000001003869d0>] xlog_bdstrat_cb+0x50/0xe0
                                sp=e000003015687ba0 bsp=e000003015681020
 [<a000000100384150>] xlog_state_release_iclog+0x770/0xcc0
                                sp=e000003015687ba0 bsp=e000003015680fc0
 [<a000000100384860>] xlog_state_sync_all+0x1c0/0x460
                                sp=e000003015687ba0 bsp=e000003015680f60
 [<a000000100385010>] _xfs_log_force+0xd0/0x5c0
                                sp=e000003015687bd0 bsp=e000003015680f00
 [<a0000001003a3720>] xfs_syncsub+0x40/0x520
                                sp=e000003015687c00 bsp=e000003015680eb0
 [<a0000001003a3d50>] xfs_sync+0x70/0xa0
                                sp=e000003015687c00 bsp=e000003015680e88
 [<a0000001003cb740>] vfs_sync+0xa0/0xc0
                                sp=e000003015687c00 bsp=e000003015680e58
 [<a0000001003c8c50>] xfs_fs_write_super+0x70/0xa0
                                sp=e000003015687c00 bsp=e000003015680e38
 [<a00000010016d490>] sync_supers+0x150/0x260
                                sp=e000003015687c00 bsp=e000003015680e08
 [<a000000100115820>] wb_kupdate+0x60/0x280
                                sp=e000003015687c00 bsp=e000003015680dc8
 [<a000000100116570>] pdflush+0x330/0x4e0
                                sp=e000003015687c50 bsp=e000003015680d90
 [<a0000001000d2ac0>] kthread+0x220/0x2a0
                                sp=e000003015687d50 bsp=e000003015680d48
 [<a000000100010a50>] kernel_thread_helper+0xd0/0x100
                                sp=e000003015687e30 bsp=e000003015680d20
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e000003015687e30 bsp=e000003015680d20

Backtrace of pid 1006 (xfsbufd)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00002bc3a23fc00 bsp=e00002bc3a238e40
 [<a00000010079b8f0>] schedule_timeout+0x110/0x180
                                sp=e00002bc3a23fd10 bsp=e00002bc3a238e10
 [<a00000010079b9f0>] schedule_timeout_interruptible+0x30/0x60
                                sp=e00002bc3a23fd40 bsp=e00002bc3a238de8
 [<a0000001003bd1d0>] xfsbufd+0x1b0/0x5e0
                                sp=e00002bc3a23fd40 bsp=e00002bc3a238d90
 [<a0000001000d2ac0>] kthread+0x220/0x2a0
                                sp=e00002bc3a23fd50 bsp=e00002bc3a238d48
 [<a000000100010a50>] kernel_thread_helper+0xd0/0x100
                                sp=e00002bc3a23fe30 bsp=e00002bc3a238d20
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e00002bc3a23fe30 bsp=e00002bc3a238d20

Backtrace of pid 1007 (xfssyncd)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00002bc3a29fc00 bsp=e00002bc3a298e20
 [<a00000010079b8f0>] schedule_timeout+0x110/0x180
                                sp=e00002bc3a29fd10 bsp=e00002bc3a298de8
 [<a00000010079b9f0>] schedule_timeout_interruptible+0x30/0x60
                                sp=e00002bc3a29fd40 bsp=e00002bc3a298dc8
 [<a0000001003c9c30>] xfssyncd+0xb0/0x400
                                sp=e00002bc3a29fd40 bsp=e00002bc3a298d90
 [<a0000001000d2ac0>] kthread+0x220/0x2a0
                                sp=e00002bc3a29fd50 bsp=e00002bc3a298d48
 [<a000000100010a50>] kernel_thread_helper+0xd0/0x100
                                sp=e00002bc3a29fe30 bsp=e00002bc3a298d20
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e00002bc3a29fe30 bsp=e00002bc3a298d20

Backtrace of pid 1010 (boot)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00000b078797bd0 bsp=e00000b078791090
 [<a000000100176860>] pipe_wait+0xc0/0x120
                                sp=e00000b078797ce0 bsp=e00000b078791068
 [<a000000100177b70>] pipe_read+0x730/0x820
                                sp=e00000b078797d10 bsp=e00000b078790fb0
 [<a000000100167ea0>] do_sync_read+0x180/0x200
                                sp=e00000b078797d10 bsp=e00000b078790f78
 [<a000000100169470>] vfs_read+0x1b0/0x340
                                sp=e00000b078797e20 bsp=e00000b078790f28
 [<a000000100169cd0>] sys_read+0x70/0xe0
                                sp=e00000b078797e20 bsp=e00000b078790eb0
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b078797e30 bsp=e00000b078790eb0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b078798000 bsp=e00000b078790eb0

Backtrace of pid 1031 (startpar)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e000003015867950 bsp=e000003015861000
 [<a00000010079b820>] schedule_timeout+0x40/0x180
                                sp=e000003015867a60 bsp=e000003015860fc8
 [<a000000100186f60>] do_select+0x360/0x840
                                sp=e000003015867a90 bsp=e000003015860ee8
 [<a000000100187a50>] sys_select+0x610/0x9e0
                                sp=e000003015867ce0 bsp=e000003015860e50
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000003015867e30 bsp=e000003015860e50
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000003015868000 bsp=e000003015860e50

Backtrace of pid 1063 (udevd)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e000003015cbf950 bsp=e000003015cb8f78
 [<a00000010079b820>] schedule_timeout+0x40/0x180
                                sp=e000003015cbfa60 bsp=e000003015cb8f48
 [<a000000100186f60>] do_select+0x360/0x840
                                sp=e000003015cbfa90 bsp=e000003015cb8e68
 [<a000000100187a50>] sys_select+0x610/0x9e0
                                sp=e000003015cbfce0 bsp=e000003015cb8dc8
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000003015cbfe30 bsp=e000003015cb8dc8
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000003015cc0000 bsp=e000003015cb8dc8

Backtrace of pid 2061 (boot.md)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00000300b97fcf0 bsp=e00000300b979028
 [<a0000001000a9430>] do_wait+0x1c50/0x20e0
                                sp=e00000300b97fe00 bsp=e00000300b978fa8
 [<a0000001000a9920>] sys_wait4+0x60/0x80
                                sp=e00000300b97fe30 bsp=e00000300b978f50
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000300b97fe30 bsp=e00000300b978f50
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000300b980000 bsp=e00000300b978f50

Backtrace of pid 2063 (lk)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00000300bc8fcf0 bsp=e00000300bc89028
 [<a0000001000a9430>] do_wait+0x1c50/0x20e0
                                sp=e00000300bc8fe00 bsp=e00000300bc88fa8
 [<a0000001000a9920>] sys_wait4+0x60/0x80
                                sp=e00000300bc8fe30 bsp=e00000300bc88f50
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000300bc8fe30 bsp=e00000300bc88f50
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000300bc90000 bsp=e00000300bc88f50

Backtrace of pid 2089 (lk_bios)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00001b03852f8b0 bsp=e00001b038529618
 [<a00000010079b820>] schedule_timeout+0x40/0x180
                                sp=e00001b03852f9c0 bsp=e00001b0385295e0
 [<a000000100385440>] _xfs_log_force+0x500/0x5c0
                                sp=e00001b03852f9f0 bsp=e00001b038529580
 [<a00000010030cd10>] xfs_alloc_search_busy+0x190/0x1e0
                                sp=e00001b03852fa20 bsp=e00001b038529538
 [<a000000100311030>] xfs_alloc_ag_vextent+0x2250/0x2420
                                sp=e00001b03852fa20 bsp=e00001b0385294a8
 [<a0000001003124b0>] xfs_alloc_vextent+0x690/0x9c0
                                sp=e00001b03852fa60 bsp=e00001b038529428
 [<a000000100332560>] xfs_bmapi+0x1e00/0x33a0
                                sp=e00001b03852fa60 bsp=e00001b0385292d8
 [<a00000010037e770>] xfs_iomap_write_allocate+0x3f0/0x760
                                sp=e00001b03852fba0 bsp=e00001b038529248
 [<a00000010037d670>] xfs_iomap+0x670/0xb00
                                sp=e00001b03852fc30 bsp=e00001b0385291d0
 [<a0000001003c5dc0>] xfs_bmap+0x40/0x60
                                sp=e00001b03852fc80 bsp=e00001b038529188
 [<a0000001003b5b60>] xfs_map_blocks+0xa0/0x120
                                sp=e00001b03852fc80 bsp=e00001b038529148
 [<a0000001003b6280>] xfs_page_state_convert+0x540/0x1a40
                                sp=e00001b03852fc90 bsp=e00001b038529080
 [<a0000001003b7e40>] xfs_vm_writepage+0x180/0x220
                                sp=e00001b03852fd50 bsp=e00001b038529040
 [<a0000001001146e0>] generic_writepages+0x420/0x800
                                sp=e00001b03852fd60 bsp=e00001b038528fc0
 [<a0000001003b7f70>] xfs_vm_writepages+0x90/0xc0
                                sp=e00001b03852fdf0 bsp=e00001b038528f88
 [<a000000100114b70>] do_writepages+0xb0/0x120
                                sp=e00001b03852fdf0 bsp=e00001b038528f58
 [<a000000100108470>] __filemap_fdatawrite_range+0xb0/0xe0
                                sp=e00001b03852fdf0 bsp=e00001b038528f20
 [<a0000001001089c0>] filemap_fdatawrite+0x40/0x60
                                sp=e00001b03852fe30 bsp=e00001b038528f00
 [<a0000001003bf320>] fs_flush_pages+0xc0/0x100
                                sp=e00001b03852fe30 bsp=e00001b038528eb8
 [<a0000001003adb10>] xfs_close+0x190/0x1e0
                                sp=e00001b03852fe30 bsp=e00001b038528e80
 [<a0000001003be820>] xfs_file_close+0xa0/0xc0
                                sp=e00001b03852fe30 bsp=e00001b038528e60
 [<a0000001001643b0>] filp_close+0xd0/0x140
                                sp=e00001b03852fe30 bsp=e00001b038528e30
 [<a000000100164560>] sys_close+0x140/0x1e0
                                sp=e00001b03852fe30 bsp=e00001b038528db0
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00001b03852fe30 bsp=e00001b038528db0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00001b038530000 bsp=e00001b038528db0

Backtrace of pid 2091 (mdrun)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e000013038907bd0 bsp=e000013038901090
 [<a000000100176860>] pipe_wait+0xc0/0x120
                                sp=e000013038907ce0 bsp=e000013038901068
 [<a000000100177b70>] pipe_read+0x730/0x820
                                sp=e000013038907d10 bsp=e000013038900fb0
 [<a000000100167ea0>] do_sync_read+0x180/0x200
                                sp=e000013038907d10 bsp=e000013038900f78
 [<a000000100169470>] vfs_read+0x1b0/0x340
                                sp=e000013038907e20 bsp=e000013038900f28
 [<a000000100169cd0>] sys_read+0x70/0xe0
                                sp=e000013038907e20 bsp=e000013038900eb0
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000013038907e30 bsp=e000013038900eb0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000013038908000 bsp=e000013038900eb0

Backtrace of pid 2134 (mdrun)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00002b83b9d7cf0 bsp=e00002b83b9d1028
 [<a0000001000a9430>] do_wait+0x1c50/0x20e0
                                sp=e00002b83b9d7e00 bsp=e00002b83b9d0fa8
 [<a0000001000a9920>] sys_wait4+0x60/0x80
                                sp=e00002b83b9d7e30 bsp=e00002b83b9d0f50
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00002b83b9d7e30 bsp=e00002b83b9d0f50
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00002b83b9d8000 bsp=e00002b83b9d0f50

Backtrace of pid 2135 (mdadm)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e000003015c07b40 bsp=e000003015c01250
 [<a00000010079a290>] io_schedule+0xf0/0x120
                                sp=e000003015c07c50 bsp=e000003015c01228
 [<a00000010079a310>] io_wait_schedule+0x50/0x80
                                sp=e000003015c07c50 bsp=e000003015c01208
 [<a000000100106260>] sleep_on_page+0x20/0x40
                                sp=e000003015c07c50 bsp=e000003015c011d8
 [<a00000010079bad0>] __wait_on_bit_lock+0xb0/0x1c0
                                sp=e000003015c07c50 bsp=e000003015c01190
 [<a000000100106210>] lock_page_blocking+0x70/0xa0
                                sp=e000003015c07c50 bsp=e000003015c01168
 [<a000000100114590>] generic_writepages+0x2d0/0x800
                                sp=e000003015c07c50 bsp=e000003015c010f0
 [<a0000001003b7f70>] xfs_vm_writepages+0x90/0xc0
                                sp=e000003015c07ce0 bsp=e000003015c010b8
 [<a000000100114b70>] do_writepages+0xb0/0x120
                                sp=e000003015c07ce0 bsp=e000003015c01088
 [<a0000001001ac8f0>] __writeback_single_inode+0x450/0x8a0
                                sp=e000003015c07ce0 bsp=e000003015c01028
 [<a0000001001ad670>] generic_sync_sb_inodes+0x4d0/0x740
                                sp=e000003015c07d20 bsp=e000003015c00fc0
 [<a0000001001ad970>] sync_sb_inodes+0x90/0xc0
                                sp=e000003015c07d20 bsp=e000003015c00f98
 [<a0000001001adac0>] sync_inodes_sb+0x120/0x140
                                sp=e000003015c07d20 bsp=e000003015c00f70
 [<a00000010016bdb0>] __fsync_super+0x30/0x1c0
                                sp=e000003015c07d60 bsp=e000003015c00f50
 [<a00000010016bf70>] fsync_super+0x30/0x60
                                sp=e000003015c07d60 bsp=e000003015c00f30
 [<a0000001001b7c70>] fsync_bdev+0x50/0xc0
                                sp=e000003015c07d60 bsp=e000003015c00f08
 [<a0000001003f8900>] blkdev_ioctl+0x100/0x11e0
                                sp=e000003015c07d60 bsp=e000003015c00e98
 [<a0000001001c25e0>] block_ioctl+0x40/0x60
                                sp=e000003015c07e10 bsp=e000003015c00e68
 [<a000000100184d30>] do_ioctl+0x90/0x180
                                sp=e000003015c07e10 bsp=e000003015c00e28
 [<a0000001001856a0>] vfs_ioctl+0x880/0x8e0
                                sp=e000003015c07e10 bsp=e000003015c00dd8
 [<a000000100185760>] sys_ioctl+0x60/0xc0
                                sp=e000003015c07e20 bsp=e000003015c00d60
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000003015c07e30 bsp=e000003015c00d60
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000003015c08000 bsp=e000003015c00d60

Backtrace of pid 2136 (grep)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e00000300bd67bd0 bsp=e00000300bd60f08
 [<a000000100176860>] pipe_wait+0xc0/0x120
                                sp=e00000300bd67ce0 bsp=e00000300bd60ee0
 [<a000000100177b70>] pipe_read+0x730/0x820
                                sp=e00000300bd67d10 bsp=e00000300bd60e30
 [<a000000100167ea0>] do_sync_read+0x180/0x200
                                sp=e00000300bd67d10 bsp=e00000300bd60df0
 [<a000000100169470>] vfs_read+0x1b0/0x340
                                sp=e00000300bd67e20 bsp=e00000300bd60da0
 [<a000000100169cd0>] sys_read+0x70/0xe0
                                sp=e00000300bd67e20 bsp=e00000300bd60d28
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000300bd67e30 bsp=e00000300bd60d28
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000300bd68000 bsp=e00000300bd60d28

Backtrace of pid 2137 (sed)

Call Trace:
 [<a000000100799ed0>] schedule+0x1bf0/0x1ec0
                                sp=e000003015acfbd0 bsp=e000003015ac9008
 [<a000000100176860>] pipe_wait+0xc0/0x120
                                sp=e000003015acfce0 bsp=e000003015ac8fd8
 [<a000000100177b70>] pipe_read+0x730/0x820
                                sp=e000003015acfd10 bsp=e000003015ac8f28
 [<a000000100167ea0>] do_sync_read+0x180/0x200
                                sp=e000003015acfd10 bsp=e000003015ac8ef0
 [<a000000100169470>] vfs_read+0x1b0/0x340
                                sp=e000003015acfe20 bsp=e000003015ac8ea0
 [<a000000100169cd0>] sys_read+0x70/0xe0
                                sp=e000003015acfe20 bsp=e000003015ac8e28
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000003015acfe30 bsp=e000003015ac8e28
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000003015ad0000 bsp=e000003015ac8e28

