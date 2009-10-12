Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZJLJsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZJLJsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZJLJsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:48:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60219 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZJLJsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:48:40 -0400
Date: Mon, 12 Oct 2009 11:48:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.32-rc5
Message-ID: <20091012094803.GB9228@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Apologies to Linus who will receive this twice, I forgot to CC lkml
 when posting it).

Hi Linus,

This mostly contains a handful of fixes for CFQ. Nothing major, but bugs
none the less. There's also an improvement in the space stripping for
the io scheduler switching, making that behave more consistently. The
buggy read/write in_flight commit is back, this time behaving as it
should. And finally, two minor writeback changes from Wu using
io_schedule() in balance_dirty_pages() to get proper iowait accounting
(we did this in .31 and earlier), and stripping a space in a new entry
in the sysfs debug bdi files to ease parsing.

Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Corrado Zoccolo (3):
      cfq-iosched: fix possible problem with jiffies wraparound
      cfq-iosched: fix think time allowed for seekers
      cfq-iosched: avoid probable slice overrun when idling

Jens Axboe (6):
      cfq-iosched: fix issue with rq-rq merging and fifo list ordering
      block: get rid of kblock_schedule_delayed_work()
      block: use proper BLK_RW_ASYNC in blk_queue_start_tag()
      cfq-iosched: abstract out the 'may this cfqq dispatch' logic
      cfq-iosched: fix the slice residual sign
      cfq-iosched: apply bool value where we return 0/1

KOSAKI Motohiro (1):
      elv_iosched_store(): fix strstrip() misuse

Nikanth Karthikesan (1):
      block: Seperate read and write statistics of in_flight requests v2

Randy Dunlap (1):
      blk-settings: fix function parameter kernel-doc notation

Wu Fengguang (2):
      writeback: account IO throttling wait as iowait
      writeback: kill space in debugfs item name

 block/blk-core.c       |   16 +---
 block/blk-merge.c      |    2 +-
 block/blk-settings.c   |    2 +-
 block/blk-tag.c        |    2 +-
 block/cfq-iosched.c    |  259 ++++++++++++++++++++++++++----------------------
 block/elevator.c       |    4 +-
 block/genhd.c          |    4 +-
 drivers/md/dm.c        |   16 ++-
 fs/partitions/check.c  |   12 ++-
 include/linux/blkdev.h |    4 -
 include/linux/genhd.h  |   21 +++--
 kernel/sched.c         |    3 -
 mm/backing-dev.c       |    2 +-
 mm/page-writeback.c    |    3 +-
 14 files changed, 191 insertions(+), 159 deletions(-)

-- 
Jens Axboe

