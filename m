Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZIHJX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZIHJX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZIHJXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:23:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56751 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZIHJXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:23:54 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/8] Per-bdi writeback flusher threads v19
Date: Tue,  8 Sep 2009 11:23:03 +0200
Message-Id: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 19th release of the writeback patchset. Changes since
v18 include:

- Switch unpin_sb_for_writeback() to using put_super() instead of
  __put_super_and_need_start(). This means making put_super()
  non-static, but we don't have to export it.
- Always check and clean old data.
- Don't copy *wbc twice in wb_do_writeback().
- Tweak 'when to break' logic in wb_writeback().
- Get rid of wb_start_writeback() and bdi_sched_work(), fold them into
  bdi_queue_work().

Thanks to Jan Kara and Christoph Hellwig for their suggestions and
review!

 b/block/blk-core.c                 |    1 
 b/drivers/block/aoe/aoeblk.c       |    1 
 b/drivers/char/mem.c               |    1 
 b/drivers/staging/pohmelfs/inode.c |    9 
 b/fs/btrfs/disk-io.c               |    1 
 b/fs/buffer.c                      |    2 
 b/fs/char_dev.c                    |    1 
 b/fs/configfs/inode.c              |    1 
 b/fs/fs-writeback.c                | 1058 +++++++++++++++++++++--------
 b/fs/fuse/inode.c                  |    1 
 b/fs/hugetlbfs/inode.c             |    1 
 b/fs/nfs/client.c                  |    1 
 b/fs/ocfs2/dlm/dlmfs.c             |    1 
 b/fs/ramfs/inode.c                 |    1 
 b/fs/super.c                       |    5 
 b/fs/sync.c                        |   20 
 b/fs/sysfs/inode.c                 |    1 
 b/fs/ubifs/budget.c                |   16 
 b/fs/ubifs/super.c                 |    9 
 b/include/linux/backing-dev.h      |   55 +
 b/include/linux/fs.h               |    9 
 b/include/linux/writeback.h        |   24 
 b/kernel/cgroup.c                  |    1 
 b/kernel/sysctl.c                  |    8 
 b/mm/Makefile                      |    2 
 b/mm/backing-dev.c                 |  380 ++++++++++
 b/mm/page-writeback.c              |  188 -----
 b/mm/swap_state.c                  |    1 
 b/mm/vmscan.c                      |    2 
 mm/pdflush.c                       |  269 -------
 30 files changed, 1292 insertions(+), 778 deletions(-)

-- 
Jens Axboe

