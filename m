Return-Path: <linux-kernel-owner+w=401wt.eu-S1422656AbXCNPUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbXCNPUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCNPUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:20:15 -0400
Received: from smtp.nokia.com ([131.228.20.172]:22969 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161338AbXCNPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:11 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:19:34 +0200
Message-Id: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/22 take 3] UBI: Unsorted Block Images
X-OriginalArrivalTime: 14 Mar 2007 15:19:34.0304 (UTC) FILETIME=[2BE0AA00:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314171953-3F0D0BB0-494C4083/0-0/0-1
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
git://git.infradead.org/ubi-2.6.git (stable)
git://git.infradead.org/~dedekind/dedekind-ubi-2.6.git (devel)

One can also browse the GIT trees at http://git.infradead.org/

This is the third iteration of the post which has fixed most of the stuff
pointed to previously.

 MAINTAINERS                   |    8
 drivers/mtd/Kconfig           |    2
 drivers/mtd/Makefile          |    2
 drivers/mtd/ubi/Kconfig       |   60 +
 drivers/mtd/ubi/Kconfig.debug |  153 +++
 drivers/mtd/ubi/Makefile      |    7
 drivers/mtd/ubi/account.c     |  233 +++++
 drivers/mtd/ubi/build.c       |  467 +++++++++++
 drivers/mtd/ubi/cdev.c        |  926 ++++++++++++++++++++++
 drivers/mtd/ubi/debug.c       |  546 +++++++++++++
 drivers/mtd/ubi/debug.h       |  146 +++
 drivers/mtd/ubi/eba.c         | 1735 +++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/gluebi.c      |  361 ++++++++
 drivers/mtd/ubi/io.c          | 1445 ++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/misc.c        |  167 +++
 drivers/mtd/ubi/scan.c        | 1478 +++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/sysfs.c       |  408 +++++++++
 drivers/mtd/ubi/ubi.h         |  867 ++++++++++++++++++++
 drivers/mtd/ubi/uif.c         |  842 ++++++++++++++++++++
 drivers/mtd/ubi/upd.c         |  359 ++++++++
 drivers/mtd/ubi/vmt.c         |  360 ++++++++
 drivers/mtd/ubi/vtbl.c        | 1387 +++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/wl.c          | 1761 ++++++++++++++++++++++++++++++++++++++++++
 fs/jffs2/fs.c                 |   12
 fs/jffs2/os-linux.h           |    6
 fs/jffs2/wbuf.c               |   24
 include/linux/mtd/ubi.h       |  196 ++++
 include/mtd/Kbuild            |    2
 include/mtd/mtd-abi.h         |    1
 include/mtd/ubi-header.h      |  371 ++++++++
 include/mtd/ubi-user.h        |  163 +++
 31 files changed, 14495 insertions(+)

--
Best regards,
Artem Bityutskiy (Битюцкий Артём)
