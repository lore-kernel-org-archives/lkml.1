Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbXJOWx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbXJOWx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXJOWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:53:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46857 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbXJOWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:53:18 -0400
Date: Mon, 15 Oct 2007 18:53:16 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Trond Myklebust <trond@netapp.com>
Subject: [GIT] locks.c updates for 2.6.24
Message-ID: <20071015225316.GB31990@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You can pull the following file-locking changes from:

  git://linux-nfs.org/~bfields/linux.git locks

Cleanup, minor bugfixes and some documentation patches.  They've been in
-mm for a while.

(By the way, I've also started some very primitive lease and flock
tests, available from:

	git://linux-nfs.org/~bfields/lock-tests.git

and I'm mainly depending on those and connectathon locking tests for
now.)

--b.

J. Bruce Fields (7):
      locks: reverse order of posix_locks_conflict() arguments
      locks: kill redundant local variable
      locks: fix flock_lock_file() comment
      Documentation: move mandatory locking documentation to filesystems/
      locks: add warning about mandatory locking races
      Documentation: move locks.txt in filesystems/
      nfsd: remove IS_ISMNDLCK macro

Matthias Kaehlcke (1):
      fs/locks.c: use list_for_each_entry() instead of list_for_each()

Pavel Emelyanov (9):
      Memory shortage can result in inconsistent flocks state
      Use list_first_entry in locks_wake_up_blocks
      locks: Fix potential OOPS in generic_setlease()
      Cleanup macros for distinguishing mandatory locks
      GFS2: clean up explicit check for mandatory locks
      9PFS: clean up explicit check for mandatory locks
      AFS: clean up explicit check for mandatory locks
      NFS: clean up explicit check for mandatory locks
      Rework /proc/locks via seq_files and seq_list helpers

 Documentation/00-INDEX                             |    6 +-
 Documentation/filesystems/00-INDEX                 |    4 +
 Documentation/{ => filesystems}/locks.txt          |   10 +-
 .../mandatory-locking.txt}                         |   21 ++-
 fs/9p/vfs_file.c                                   |    2 +-
 fs/afs/flock.c                                     |    3 +-
 fs/gfs2/ops_file.c                                 |    4 +-
 fs/locks.c                                         |  192 +++++++++-----------
 fs/nfs/file.c                                      |    3 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/nfsd/vfs.c                                      |   13 +-
 fs/proc/proc_misc.c                                |   19 +-
 fs/read_write.c                                    |    2 +-
 include/linux/fs.h                                 |   22 ++-
 14 files changed, 157 insertions(+), 146 deletions(-)
 rename Documentation/{ => filesystems}/locks.txt (87%)
 rename Documentation/{mandatory.txt => filesystems/mandatory-locking.txt} (89%)
