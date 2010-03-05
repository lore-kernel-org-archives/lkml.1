Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0CEUk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:40:26 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751755Ab0CEUkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:40:25 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003052040.o25KeH1g013314@stout.americas.sgi.com>
Date: Fri, 05 Mar 2010 14:40:17 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.34-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I mentioned in my first pull request, this is the second
set of XFS commits for 2.6.34-rc1.  A little later than I'd
hoped (sorry).

					-Alex

The following changes since commit 9467c4fdd66f6810cecef0f1173330f3c6e67d45:
  Linus Torvalds (1):
        Merge branch 'write_inode2' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'for-2.6.34-rc1-batch2' into for-linus

Christoph Hellwig (14):
      xfs: fix dquota trace format
      xfs: merge xfs_lrw.c into xfs_file.c
      xfs: remove wrappers for read/write file operations
      xfs: remove wrapper for the fsync file operation
      xfs: implement optimized fdatasync
      xfs: fix inode pincount check in fsync
      xfs: fix xfs_fsblock_t tracing
      xfs: split xfs_bmap_btalloc
      xfs: stop passing opaque handles to xfs_log.c routines
      xfs: factor common xfs_trans_bjoin code
      xfs: kill xfs_lrw.h
      xfs: cleanup xfs_iunpin_wait/xfs_iunpin_nowait
      xfs: remove xfs_ipin/xfs_iunpin
      xfs: fix locking for inode cache radix tree tag updates

Dave Chinner (6):
      xfs: Non-blocking inode locking in IO completion
      xfs: Fix a build warning in xfs_aops.c
      xfs: check for more work before sleeping in xfssyncd
      xfs: truncate delalloc extents when IO fails in writeback
      xfs: Increase the default size of the reserved blocks pool
      xfs: return inode fork offset in bulkstat for fsr

Eric Sandeen (1):
      xfs: increase readdir buffer size

 fs/xfs/Makefile              |    1 -
 fs/xfs/linux-2.6/xfs_aops.c  |  221 +++++++++---
 fs/xfs/linux-2.6/xfs_file.c  |  854 +++++++++++++++++++++++++++++++++++++++---
 fs/xfs/linux-2.6/xfs_iops.c  |   10 +
 fs/xfs/linux-2.6/xfs_linux.h |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c   |  796 ---------------------------------------
 fs/xfs/linux-2.6/xfs_lrw.h   |   29 --
 fs/xfs/linux-2.6/xfs_sync.c  |   10 +-
 fs/xfs/linux-2.6/xfs_trace.c |   16 -
 fs/xfs/linux-2.6/xfs_trace.h |   22 +-
 fs/xfs/xfs_bmap.c            |  220 ++++++-----
 fs/xfs/xfs_fs.h              |    3 +-
 fs/xfs/xfs_iget.c            |   19 +-
 fs/xfs/xfs_inode.c           |   68 +---
 fs/xfs/xfs_inode.h           |    3 +-
 fs/xfs/xfs_inode_item.c      |   18 +-
 fs/xfs/xfs_itable.c          |    2 +
 fs/xfs/xfs_log.c             |  106 +++---
 fs/xfs/xfs_log.h             |   16 +-
 fs/xfs/xfs_mount.c           |   69 +++-
 fs/xfs/xfs_mount.h           |    2 +
 fs/xfs/xfs_trans.c           |    2 +-
 fs/xfs/xfs_trans.h           |    2 +-
 fs/xfs/xfs_trans_buf.c       |  216 ++++--------
 fs/xfs/xfs_vnodeops.c        |  107 ------
 fs/xfs/xfs_vnodeops.h        |   15 +-
 26 files changed, 1344 insertions(+), 1484 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/xfs_lrw.c
 delete mode 100644 fs/xfs/linux-2.6/xfs_lrw.h
