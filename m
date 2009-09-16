Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZIPNbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZIPNbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZIPNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:31:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34179 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZIPNbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:31:36 -0400
Date: Wed, 16 Sep 2009 15:31:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] writeback fixes and cleanups
Message-ID: <20090916133138.GQ23126@kernel.dk>
References: <20090915194955.GV23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915194955.GV23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Jens Axboe wrote:
> Hi,
> 
> This should conclude the major updates to the previous writeback
> inclusion, and has a bunch of must have fixes from Nick as well. So I
> think we should include this sooner rather than later, should also fix
> Ingo's bug report.

Linus, JFYI, the diffstat now looks like this:

  git://git.kernel.dk/linux-2.6-block.git writeback

Christoph Hellwig (1):
      writeback: merely wakeup flusher thread if work allocation fails for WB_SYNC_NONE

Jens Axboe (11):
      fs: remove bdev->bd_inode_backing_dev_info
      writeback: get rid of wbc->for_writepages
      writeback: make wb_writeback() take an argument structure
      fs: Assign bdi in super_block
      writeback: only use bdi_writeback_all() for WB_SYNC_NONE writeout
      writeback: use RCU to protect bdi_list
      writeback: inline allocation failure handling in bdi_alloc_queue_work()
      writeback: separate starting of sync vs opportunistic writeback
      writeback: splice dirty inode entries to default bdi on bdi_destroy()
      writeback: add comments to bdi_work structure
      writeback: use schedule_timeout_interruptible()

Nick Piggin (4):
      writeback: remove smp_mb(), it's not needed with list_add_tail_rcu()
      writeback: improve scalability of bdi writeback work queues
      writeback: Fix bdi use after free in wb_work_complete()
      writeback: fix possible bdi writeback refcounting problem

 fs/afs/write.c              |    1 -
 fs/block_dev.c              |    1 -
 fs/btrfs/disk-io.c          |    1 +
 fs/btrfs/ordered-data.c     |    1 -
 fs/fs-writeback.c           |  345 ++++++++++++++++++++-----------------------
 fs/fuse/inode.c             |    2 +
 fs/inode.c                  |    4 +-
 fs/jbd2/commit.c            |    1 -
 fs/nfs/super.c              |    2 +
 fs/nfs/write.c              |    1 -
 fs/nilfs2/the_nilfs.c       |    4 +-
 fs/super.c                  |    6 +
 fs/sync.c                   |    9 +-
 fs/ubifs/budget.c           |   20 +--
 fs/ubifs/super.c            |    1 +
 include/linux/backing-dev.h |    3 +-
 include/linux/fs.h          |    2 +-
 include/linux/writeback.h   |    5 +-
 include/trace/events/ext4.h |    6 +-
 mm/backing-dev.c            |   90 +++++++++---
 mm/page-writeback.c         |   22 +--
 21 files changed, 264 insertions(+), 263 deletions(-)

-- 
Jens Axboe

