Return-Path: <linux-kernel-owner+w=401wt.eu-S2992533AbXCWQyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992533AbXCWQyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992538AbXCWQyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:54:04 -0400
Received: from smtp.nokia.com ([131.228.20.173]:59023 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992533AbXCWQx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:53:56 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Fri, 23 Mar 2007 18:42:56 +0200
Message-Id: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/20 take 4] UBI: Unsorted Block Images
X-OriginalArrivalTime: 23 Mar 2007 16:42:56.0964 (UTC) FILETIME=[4F69C040:01C76D6A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070323184314-7B0C1BB0-49B2DE8D/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch-set contains UBI, which stands for Unsorted Block Images. This
is closely related to the memory technology devices Linux subsystem (MTD),
so this new piece of software is from drivers/mtd/ubi.

In short, UBI provides wear-levelling support across the whole flash chip.
UBI completely hides 2 aspects of flash chips which make them very difficult to
work with:
1. wear of eraseblocks;
2. bad eraseblocks.

UBI also makes it possible to dynamically create, delete and re-size flash
partitions (UBI volumes). So here some analogy to LVM may be pointed.

There is some documentation available at:
http://www.linux-mtd.infradead.org/doc/ubi.html
http://www.linux-mtd.infradead.org/faq/ubi.html

The sources are available via the GIT tree:
git://git.infradead.org/ubi-2.6.git (stable)
git://git.infradead.org/~dedekind/dedekind-ubi-2.6.git (devel)

One can also browse the GIT trees at http://git.infradead.org/

This is the 4th iteration of the post which has fixed most of the stuff
pointed to previously:

- Removed "itsy-bitsy" units
- Removed a lot of debugging stuff
- Fixed kernel-doc
- fixed inline damage in eba.c

 MAINTAINERS                   |    8
 drivers/mtd/Kconfig           |    2
 drivers/mtd/Makefile          |    2
 drivers/mtd/ubi/Kconfig       |   58 +
 drivers/mtd/ubi/Kconfig.debug |  104 ++
 drivers/mtd/ubi/Makefile      |    7
 drivers/mtd/ubi/build.c       |  843 ++++++++++++++++++++
 drivers/mtd/ubi/cdev.c        |  724 +++++++++++++++++
 drivers/mtd/ubi/debug.c       |  224 +++++
 drivers/mtd/ubi/debug.h       |  161 +++
 drivers/mtd/ubi/eba.c         | 1132 ++++++++++++++++++++++++++++
 drivers/mtd/ubi/gluebi.c      |  337 ++++++++
 drivers/mtd/ubi/io.c          | 1263 +++++++++++++++++++++++++++++++
 drivers/mtd/ubi/kapi.c        |  545 +++++++++++++
 drivers/mtd/ubi/misc.c        |  105 ++
 drivers/mtd/ubi/scan.c        | 1374 +++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/scan.h        |  167 ++++
 drivers/mtd/ubi/ubi.h         |  560 +++++++++++++
 drivers/mtd/ubi/upd.c         |  348 ++++++++
 drivers/mtd/ubi/vmt.c         |  811 ++++++++++++++++++++
 drivers/mtd/ubi/vtbl.c        |  809 ++++++++++++++++++++
 drivers/mtd/ubi/wl.c          | 1698 ++++++++++++++++++++++++++++++++++++++++++
 fs/jffs2/fs.c                 |   12
 fs/jffs2/os-linux.h           |    6
 fs/jffs2/wbuf.c               |   24
 include/linux/mtd/ubi.h       |  191 ++++
 include/mtd/Kbuild            |    2
 include/mtd/mtd-abi.h         |    1
 include/mtd/ubi-header.h      |  360 ++++++++
 include/mtd/ubi-user.h        |  161 +++
 30 files changed, 12039 insertions(+)

--
Best regards,
Artem Bityutskiy (Битюцкий Артём)
