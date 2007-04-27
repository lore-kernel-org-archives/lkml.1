Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbXD0Mp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbXD0Mp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXD0Mpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:45:55 -0400
Received: from smtp.nokia.com ([131.228.20.170]:55846 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbXD0Mpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:45:53 -0400
Subject: [GIT-PULL] please pull UBI tree
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Apr 2007 15:45:25 +0300
Message-Id: <1177677925.7539.18.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Apr 2007 12:45:26.0306 (UTC) FILETIME=[EDD12820:01C788C9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please, pull UBI tree from
git://git.infradead.org/ubi-2.6.git for-linus


The UBI tree has been in -mm for several releases and we would like to
see it in the mainline.

We have several groups using UBI now and it has proved to be fairly
stable. We've also got some feedback from community. We have also sent
UBI for review to LKML several times, got feedback, and fixed what was
requested.

In short, UBI provides wear-leveling support across the whole flash
chip. UBI completely hides 2 aspects of flash chips which make them very
difficult to work with:
1. wear of eraseblocks;
2. bad eraseblocks.

UBI also makes it possible to dynamically create, delete and re-size
flash partitions (UBI volumes). So here some analogy to LVM may be
pointed.

We are using UBI to develop a new flash file system on top, because it
encapsulates most of the media-related complexities and make it possible
to concentrate on file-system problems, instead on of solving flash
media problems.

There is some documentation available at:
http://www.linux-mtd.infradead.org/doc/ubi.html
http://www.linux-mtd.infradead.org/faq/ubi.html

The sources are available via the GIT tree:
git://git.infradead.org/ubi-2.6.git

One can also browse the GIT tree using http://git.infradead.org/


 MAINTAINERS                   |    8 +
 drivers/mtd/Kconfig           |    2 +
 drivers/mtd/Makefile          |    2 +
 drivers/mtd/ubi/Kconfig       |   58 ++
 drivers/mtd/ubi/Kconfig.debug |  104 +++
 drivers/mtd/ubi/Makefile      |    7 +
 drivers/mtd/ubi/build.c       |  848 +++++++++++++++++++++
 drivers/mtd/ubi/cdev.c        |  722 ++++++++++++++++++
 drivers/mtd/ubi/debug.c       |  224 ++++++
 drivers/mtd/ubi/debug.h       |  161 ++++
 drivers/mtd/ubi/eba.c         | 1241 ++++++++++++++++++++++++++++++
 drivers/mtd/ubi/gluebi.c      |  323 ++++++++
 drivers/mtd/ubi/io.c          | 1259 +++++++++++++++++++++++++++++++
 drivers/mtd/ubi/kapi.c        |  575 ++++++++++++++
 drivers/mtd/ubi/misc.c        |  105 +++
 drivers/mtd/ubi/scan.c        | 1368 +++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/scan.h        |  167 ++++
 drivers/mtd/ubi/ubi.h         |  535 +++++++++++++
 drivers/mtd/ubi/upd.c         |  348 +++++++++
 drivers/mtd/ubi/vmt.c         |  809 ++++++++++++++++++++
 drivers/mtd/ubi/vtbl.c        |  809 ++++++++++++++++++++
 drivers/mtd/ubi/wl.c          | 1671 +++++++++++++++++++++++++++++++++++++++++
 fs/jffs2/fs.c                 |   12 +
 fs/jffs2/os-linux.h           |    6 +
 fs/jffs2/wbuf.c               |   24 +
 include/linux/mtd/ubi.h       |  202 +++++
 include/mtd/Kbuild            |    2 +
 include/mtd/mtd-abi.h         |    1 +
 include/mtd/ubi-header.h      |  360 +++++++++
 include/mtd/ubi-user.h        |  161 ++++
 30 files changed, 12114 insertions(+), 0 deletions(-)


Artem B. Bityutskiy (1):
      UBI: Unsorted Block Images

Artem Bityutskiy (3):
      JFFS2: add UBI support
      UBI: add me to MAINTAINERS
      UBI: remove unused variable


commit d468a030026017008286919aa6127b1190efb2c2
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Fri Apr 27 15:11:44 2007 +0300

UBI: remove unused variable

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 485764016d5accb813e8bdd076802a7e3318bb64
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Tue Feb 13 17:11:10 2007 +0200

UBI: add me to MAINTAINERS

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 0029da3bf430eea498eee8cef5933f9214534b8a
Author: Artem Bityutskiy <dedekind@infradead.org>
Date:   Wed Oct 4 19:15:21 2006 +0300

JFFS2: add UBI support

This patch make JFFS2 able to work with UBI volumes via the emulated MTD
devices which are directly mapped to these volumes.

Signed-off-by: Artem Bityutskiy <dedekind@infradead.org>

commit 801c135ce73d5df1caf3eca35b66a10824ae0707
Author: Artem B. Bityutskiy <dedekind@linutronix.de>
Date:   Tue Jun 27 12:22:22 2006 +0400

UBI: Unsorted Block Images

UBI (Latin: "where?") manages multiple logical volumes on a single
flash device, specifically supporting NAND flash devices. UBI provides
a flexible partitioning concept which still allows for wear-levelling
across the whole flash device.

In a sense, UBI may be compared to the Logical Volume Manager
(LVM). Whereas LVM maps logical sector numbers to physical HDD sector
numbers, UBI maps logical eraseblocks to physical eraseblocks.

More information may be found at
http://www.linux-mtd.infradead.org/doc/ubi.html

Partitioning/Re-partitioning

  An UBI volume occupies a certain number of erase blocks. This is
  limited by a configured maximum volume size, which could also be
  viewed as the partition size. Each individual UBI volume's size can
  be changed independently of the other UBI volumes, provided that the
  sum of all volume sizes doesn't exceed a certain limit.

  UBI supports dynamic volumes and static volumes. Static volumes are
  read-only and their contents are protected by CRC check sums.

Bad eraseblocks handling

  UBI transparently handles bad eraseblocks. When a physical
  eraseblock becomes bad, it is substituted by a good physical
  eraseblock, and the user does not even notice this.

Scrubbing

  On a NAND flash bit flips can occur on any write operation,
  sometimes also on read. If bit flips persist on the device, at first
  they can still be corrected by ECC, but once they accumulate,
  correction will become impossible. Thus it is best to actively scrub
  the affected eraseblock, by first copying it to a free eraseblock
  and then erasing the original. The UBI layer performs this type of
  scrubbing under the covers, transparently to the UBI volume users.

Erase Counts

  UBI maintains an erase count header per eraseblock. This frees
  higher-level layers (like file systems) from doing this and allows
  for centralized erase count management instead. The erase counts are
  used by the wear-levelling algorithm in the UBI layer. The algorithm
  itself is exchangeable.

Booting from NAND

  For booting directly from NAND flash the hardware must at least be
  capable of fetching and executing a small portion of the NAND
  flash. Some NAND flash controllers have this kind of support. They
  usually limit the window to a few kilobytes in erase block 0. This
  "initial program loader" (IPL) must then contain sufficient logic to
  load and execute the next boot phase.

  Due to bad eraseblocks, which may be randomly scattered over the
  flash device, it is problematic to store the "secondary program
  loader" (SPL) statically. Also, due to bit-flips it may become
  corrupted over time. UBI allows to solve this problem gracefully by
  storing the SPL in a small static UBI volume.

UBI volumes vs. static partitions

  UBI volumes are still very similar to static MTD partitions:

    * both consist of eraseblocks (logical eraseblocks in case of UBI
      volumes, and physical eraseblocks in case of static partitions;
    * both support three basic operations - read, write, erase.

  But UBI volumes have the following advantages over traditional
  static MTD partitions:

    * there are no eraseblock wear-leveling constraints in case of UBI
      volumes, so the user should not care about this;
    * there are no bit-flips and bad eraseblocks in case of UBI volumes.

  So, UBI volumes may be considered as flash devices with relaxed
  restrictions.

Where can it be found?

  Documentation, kernel code and applications can be found in the MTD
  gits.

What are the applications for?

  The applications help to create binary flash images for two purposes: pfi
  files (partial flash images) for in-system update of UBI volumes, and plain
  binary images, with or without OOB data in case of NAND, for a manufacturing
  step. Furthermore some tools are/and will be created that allow flash content
  analysis after a system has crashed..

Who did UBI?

  The original ideas, where UBI is based on, were developed by Andreas
  Arnez, Frank Haverkamp and Thomas Gleixner. Josh W. Boyer and some others
  were involved too. The implementation of the kernel layer was done by Artem
  B. Bityutskiy. The user-space applications and tools were written by Oliver
  Lohmann with contributions from Frank Haverkamp, Andreas Arnez, and Artem.
  Joern Engel contributed a patch which modifies JFFS2 so that it can be run on
  a UBI volume. Thomas Gleixner did modifications to the NAND layer. Alexander
  Schmidt made some testing work as well as core functionality improvements.

Signed-off-by: Artem B. Bityutskiy <dedekind@linutronix.de>
Signed-off-by: Frank Haverkamp <haver@vnet.ibm.com>

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

