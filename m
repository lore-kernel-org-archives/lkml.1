Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0BIHAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 02:00:18 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:35237 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0BIHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 02:00:16 -0500
Message-ID: <4B7107CF.3060703@oracle.com>
Date: Tue, 09 Feb 2010 14:59:27 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
       "tao.ma" <tao.ma@oracle.com>
Subject: lockdep warning for iscsi in 2.6.33-rc6
Content-Type: multipart/mixed;
 boundary="------------040408060007030805050301"
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B7107F4.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040408060007030805050301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mike,
	I meet with a lockdep warning for iscsi in 2.6.33-rc6.
the lockdep is attached.

Regards,
Tao

--------------040408060007030805050301
Content-Type: text/plain;
 name="iscsi_lockdep"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iscsi_lockdep"

Feb  9 11:39:29 ocfs2-test7 kernel: =======================================================
Feb  9 11:39:29 ocfs2-test7 kernel: [ INFO: possible circular locking dependency detected ]
Feb  9 11:39:29 ocfs2-test7 kernel: 2.6.33-rc6 #6
Feb  9 11:39:29 ocfs2-test7 kernel: -------------------------------------------------------
Feb  9 11:39:29 ocfs2-test7 kernel: iscsid/2960 is trying to acquire lock:
Feb  9 11:39:29 ocfs2-test7 kernel:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffffa006aec5>] scsi_scan_target+0x6d/0xad [scsi_mod]
Feb  9 11:39:29 ocfs2-test7 kernel: 
Feb  9 11:39:29 ocfs2-test7 kernel: but task is already holding lock:
Feb  9 11:39:30 ocfs2-test7 kernel:  (&ihost->mutex){+.+...}, at: [<ffffffffa02aeb34>] iscsi_user_scan_session+0x96/0x14b [scsi_transport_iscsi]
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: which lock already depends on the new lock.
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: the existing dependency chain (in reverse order) is:
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: -> #2 (&ihost->mutex){+.+...}:
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff820641ea>] validate_chain+0xa31/0xedb
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82064f9c>] __lock_acquire+0x908/0x95f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82065d62>] lock_acquire+0xbc/0x102
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8232d3c5>] mutex_lock_nested+0x48/0x29f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa02aeb34>] iscsi_user_scan_session+0x96/0x14b [scsi_transport_iscsi]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8221702f>] device_for_each_child+0x32/0x64
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa02aea83>] iscsi_user_scan+0x28/0x2a [scsi_transport_iscsi]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa006b979>] store_scan+0x9d/0xc9 [scsi_mod]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82216c88>] dev_attr_store+0x1b/0x1d
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8212b78b>] sysfs_write_file+0xf7/0x133
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff820d881e>] vfs_write+0xae/0x14a
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff820d8d2a>] sys_write+0x47/0x6f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: -> #1 (s_active){++++.+}:
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff820641ea>] validate_chain+0xa31/0xedb
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82064f9c>] __lock_acquire+0x908/0x95f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82065d62>] lock_acquire+0xbc/0x102
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8212c885>] sysfs_addrm_finish+0xba/0x125
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8212adbe>] sysfs_hash_and_remove+0x4f/0x6b
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8212ce6f>] sysfs_remove_link+0x1c/0x1e
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8221a10e>] driver_sysfs_remove+0x29/0x3c
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8221a3e5>] driver_probe_device+0xdc/0x139
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8221a627>] __device_attach+0x33/0x3c
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff822194a9>] bus_for_each_drv+0x4d/0x80
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8221a541>] device_attach+0x60/0x77
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82219445>] bus_probe_device+0x22/0x39
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82217edb>] device_add+0x44c/0x5d3
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa006c026>] scsi_sysfs_add_sdev+0xb8/0x1e2 [scsi_mod]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa006a0e4>] scsi_probe_and_add_lun+0xadd/0xbcf [scsi_mod]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa006adf7>] __scsi_add_device+0xb6/0xe5 [scsi_mod]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa00b16d6>] ata_scsi_scan_host+0x89/0x17a [libata]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa00afb25>] async_port_probe+0xa9/0xb4 [libata]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8205a5cc>] async_thread+0x115/0x206
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82054a5d>] kthread+0x7d/0x85
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82003794>] kernel_thread_helper+0x4/0x10
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: -> #0 (&shost->scan_mutex){+.+.+.}:
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82063ed6>] validate_chain+0x71d/0xedb
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82064f9c>] __lock_acquire+0x908/0x95f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82065d62>] lock_acquire+0xbc/0x102
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8232d3c5>] mutex_lock_nested+0x48/0x29f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa006aec5>] scsi_scan_target+0x6d/0xad [scsi_mod]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa02aeb9f>] iscsi_user_scan_session+0x101/0x14b [scsi_transport_iscsi]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8221702f>] device_for_each_child+0x32/0x64
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa02aea83>] iscsi_user_scan+0x28/0x2a [scsi_transport_iscsi]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffffa006b979>] store_scan+0x9d/0xc9 [scsi_mod]
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff82216c88>] dev_attr_store+0x1b/0x1d
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8212b78b>] sysfs_write_file+0xf7/0x133
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff820d881e>] vfs_write+0xae/0x14a
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff820d8d2a>] sys_write+0x47/0x6f
Feb  9 11:39:30 ocfs2-test7 kernel:        [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b
Feb  9 11:39:30 ocfs2-test7 kernel: 
Feb  9 11:39:30 ocfs2-test7 kernel: other info that might help us debug this:
Feb  9 11:39:31 ocfs2-test7 kernel: 
Feb  9 11:39:31 ocfs2-test7 kernel: 4 locks held by iscsid/2960:
Feb  9 11:39:31 ocfs2-test7 kernel:  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8212b6cd>] sysfs_write_file+0x39/0x133
Feb  9 11:39:31 ocfs2-test7 kernel:  #1:  (s_active){++++.+}, at: [<ffffffff8212cb61>] sysfs_get_active_two+0x1f/0x44
Feb  9 11:39:31 ocfs2-test7 kernel:  #2:  (s_active){++++.+}, at: [<ffffffff8212cb6e>] sysfs_get_active_two+0x2c/0x44
Feb  9 11:39:31 ocfs2-test7 kernel:  #3:  (&ihost->mutex){+.+...}, at: [<ffffffffa02aeb34>] iscsi_user_scan_session+0x96/0x14b [scsi_transport_iscsi]
Feb  9 11:39:31 ocfs2-test7 kernel: 
Feb  9 11:39:31 ocfs2-test7 kernel: stack backtrace:
Feb  9 11:39:31 ocfs2-test7 kernel: Pid: 2960, comm: iscsid Not tainted 2.6.33-rc6 #6
Feb  9 11:39:31 ocfs2-test7 kernel: Call Trace:
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff820630b2>] print_circular_bug+0xb3/0xc1
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff82063ed6>] validate_chain+0x71d/0xedb
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff820613d0>] ? add_lock_to_list+0x82/0xc2
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff82064f9c>] __lock_acquire+0x908/0x95f
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff82065d62>] lock_acquire+0xbc/0x102
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa006aec5>] ? scsi_scan_target+0x6d/0xad [scsi_mod]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff8232d3c5>] mutex_lock_nested+0x48/0x29f
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa006aec5>] ? scsi_scan_target+0x6d/0xad [scsi_mod]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff820622ef>] ? mark_held_locks+0x49/0x69
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff8232ef48>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa006aec5>] scsi_scan_target+0x6d/0xad [scsi_mod]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa02aeb9f>] iscsi_user_scan_session+0x101/0x14b [scsi_transport_iscsi]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa02aea9e>] ? iscsi_user_scan_session+0x0/0x14b [scsi_transport_iscsi]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff8221702f>] device_for_each_child+0x32/0x64
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa02aea83>] iscsi_user_scan+0x28/0x2a [scsi_transport_iscsi]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffffa006b979>] store_scan+0x9d/0xc9 [scsi_mod]
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff8212cb6e>] ? sysfs_get_active_two+0x2c/0x44
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff82216c88>] dev_attr_store+0x1b/0x1d
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff8212b78b>] sysfs_write_file+0xf7/0x133
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff820d881e>] vfs_write+0xae/0x14a
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff820d8d2a>] sys_write+0x47/0x6f
Feb  9 11:39:31 ocfs2-test7 kernel:  [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b

--------------040408060007030805050301--
