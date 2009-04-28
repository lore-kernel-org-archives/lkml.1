Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZD1EJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZD1EJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZD1EHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:07:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:38773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZD1EHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:07:40 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, joerg@dorchain.net, geert@linux-m68k.org,
       davem@davemloft.net, jdike@linux.intel.com, benh@kernel.crashing.org,
       Laurent@lvivier.info
Subject: [GIT PATCH linux-2.6-block#for-2.6.31] block: lld cleanup patches, take#2
Date: Tue, 28 Apr 2009 13:06:03 +0900
Message-Id: <1240891577-4813-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 04:06:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-2.6.31

This is the second take of block-lld-cleanup-patches.  Changes from
the last take[L] are

* Bartlomiej's two mg_disk cleanup patches added.
* ubd build bug fixed.
* hd and mg_disk verified to work.

This patchset contains the following patches.

 0001-block-make-blk_end_request_cur-return-bool.patch
 0002-block-don-t-init-rq-fields-unnecessarily.patch
 0003-amiflop-ataflop-xd-mg_disk-clean-up-unnecessary-stu.patch
 0004-ps3disk-simplify-request-completion.patch
 0005-sunvdc-kill-vdc_end_request.patch
 0006-ubd-cleanup-completion-path.patch
 0007-ubd-drop-unnecessary-rq-sector-manipulation.patch
 0008-hd-clean-up-request-completion-paths.patch
 0009-swim3-clean-up-request-completion-paths.patch
 0010-swim-clean-up-request-completion-paths.patch
 0011-mg_disk-fold-mg_disk.h-into-mg_disk.c.patch
 0012-mg_disk-clean-up-request-completion-paths.patch
 0013-mg_disk-fix-dependency-on-libata.patch
 0014-mg_disk-use-defines-from-linux-ata.h.patch

hd and um are verified to work.  Changes in xd, amiflop, ps3disk,
swim3 and swim are somewhat trivial and I'm fairly sure they won't
break the drivers.  Changes in sunvdc also is fairly trivial and acked
by davem.  mg_disk changes are a bit more involved but are mostly
similar to what happened to hd.

So, all in all, I think it would be fairly safe to pull the patchset.

This patchset is on top of

  linux-2.6-block#for-linus[1]
+ block-fix-hd-and-mg_disk patchset[2]
+ pulled into #for-2.6.31[3]

and contains the following changes.

 arch/um/drivers/ubd_kern.c |   33 ---
 block/scsi_ioctl.c         |    2 
 drivers/block/Kconfig      |    2 
 drivers/block/amiflop.c    |    7 
 drivers/block/ataflop.c    |    4 
 drivers/block/hd.c         |   36 +--
 drivers/block/mg_disk.c    |  413 ++++++++++++++++++++++++++++-----------------
 drivers/block/ps3disk.c    |    5 
 drivers/block/sunvdc.c     |    9 
 drivers/block/swim.c       |    7 
 drivers/block/swim3.c      |   31 ---
 drivers/block/xd.c         |    9 
 include/linux/blkdev.h     |   16 +
 include/linux/mg_disk.h    |  206 ----------------------
 14 files changed, 298 insertions(+), 482 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/826541
[1] f2d1f0ae7851be5ebd9613a80dac139270938809
[2] http://thread.gmane.org/gmane.linux.ide/40198
[3] 0f38503f0cc5142fdb40ad1c79a09e7ba0bcb74f
