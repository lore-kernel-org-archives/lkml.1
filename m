Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZIOSQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZIOSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIOSQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:16:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59520 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbZIOSQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:51 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: [PATCH 0/11] Post merge per-bdi writeback patches v3
Date: Tue, 15 Sep 2009 20:16:46 +0200
Message-Id: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Another set of post-merge patches, building on top of the
stuff posted the other day.

Includes cleanups as well as a fix not getting the range_cyclic
vs range_start/end set correctly, a fix for the warning that
triggered in bdi_destroy(), killing bdev->bd_inode_backing_dev_info
and wbc->for_writepages. We remove more code than we add, but with
some added comments the diffstat ends up looking like this:

 fs/afs/write.c              |    1 
 fs/block_dev.c              |    1 
 fs/btrfs/disk-io.c          |    1 
 fs/btrfs/ordered-data.c     |    1 
 fs/fs-writeback.c           |  351 ++++++++++++++++--------------------
 fs/fuse/inode.c             |    2 
 fs/inode.c                  |    4 
 fs/jbd2/commit.c            |    1 
 fs/nfs/write.c              |    1 
 fs/nilfs2/the_nilfs.c       |    4 
 fs/super.c                  |    6 
 fs/sync.c                   |    9 
 fs/ubifs/budget.c           |   20 --
 fs/ubifs/super.c            |    1 
 include/linux/backing-dev.h |    3 
 include/linux/fs.h          |    2 
 include/linux/writeback.h   |    5 
 include/trace/events/ext4.h |    6 
 mm/backing-dev.c            |   90 ++++++---
 mm/page-writeback.c         |   22 --
 20 files changed, 265 insertions(+), 266 deletions(-)

Please review!

-- 
Jens Axboe

