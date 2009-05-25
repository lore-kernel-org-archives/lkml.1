Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZEYB0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZEYB0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZEYB0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:26:41 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:59790 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZEYB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hyPbBJZakXPvTcO1NJ14Ti/TRUa5P95rgR/o5OpJREMmEmK6yP9XXcB4opTUKFXNzF
         UVpVg4se1UV05umEsQJbDvNZ4lNf+LH05yzlLPkLNV0mLLZWPDC6DR+j9nce3jvjRhfU
         d9RXrhJhc9DYDQ5Yf20Nhz7a9Mi3IxjN1Y720=
MIME-Version: 1.0
Date: Mon, 25 May 2009 09:26:41 +0800
Message-ID: <fa69d4570905241826l3186b901qc3938fbe4693c4f3@mail.gmail.com>
Subject: md: sysfs create failed when stop md and then start it.
From: s ticket <smticket@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
       The kernel print
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x40/0x4c()
sysfs: duplicate filename 'sync_action' can not be created
Modules linked in: e1000 sata_mv
[<8002ab18>] (dump_stack+0x0/0x14) from [<8003636c>] (warn_slowpath+0x70/0x8c)
[<800362fc>] (warn_slowpath+0x0/0x8c) from [<800c2014>]
(sysfs_add_one+0x40/0x4c)
 r3:8032bad0 r2:80305ce0
 r7:f110da50 r6:80360e50 r5:f10a2d80 r4:ffffffef
[<800c1fd4>] (sysfs_add_one+0x0/0x4c) from [<800c1660>]
(sysfs_add_file_mode+0x58/0xa8)
 r5:f10a2d80 r4:f0955c30
[<800c1608>] (sysfs_add_file_mode+0x0/0xa8) from [<800c3b10>]
(internal_create_group+0xfc/0x1f0)
 r7:00000000 r6:f110da50 r5:00000000 r4:80360d3c
[<800c3a14>] (internal_create_group+0x0/0x1f0) from [<800c3c38>]
(sysfs_create_group+0x18/0x1c)
[<800c3c20>] (sysfs_create_group+0x0/0x1c) from [<80207bfc>]
(do_md_run+0x554/0xafc)
[<802076a8>] (do_md_run+0x0/0xafc) from [<8020e280>] (md_ioctl+0x980/0x11ec)
[<8020d900>] (md_ioctl+0x0/0x11ec) from [<801610e0>]
(__blkdev_driver_ioctl+0x38/0x44)
[<801610a8>] (__blkdev_driver_ioctl+0x0/0x44) from [<801611e8>]
(blkdev_ioctl+0x98/0x96c)
[<80161150>] (blkdev_ioctl+0x0/0x96c) from [<800a6c3c>] (block_ioctl+0x3c/0x40)
[<800a6c00>] (block_ioctl+0x0/0x40) from [<8008bd98>] (vfs_ioctl+0x34/0x78)
[<8008bd64>] (vfs_ioctl+0x0/0x78) from [<8008c0cc>] (do_vfs_ioctl+0x2c8/0x554)
 r5:7e8dc8fc r4:f1803600
[<8008be04>] (do_vfs_ioctl+0x0/0x554) from [<8008c398>] (sys_ioctl+0x40/0x68)
[<8008c358>] (sys_ioctl+0x0/0x68) from [<80026de0>] (ret_fast_syscall+0x0/0x3c)
 r7:00000036 r6:00000004 r5:00000000 r4:00000001
---[ end trace bb619341641b4e0b ]---
md: cannot register extra attributes for md0

    Having mdadm running as monitor at background and  call mdadm
--stop and mdadm -C several times
can trigger this bug. It seem that after mdadm --stop return,
mddev->active is not zero and thus
`mddev_delayed_delete' isn't called.

    The kernel is 2.6.29.1 (iop13xx)

                                               Jbin
