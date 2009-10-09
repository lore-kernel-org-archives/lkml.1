Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbZJIRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbZJIRam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZJIRal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:30:41 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32961 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZJIRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:30:40 -0400
Date: Fri, 9 Oct 2009 13:29:44 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.32-rc
Message-ID: <20091009172944.GB2632@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ACF730F.0167:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Btrfs updates are in the master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

This branch is still against 2.6.31, but git merging lets it work with
the code Linus has already pulled and merged into 2.6.32-rc

This bunch fine tunes the enospc support, removing a window where the
accounting would let people allocate even though space wasn't yet
available.

There is a deadlock fix where the worker threads would get stuck waiting
for memory while trying to start more worker threads, and an important
fix for the file clone ioctl where it can incorrectly setup extents on the
clone.

Alexey Dobriyan (1) commits (+2/-2):
    Btrfs: constify dentry_operations

Chris Mason (5) commits (+166/-73):
    Btrfs: delay clearing EXTENT_DELALLOC for compressed extents (+4/-2)
    Btrfs: fix uninit compiler warning in cow_file_range_nocow (+1/-0)
    Btrfs: cleanup extent_clear_unlock_delalloc flags (+51/-37)
    Btrfs: fix file clone ioctl for bookend extents (+4/-2)
    Btrfs: fix deadlock on async thread startup (+106/-32)

Josef Bacik (4) commits (+225/-55):
    Btrfs: release delalloc reservations on extent item insertion (+107/-37)
    Btrfs: async delalloc flushing under space pressure (+88/-11)
    Btrfs: optimize fsync for the single writer case (+13/-1)
    Btrfs: fix possible softlockup in the allocator (+17/-6)

Zheng Yan (2) commits (+61/-34):
    Btrfs: optimize back reference update during btrfs_drop_snapshot (+53/-29)
    Btrfs: remove negative dentry when deleting subvolumne (+8/-5)

Total: (12) commits

 fs/btrfs/async-thread.c |   81 ++++++++++++++--
 fs/btrfs/async-thread.h |   10 +-
 fs/btrfs/btrfs_inode.h  |   12 +-
 fs/btrfs/ctree.h        |   21 ++--
 fs/btrfs/disk-io.c      |   48 +++++----
 fs/btrfs/extent-tree.c  |  239 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/extent_io.c    |   46 ++++-----
 fs/btrfs/extent_io.h    |   18 ++-
 fs/btrfs/file.c         |    3 
 fs/btrfs/inode.c        |  111 ++++++++++++++--------
 fs/btrfs/ioctl.c        |    7 +
 fs/btrfs/ordered-data.c |    6 +
 fs/btrfs/relocation.c   |    4 
 fs/btrfs/tree-log.c     |   12 ++
 14 files changed, 454 insertions(+), 164 deletions(-)
