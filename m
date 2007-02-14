Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbXBNKdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbXBNKdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXBNKdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:33:40 -0500
Received: from info6.gawab.com ([204.97.230.44]:42238 "HELO info6.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751546AbXBNKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:33:39 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 05:33:39 EST
Message-ID: <20070214102432.6346.qmail@info6.gawab.com>
From: "Ramy M. Hassan " <ramy@gawab.com>
To: linux-kernel@vger.kernel.org
Cc: "Ahmed El Zein" <a.elzein@gawab.net>
Subject: xfs internal error on a new filesystem
Date: Wed, 14 Feb 2007 10:24:27 GMT
Content-Type: text/plain ; charset="windows-1256"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.135.122.240]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
We got the following xfs internal error on one of our production servers:

Feb 14 08:28:52 info6 kernel: [238186.676483] Filesystem "sdd8": XFS
internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c. 
Caller 0xf8b906e7
Feb 14 08:28:52 info6 kernel: [238186.869089]  [pg0+947617605/1069749248]
xfs_trans_cancel+0x115/0x140 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.879131]  [pg0+947664615/1069749248]
xfs_mkdir+0x2ad/0x777 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882517]  [pg0+947664615/1069749248]
xfs_mkdir+0x2ad/0x777 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882558]  [pg0+947708079/1069749248]
xfs_vn_mknod+0x46f/0x493 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882625]  [pg0+947621368/1069749248]
xfs_trans_unlocked_item+0x32/0x50 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882654]  [pg0+947428195/1069749248]
xfs_da_buf_done+0x73/0xca [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882712]  [pg0+947623330/1069749248]
xfs_trans_brelse+0xd2/0xe5 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882739]  [pg0+947686680/1069749248]
xfs_buf_rele+0x21/0x77 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882768]  [pg0+947428868/1069749248]
xfs_da_state_free+0x64/0x6b [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882827]  [pg0+947468486/1069749248]
xfs_dir2_node_lookup+0x85/0xbb [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882857]  [pg0+947445628/1069749248]
xfs_dir_lookup+0x13a/0x13e [xfs]
Feb 14 08:28:52 info6 kernel: [238186.882912]  [vfs_permission+32/36]
vfs_permission+0x20/0x24
Feb 14 08:28:52 info6 kernel: [238186.883395]  [__link_path_walk+119/3686]
__link_path_walk+0x77/0xe66
Feb 14 08:28:52 info6 kernel: [238186.883413]  [pg0+947627458/1069749248]
xfs_dir_lookup_int+0x3c/0x121 [xfs]
Feb 14 08:28:52 info6 kernel: [238186.883453]  [pg0+947708157/1069749248]
xfs_vn_mkdir+0x2a/0x2e [xfs]
Feb 14 08:28:52 info6 kernel: [238186.883481]  [vfs_mkdir+221/299]
vfs_mkdir+0xdd/0x12b
Feb 14 08:28:52 info6 kernel: [238186.883493]  [sys_mkdirat+156/222]
sys_mkdirat+0x9c/0xde
Feb 14 08:28:52 info6 kernel: [238186.883510]  [sys_mkdir+31/35]
sys_mkdir+0x1f/0x23
Feb 14 08:28:52 info6 kernel: [238186.883519]  [sysenter_past_esp+86/121]
sysenter_past_esp+0x56/0x79
Feb 14 08:28:52 info6 kernel: [238186.883804] xfs_force_shutdown(sdd8,0x8)
called from line 1139 of file fs/xfs/xfs_trans.c.  Return address =
0xf8b84f6b
Feb 14 08:28:52 info6 kernel: [238186.945610] Filesystem "sdd8": Corruption
of in-memory data detected.  Shutting down filesystem: sdd8
Feb 14 08:28:52 info6 kernel: [238186.952732] Please umount the filesystem,
and rectify the problem(s)

We were able to unmount/remount the volume (didn't do xfs_repair because we
thought it might take long time, and the server was already in production
at the moement)
The file system was created less than 48hours ago, and 370G of sensitve
production data was moved to the server before it xfs crash.
In fact, we have been using reiserfs for a long period of time, and we have
suffered from several filesystem corruption incidents, so we decided to
switch to xfs hoping that it is more stable and corrupts less than
reiserfs, but it was disappointing to get this problem after just 48 hours
from reformating a production server using xfs.

System details :
Kernel: 2.6.18
Controller: 3ware 9550SX-8LP (RAID 10)

We are wondering here if this problem is an indicator to data corruption on
disk ? is it really necessary to run xfs_repair ?  Do u recommend that we
switch back to reiserfs ? Could it be a hardware related problems  ? any
clues how to verify that ?

Thanks

--Ramy

---------------------------------------------
Free POP3 Email from www.Gawab.com 
Sign up NOW and get your account @gawab.com!!
