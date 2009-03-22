Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZCVT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZCVT0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZCVT0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52555 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbZCVT0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:06 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org
Subject: [PATCH 0/12] Per-bdi writeback flusher threads #2
Date: Sun, 22 Mar 2009 20:25:52 +0100
Message-Id: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Second version of this patchset. Changes since last time:

- Rearranged the obvious and prep patches to be at the beginning
  of the series. That's patches 1-3, they will go upstream for 2.6.30
  since they are just cleanups.

- The other change is more interesting. It adds support for > 1 flusher
  thread per bdi. Comments welcome, I'm particularly curious whether
  the super_operation is the right place to add this or not. We'll also
  need a few other changes, particularly I think that users of this will
  want to provide their own generic_sync_wb_inodes() at least. Probably
  along with their own variants of queue_io/requeue_io/redirty_tail() and
  so on.

- Various little bug fixes.

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |    3 
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  490 +++++++++++++++++++++++-----------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ntfs/super.c             |   32 --
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |   14 
 b/fs/sync.c                   |   16 -
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   62 ++++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 -
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  429 +++++++++++++++++++++++++++++
 b/mm/page-writeback.c         |  140 ---------
 mm/pdflush.c                  |  251 -----------------
 b/mm/readahead.c              |   25 -
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 29 files changed, 889 insertions(+), 619 deletions(-)

-- 
Jens Axboe


