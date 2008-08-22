Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYHVObC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYHVObC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYHVOaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:30:52 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41218 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751560AbYHVOav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:30:51 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1KWXf5-0004gv-P7@closure.thunk.org>
Date: Fri, 22 Aug 2008 10:30:47 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This patch series contains a number of bug fixes that fixes various
BUG() crashes discovered by early adopters for ext4 and by benchmarkers.
I'd really like to get these fixes included for 2.6.27.

Thanks!!

						- Ted

Diffstats:

 Documentation/filesystems/ext4.txt |    6 +
 fs/ext4/balloc.c                   |    3 +
 fs/ext4/dir.c                      |   20 ++-
 fs/ext4/ext4.h                     |    4 +
 fs/ext4/ext4_extents.h             |    4 +-
 fs/ext4/ext4_jbd2.h                |    8 +
 fs/ext4/extents.c                  |  113 ++++-----
 fs/ext4/ialloc.c                   |    2 +-
 fs/ext4/inode.c                    |  478 ++++++++++++++++++++++++------------
 fs/ext4/mballoc.c                  |   53 ++++-
 fs/ext4/migrate.c                  |    3 +-
 fs/ext4/resize.c                   |    3 +-
 fs/ext4/super.c                    |    1 +
 13 files changed, 460 insertions(+), 238 deletions(-)

Aneesh Kumar K.V (5):
      ext4: Handle unwritten extent properly with delayed allocation
      ext4: Rework the ext4_da_writepages() function
      ext4: make sure ext4_has_free_blocks returns 0 for ENOSPC
      ext4: Initialize writeback_index to 0 when allocating a new inode
      ext4: Fix small file fragmentation

Eric Sandeen (1):
      ext4: Fix bug where we return ENOSPC even though we have plenty of inodes

Josef Bacik (1):
      ext4: don't try to resize if there are no reserved gdt blocks left

Mingming Cao (5):
      ext4: Fix delalloc release block reservation for truncate
      ext4: journal credits calulation cleanup and fix for non-extent writepage
      ext4: journal credits reservation fixes for extent file writepage
      ext4: journal credits reservation fixes for DIO, fallocate
      ext4: journal credit fix for the delayed allocation's writepages() function

Theodore Ts'o (4):
      ext4: Fix potential truncate BUG due to i_prealloc_list being non-empty
      ext4: Fix ext4_dx_readdir hash collision handling
      ext4: Use ext4_discard_reservations instead of mballoc-specific call
      ext4: Update documentation to remind users to update mke2fs.conf

