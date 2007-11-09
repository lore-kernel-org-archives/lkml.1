Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXKISXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXKISXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXKISXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:23:47 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47986 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbXKISXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:23:46 -0500
Date: Fri, 9 Nov 2007 13:23:09 -0500
Message-Id: <200711091823.lA9IN9Bp000989@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: OOPSes + WARNING: at fs/file_table.c:262 __fput() in -mm 2007-11-06-02-32++
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Setup: FC6 system with MM snapshot broken-out-2007-11-06-02-32 and these two
patches added:

r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch

All I do is  boot the system with said kernel, wait a few seconds, then shut
it down with "init 0".  As services shutdown, I get this:

Stopping RPC idmapd:

kernel: __fput() of writeable file with no mnt_want_write()
kernel: WARNING: at fs/file_table.c:262 __fput()
kernel:  [<c010283e>] show_trace_log_lvl+0x12/0x25
kernel:  [<c0103042>] show_trace+0xd/0x10
kernel:  [<c010313e>] dump_stack+0x15/0x17
kernel:  [<c01491a4>] __fput+0x153/0x203
kernel:  [<c014952d>] fput+0x2d/0x32
kernel:  [<c0146c8a>] filp_close+0x50/0x5a
kernel:  [<c01104fc>] put_files_struct+0x7c/0xbe
kernel:  [<c0110575>] __exit_files+0x37/0x3c
kernel:  [<c01115de>] do_exit+0x1ed/0x653
kernel:  [<c0111ab2>] sys_exit_group+0x0/0x11
kernel:  [<c01183fc>] get_signal_to_deliver+0x3c4/0x3e8
kernel:  [<c0101873>] do_notify_resume+0x8c/0x6c4
kernel:  [<c0102339>] work_notifysig+0x13/0x1a
kernel:  =======================

Stopping NFS statd: BUG: unable to handle kernel paging request at virtual
address 6b6b6b6b.

EIP is at kobject_uevent_env+0x3c/0x399 which was called from
kobject_uevent, called from remove_user_sysfs_dir, run_workqueue,
worker_thread, kthread, kernel_thread_helper.

After that there are several other oopses (eg. during unmount of pipefs),
but I don't know how much to believe them given the first 1-2.  Sorry I
don't have a cut-n-paste of the precise stack trace, but if anyone's
interested, I have a short video file of the shutdown sequence w/ all of the
oopses.

Erez.
