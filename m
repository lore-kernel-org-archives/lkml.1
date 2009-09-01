Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZIALTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZIALTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZIALTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:19:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45105 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbZIALTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:19:38 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/8] Per-bdi writeback flusher threads v16
Date: Tue,  1 Sep 2009 13:18:58 +0200
Message-Id: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 16th version of the writeback patches. Changes since v15:

- Fix a newly introduced build failure in ubifs
- Split the 'move super_block to writeback_control' into a prep patch.
- Elevate super_block ref count before diving into generic_sync_sb_inodes(),
  not sure about this approach yet. Should match the old code, but perhaps
  we can do better. This fixes the issue that Ted saw with delayed writeout
  of dirty inodes after RO mount.
- Pass wbc around in fs-writeback.c instead of 3-4 arguments.

 b/block/blk-core.c                 |    1 
 b/drivers/block/aoe/aoeblk.c       |    1 
 b/drivers/char/mem.c               |    1 
 b/drivers/staging/pohmelfs/inode.c |    3 
 b/fs/btrfs/disk-io.c               |    1 
 b/fs/buffer.c                      |    2 
 b/fs/char_dev.c                    |    1 
 b/fs/configfs/inode.c              |    1 
 b/fs/fs-writeback.c                |  908 ++++++++++++++++++++---------
 b/fs/fuse/inode.c                  |    1 
 b/fs/hugetlbfs/inode.c             |    1 
 b/fs/nfs/client.c                  |    1 
 b/fs/ocfs2/dlm/dlmfs.c             |    1 
 b/fs/ramfs/inode.c                 |    1 
 b/fs/super.c                       |    3 
 b/fs/sync.c                        |    2 
 b/fs/sysfs/inode.c                 |    1 
 b/fs/ubifs/budget.c                |    5 
 b/fs/ubifs/super.c                 |    4 
 b/include/linux/backing-dev.h      |   56 +
 b/include/linux/fs.h               |   10 
 b/include/linux/writeback.h        |   19 
 b/kernel/cgroup.c                  |    1 
 b/kernel/sysctl.c                  |    8 
 b/mm/Makefile                      |    2 
 b/mm/backing-dev.c                 |  379 +++++++++++-
 b/mm/page-writeback.c              |  174 +----
 b/mm/swap_state.c                  |    1 
 b/mm/vmscan.c                      |    2 
 mm/pdflush.c                       |  269 --------
 30 files changed, 1162 insertions(+), 698 deletions(-)

-- 
Jens Axboe

