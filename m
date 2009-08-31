Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZHaTle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZHaTle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZHaTld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:41:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35091 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZHaTlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:41:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/7] Per-bdi writeback flusher threads v15
Date: Mon, 31 Aug 2009 21:41:26 +0200
Message-Id: <1251747693-32354-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 15th version of the writeback patches. Changes since v14:

- Collapsed a few patches and got rid of the multiple thread support.
  The work items remain, it's been well tested and means that you
  can queue work for a bdi without blocking and waiting for it to
  finish the existing work. Lazy exit is now included in the
  first patch.
- I kept the 'remove pdflush' patch separate. The main patch is
  already big enough, and thinking about it, I think it makes sense
  to retain as a separate patch.

Christoph, let me know if there are things you are still not happy
with and I will reply/address them. Note that this series has only
received a light testing. This means that it boots and seems to work
(flushes data on sync and at intervals) and does not corrupt data,
but it hasn't received a thorough testing yet. That will come tomorrow.
But I wanted to push this out there, so we can settle the code base
quickly again.

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |    1 
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  907 ++++++++++++++++++++++++----------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sync.c                   |    2 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   57 ++
 b/include/linux/fs.h          |   10 
 b/include/linux/writeback.h   |   19 
 b/kernel/cgroup.c             |    1 
 b/kernel/sysctl.c             |    8 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  379 +++++++++++++-
 b/mm/page-writeback.c         |  165 +-----
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 ----------
 28 files changed, 1145 insertions(+), 695 deletions(-)

-- 
Jens Axboe

