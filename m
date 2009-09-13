Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZIMR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZIMR7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZIMR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:59:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36205 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZIMR67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:58:59 -0400
Date: Sun, 13 Sep 2009 19:59:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.32-rc1
Message-ID: <20090913175902.GP14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the changes queued up in the block/IO area for 2.6.32. Nothing
totally exciting. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.32

Christoph Hellwig (1):
      block: use blkdev_issue_discard in blk_ioctl_discard

David Woodhouse (1):
      Make DISCARD_BARRIER and DISCARD_NOBARRIER writes instead of reads

Ed L. Cashin (1):
      aoe: end barrier bios with EOPNOTSUPP

Eric Dumazet (1):
      cciss: memory leak in cciss_init_one()

Hannes Reinecke (1):
      Send uevents for write_protect changes

Jeff Moyer (1):
      cfq: choose a new next_req when a request is dispatched

Jens Axboe (13):
      cfq-iosched: drain device queue before switching to a sync queue
      block: make bio_rw_flagged() return a bool
      bio: first step in sanitizing the bio->bi_rw flag testing
      block: improve queue_should_plug() by looking at IO depths
      block: add blk-iopoll, a NAPI like approach for block devices
      block: fix long lines in block/blk-iopoll.c
      block: adjust default budget for blk-iopoll
      block: fix comment in blk-iopoll.c
      block: use interrupts disabled version of raise_softirq_irqoff()
      cfq-iosched: get rid of must_alloc flag
      block: make blk_iopoll_prep_sched() follow normal 0/1 return convention
      block: enable rq CPU completion affinity by default
      block: don't assume device has a request list backing in nr_requests store

Marcin Slusarz (1):
      block: use printk_once

Martin K. Petersen (1):
      block: Optimal I/O limit wrapper

Miklos Szeredi (1):
      splice: update mtime and atime on files

Minchan Kim (1):
      block: trace bio queueing trial only when it occurs

Nikanth Karthikesan (1):
      Seperate read and write statistics of in_flight requests

Shan Wei (1):
      cfq: fix the log message after dispatched a request

Tejun Heo (3):
      block: use the same failfast bits for bio and request
      block: implement mixed merge of different failfast requests
      scsi,block: update SCSI to handle mixed merge failures

Vivek Goyal (1):
      cfq-iosched: no need to keep track of busy_rt_queues

 block/Makefile              |    2 +-
 block/blk-barrier.c         |   31 ++++---
 block/blk-core.c            |  166 +++++++++++++++++++++++++------
 block/blk-iopoll.c          |  227 +++++++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c           |   51 ++++++++--
 block/blk-settings.c        |   21 ++++-
 block/blk-sysfs.c           |    7 +-
 block/blk.h                 |    1 +
 block/cfq-iosched.c         |   72 ++++++--------
 block/elevator.c            |   16 +---
 block/genhd.c               |   22 ++++-
 block/ioctl.c               |   49 +---------
 drivers/block/aoe/aoeblk.c  |    3 +
 drivers/block/cciss.c       |    4 +-
 drivers/block/loop.c        |    2 +-
 drivers/block/paride/pcd.c  |   12 +--
 drivers/block/sx8.c         |    4 +-
 drivers/block/viodasd.c     |   12 +--
 drivers/md/dm-raid1.c       |    2 +-
 drivers/md/dm-stripe.c      |    4 +-
 drivers/md/dm.c             |   28 +++---
 drivers/md/linear.c         |    2 +-
 drivers/md/multipath.c      |    4 +-
 drivers/md/raid0.c          |    2 +-
 drivers/md/raid1.c          |   14 ++-
 drivers/md/raid10.c         |    6 +-
 drivers/md/raid5.c          |    2 +-
 drivers/scsi/scsi_lib.c     |    6 +-
 drivers/staging/dst/dcore.c |    5 +-
 fs/btrfs/extent-tree.c      |    3 +-
 fs/btrfs/volumes.c          |    4 +-
 fs/gfs2/rgrp.c              |    6 +-
 fs/partitions/check.c       |   12 ++-
 fs/splice.c                 |    8 +-
 include/linux/bio.h         |   69 ++++++-------
 include/linux/blk-iopoll.h  |   48 +++++++++
 include/linux/blkdev.h      |   44 +++++++--
 include/linux/fs.h          |    4 +-
 include/linux/genhd.h       |   21 +++--
 include/linux/interrupt.h   |    1 +
 kernel/sysctl.c             |   10 ++-
 mm/swapfile.c               |    6 +-
 42 files changed, 729 insertions(+), 284 deletions(-)
 create mode 100644 block/blk-iopoll.c
 create mode 100644 include/linux/blk-iopoll.h

-- 
Jens Axboe

