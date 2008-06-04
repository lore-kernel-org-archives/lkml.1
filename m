Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbYFDPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbYFDPsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbYFDPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:48:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572AbYFDPsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:48:36 -0400
Date: Wed, 4 Jun 2008 11:41:37 -0400
From: Dave Jones <davej@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.25 md oops during boot.
Message-ID: <20080604154137.GA26157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Neil Brown <neilb@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,
 Here's an odd one.
https://bugzilla.redhat.com/show_bug.cgi?id=442204

Slightly old (.25-rc8-git7), but I don't recall anything changing between
then and .25 final that could explain this.

	Dave

BUG: unable to handle kernel NULL pointer dereference at 00000020
IP: [<c04bbb65>] sysfs_addrm_start+0x21/0x7d
Oops: 0000 [#1] SMP 
Modules linked in: e1000(+) i2c_piix4 i2c_core sg ac button sr_mod cdrom
ata_piix libata dm_snapshot dm_zero dm_mirror dm_mod mptspi mptscsih mptbase
scsi_transport_spi sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
[last unloaded: scsi_wait_scan]

Pid: 742, comm: mdadm Not tainted (2.6.25-0.218.rc8.git7.fc9.i686 #1)
EIP: 0060:[<c04bbb65>] EFLAGS: 00010246 CPU: 0
EIP is at sysfs_addrm_start+0x21/0x7d
EAX: c04bbc23 EBX: 00000000 ECX: 00000000 EDX: 00000062
ESI: f6ecdc84 EDI: f6ecdc94 EBP: f6ecdc78 ESP: f6ecdc6c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mdadm (pid: 742, ti=f6ecd000 task=f6e22e80 task.ti=f6ecd000)
Stack: f6ecdc84 f6e75bd0 fffffff4 f6ecdca0 c04bbfb7 00000000 00000000 00000000 
       00000000 00000000 f7853dc4 fffffffe f7af6824 f6ecdcb4 c04bc01c f6ecdcac 
       c04f08f2 f7853dc4 f6ecdcd0 c04f09ec f7af6824 f6ecdcd0 00000000 f7853dc4 
Call Trace:
 [<c04bbfb7>] ? create_dir+0x3a/0x72
 [<c04bc01c>] ? sysfs_create_dir+0x2d/0x41
 [<c04f08f2>] ? kobject_get+0x12/0x17
 [<c04f09ec>] ? kobject_add_internal+0xa4/0x145
 [<c04f0b21>] ? kobject_add_varg+0x35/0x41
 [<c04f0b92>] ? kobject_add+0x43/0x49
 [<c05948aa>] ? bind_rdev_to_array+0x124/0x1ab
 [<c04cf900>] ? task_has_capability+0x47/0x76
 [<c04f4f94>] ? copy_from_user+0x39/0x121
 [<c05994d1>] ? md_ioctl+0xf75/0x183b
 [<c04cfde2>] ? inode_has_perm+0x5b/0x65
 [<c0490ce5>] ? d_free+0x3b/0x4d
 [<c0492094>] ? dput+0x34/0xee
 [<c04efb51>] ? _atomic_dec_and_lock+0x29/0x44
 [<c04958b8>] ? mntput_no_expire+0x16/0x69
 [<c0488796>] ? path_put+0x20/0x23
 [<c048ab1b>] ? __link_path_walk+0xce7/0xcfc
 [<c04e831d>] ? blkdev_driver_ioctl+0x49/0x5b
 [<c04e8ab0>] ? blkdev_ioctl+0x781/0x79d
 [<c04d06a8>] ? selinux_file_free_security+0x14/0x16
 [<c04cfde2>] ? inode_has_perm+0x5b/0x65
 [<c04d01b9>] ? file_has_perm+0x7c/0x85
 [<c04a241b>] ? block_ioctl+0x16/0x1b
 [<c04a2405>] ? block_ioctl+0x0/0x1b
 [<c048c99e>] ? vfs_ioctl+0x22/0x69
 [<c048cc1e>] ? do_vfs_ioctl+0x239/0x24c
 [<c04d034f>] ? selinux_file_ioctl+0xa8/0xab
 [<c048cc71>] ? sys_ioctl+0x40/0x5b
 [<c0405cf6>] ? syscall_call+0x7/0xb
 =======================
Code: 89 31 8d 65 f4 5b 5e 5f 5d c3 55 b9 04 00 00 00 89 e5 57 89 c7 56 89 c6 53
31 c0 89 d3 f3 ab b8 34 fc 71 c0 89 16 e8 1f e2 16 00 <8b> 53 20 b9 f0 b7 4b c0
a1 88 f4 83 c0 53 e8 43 71 fd ff 5f 85 
EIP: [<c04bbb65>] sysfs_addrm_start+0x21/0x7d SS:ESP 0068:f6ecdc6c
---[ end trace ca143223eefdc828 ]---


-- 
http://www.codemonkey.org.uk
