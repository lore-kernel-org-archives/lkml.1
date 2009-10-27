Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZJ0VUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZJ0VUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbZJ0VUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:20:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43340 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbZJ0VT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:19:59 -0400
Date: Tue, 27 Oct 2009 22:19:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc5: surprise removal of USB mass storage, and whole system
 goes to hell
Message-ID: <20091027211951.GA21967@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


I did remove one harddrive w/o unmounting, and now the whole system
becomes unusable :-(: (whole dmesg attached).

Stuff like "sync" hangs, and I'll probably have to reboot soon.
								Pavel

usb 1-1:1.0: uevent
usb-storage 1-1:1.0: usb_probe_interface
usb-storage 1-1:1.0: usb_probe_interface - got id
scsi18 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 18
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '018'
scsi 18:0:0:0: Direct-Access     HTS54106 0G9SA00               PQ: 0 ANSI: 2 CCS
sd 18:0:0:0: [sdc] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
sd 18:0:0:0: [sdc] Write Protect is off
sd 18:0:0:0: [sdc] Mode Sense: 3c 00 00 00
sd 18:0:0:0: [sdc] Assuming drive cache: write through
sd 18:0:0:0: Attached scsi generic sg1 type 0
sd 18:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1 sdc2 sdc4
usb-storage: device scan complete
sd 18:0:0:0: [sdc] Assuming drive cache: write through
sd 18:0:0:0: [sdc] Attached SCSI disk
usb 1-1:1.0: uevent
usb 1-1: uevent
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs error (device sdb2): ext3_find_entry: reading directory #2 offset 0
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
EXT3-fs error (device sdb2): ext3_find_entry: reading directory #2 offset 0
------------[ cut here ]------------
WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x80/0xa0()
Hardware name: 17097HU
Modules linked in:
Pid: 2110, comm: sh Not tainted 2.6.32-rc5-00154-gfbad3ad-dirty #83
Call Trace:
 [<c0791da9>] ? printk+0x18/0x1a
 [<c02b9110>] ? mark_buffer_dirty+0x80/0xa0
 [<c023113c>] warn_slowpath_common+0x6c/0xc0
 [<c02b9110>] ? mark_buffer_dirty+0x80/0xa0
 [<c02311a5>] warn_slowpath_null+0x15/0x20
 [<c02b9110>] mark_buffer_dirty+0x80/0xa0
 [<c02eeed4>] ext3_commit_super+0x44/0x80
 [<c02f01c8>] ext3_handle_error+0x48/0xb0
 [<c0791da9>] ? printk+0x18/0x1a
 [<c02f02f1>] ext3_error+0x51/0x60
 [<c02ece2d>] ext3_find_entry+0x5ad/0x6d0
 [<c02a96b4>] ? d_alloc+0x114/0x190
 [<c02ed73d>] ext3_lookup+0x3d/0x100
 [<c02a96d8>] ? d_alloc+0x138/0x190
 [<c029faf9>] do_lookup+0x199/0x1c0
 [<c02a12ed>] __link_path_walk+0x31d/0xd70
 [<c02a1f34>] path_walk+0x54/0xb0
 [<c02a2081>] do_path_lookup+0x51/0x60
 [<c02a2b1a>] user_path_at+0x4a/0x80
 [<c029b045>] vfs_fstatat+0x35/0x70
 [<c029b15b>] vfs_stat+0x1b/0x20
 [<c029b174>] sys_stat64+0x14/0x30
 [<c0255dc3>] ? lockdep_sys_exit+0x23/0x80
 [<c0202e5c>] ? sysenter_do_call+0x1e/0x31
 [<c0202e50>] sysenter_do_call+0x12/0x31
---[ end trace 4eaf1068b9a2a4ba ]---
EXT3-fs error (device sdb2): ext3_readdir: directory #2 contains a hole at offset 0
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task umount:21522 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D c8469eb4     0 21522  24889 0x00000000
 c8469ec8 00000046 00000002 c8469eb4 c2c01d64 00000000 c8469e6c c8469e7c
 508b0602 00013840 00000000 00000003 00000000 db18ac40 c0ad2d64 cd044680
 cd044908 c2c050c0 00000000 051c883d 00000046 cd044680 db18ac40 c8469eac
Call Trace:
 [<c07946fe>] ? rwsem_down_failed_common+0x2e/0x190
 [<c0794775>] rwsem_down_failed_common+0xa5/0x190
 [<c079487d>] rwsem_down_write_failed+0x1d/0x30
 [<c07948fe>] call_rwsem_down_write_failed+0x6/0x8
 [<c0793f67>] ? down_write+0x47/0x50
 [<c029a082>] ? deactivate_super+0x42/0x60
 [<c029a082>] deactivate_super+0x42/0x60
 [<c02ae1b8>] mntput_no_expire+0x98/0xc0
 [<c02ae49f>] sys_umount+0x4f/0x2e0
 [<c02ae749>] sys_oldumount+0x19/0x20
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task sync:21224 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D e527dec8     0 21224  21221 0x00000000
 e527dedc 00000046 00000002 e527dec8 c2c01d64 00000000 c0224f96 00000000
 c14dbaa0 0001379f c2e050d0 0001379f c14dd6fc c2e05118 c0ad2d64 f61f3680
 f61f3908 c2c050c0 00000000 0519e6c9 00000000 00000001 00000001 00000000
Call Trace:
 [<c0224f96>] ? select_task_rq_fair+0x46/0x7e0
 [<c02b31b8>] bdi_sched_wait+0x8/0x10
 [<c07931e7>] __wait_on_bit+0x47/0x70
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c07932b8>] out_of_line_wait_on_bit+0xa8/0xc0
 [<c02b31b0>] ? bdi_sched_wait+0x0/0x10
 [<c0245820>] ? wake_bit_function+0x0/0x60
 [<c02b3222>] sync_inodes_sb+0x62/0x130
 [<c02b7250>] __sync_filesystem+0x20/0x60
 [<c02b7375>] sync_filesystems+0xe5/0x120
 [<c02b73fb>] sys_sync+0x1b/0x40
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.
INFO: task umount:21522 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount        D c8469eb4     0 21522  24889 0x00000000
 c8469ec8 00000046 00000002 c8469eb4 c2c01d64 00000000 c8469e6c c8469e7c
 508b0602 00013840 00000000 00000003 00000000 db18ac40 c0ad2d64 cd044680
 cd044908 c2c050c0 00000000 051c883d 00000046 cd044680 db18ac40 c8469eac
Call Trace:
 [<c07946fe>] ? rwsem_down_failed_common+0x2e/0x190
 [<c0794775>] rwsem_down_failed_common+0xa5/0x190
 [<c079487d>] rwsem_down_write_failed+0x1d/0x30
 [<c07948fe>] call_rwsem_down_write_failed+0x6/0x8
 [<c0793f67>] ? down_write+0x47/0x50
 [<c029a082>] ? deactivate_super+0x42/0x60
 [<c029a082>] deactivate_super+0x42/0x60
 [<c02ae1b8>] mntput_no_expire+0x98/0xc0
 [<c02ae49f>] sys_umount+0x4f/0x2e0
 [<c02ae749>] sys_oldumount+0x19/0x20
 [<c0202e50>] sysenter_do_call+0x12/0x31
INFO: lockdep is turned off.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--7JfCtLOvnd9MIVvH
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="delme.gz"
Content-Transfer-Encoding: base64

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
kAkw54oVIq1yu0hrEiTCCyi6qZEciyY1IsdqhJapkYxKkh+1K1hSfOd9QeRRvzOIFJV7g/iw
OaGed0heiuQaTSHvqinknKaQ22kKuVZTyO01RTVpQVOwbruFJc1r3jEUZO32DIVw73PTMHl7
223DmgJdNg4pfbHr6iTUIdvjPiNrUodZRNmUugW0arN+qBTywnR8ZnuNOQu9iijvEtTtScb2
bLtdyW1uua3FYW5nslG5ZsaqsiG5Vby2IfJODdnilm+InGtItYg1sKDVa1W50tjvBnL7UEFV
6Ox2E9re/Yps/BmZ05kuWzrMlTV1V4fQWr+q2rvuVvcbzv2G8xPbcK4+Xv7UdpwpKzXBq7eN
+z3nfs+533P+bnvOlL0oCwxU7w5Uh/oV22CKKUX6m+22QW3URaqr4xQlkerOIQY5y6J1iEEu
Xd/qYgR9iOH5hhjkvQaj5cfFBfYYvHiCIQY5DqHLe4wZyE0xg1wIXa4L5X7jmEHLwIqy08Zf
y7BvS38nXYE627lKlkXr3cPSy/ZobuOs3z7stw/5iq3sdcV+zD19O6x9yo7hVSVaKpU97jYq
O4VXlXx4tftuY4FR5W5jga5ut7FA2nYjr0Ox9DYv/IW7jVbb3cY9VfKp7DY2hJhrw645Q/0Z
h133sPMqfadh66v6Larao5z0KCc9ykmPctKjnPQoJz3KydbhdlSk00iLzk1wjWzy0vHR1z/U
aSG8H1mRh7HCjwocRNo4vbb2mZ3IyESi66hycZYnfiTjGx9DqNzGaHkMQTaZavTHEPpjCD/A
MYS/zM2vtPTq13TZe07oQP2FWlFoV31y6ED0Wd3+SuPbX6m6xy04tSmunNuCUzPxzb1twbXX
wM/AQOxvHe3tpN5O+rZ20l/m2lFaeu8o7S8efc52kvb07KRndfUoja8epdoe7SSttZ3UboNZ
282S+uHspP6+0B/MTqKd7ST6ODuJ1dlJ9NF2Et3d3KC7mRu0q51UufHx/SpebyfR2E7SS+0k
LSXrfsBwu3CX44W05eFCusvRQtriYGFxraGVVhTdzYqiGYODtrGiaI0VRdtaUdWEBStK3+tB
Qv37HCTUY8tE3+PJQH2nCI6etzu6nwwsMKo8GVigqzsZWCBte+iuQ7FH4JDsqZJVJwO3ZlFu
jt/97m38lbmwxX4ZvHdIyIm3XLqhmJJfYOBUkFRcSoLB2YcbGbOxYHJgM6NpC+VJxIdTHM5h
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
zKMxj/68PPo/rqmogx29AQA=

--7JfCtLOvnd9MIVvH--
