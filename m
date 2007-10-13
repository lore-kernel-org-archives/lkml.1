Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbXJMTLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbXJMTLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762566AbXJMTLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:11:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762590AbXJMTLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:11:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Date: Sat, 13 Oct 2007 21:26:32 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710132126.33085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are many traces like this in my dmesg from 2.6.23-git3 (they don't
appear for vanilla 2.6.23):

<4>sysfs: duplicate filename 'ethxx1' can not be created
WARNING: at /home/rafael/src/linux-2.6/fs/sysfs/dir.c:425 sysfs_add_one()

Call Trace:
 [<ffffffff802d1532>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d2411>] sysfs_create_link+0xd1/0x12c
 [<ffffffff803756da>] device_rename+0x17a/0x1db
 [<ffffffff803c903d>] dev_change_name+0x114/0x20c
 [<ffffffff803c9339>] dev_ifsioc+0x204/0x2d0
 [<ffffffff803c9925>] dev_ioctl+0x520/0x633
 [<ffffffff803bf445>] sk_alloc+0x37/0x10c
 [<ffffffff8024b977>] up_read+0x9/0xb
 [<ffffffff803bc65e>] sock_ioctl+0x1fe/0x20c
 [<ffffffff8029b34a>] do_ioctl+0x2a/0x77
 [<ffffffff8029b5e8>] vfs_ioctl+0x251/0x26e
 [<ffffffff8029b664>] sys_ioctl+0x5f/0x83
 [<ffffffff8020bd4e>] system_call+0x7e/0x83

net ethxx1: device_rename: sysfs_create_symlink failed (-17)
sysfs: duplicate filename 'eth1' can not be created

Everything seems to work, but this just looks fishy.

I reported it for at least one -mm of the recent -mm kernels, but no one
responded.

Greetings,
Rafael
