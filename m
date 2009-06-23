Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbZFWIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbZFWIMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZFWILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:11:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52382 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZFWILy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:11:54 -0400
Date: Tue, 23 Jun 2009 10:11:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       hch@infradead.org
Subject: merging the per-bdi writeback patchset
Message-ID: <20090623081156.GT31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Things are looking good for this patchset and it's been in -next for
almost a week without any reports of problems. So I'd like to merge it
for 2.6.31 if at all possible. Any objections?

This was the last posting of the patchset:

http://lkml.org/lkml/2009/6/17/143

  git://git.kernel.dk/linux-2.6-block.git writeback

Jens Axboe (10):
      writeback: move dirty inodes from super_block to backing_dev_info
      writeback: switch to per-bdi threads for flushing data
      writeback: get rid of pdflush completely
      writeback: separate the flushing state/task from the bdi
      writeback: support > 1 flusher thread per bdi
      writeback: allow sleepy exit of default writeback task
      writeback: add some debug inode list counters to bdi stats
      writeback: add name to backing_dev_info
      writeback: check for registered bdi in flusher add and inode dirty
      writeback: use spin_trylock() in bdi_writeback_all() for WB_SYNC_NONE

 block/blk-core.c            |    1 +
 drivers/block/aoe/aoeblk.c  |    1 +
 drivers/char/mem.c          |    1 +
 fs/btrfs/disk-io.c          |    1 +
 fs/buffer.c                 |    2 +-
 fs/char_dev.c               |    1 +
 fs/configfs/inode.c         |    1 +
 fs/fs-writeback.c           |  812 ++++++++++++++++++++++++++++++++++---------
 fs/fuse/inode.c             |    1 +
 fs/hugetlbfs/inode.c        |    1 +
 fs/nfs/client.c             |    1 +
 fs/ocfs2/dlm/dlmfs.c        |    1 +
 fs/ramfs/inode.c            |    1 +
 fs/super.c                  |    3 -
 fs/sysfs/inode.c            |    1 +
 fs/ubifs/super.c            |    1 +
 include/linux/backing-dev.h |   71 ++++-
 include/linux/fs.h          |   11 +-
 include/linux/writeback.h   |   15 +-
 kernel/cgroup.c             |    1 +
 mm/Makefile                 |    2 +-
 mm/backing-dev.c            |  532 ++++++++++++++++++++++++++++-
 mm/page-writeback.c         |  157 ++-------
 mm/pdflush.c                |  269 --------------
 mm/swap_state.c             |    1 +
 mm/vmscan.c                 |    2 +-
 26 files changed, 1294 insertions(+), 597 deletions(-)
 delete mode 100644 mm/pdflush.c

-- 
Jens Axboe

