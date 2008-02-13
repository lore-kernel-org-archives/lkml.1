Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYBMNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYBMNyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYBMNyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:54:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:20595 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbYBMNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c9AY3ROIwOvH5mk+mpZkeA0YyXRKXmTInTKx55z6alMzX5YKkPM79fuzsSYxYtVSqr6LMlTeh5EeKRQLrDQ3odHcN2MGkGuzcQzav7KbQQUvaeJDGrpeythBc7DBvbcosXE7gpa+RkW0It0JE3CdLV/ouwBR1FiA1W6ewmOTb0Q=
Message-ID: <c4e36d110802130554m72a2d80dpe9786851fe294e88@mail.gmail.com>
Date: Wed, 13 Feb 2008 14:54:12 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: losetup INFO: possible circular locking dependency detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting this INFO message from losetup I'm using in my scripts:
if more info is needed from my side just ask.

(haven't seen this with 2.6.24..., using T61, 64bit kernel)

Bye

Zdenek

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.25-rc1 #29
 -------------------------------------------------------
 losetup/26595 is trying to acquire lock:
  (&bdev->bd_mutex){--..}, at: [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0

 but task is already holding lock:
  (&lo->lo_ctl_mutex){--..}, at: [<ffffffff883d097e>] lo_ioctl+0x4e/0xaf0 [loop]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&lo->lo_ctl_mutex){--..}:
        [<ffffffff81066f80>] __lock_acquire+0xf70/0x1000
        [<ffffffff883cf384>] lo_open+0x34/0x50 [loop]
        [<ffffffff810670b8>] lock_acquire+0xa8/0xf0
        [<ffffffff883cf384>] lo_open+0x34/0x50 [loop]
        [<ffffffff812f17ac>] mutex_lock_nested+0xcc/0x370
        [<ffffffff883cf384>] lo_open+0x34/0x50 [loop]
        [<ffffffff883cf384>] lo_open+0x34/0x50 [loop]
        [<ffffffff810e67c9>] do_open+0xa9/0x350
        [<ffffffff812f3b80>] _spin_unlock+0x30/0x60
        [<ffffffff810e6aad>] blkdev_open+0x3d/0x90
        [<ffffffff810b61b0>] __dentry_open+0x110/0x280
        [<ffffffff810e6a70>] blkdev_open+0x0/0x90
        [<ffffffff810b63e4>] nameidata_to_filp+0x44/0x60
        [<ffffffff810b644a>] do_filp_open+0x4a/0x50
        [<ffffffff810b603d>] get_unused_fd_flags+0xed/0x140
        [<ffffffff810b64c6>] do_sys_open+0x76/0x100
        [<ffffffff810b657b>] sys_open+0x1b/0x20
        [<ffffffff8100c8ae>] tracesys+0xdc/0xe1
        [<ffffffffffffffff>] 0xffffffffffffffff

 -> #0 (&bdev->bd_mutex){--..}:
        [<ffffffff81066e8d>] __lock_acquire+0xe7d/0x1000
        [<ffffffff810658d9>] trace_hardirqs_on+0x139/0x1a0
        [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0
        [<ffffffff810670b8>] lock_acquire+0xa8/0xf0
        [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0
        [<ffffffff812f17ac>] mutex_lock_nested+0xcc/0x370
        [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0
        [<ffffffff81014908>] native_sched_clock+0x98/0xa0
        [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0
        [<ffffffff810e640b>] blkdev_put+0xb/0x10
        [<ffffffff810e6438>] blkdev_close+0x28/0x40
        [<ffffffff810b9530>] __fput+0xd0/0x1b0
        [<ffffffff810b962d>] fput+0x1d/0x30
        [<ffffffff883d091d>] loop_clr_fd+0x1ad/0x1c0 [loop]
        [<ffffffff883d0a9f>] lo_ioctl+0x16f/0xaf0 [loop]
        [<ffffffff810cccdf>] __d_lookup+0xef/0x180
        [<ffffffff81014908>] native_sched_clock+0x98/0xa0
        [<ffffffff81014908>] native_sched_clock+0x98/0xa0
        [<ffffffff8106634d>] __lock_acquire+0x33d/0x1000
        [<ffffffff8106634d>] __lock_acquire+0x33d/0x1000
        [<ffffffff810639a6>] get_lock_stats+0x16/0x60
        [<ffffffff81014908>] native_sched_clock+0x98/0xa0
        [<ffffffff810639a6>] get_lock_stats+0x16/0x60
        [<ffffffff810639fe>] put_lock_stats+0xe/0x30
        [<ffffffff812f2049>] mutex_unlock+0x9/0x10
        [<ffffffff8116731d>] blkdev_driver_ioctl+0x8d/0xa0
        [<ffffffff811675ad>] blkdev_ioctl+0x27d/0x7e0
        [<ffffffff81014908>] native_sched_clock+0x98/0xa0
        [<ffffffff8106634d>] __lock_acquire+0x33d/0x1000
        [<ffffffff81014908>] native_sched_clock+0x98/0xa0
        [<ffffffff810639a6>] get_lock_stats+0x16/0x60
        [<ffffffff810e5a7b>] block_ioctl+0x1b/0x20
        [<ffffffff810c67b1>] vfs_ioctl+0x31/0xa0
        [<ffffffff810c6aa3>] do_vfs_ioctl+0x283/0x2f0
        [<ffffffff810c6ba9>] sys_ioctl+0x99/0xa0
        [<ffffffff8100c8ae>] tracesys+0xdc/0xe1
        [<ffffffffffffffff>] 0xffffffffffffffff

 other info that might help us debug this:

 1 lock held by losetup/26595:
  #0:  (&lo->lo_ctl_mutex){--..}, at: [<ffffffff883d097e>]
lo_ioctl+0x4e/0xaf0 [loop]

 stack backtrace:
 Pid: 26595, comm: losetup Not tainted 2.6.25-rc1 #29

 Call Trace:
  [<ffffffff81065d54>] print_circular_bug_tail+0x84/0x90
  [<ffffffff81066e8d>] __lock_acquire+0xe7d/0x1000
  [<ffffffff810658d9>] ? trace_hardirqs_on+0x139/0x1a0
  [<ffffffff810e6258>] ? __blkdev_put+0x38/0x1e0
  [<ffffffff810670b8>] lock_acquire+0xa8/0xf0
  [<ffffffff810e6258>] ? __blkdev_put+0x38/0x1e0
  [<ffffffff812f17ac>] mutex_lock_nested+0xcc/0x370
  [<ffffffff810e6258>] ? __blkdev_put+0x38/0x1e0
  [<ffffffff81014908>] ? native_sched_clock+0x98/0xa0
  [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0
  [<ffffffff810e640b>] blkdev_put+0xb/0x10
  [<ffffffff810e6438>] blkdev_close+0x28/0x40
  [<ffffffff810b9530>] __fput+0xd0/0x1b0
  [<ffffffff810b962d>] fput+0x1d/0x30
  [<ffffffff883d091d>] :loop:loop_clr_fd+0x1ad/0x1c0
  [<ffffffff883d0a9f>] :loop:lo_ioctl+0x16f/0xaf0
  [<ffffffff810cccdf>] ? __d_lookup+0xef/0x180
  [<ffffffff81014908>] ? native_sched_clock+0x98/0xa0
  [<ffffffff81014908>] ? native_sched_clock+0x98/0xa0
  [<ffffffff8106634d>] ? __lock_acquire+0x33d/0x1000
  [<ffffffff8106634d>] ? __lock_acquire+0x33d/0x1000
  [<ffffffff810639a6>] ? get_lock_stats+0x16/0x60
  [<ffffffff81014908>] ? native_sched_clock+0x98/0xa0
  [<ffffffff810639a6>] ? get_lock_stats+0x16/0x60
  [<ffffffff810639fe>] ? put_lock_stats+0xe/0x30
  [<ffffffff812f2049>] ? mutex_unlock+0x9/0x10
  [<ffffffff8116731d>] blkdev_driver_ioctl+0x8d/0xa0
  [<ffffffff811675ad>] blkdev_ioctl+0x27d/0x7e0
  [<ffffffff81014908>] ? native_sched_clock+0x98/0xa0
  [<ffffffff8106634d>] ? __lock_acquire+0x33d/0x1000
  [<ffffffff81014908>] ? native_sched_clock+0x98/0xa0
  [<ffffffff810639a6>] ? get_lock_stats+0x16/0x60
  [<ffffffff810e5a7b>] block_ioctl+0x1b/0x20
  [<ffffffff810c67b1>] vfs_ioctl+0x31/0xa0
  [<ffffffff810c6aa3>] do_vfs_ioctl+0x283/0x2f0
  [<ffffffff810c6ba9>] sys_ioctl+0x99/0xa0
  [<ffffffff8100c8ae>] tracesys+0xdc/0xe1
