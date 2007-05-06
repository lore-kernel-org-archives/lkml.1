Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbXEFWov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbXEFWov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXEFWov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:44:51 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:53189 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXEFWou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:44:50 -0400
Message-ID: <463E5A5D.1070509@simon.arlott.org.uk>
Date: Sun, 06 May 2007 23:44:45 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: xfs_ilock: possible recursive locking detected
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[  119.948000] =============================================
[  119.948000] [ INFO: possible recursive locking detected ]
[  119.948000] 2.6.21-git #185
[  119.948000] ---------------------------------------------
[  119.948000] cc1/6496 is trying to acquire lock:
[  119.948000]  (&(&ip->i_lock)->mr_lock){----}, at: [<b025d230>] xfs_ilock+0x60/0xb0
[  119.948000]
[  119.948000] but task is already holding lock:
[  119.948000]  (&(&ip->i_lock)->mr_lock){----}, at: [<b025d230>] xfs_ilock+0x60/0xb0
[  119.948000]
[  119.948000] other info that might help us debug this:
[  119.948000] 2 locks held by cc1/6496:
[  119.948000]  #0:  (&inode->i_mutex){--..}, at: [<b051585c>] mutex_lock+0x1c/0x20
[  119.948000]  #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<b025d230>] xfs_ilock+0x60/0xb0
[  119.948000]
[  119.948000] stack backtrace:
[  119.948000]  [<b0104f4a>] show_trace_log_lvl+0x1a/0x30
[  119.948000]  [<b0104f72>] show_trace+0x12/0x20
[  119.948000]  [<b0105086>] dump_stack+0x16/0x20
[  119.948000]  [<b013dcb7>] print_deadlock_bug+0xc7/0xe0
[  119.948000]  [<b013dd3b>] check_deadlock+0x6b/0x80
[  119.948000]  [<b013f772>] __lock_acquire+0x352/0xbb0
[  119.948000]  [<b0140452>] lock_acquire+0x62/0x80
[  119.948000]  [<b013825a>] down_write+0x3a/0x60
[  119.948000]  [<b025d230>] xfs_ilock+0x60/0xb0
[  119.948000]  [<b025c9c1>] xfs_iget_core+0x2a1/0x5f0
[  119.948000]  [<b025cdc1>] xfs_iget+0xb1/0x110
[  119.948000]  [<b02776a8>] xfs_trans_iget+0xa8/0x140
[  119.948000]  [<b025ef8f>] xfs_ialloc+0xaf/0x4c0
[  119.948000]  [<b02780fd>] xfs_dir_ialloc+0x6d/0x280
[  119.948000]  [<b027df19>] xfs_create+0x249/0x670
[  119.948000]  [<b0289b7a>] xfs_vn_mknod+0x20a/0x350
[  119.948000]  [<b0289cd2>] xfs_vn_create+0x12/0x20
[  119.948000]  [<b0174f26>] vfs_create+0xb6/0x100
[  119.948000]  [<b017518e>] open_namei_create+0x4e/0xa0
[  119.948000]  [<b0175733>] open_namei+0x553/0x590
[  119.948000]  [<b016b05c>] do_filp_open+0x2c/0x60
[  119.948000]  [<b016b3c0>] do_sys_open+0x50/0xe0
[  119.948000]  [<b016b46c>] sys_open+0x1c/0x20
[  119.948000]  [<b010416c>] sysenter_past_esp+0x5d/0x99
[  119.948000]  =======================

-- 
Simon Arlott
