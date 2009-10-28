Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZJ1BOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZJ1BOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbZJ1BOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:14:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:50870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZJ1BOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:14:17 -0400
Date: Wed, 28 Oct 2009 02:14:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.32-rc5: surprise removal of USB mass storage, and whole
 system goes to hell
In-Reply-To: <20091027211951.GA21967@elf.ucw.cz>
Message-ID: <alpine.LRH.2.00.0910280212510.25075@twin.jikos.cz>
References: <20091027211951.GA21967@elf.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Pavel Machek wrote:

> I did remove one harddrive w/o unmounting, and now the whole system
> becomes unusable :-(: (whole dmesg attached).
> 
> Stuff like "sync" hangs, and I'll probably have to reboot soon.

>From the traces it seems that it might be related to the new per-bdi 
writeback stuff ... adding Jens to CC.

> usb 1-1:1.0: uevent
> usb-storage 1-1:1.0: usb_probe_interface
> usb-storage 1-1:1.0: usb_probe_interface - got id
> scsi18 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 18
> usb-storage: waiting for device to settle before scanning
> drivers/usb/core/inode.c: creating file '018'
> scsi 18:0:0:0: Direct-Access     HTS54106 0G9SA00               PQ: 0 ANSI: 2 CCS
> sd 18:0:0:0: [sdc] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
> sd 18:0:0:0: [sdc] Write Protect is off
> sd 18:0:0:0: [sdc] Mode Sense: 3c 00 00 00
> sd 18:0:0:0: [sdc] Assuming drive cache: write through
> sd 18:0:0:0: Attached scsi generic sg1 type 0
> sd 18:0:0:0: [sdc] Assuming drive cache: write through
>  sdc: sdc1 sdc2 sdc4
> usb-storage: device scan complete
> sd 18:0:0:0: [sdc] Assuming drive cache: write through
> sd 18:0:0:0: [sdc] Attached SCSI disk
> usb 1-1:1.0: uevent
> usb 1-1: uevent
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sdc2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> EXT3-fs error (device sdb2): ext3_find_entry: reading directory #2 offset 0
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> EXT3-fs error (device sdb2): ext3_find_entry: reading directory #2 offset 0
> ------------[ cut here ]------------
> WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x80/0xa0()
> Hardware name: 17097HU
> Modules linked in:
> Pid: 2110, comm: sh Not tainted 2.6.32-rc5-00154-gfbad3ad-dirty #83
> Call Trace:
>  [<c0791da9>] ? printk+0x18/0x1a
>  [<c02b9110>] ? mark_buffer_dirty+0x80/0xa0
>  [<c023113c>] warn_slowpath_common+0x6c/0xc0
>  [<c02b9110>] ? mark_buffer_dirty+0x80/0xa0
>  [<c02311a5>] warn_slowpath_null+0x15/0x20
>  [<c02b9110>] mark_buffer_dirty+0x80/0xa0
>  [<c02eeed4>] ext3_commit_super+0x44/0x80
>  [<c02f01c8>] ext3_handle_error+0x48/0xb0
>  [<c0791da9>] ? printk+0x18/0x1a
>  [<c02f02f1>] ext3_error+0x51/0x60
>  [<c02ece2d>] ext3_find_entry+0x5ad/0x6d0
>  [<c02a96b4>] ? d_alloc+0x114/0x190
>  [<c02ed73d>] ext3_lookup+0x3d/0x100
>  [<c02a96d8>] ? d_alloc+0x138/0x190
>  [<c029faf9>] do_lookup+0x199/0x1c0
>  [<c02a12ed>] __link_path_walk+0x31d/0xd70
>  [<c02a1f34>] path_walk+0x54/0xb0
>  [<c02a2081>] do_path_lookup+0x51/0x60
>  [<c02a2b1a>] user_path_at+0x4a/0x80
>  [<c029b045>] vfs_fstatat+0x35/0x70
>  [<c029b15b>] vfs_stat+0x1b/0x20
>  [<c029b174>] sys_stat64+0x14/0x30
>  [<c0255dc3>] ? lockdep_sys_exit+0x23/0x80
>  [<c0202e5c>] ? sysenter_do_call+0x1e/0x31
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> ---[ end trace 4eaf1068b9a2a4ba ]---
> EXT3-fs error (device sdb2): ext3_readdir: directory #2 contains a hole at offset 0
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task umount:21522 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> umount        D c8469eb4     0 21522  24889 0x00000000
>  c8469ec8 00000046 00000002 c8469eb4 c2c01d64 00000000 c8469e6c c8469e7c
>  508b0602 00013840 00000000 00000003 00000000 db18ac40 c0ad2d64 cd044680
>  cd044908 c2c050c0 00000000 051c883d 00000046 cd044680 db18ac40 c8469eac
> Call Trace:
>  [<c07946fe>] ? rwsem_down_failed_common+0x2e/0x190
>  [<c0794775>] rwsem_down_failed_common+0xa5/0x190
>  [<c079487d>] rwsem_down_write_failed+0x1d/0x30
>  [<c07948fe>] call_rwsem_down_write_failed+0x6/0x8
>  [<c0793f67>] ? down_write+0x47/0x50
>  [<c029a082>] ? deactivate_super+0x42/0x60
>  [<c029a082>] deactivate_super+0x42/0x60
>  [<c02ae1b8>] mntput_no_expire+0x98/0xc0
>  [<c02ae49f>] sys_umount+0x4f/0x2e0
>  [<c02ae749>] sys_oldumount+0x19/0x20
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task sync:21224 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> sync          D e527dec8     0 21224  21221 0x00000000
>  e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
>  c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
>  f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
> Call Trace:
>  [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
>  [<c02b31b8>] bdi_sched_wait+0x8/0x10
>  [<c07931e7>] __wait_on_bit+0x47/0x70
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
>  [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
>  [<c0245820>] ? wake_bit_function+0x0/0x60
>  [<c02b3222>] sync_inodes_sb+0x62/0x130
>  [<c02b7250>] __sync_filesystem+0x20/0x60
>  [<c02b7375>] sync_filesystems+0xe5/0x120
>  [<c02b73fb>] sys_sync+0x1b/0x40
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> INFO: task umount:21522 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> umount        D c8469eb4     0 21522  24889 0x00000000
>  c8469ec8 00000046 00000002 c8469eb4 c2c01d64 00000000 c8469e6c c8469e7c
>  508b0602 00013840 00000000 00000003 00000000 db18ac40 c0ad2d64 cd044680
>  cd044908 c2c050c0 00000000 051c883d 00000046 cd044680 db18ac40 c8469eac
> Call Trace:
>  [<c07946fe>] ? rwsem_down_failed_common+0x2e/0x190
>  [<c0794775>] rwsem_down_failed_common+0xa5/0x190
>  [<c079487d>] rwsem_down_write_failed+0x1d/0x30
>  [<c07948fe>] call_rwsem_down_write_failed+0x6/0x8
>  [<c0793f67>] ? down_write+0x47/0x50
>  [<c029a082>] ? deactivate_super+0x42/0x60
>  [<c029a082>] deactivate_super+0x42/0x60
>  [<c02ae1b8>] mntput_no_expire+0x98/0xc0
>  [<c02ae49f>] sys_umount+0x4f/0x2e0
>  [<c02ae749>] sys_oldumount+0x19/0x20
>  [<c0202e50>] sysenter_do_call+0x12/0x31
> INFO: lockdep is turned off.
> 
> 									Pavel
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

