Return-Path: <linux-kernel-owner+w=401wt.eu-S2992683AbXBQRBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992683AbXBQRBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992681AbXBQRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:01:53 -0500
Received: from smtp.nokia.com ([131.228.20.171]:55870 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992665AbXBQRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:51 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:54:24 +0200
Message-Id: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
X-OriginalArrivalTime: 17 Feb 2007 16:53:51.0837 (UTC) FILETIME=[33B3F0D0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185222-39D01BB0-492F98FE/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch-set contains UBI, which stands for Unsorted Block Images. This
is closely related to the memory technology devices Linux subsystem (MTD),
so this new piece of software is from drivers/mtd/ubi.

In short, UBI is kind of LVM layer but for flash (MTD) devices. It makes
it possible to dynamically create, delete and re-size volumes. But the
analogy is not full. UBI also takes care of wear-leveling and bad
eraseblocks handling, so UBI completely hides 2 aspects of flash chips
which make them very difficult to work with:

1. wear of eraseblocks;
2. bad eraseblocks.

There is some documentation available at:
http://www.linux-mtd.infradead.org/doc/ubi.html
http://www.linux-mtd.infradead.org/faq/ubi.html

The sources are available via the GIT tree:
git://git.infradead.org/ubi-2.6.git

The UBI tree has been in -mm for a few releases now and we would like to
see it in the mainline. We have several groups using the code now and it
has proved to be fairly stable thus far. We've also got some feedback
from people outside the community.

The structure of the UBI code is very simple. Whole UBI consists of units.
Each unit has one .c file which implements it and one .h file which defines
the interface of this unit. So I've split the UBI code so that there is
a distinct patch for each unit header and implementations. Plus there are
several patches like JFFS2 support, user-space-visible headers, etc.
To realize what is the unit responsible for, glance at its header - there
is a short description.

Diffstat of the whole UBI:

 MAINTAINERS                   |    8
 drivers/mtd/Kconfig           |    2
 drivers/mtd/Makefile          |    2
 drivers/mtd/ubi/Kconfig       |   71 +
 drivers/mtd/ubi/Kconfig.debug |  218 +++++
 drivers/mtd/ubi/Makefile      |    7
 drivers/mtd/ubi/account.c     |  286 +++++++
 drivers/mtd/ubi/account.h     |  118 ++
 drivers/mtd/ubi/alloc.c       |  369 +++++++++
 drivers/mtd/ubi/alloc.h       |  235 +++++
 drivers/mtd/ubi/background.c  |  352 ++++++++
 drivers/mtd/ubi/background.h  |  177 ++++
 drivers/mtd/ubi/badeb.c       |  234 +++++
 drivers/mtd/ubi/badeb.h       |  108 ++
 drivers/mtd/ubi/build.c       |  191 ++++
 drivers/mtd/ubi/build.h       |   62 +
 drivers/mtd/ubi/cdev.c        | 1033 +++++++++++++++++++++++++
 drivers/mtd/ubi/cdev.h        |   82 ++
 drivers/mtd/ubi/debug.c       |  634 +++++++++++++++
 drivers/mtd/ubi/debug.h       |  284 +++++++
 drivers/mtd/ubi/eba.c         | 1212 ++++++++++++++++++++++++++++++
 drivers/mtd/ubi/eba.h         |  362 +++++++++
 drivers/mtd/ubi/gluebi.c      |  363 +++++++++
 drivers/mtd/ubi/gluebi.h      |   88 ++
 drivers/mtd/ubi/init.c        |  371 +++++++++
 drivers/mtd/ubi/io.c          | 1297 ++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/io.h          |  419 ++++++++++
 drivers/mtd/ubi/misc.c        |  138 +++
 drivers/mtd/ubi/misc.h        |  146 +++
 drivers/mtd/ubi/scan.c        | 1383 ++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/scan.h        |  279 ++++++
 drivers/mtd/ubi/sysfs.c       |  614 +++++++++++++++
 drivers/mtd/ubi/sysfs.h       |   82 ++
 drivers/mtd/ubi/ubi.h         |  100 ++
 drivers/mtd/ubi/uif.c         |  786 +++++++++++++++++++
 drivers/mtd/ubi/uif.h         |  182 ++++
 drivers/mtd/ubi/upd.c         |  389 +++++++++
 drivers/mtd/ubi/upd.h         |  136 +++
 drivers/mtd/ubi/volmgmt.c     |  374 +++++++++
 drivers/mtd/ubi/volmgmt.h     |  129 +++
 drivers/mtd/ubi/vtbl.c        | 1369 ++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/vtbl.h        |  302 +++++++
 drivers/mtd/ubi/wl.c          | 1684 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/wl.h          |  284 +++++++
 fs/jffs2/fs.c                 |   12
 fs/jffs2/os-linux.h           |    6
 fs/jffs2/wbuf.c               |   24
 include/linux/mtd/ubi.h       |  391 +++++++++
 include/mtd/Kbuild            |    2
 include/mtd/mtd-abi.h         |    1
 include/mtd/ubi-header.h      |  337 ++++++++
 include/mtd/ubi-user.h        |  161 ++++
 52 files changed, 17896 insertions(+)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)
