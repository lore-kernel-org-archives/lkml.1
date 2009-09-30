Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZI3FZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZI3FZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 01:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZI3FZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 01:25:32 -0400
Received: from thunk.org ([69.25.196.29]:52827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZI3FZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 01:25:31 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 for v2.6.32 round II
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Msrgx-0001br-MP@closure.thunk.org>
Date: Wed, 30 Sep 2009 01:25:31 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following changes for v2.6.32.

Thanks!!

                                                        - Ted

Curt Wohlgemuth (2):
      ext4: Make sure ext4_dirty_inode() updates the inode in no journal mode
      ext4: Handle nested ext4_journal_start/stop calls without a journal

Frank Mayhar (1):
      ext4: Avoid updating the inode table bh twice in no journal mode

Jan Kara (1):
      ext4: Update documentation about quota mount options

Josh Stone (1):
      ext4: Add a stub for mpage_da_data in the trace header

Mingming Cao (4):
      ext4: release reserved quota when block reservation for delalloc retry
      ext4: Split uninitialized extents for direct I/O
      ext4: Use end_io callback to avoid direct I/O fallback to buffered I/O
      ext4: async direct IO for holes and fallocate support

Theodore Ts'o (8):
      ext4: Use ext4_msg() for ext4_da_writepage() errors
      ext4: Fix hueristic which avoids group preallocation for closed files
      ext4: Adjust ext4_da_writepages() to write out larger contiguous chunks
      ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
      ext4, jbd2: Drop unneeded printks at mount and unmount time
      ext4: Use tracepoints for mb_history trace file
      jbd2: Use tracepoints for history file
      ext4: Fix time encoding with extra epoch bits

 Documentation/filesystems/ext4.txt |   13 +-
 Documentation/filesystems/proc.txt |    1 -
 fs/ext4/ext4.h                     |   54 +++-
 fs/ext4/ext4_extents.h             |    7 +-
 fs/ext4/ext4_jbd2.h                |    6 +-
 fs/ext4/extents.c                  |  444 +++++++++++++++++++++++++---
 fs/ext4/fsync.c                    |    5 +
 fs/ext4/inode.c                    |  574 +++++++++++++++++++++++++++++++-----
 fs/ext4/mballoc.c                  |  305 +------------------
 fs/ext4/mballoc.h                  |   35 +---
 fs/ext4/migrate.c                  |    2 +-
 fs/ext4/move_extent.c              |   20 +-
 fs/ext4/namei.c                    |    3 +-
 fs/ext4/super.c                    |   99 ++++---
 fs/jbd2/checkpoint.c               |    7 +
 fs/jbd2/commit.c                   |   59 ++--
 fs/jbd2/journal.c                  |  196 +------------
 include/linux/jbd2.h               |   27 +--
 include/trace/events/ext4.h        |  178 +++++++++++-
 include/trace/events/jbd2.h        |   78 +++++
 20 files changed, 1362 insertions(+), 751 deletions(-)
