Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXIDOZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXIDOZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXIDOZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:25:01 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:43189 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbXIDOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:25:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: shaggy@austin.ibm.com, jfs-discussion@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: umount triggers a warning in jfs and takes almost a minute
Date: Tue, 4 Sep 2007 16:25:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041625.11007.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

using jfs on a flash drive (which is a bit unusual: 2K sectors) unmounting
triggers a warning and takes 52 second, if I have used the filesystem. (ls -l)
is sufficient. This is 2.6.23-rc4 on x86_64.

mkfs.jfs version 1.1.11, 05-Jun-2006

	Regards
		Oliver

Sep  4 16:18:57 oenone kernel: WARNING: at fs/jfs/jfs_logmgr.c:1643 jfs_flush_journal()
Sep  4 16:18:57 oenone kernel:
Sep  4 16:18:57 oenone kernel: Call Trace:
Sep  4 16:18:57 oenone kernel:  [<ffffffff8856b96e>] :jfs:jfs_flush_journal+0x26a/0x27d
Sep  4 16:18:57 oenone kernel:  [<ffffffff8029f39e>] dispose_list+0xde/0xf7
Sep  4 16:18:57 oenone kernel:  [<ffffffff88559003>] :jfs:jfs_umount+0x30/0xe5
Sep  4 16:18:57 oenone kernel:  [<ffffffff88555a31>] :jfs:jfs_put_super+0xd/0x5e
Sep  4 16:18:57 oenone kernel:  [<ffffffff8028e68b>] generic_shutdown_super+0x60/0xf0
Sep  4 16:18:57 oenone kernel:  [<ffffffff8028e728>] kill_block_super+0xd/0x1e
Sep  4 16:18:57 oenone kernel:  [<ffffffff8028e7f3>] deactivate_super+0x6a/0x82
Sep  4 16:18:57 oenone kernel:  [<ffffffff802a1880>] sys_umount+0x249/0x25a
Sep  4 16:18:57 oenone kernel:  [<ffffffff80260e2f>] audit_syscall_entry+0x141/0x174
Sep  4 16:18:57 oenone kernel:  [<ffffffff8020be8c>] tracesys+0xdc/0xe1

oenone:/home/oliver # mount -t jfs /dev/sdd1 /mnt
oenone:/home/oliver # ls -l /mnt
insgesamt 72
-rw-r--r-- 1 root root 72797  4. Sep 14:51 config
oenone:/home/oliver # time umount /mnt

real    0m52.608s
user    0m0.000s
sys     0m0.008s
