Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZHGIzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZHGIzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbZHGIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:54:59 -0400
Received: from mail.aixigo.de ([195.14.232.227]:26765 "EHLO gate1.ac.aixigo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757243AbZHGIy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:54:57 -0400
X-Greylist: delayed 946 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 04:54:56 EDT
Message-ID: <4A7BE82E.7030603@aixigo.de>
Date: Fri, 07 Aug 2009 10:39:10 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090618)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.26-2-amd64 (debian): XFS internal error XFS_WANT_CORRUPTED_GOTO
 at line 4521 of file fs/xfs/xfs_bmap.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Hopefully it is allowed to post a question about a file system
problem here, even though I am not running a vanilla kernel.

I am running a filer with >6TByte storage in a single xfs file
system. Its based upon Lenny 5.0, including kernel 2.6.26-2
(amd64) provided by the Debian folks.

Last night the machine became terrible slow. At that time I ran
a regular rsync to mirror the files to another host. Since then
I get the error messages shown below. fsck reports no problems,
but the machine stays slow. A reboot did not help, either.

Questions:

How serious is this? Can I rely upon fsck telling me that there
is no problem?

I've got a replacement machine waiting (Lenny 5.0.2 plus vanilla
2.6.29.6). This is the mirror host mentioned above. Should I avoid
xfs and go with ext3 or jfs?


Any helpful comment would be highly appreciated. Of course I
would be glad to help to track this down.


Regards

Harri
=================================================================

[38052.643947] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4521 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffffa02317d7
[38052.673956] Pid: 5365, comm: nfsd Tainted: G        W 2.6.26-2-amd64 #1
[38052.703013]
[38052.703013] Call Trace:
[38052.766400]  [<ffffffffa02317d7>] :xfs:xfs_iread_extents+0xac/0xc8
[38052.800561]  [<ffffffffa0212acc>] :xfs:xfs_bmap_read_extents+0x360/0x383
[38052.829834]  [<ffffffffa02317d7>] :xfs:xfs_iread_extents+0xac/0xc8
[38052.863061]  [<ffffffffa0218382>] :xfs:xfs_bmapi+0x22f/0xf73
[38052.863061]  [<ffffffff804292dc>] __down_write_nested+0x12/0xa1
[38052.863061]  [<ffffffffa0235822>] :xfs:xfs_iomap+0x149/0x297
[38052.863061]  [<ffffffff8030b656>] elv_rb_add+0x56/0x5a
[38052.863061]  [<ffffffff8027caba>] zone_statistics+0x3a/0x8e
[38052.863061]  [<ffffffffa024bc10>] :xfs:__xfs_get_blocks+0x5f/0x198
[38052.863061]  [<ffffffff80270ec6>] find_get_page+0x21/0x54
[38052.863061]  [<ffffffffa022fcca>] :xfs:xfs_iext_bno_to_ext+0xc0/0x140
[38052.863061]  [<ffffffff802bb25e>] __block_prepare_write+0x19d/0x364
[38052.863061]  [<ffffffffa024bd5a>] :xfs:xfs_get_blocks+0x0/0xe
[38052.863061]  [<ffffffff802711a6>] find_lock_page+0x1f/0x8a
[38052.863061]  [<ffffffff802bb4c2>] block_write_begin+0x78/0xcc
[38052.863061]  [<ffffffffa024b7a1>] :xfs:xfs_vm_write_begin+0x22/0x27
[38052.863061]  [<ffffffffa024bd5a>] :xfs:xfs_get_blocks+0x0/0xe
[38052.863061]  [<ffffffff80271e0a>] generic_file_buffered_write+0x14c/0x630
[38052.863061]  [<ffffffffa02437c0>] :xfs:xfs_trans_log_buf+0x55/0x7e
[38052.863061]  [<ffffffff80238bc1>] current_fs_time+0x1e/0x24
[38052.863061]  [<ffffffffa02526fb>] :xfs:xfs_write+0x50d/0x722
[38052.863061]  [<ffffffff803bce15>] dev_queue_xmit+0x273/0x2b2
[38052.863061]  [<ffffffff802ac7e7>] ifind_fast+0x38/0x75
[38052.863061]  [<ffffffffa024f1bb>] :xfs:xfs_file_aio_write+0x0/0x4f
[38052.863061]  [<ffffffff8029aaf7>] do_sync_readv_writev+0xc0/0x107
[38052.863061]  [<ffffffff8031da6b>] __up_read+0x13/0x8a
[38052.863061]  [<ffffffffa030b459>] :exportfs:find_acceptable_alias+0x1a/0xcd
[38052.863061]  [<ffffffff802461b1>] autoremove_wake_function+0x0/0x2e
[38052.863061]  [<ffffffffa030b5b5>] :exportfs:exportfs_decode_fh+0xa9/0x1dc
[38052.863061]  [<ffffffffa031f22b>] :nfsd:nfsd_acceptable+0x0/0xc9
[38052.863061]  [<ffffffff8029a98d>] rw_copy_check_uvector+0x6c/0xdc
[38052.863061]  [<ffffffff8029b1aa>] do_readv_writev+0xb2/0x18b
[38052.863061]  [<ffffffffa0325185>] :nfsd:nfsd_setuser+0x11e/0x1e9
[38052.863061]  [<ffffffffa031e8f4>] :nfsd:nfsd_setuser_and_check_port+0x52/0x57
[38052.863061]  [<ffffffffa031fd7d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
[38052.863061]  [<ffffffff80299785>] __dentry_open+0x154/0x238
[38052.863061]  [<ffffffffa0320400>] :nfsd:nfsd_open+0x13c/0x170
[38052.863061]  [<ffffffffa0320638>] :nfsd:nfsd_write+0xc5/0xe2
[38052.863061]  [<ffffffffa03275d8>] :nfsd:nfsd3_proc_write+0xe6/0x105
[38052.863061]  [<ffffffffa031c248>] :nfsd:nfsd_dispatch+0xde/0x1b6
[38052.863061]  [<ffffffffa029155b>] :sunrpc:svc_process+0x408/0x6e9
[38052.863061]  [<ffffffff80429384>] __down_read+0x12/0xa1
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c805>] :nfsd:nfsd+0x194/0x2a3
[38052.863061]  [<ffffffff802301ec>] schedule_tail+0x27/0x5c
[38052.863061]  [<ffffffff8020cf28>] child_rip+0xa/0x12
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffff8020cf1e>] child_rip+0x0/0x12
[38052.863061]
[38052.863061] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4521 of file fs/xfs/xfs_bmap.c.  Caller 0xffffffffa02317d7
[38052.863061] Pid: 5365, comm: nfsd Tainted: G        W 2.6.26-2-amd64 #1
[38052.863061]
[38052.863061] Call Trace:
[38052.863061]  [<ffffffffa02317d7>] :xfs:xfs_iread_extents+0xac/0xc8
[38052.863061]  [<ffffffffa0212acc>] :xfs:xfs_bmap_read_extents+0x360/0x383
[38052.863061]  [<ffffffffa02317d7>] :xfs:xfs_iread_extents+0xac/0xc8
[38052.863061]  [<ffffffffa0218382>] :xfs:xfs_bmapi+0x22f/0xf73
[38052.863061]  [<ffffffff802125e7>] read_tsc+0x9/0x20
[38052.863061]  [<ffffffff8024ac46>] getnstimeofday+0x39/0x98
[38052.863061]  [<ffffffff80248d4a>] ktime_get_ts+0x22/0x4b
[38052.863061]  [<ffffffff804292dc>] __down_write_nested+0x12/0xa1
[38052.863061]  [<ffffffffa0235822>] :xfs:xfs_iomap+0x149/0x297
[38052.863061]  [<ffffffffa024bc10>] :xfs:__xfs_get_blocks+0x5f/0x198
[38052.863061]  [<ffffffff80279610>] pagevec_lookup+0x17/0x1e
[38052.863061]  [<ffffffff802711a6>] find_lock_page+0x1f/0x8a
[38052.863061]  [<ffffffff802bafa1>] block_truncate_page+0x105/0x225
[38052.863061]  [<ffffffffa024bd5a>] :xfs:xfs_get_blocks+0x0/0xe
[38052.863061]  [<ffffffffa0250fa7>] :xfs:xfs_vn_truncate+0x1b/0x34
[38052.863061]  [<ffffffff802824e2>] vmtruncate+0xc5/0xe7
[38052.863061]  [<ffffffff802bb506>] block_write_begin+0xbc/0xcc
[38052.863061]  [<ffffffffa024b7a1>] :xfs:xfs_vm_write_begin+0x22/0x27
[38052.863061]  [<ffffffffa024bd5a>] :xfs:xfs_get_blocks+0x0/0xe
[38052.863061]  [<ffffffff80271e0a>] generic_file_buffered_write+0x14c/0x630
[38052.863061]  [<ffffffffa02437c0>] :xfs:xfs_trans_log_buf+0x55/0x7e
[38052.863061]  [<ffffffff80238bc1>] current_fs_time+0x1e/0x24
[38052.863061]  [<ffffffffa02526fb>] :xfs:xfs_write+0x50d/0x722
[38052.863061]  [<ffffffff803bce15>] dev_queue_xmit+0x273/0x2b2
[38052.863061]  [<ffffffff802ac7e7>] ifind_fast+0x38/0x75
[38052.863061]  [<ffffffffa024f1bb>] :xfs:xfs_file_aio_write+0x0/0x4f
[38052.863061]  [<ffffffff8029aaf7>] do_sync_readv_writev+0xc0/0x107
[38052.863061]  [<ffffffff8031da6b>] __up_read+0x13/0x8a
[38052.863061]  [<ffffffffa030b459>] :exportfs:find_acceptable_alias+0x1a/0xcd
[38052.863061]  [<ffffffff802461b1>] autoremove_wake_function+0x0/0x2e
[38052.863061]  [<ffffffffa030b5b5>] :exportfs:exportfs_decode_fh+0xa9/0x1dc
[38052.863061]  [<ffffffffa031f22b>] :nfsd:nfsd_acceptable+0x0/0xc9
[38052.863061]  [<ffffffff8029a98d>] rw_copy_check_uvector+0x6c/0xdc
[38052.863061]  [<ffffffff8029b1aa>] do_readv_writev+0xb2/0x18b
[38052.863061]  [<ffffffffa0325185>] :nfsd:nfsd_setuser+0x11e/0x1e9
[38052.863061]  [<ffffffffa031e8f4>] :nfsd:nfsd_setuser_and_check_port+0x52/0x57
[38052.863061]  [<ffffffffa031fd7d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
[38052.863061]  [<ffffffff80299785>] __dentry_open+0x154/0x238
[38052.863061]  [<ffffffffa0320400>] :nfsd:nfsd_open+0x13c/0x170
[38052.863061]  [<ffffffffa0320638>] :nfsd:nfsd_write+0xc5/0xe2
[38052.863061]  [<ffffffffa03275d8>] :nfsd:nfsd3_proc_write+0xe6/0x105
[38052.863061]  [<ffffffffa031c248>] :nfsd:nfsd_dispatch+0xde/0x1b6
[38052.863061]  [<ffffffffa029155b>] :sunrpc:svc_process+0x408/0x6e9
[38052.863061]  [<ffffffff80429384>] __down_read+0x12/0xa1
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c805>] :nfsd:nfsd+0x194/0x2a3
[38052.863061]  [<ffffffff802301ec>] schedule_tail+0x27/0x5c
[38052.863061]  [<ffffffff8020cf28>] child_rip+0xa/0x12
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffff8020cf1e>] child_rip+0x0/0x12
[38052.863061]
[38052.863061] ------------[ cut here ]------------
[38052.863061] WARNING: at fs/xfs/linux-2.6/xfs_iops.c:728 vmtruncate+0xc5/0xe7()
[38052.863061] Modules linked in: ipv6 battery nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc bonding xfs loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr iTCO_wdt psmouse serio_raw i2c_i801 i2c_core shpchp container pci_hotplug button joydev evdev reiserfs sg sr_mod cdrom ide_pci_generic ide_core ata_piix sd_mod usbhid hid ff_memless usb_storage ata_generic libata dock e1000e ehci_hcd 3w_9xxx uhci_hcd scsi_mod thermal processor fan thermal_sys
[38052.863061] Pid: 5365, comm: nfsd Tainted: G        W 2.6.26-2-amd64 #1
[38052.863061]
[38052.863061] Call Trace:
[38052.863061]  [<ffffffff80234a00>] warn_on_slowpath+0x51/0x7a
[38052.863061]  [<ffffffff80279610>] pagevec_lookup+0x17/0x1e
[38052.863061]  [<ffffffff802711a6>] find_lock_page+0x1f/0x8a
[38052.863061]  [<ffffffff802bb0b0>] block_truncate_page+0x214/0x225
[38052.863061]  [<ffffffffa024bd5a>] :xfs:xfs_get_blocks+0x0/0xe
[38052.863061]  [<ffffffff802824e2>] vmtruncate+0xc5/0xe7
[38052.863061]  [<ffffffff802bb506>] block_write_begin+0xbc/0xcc
[38052.863061]  [<ffffffffa024b7a1>] :xfs:xfs_vm_write_begin+0x22/0x27
[38052.863061]  [<ffffffffa024bd5a>] :xfs:xfs_get_blocks+0x0/0xe
[38052.863061]  [<ffffffff80271e0a>] generic_file_buffered_write+0x14c/0x630
[38052.863061]  [<ffffffffa02437c0>] :xfs:xfs_trans_log_buf+0x55/0x7e
[38052.863061]  [<ffffffff80238bc1>] current_fs_time+0x1e/0x24
[38052.863061]  [<ffffffffa02526fb>] :xfs:xfs_write+0x50d/0x722
[38052.863061]  [<ffffffff803bce15>] dev_queue_xmit+0x273/0x2b2
[38052.863061]  [<ffffffff802ac7e7>] ifind_fast+0x38/0x75
[38052.863061]  [<ffffffffa024f1bb>] :xfs:xfs_file_aio_write+0x0/0x4f
[38052.863061]  [<ffffffff8029aaf7>] do_sync_readv_writev+0xc0/0x107
[38052.863061]  [<ffffffff8031da6b>] __up_read+0x13/0x8a
[38052.863061]  [<ffffffffa030b459>] :exportfs:find_acceptable_alias+0x1a/0xcd
[38052.863061]  [<ffffffff802461b1>] autoremove_wake_function+0x0/0x2e
[38052.863061]  [<ffffffffa030b5b5>] :exportfs:exportfs_decode_fh+0xa9/0x1dc
[38052.863061]  [<ffffffffa031f22b>] :nfsd:nfsd_acceptable+0x0/0xc9
[38052.863061]  [<ffffffff8029a98d>] rw_copy_check_uvector+0x6c/0xdc
[38052.863061]  [<ffffffff8029b1aa>] do_readv_writev+0xb2/0x18b
[38052.863061]  [<ffffffffa0325185>] :nfsd:nfsd_setuser+0x11e/0x1e9
[38052.863061]  [<ffffffffa031e8f4>] :nfsd:nfsd_setuser_and_check_port+0x52/0x57
[38052.863061]  [<ffffffffa031fd7d>] :nfsd:nfsd_vfs_write+0xe9/0x2dd
[38052.863061]  [<ffffffff80299785>] __dentry_open+0x154/0x238
[38052.863061]  [<ffffffffa0320400>] :nfsd:nfsd_open+0x13c/0x170
[38052.863061]  [<ffffffffa0320638>] :nfsd:nfsd_write+0xc5/0xe2
[38052.863061]  [<ffffffffa03275d8>] :nfsd:nfsd3_proc_write+0xe6/0x105
[38052.863061]  [<ffffffffa031c248>] :nfsd:nfsd_dispatch+0xde/0x1b6
[38052.863061]  [<ffffffffa029155b>] :sunrpc:svc_process+0x408/0x6e9
[38052.863061]  [<ffffffff80429384>] __down_read+0x12/0xa1
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c805>] :nfsd:nfsd+0x194/0x2a3
[38052.863061]  [<ffffffff802301ec>] schedule_tail+0x27/0x5c
[38052.863061]  [<ffffffff8020cf28>] child_rip+0xa/0x12
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffffa031c671>] :nfsd:nfsd+0x0/0x2a3
[38052.863061]  [<ffffffff8020cf1e>] child_rip+0x0/0x12
[38052.863061]
[38052.863061] ---[ end trace f0e5b71059fd82cf ]---
[38052.863061] nfsd: non-standard errno: -117

