Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZBYTRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZBYTRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZBYTRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:17:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44730 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZBYTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:17:39 -0500
Date: Wed, 25 Feb 2009 20:20:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Subject: 2.6.29-rc3: rfcomm0 still triggers WARNING: at sysfs_add_one
Message-ID: <20090225192011.GA2645@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not sure how repeatable this is ...

								Pavel

Linux version 2.6.29-rc3 (pavel@Elf) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-24)) #505 SMP Sun Feb 8 00:20:09 CET 2009
KERNEL supported cpus:
.../data/l/linux/drivers/usb/core/inode.c: creating file '023'
scsi 17:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
sd 17:0:0:0: [sdc] Attached SCSI removable disk
sd 17:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete
------------[ cut here ]------------
WARNING: at /data/l/linux/fs/sysfs/dir.c:462 sysfs_add_one+0x49/0x50()
Hardware name: 17097HU
sysfs: duplicate filename 'rfcomm0' can not be created
Modules linked in:
Pid: 18941, comm: rfcomm Not tainted 2.6.29-rc3 #505
Call Trace:
 [<c022dec6>] warn_slowpath+0x86/0xa0
 [<c024ef52>] ? __lock_acquire+0x232/0xac0
 [<c02cc021>] ? sysfs_find_dirent+0x21/0x30
 [<c02cc04d>] ? __sysfs_add_one+0x1d/0x90
 [<c02cc170>] ? sysfs_addrm_start+0x60/0xb0
 [<c02cc109>] sysfs_add_one+0x49/0x50
 [<c02cc649>] create_dir+0x49/0x90
 [<c02cc6bb>] sysfs_create_dir+0x2b/0x50
 [<c077c2cd>] ? _spin_unlock+0x1d/0x20
 [<c035f120>] kobject_add_internal+0xc0/0x1a0
 [<c035f2ec>] kobject_add_varg+0x4c/0x50
 [<c035f58f>] kobject_add+0x2f/0x60
 [<c0421183>] device_add+0xa3/0x480
 [<c0368a72>] ? __spin_lock_init+0x32/0x60
 [<c0421572>] device_register+0x12/0x20
 [<c042160c>] device_create_vargs+0x8c/0xc0
 [<c042166b>] device_create+0x2b/0x30
 [<c03c9519>] tty_register_device+0x69/0xe0
 [<c07103e8>] ? rfcomm_dev_ioctl+0x5f8/0x760
 [<c07103fa>] rfcomm_dev_ioctl+0x60a/0x760
 [<c070e4cd>] ? rfcomm_sock_ioctl+0x3d/0x60
 [<c070e4d9>] rfcomm_sock_ioctl+0x49/0x60
 [<c0675941>] sock_ioctl+0xd1/0x220
 [<c0675870>] ? sock_ioctl+0x0/0x220
 [<c0295aa8>] vfs_ioctl+0x28/0x80
 [<c0295de2>] do_vfs_ioctl+0x1e2/0x540
 [<c021b4cf>] ? do_page_fault+0x34f/0x610
 [<c0244f06>] ? up_read+0x16/0x30
 [<c021b4cf>] ? do_page_fault+0x34f/0x610
 [<c0675636>] ? sys_socketcall+0x66/0x270
 [<c0296179>] sys_ioctl+0x39/0x60
 [<c02032be>] syscall_call+0x7/0xb
---[ end trace 55cba734514c5169 ]---
kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 18941, comm: rfcomm Tainted: G        W  2.6.29-rc3 #505
Call Trace:
 [<c035f1aa>] kobject_add_internal+0x14a/0x1a0
 [<c035f2ec>] kobject_add_varg+0x4c/0x50
 [<c035f58f>] kobject_add+0x2f/0x60
 [<c0421183>] device_add+0xa3/0x480
 [<c0368a72>] ? __spin_lock_init+0x32/0x60
 [<c0421572>] device_register+0x12/0x20
 [<c042160c>] device_create_vargs+0x8c/0xc0
 [<c042166b>] device_create+0x2b/0x30
 [<c03c9519>] tty_register_device+0x69/0xe0
 [<c07103e8>] ? rfcomm_dev_ioctl+0x5f8/0x760
 [<c07103fa>] rfcomm_dev_ioctl+0x60a/0x760
 [<c070e4cd>] ? rfcomm_sock_ioctl+0x3d/0x60
 [<c070e4d9>] rfcomm_sock_ioctl+0x49/0x60
 [<c0675941>] sock_ioctl+0xd1/0x220
 [<c0675870>] ? sock_ioctl+0x0/0x220
 [<c0295aa8>] vfs_ioctl+0x28/0x80
 [<c0295de2>] do_vfs_ioctl+0x1e2/0x540
 [<c021b4cf>] ? do_page_fault+0x34f/0x610
 [<c0244f06>] ? up_read+0x16/0x30
 [<c021b4cf>] ? do_page_fault+0x34f/0x610
 [<c0675636>] ? sys_socketcall+0x66/0x270
 [<c0296179>] sys_ioctl+0x39/0x60
 [<c02032be>] syscall_call+0x7/0xb


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
