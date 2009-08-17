Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbZHQURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbZHQURw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZHQURv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:17:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39556 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbZHQURu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:17:50 -0400
Date: Mon, 17 Aug 2009 16:17:50 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: md deadlock (2.6.31-rc5-git2)
Message-ID: <20090817201750.GA21562@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel is a bit old (it's what we froze on for Fedora 12 alpha,
and we haven't started building install images with anything newer yet),
but I don't recall seeing anything similar posted recently..

While creating a series of md arrays, I got the mdadm process to just lock up.
Looking in dmesg showed that it had warned about it too ..

	Dave


...
type=1403 audit(1250524416.444:2): policy loaded auid=4294967295 ses=4294967295
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
xor: automatically using best checksumming function: generic_sse
   generic_sse:  4188.000 MB/sec
xor: using function: generic_sse (4188.000 MB/sec)
async_tx: api initialized (async)
raid6: int64x1   1199 MB/s
raid6: int64x2   1363 MB/s
raid6: int64x4   1570 MB/s
raid6: int64x8   1265 MB/s
raid6: sse2x1    1734 MB/s
raid6: sse2x2    2750 MB/s
raid6: sse2x4    2843 MB/s
raid6: using algorithm sse2x4 (2843 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: raid10 personality registered for level 10
md: linear personality registered for level -1
device-mapper: multipath: version 1.1.0 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
executing set pll
executing set crtc timing
[drm] TV-5: set mode 1280x1024 1d
end_request: I/O error, dev fd0, sector 0
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
md: bind<sda11>
md: bind<sdb11>
raid1: md0 is not clean -- starting background reconstruction
raid1: raid set md0 active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 104726528
md: resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 102272 blocks.
 md0: unknown partition table
md: bind<sda1>
md: bind<sdb1>
raid0: looking at sdb1
raid0:   comparing sdb1(20479872)
 with sdb1(20479872)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda1
raid0:   comparing sda1(20479872)
 with sdb1(20479872)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 40959744 sectors.
******* md1 configuration *********
zone0=[sda1/sdb1/]
        zone offset=0kb device offset=0kb size=20479872kb
**********************************

md1: detected capacity change from 0 to 20971388928
 md1: unknown partition table
md: bind<sda2>
md: bind<sdb2>
raid0: looking at sdb2
raid0:   comparing sdb2(2047872)
 with sdb2(2047872)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda2
raid0:   comparing sda2(2047872)
 with sdb2(2047872)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 4095744 sectors.
******* md2 configuration *********
zone0=[sda2/sdb2/]
        zone offset=0kb device offset=0kb size=2047872kb
**********************************

md2: detected capacity change from 0 to 2097020928
 md2: unknown partition table
md: bind<sda3>
md: bind<sdb3>
raid0: looking at sdb3
raid0:   comparing sdb3(2047872)
 with sdb3(2047872)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda3
raid0:   comparing sda3(2047872)
 with sdb3(2047872)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 4095744 sectors.
******* md3 configuration *********
zone0=[sda3/sdb3/]
        zone offset=0kb device offset=0kb size=2047872kb
**********************************

md: md0: resync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sda11
 disk 1, wo:0, o:1, dev:sdb11
INFO: task mdadm:2249 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mdadm         D 0000000000000003  4664  2249    333 0x00000080
 ffff880023c81938 0000000000000086 0000000000000000 0000000000000001
 ffff88002bb124a0 0000000000000007 0000000000000006 ffff88003f417028
 ffff88002bb12890 000000000000fa20 ffff88002bb12890 00000000001d5bc0
Call Trace:
 [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
 [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
 [<ffffffff814fb166>] __mutex_lock_common+0x21e/0x3bf
 [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
 [<ffffffff814fb42a>] mutex_lock_nested+0x4f/0x6b
 [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
 [<ffffffff813f35ce>] do_md_run+0x886/0x92f
 [<ffffffff814fb356>] ? mutex_lock_interruptible_nested+0x4f/0x6a
 [<ffffffff813f5f30>] md_ioctl+0x11b6/0x142b
 [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
 [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
 [<ffffffff81263f12>] __blkdev_driver_ioctl+0x36/0x95
 [<ffffffff81264895>] blkdev_ioctl+0x8d6/0x925
 [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
 [<ffffffff8122bae6>] ? __rcu_read_unlock+0x34/0x4a
 [<ffffffff8122ca90>] ? avc_has_perm_noaudit+0x3c9/0x3ef
 [<ffffffff8122cb21>] ? avc_has_perm+0x6b/0x91
 [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
 [<ffffffff8116e5b4>] block_ioctl+0x4a/0x62
 [<ffffffff81150e03>] vfs_ioctl+0x31/0xaa
 [<ffffffff811513c5>] do_vfs_ioctl+0x4aa/0x506
 [<ffffffff81151486>] sys_ioctl+0x65/0x9c
 [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
2 locks held by mdadm/2249:
 #0:  (&new->reconfig_mutex#2){+.+.+.}, at: [<ffffffff813edcab>] mddev_lock+0x2a/0x40
 #1:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
INFO: task mdadm:2249 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mdadm         D 0000000000000003  4664  2249    333 0x00000080
 ffff880023c81938 0000000000000086 0000000000000000 0000000000000001
 ffff88002bb124a0 0000000000000007 0000000000000006 ffff88003f417028
 ffff88002bb12890 000000000000fa20 ffff88002bb12890 00000000001d5bc0
Call Trace:
 [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
 [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
 [<ffffffff814fb166>] __mutex_lock_common+0x21e/0x3bf
 [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
 [<ffffffff814fb42a>] mutex_lock_nested+0x4f/0x6b
 [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
 [<ffffffff813f35ce>] do_md_run+0x886/0x92f
 [<ffffffff814fb356>] ? mutex_lock_interruptible_nested+0x4f/0x6a
 [<ffffffff813f5f30>] md_ioctl+0x11b6/0x142b
 [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
 [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
 [<ffffffff81263f12>] __blkdev_driver_ioctl+0x36/0x95
 [<ffffffff81264895>] blkdev_ioctl+0x8d6/0x925
 [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
 [<ffffffff8122bae6>] ? __rcu_read_unlock+0x34/0x4a
 [<ffffffff8122ca90>] ? avc_has_perm_noaudit+0x3c9/0x3ef
 [<ffffffff8122cb21>] ? avc_has_perm+0x6b/0x91
 [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
 [<ffffffff8116e5b4>] block_ioctl+0x4a/0x62
 [<ffffffff81150e03>] vfs_ioctl+0x31/0xaa
 [<ffffffff811513c5>] do_vfs_ioctl+0x4aa/0x506
 [<ffffffff81151486>] sys_ioctl+0x65/0x9c
 [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
2 locks held by mdadm/2249:
 #0:  (&new->reconfig_mutex#2){+.+.+.}, at: [<ffffffff813edcab>] mddev_lock+0x2a/0x40
 #1:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d

