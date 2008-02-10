Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYBJGe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYBJGe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYBJGes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:34:48 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41745 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbYBJGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:34:46 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 update
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1JO5kV-0005WX-JJ@closure.thunk.org>
Date: Sun, 10 Feb 2008 01:33:11 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

These are mostly bug fixes that we've found since the last pull request.
The one non-bugfix change is that I've added a sanity check to assure
that production ext3 filesystems don't get mounted with ext4dev
accidentally.  The need for this was discovered when Eric Sandeen
started putting ext4 into Fedora's Rawhide release for initial testing.

Thanks,

						- Ted

Aneesh Kumar K.V (5):
      jbd2: Fix reference counting on the journal commit block's buffer head
      JBD2: Use the incompat macro for testing the incompat feature.
      ext4: Fix null bh pointer dereference in mballoc
      ext4: Fix circular locking dependency with migrate and rm.
      ext4: Don't panic in case of corrupt bitmap

Dave Kleikamp (1):
      JBD2:  Clear buffer_ordered flag for barried IO request on success

Eric Sandeen (2):
      allow in-inode EAs on ext4 root inode
      ext4: allocate struct ext4_allocation_context from a kmem cache

Jan Kara (2):
      jbd: Remove useless loop when writing commit record
      ext4: Fix Direct I/O locking

Mingming Cao (1):
      jbd2: Add error check to journal_wait_on_commit_record to avoid oops

Theodore Tso (1):
      ext4: Add new "development flag" to the ext4 filesystem

Valerie Clement (1):
      ext4: Don't set EXTENTS_FL flag for fast symlinks

 fs/ext4/inode.c         |  115 +++++++++++++++-----------------
 fs/ext4/mballoc.c       |  164 ++++++++++++++++++++++++++++++-----------------
 fs/ext4/migrate.c       |  123 +++++++++++++++++++++++------------
 fs/ext4/namei.c         |    1 +
 fs/ext4/super.c         |   11 +++
 fs/jbd/commit.c         |   14 ++--
 fs/jbd2/commit.c        |   10 ++-
 fs/jbd2/recovery.c      |    2 +-
 include/linux/ext4_fs.h |    7 ++
 9 files changed, 270 insertions(+), 177 deletions(-)

