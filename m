Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZCMFDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZCMFDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZCMFDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:03:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:59723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZCMFDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:03:22 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] block: cleanup patches
Date: Fri, 13 Mar 2009 14:02:44 +0900
Message-Id: <1236920578-2179-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This patchset is available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup

This patchset contains the following 14 cleanup patches.

 0001-block-merge-blk_invoke_request_fn-into-__blk_run_.patch
 0002-block-kill-blk_start_queueing.patch
 0003-block-don-t-set-REQ_NOMERGE-unnecessarily.patch
 0004-block-cleanup-REQ_SOFTBARRIER-usages.patch
 0005-block-clean-up-misc-stuff-after-block-layer-timeout.patch
 0006-block-reorder-request-completion-functions.patch
 0007-block-reorganize-request-fetching-functions.patch
 0008-block-kill-blk_end_request_callback.patch
 0009-block-clean-up-request-completion-API.patch
 0010-block-move-rq-start_time-initialization-to-blk_rq_.patch
 0011-block-implement-and-use-__-blk_end_request_all.patch
 0012-block-kill-end_request.patch
 0013-ubd-simplify-block-request-completion.patch
 0014-block-clean-up-unnecessary-stuff-from-block-drivers.patch

* 0001-0007: cleanups in block layer proper
* 0008     : kill blk_end_request_callback()
* 0009     : further completion cleanup in block layer proper after 0008
* 0010     : rq->start_time is always initialized
* 0011     : [__]blk_end_request_all() added and used
* 0012     : kill end_request()
* 0013-0014: lld cleanup

It's on top of the current linux-2.6-block/for-2.6.30[1] and comes
with nice diffstat.

And comes with the following nice diffstat.  :-)

 arch/arm/plat-omap/mailbox.c        |   11 
 arch/um/drivers/ubd_kern.c          |   23 -
 block/as-iosched.c                  |    6 
 block/blk-barrier.c                 |    9 
 block/blk-core.c                    |  481 ++++++++++++++----------------------
 block/blk-exec.c                    |    1 
 block/blk-timeout.c                 |   22 -
 block/blk.h                         |   37 ++
 block/cfq-iosched.c                 |   10 
 block/elevator.c                    |  137 ----------
 drivers/block/amiflop.c             |   15 -
 drivers/block/ataflop.c             |   18 -
 drivers/block/cciss.c               |    3 
 drivers/block/cpqarray.c            |    3 
 drivers/block/hd.c                  |   14 -
 drivers/block/paride/pcd.c          |   12 
 drivers/block/paride/pd.c           |    5 
 drivers/block/paride/pf.c           |   28 +-
 drivers/block/ps3disk.c             |    6 
 drivers/block/swim3.c               |   26 -
 drivers/block/sx8.c                 |    3 
 drivers/block/virtio_blk.c          |    2 
 drivers/block/xd.c                  |   22 -
 drivers/block/xen-blkfront.c        |    6 
 drivers/block/xsysace.c             |    4 
 drivers/block/z2ram.c               |    4 
 drivers/cdrom/gdrom.c               |    8 
 drivers/cdrom/viocd.c               |   25 -
 drivers/ide/ide-cd.c                |   30 --
 drivers/ide/ide-disk.c              |    1 
 drivers/ide/ide-io.c                |    4 
 drivers/ide/ide-ioctls.c            |    1 
 drivers/ide/ide-park.c              |    7 
 drivers/ide/ide-pm.c                |    3 
 drivers/memstick/core/mspro_block.c |    2 
 drivers/message/i2o/i2o_block.c     |    2 
 drivers/mtd/mtd_blkdevs.c           |   22 -
 drivers/s390/block/dasd.c           |   17 -
 drivers/s390/char/tape_block.c      |   15 -
 drivers/sbus/char/jsflash.c         |    8 
 drivers/scsi/scsi_lib.c             |    2 
 include/linux/blkdev.h              |  139 ++++++++--
 42 files changed, 488 insertions(+), 706 deletions(-)

Thanks.

--
tejun

[1] 6319ec3182b26abecd2fa9ab97c945f0161d4e36
