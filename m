Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZIKHeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZIKHeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZIKHeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:34:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44820 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbZIKHeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:34:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/7] Per-bdi writeback flusher threads v20
Date: Fri, 11 Sep 2009 09:34:03 +0200
Message-Id: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(sorry if you receive this twice, the original posting had a mangled
 From address).

This is the 20th release of the writeback patchset. Changes since
v19 include:

- Drop the max writeback pages patch from Ted. I think we should do
  something to that effect, but there's really no reason to entangle
  it with this patchset.
- Fix two checkpatch warnings on missing KERN_*.
- Rebase to 2.6.31, the aoe patch conflicted with the v19.

So essentially only a few cosmetic changes, and the dropping of a patch.
Please review and ack, I'd like to send this in very shortly. Thanks!

 b/block/blk-core.c                 |    1 
 b/drivers/block/aoe/aoeblk.c       |    1 
 b/drivers/char/mem.c               |    1 
 b/drivers/staging/pohmelfs/inode.c |    9 
 b/fs/btrfs/disk-io.c               |    1 
 b/fs/buffer.c                      |    2 
 b/fs/char_dev.c                    |    1 
 b/fs/configfs/inode.c              |    1 
 b/fs/fs-writeback.c                | 1065 +++++++++++++++++++++--------
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
 b/include/linux/writeback.h        |   23 
 b/kernel/cgroup.c                  |    1 
 b/mm/Makefile                      |    2 
 b/mm/backing-dev.c                 |  381 ++++++++++
 b/mm/page-writeback.c              |  182 ----
 b/mm/swap_state.c                  |    1 
 b/mm/vmscan.c                      |    2 
 mm/pdflush.c                       |  269 -------
 29 files changed, 1285 insertions(+), 778 deletions(-)

-- 
Jens Axboe

