Return-Path: <linux-kernel-owner+w=401wt.eu-S1765918AbZFQLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765918AbZFQLJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764392AbZFQLIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:08:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50631 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763176AbZFQLHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:07:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: [PATCH 0/10] Per-bdi writeback flusher threads v11
Date: Wed, 17 Jun 2009 13:07:12 +0200
Message-Id: <1245236842-3141-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 11th version of the writeback patches. Changes since v10:

- I think this finally fixes the one show stopper issue I was aware
  of. This is the one that Yanmin Zhang reported and which has plagued
  this patch series for some time. Basically it was due to a race
  between work queueing and exited tasks. I cleaned up this part while
  fixing the bug.
- The three prep patches are now merged, so they have been deleted.
- Updated to current -git.

For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v11.patch

and also stored this in a writeback-v11 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v11

Please test and report results/interesting finds. Thanks! I hope to merge
this work sooner rather than later, so please do give it a good beating.

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |    1 
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  812 +++++++++++++++++++++++++++-------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   72 ++-
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  530 +++++++++++++++++++++-
 b/mm/page-writeback.c         |  157 ------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 -----------
 26 files changed, 1293 insertions(+), 597 deletions(-)

-- 
Jens Axboe

