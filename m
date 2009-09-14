Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZINJgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZINJgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZINJga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:36:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38626 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZINJg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:36:29 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: [PATCH 0/7] Post merge per-bdi writeback patches v2
Date: Mon, 14 Sep 2009 11:36:27 +0200
Message-Id: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the writeback patches are now (at last!) in mainline, I renamed
this branch from writeback-postmerge to just plain writeback. The first
four patches are identical to the ones from friday, and then I added
three more patches. Two of them are cleanups to better separate the
WB_SYNC_NONE and WB_SYNC_ALL writeback paths, the latter is a fix for
when a bdi is destroyed whilst inodes are still attached. I don't see
a much better way to fix this at the moment, if inodes get requeued
at sync time, then it would complicate exit quite a lot. So just
move those entries to the default_backing_dev_info, which can handle
them at any time.

Patches are also available at:

  git://git.kernel.dk/linux-2.6-block.git writeback

 fs/btrfs/disk-io.c          |    1 
 fs/fs-writeback.c           |  181 ++++++++++++++----------------------
 fs/fuse/inode.c             |    2 
 fs/super.c                  |    6 +
 fs/sync.c                   |    9 +
 fs/ubifs/super.c            |    1 
 include/linux/backing-dev.h |    1 
 include/linux/fs.h          |    1 
 mm/backing-dev.c            |   88 +++++++++++++----
 mm/page-writeback.c         |    9 -
 10 files changed, 161 insertions(+), 138 deletions(-)

-- 
Jens Axboe


