Return-Path: <linux-kernel-owner+w=401wt.eu-S1161104AbXBAAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161104AbXBAAOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXBAAOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:14:17 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:54221 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161104AbXBAAOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:14:17 -0500
Date: Wed, 31 Jan 2007 16:14:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Andrew Morton wrote:

> - Restored git-block.patch: mainly the block unplugging rework.  The
>   problematic CFQ updates have been taken out.

MD hung again as before so I compiled a kernel 
without it. Next XFS started hanging during bootup.

Some traces of processes hung but I do not have a clue as to what is 
wrong here...:

Call Trace:
 [<a00000010074c1b0>] schedule+0x1bf0/0x1ec0
                                sp=e00000301560fac0 bsp=e000003015608fc8
 [<a0000001003ba350>] xfs_buf_iorequest+0x130/0x820
                                sp=e00000301560fbd0 bsp=e000003015608f58
 [<a0000001003c5b00>] xfs_bdstrat_cb+0x60/0x100
                                sp=e00000301560fc00 bsp=e000003015608f38
 [<a0000001003b2ba0>] xfs_bwrite+0xe0/0x1e0
                                sp=e00000301560fc00 bsp=e000003015608f00
 [<a0000001003a3980>] xfs_syncsub+0x2c0/0x520
                                sp=e00000301560fc00 bsp=e000003015608eb0
 [<a0000001003a3d30>] xfs_sync+0x70/0xa0
                                sp=e00000301560fc00 bsp=e000003015608e88
 [<a0000001003cb400>] vfs_sync+0xa0/0xc0
                                sp=e00000301560fc00 bsp=e000003015608e58
 [<a0000001003c8910>] xfs_fs_write_super+0x70/0xa0
                                sp=e00000301560fc00 bsp=e000003015608e38
 [<a00000010016d490>] sync_supers+0x150/0x260
                                sp=e00000301560fc00 bsp=e000003015608e08
 [<a000000100115820>] wb_kupdate+0x60/0x280
                                sp=e00000301560fc00 bsp=e000003015608dc8
 [<a000000100116570>] pdflush+0x330/0x4e0
                                sp=e00000301560fc50 bsp=e000003015608d90
 [<a0000001000d2ac0>] kthread+0x220/0x2a0
                                sp=e00000301560fd50 bsp=e000003015608d48
 [<a000000100010a50>] kernel_thread_helper+0xd0/0x100
                                sp=e00000301560fe30 bsp=e000003015608d20
 [<a000000100009140>] start_kernel_thread+0x20/0x40
                                sp=e00000301560fe30 bsp=e000003015608d20
                                                                                             
Call Trace:
 [<a00000010074c1b0>] schedule+0x1bf0/0x1ec0
                                sp=e00001b03869f8b0 bsp=e00001b038699618
 [<a00000010074db00>] schedule_timeout+0x40/0x180
                                sp=e00001b03869f9c0 bsp=e00001b0386995e0
 [<a000000100385420>] _xfs_log_force+0x500/0x5c0
                                sp=e00001b03869f9f0 bsp=e00001b038699580
 [<a00000010030ccf0>] xfs_alloc_search_busy+0x190/0x1e0
                                sp=e00001b03869fa20 bsp=e00001b038699538
 [<a000000100311010>] xfs_alloc_ag_vextent+0x2250/0x2420
                                sp=e00001b03869fa20 bsp=e00001b0386994a8
 [<a000000100312490>] xfs_alloc_vextent+0x690/0x9c0
                                sp=e00001b03869fa60 bsp=e00001b038699428
 [<a000000100332540>] xfs_bmapi+0x1e00/0x33a0
                                sp=e00001b03869fa60 bsp=e00001b0386992d8
 [<a00000010037e750>] xfs_iomap_write_allocate+0x3f0/0x760
                                sp=e00001b03869fba0 bsp=e00001b038699248
 [<a00000010037d650>] xfs_iomap+0x670/0xb00
                                sp=e00001b03869fc30 bsp=e00001b0386991d0
 [<a0000001003c5a80>] xfs_bmap+0x40/0x60
                                sp=e00001b03869fc80 bsp=e00001b038699188
 [<a0000001003b5b40>] xfs_map_blocks+0xa0/0x120
                                sp=e00001b03869fc80 bsp=e00001b038699148
 [<a0000001003b6260>] xfs_page_state_convert+0x540/0x1a40
                                sp=e00001b03869fc90 bsp=e00001b038699080
 [<a0000001003b7e20>] xfs_vm_writepage+0x180/0x220
                                sp=e00001b03869fd50 bsp=e00001b038699040
 [<a0000001001146e0>] generic_writepages+0x420/0x800
                                sp=e00001b03869fd60 bsp=e00001b038698fc0
 [<a0000001003b7f50>] xfs_vm_writepages+0x90/0xc0
                                sp=e00001b03869fdf0 bsp=e00001b038698f88
 [<a000000100114b70>] do_writepages+0xb0/0x120
                                sp=e00001b03869fdf0 bsp=e00001b038698f58
 [<a000000100108470>] __filemap_fdatawrite_range+0xb0/0xe0
                                sp=e00001b03869fdf0 bsp=e00001b038698f20
 [<a0000001001089c0>] filemap_fdatawrite+0x40/0x60
                                sp=e00001b03869fe30 bsp=e00001b038698f00
 [<a0000001003befe0>] fs_flush_pages+0xc0/0x100
                                sp=e00001b03869fe30 bsp=e00001b038698eb8
 [<a0000001003adaf0>] xfs_close+0x190/0x1e0
                                sp=e00001b03869fe30 bsp=e00001b038698e80
 [<a0000001003be4e0>] xfs_file_close+0xa0/0xc0
                                sp=e00001b03869fe30 bsp=e00001b038698e60
 [<a0000001001643b0>] filp_close+0xd0/0x140
                                sp=e00001b03869fe30 bsp=e00001b038698e30
 [<a000000100164560>] sys_close+0x140/0x1e0
                                sp=e00001b03869fe30 bsp=e00001b038698db0
 [<a00000010000b360>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00001b03869fe30 bsp=e00001b038698db0
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00001b0386a0000 bsp=e00001b038698db0


