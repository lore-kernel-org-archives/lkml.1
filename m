Return-Path: <linux-kernel-owner+w=401wt.eu-S1765586AbZEAUdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765586AbZEAUdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762555AbZEAUde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:33:34 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:53482 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbZEAUdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Bd1/sHwz+SVNMuA34U1LyYV0iKzuyun09knNND+rjw+1KhRAkC5ntXayt6oIJeeSUy
         MdWBL6P8g6FI072RpT2SWX60KI2Bw2CRvIi3Nl4NDcKXKIadJKzPUxKgRaz2PaK/x4qa
         KTurTZ2bRJzs/qcRzp/P8MZhQV4BlPoUHygac=
MIME-Version: 1.0
Date: Sat, 2 May 2009 00:33:30 +0400
Message-ID: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
Subject: 2.6.30-rc4: xfs_fsr hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# xfs_db -r /dev/sdc1
xfs_db> frag
actual 23805, ideal 22890, fragmentation factor 3.84%
# xfs_fsr -v /dev/sdc1
/mnt/c start inode=0
ino=158
extents before:3 after:1 DONE ino=158

 then it hangs


INFO: task xfs_fsr:2403 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfs_fsr       D 00000000  4492  2403   1928
 f3cc9dec 00000046 00000001 00000000 f3cc9de8 ec976680 ec976900 f2d06a50
 ec976680 00000001 f2d06a50 f2d06a4c ffffffff f2d06a4c ec976680 f3cc9df4
 c0447892 f3cc9e20 c04498ad f3cc9e28 f2d06a50 f2d06a74 f3cc9e44 00000246
Call Trace:
 [<c0447892>] schedule+0x12/0x30
 [<c04498ad>] rwsem_down_failed_common+0x6d/0x180
 [<c04499dd>] rwsem_down_write_failed+0x1d/0x30
 [<c0449a2a>] call_rwsem_down_write_failed+0x6/0x8
 [<c026bfce>] ? xfs_ilock+0xee/0x100
 [<c013fcd6>] ? down_write_nested+0x76/0x90
 [<c026bfce>] ? xfs_ilock+0xee/0x100
 [<c026bfce>] xfs_ilock+0xee/0x100
 [<c0290fb4>] xfs_inactive+0x334/0x540
 [<c01b382b>] ? inotify_inode_is_dead+0x1b/0x80
 [<c029d4ef>] xfs_fs_clear_inode+0x1f/0x30
 [<c019b7bb>] clear_inode+0x8b/0x110
 [<c019bf06>] generic_delete_inode+0xe6/0x120
 [<c0449d86>] ? _spin_lock+0x66/0x70
 [<c019c09f>] generic_drop_inode+0x15f/0x230
 [<c02c0958>] ? _atomic_dec_and_lock+0x18/0x40
 [<c019b477>] iput+0x47/0x50
 [<c0198a4f>] dentry_iput+0x6f/0xc0
 [<c0198b74>] d_kill+0x24/0x50
 [<c019a03b>] dput+0x5b/0x120
 [<c018a892>] __fput+0x162/0x240
 [<c018a98f>] fput+0x1f/0x30
 [<c01873f7>] filp_close+0x47/0x70
 [<c018748c>] sys_close+0x6c/0xd0
 [<c0102e48>] sysenter_do_call+0x12/0x36
INFO: lockdep is turned off.
