Return-Path: <linux-kernel-owner+w=401wt.eu-S1761883AbZLKVhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883AbZLKVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759017AbZLKVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:37:46 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55454 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758502AbZLKVhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:37:46 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200912112137.nBBLbgfl022033@stout.americas.sgi.com>
Date: Fri, 11 Dec 2009 15:37:41 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] (re-do) XFS update for 2.6.33-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second try.  Sorry about the first one yesterday.  This should be
much cleaner...

					-Alex

The following changes since commit 22763c5cf3690a681551162c15d34d935308c8d7:
  Linus Torvalds (1):
        Linux 2.6.32

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Andy Poling (1):
      xfs: Wrapped journal record corruption on read at recovery

Christoph Hellwig (13):
      xfs: simplify inode teardown
      xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
      xfs: I/O completion handlers must use NOFS allocations
      xfs: reset the i_iolock lock class in the reclaim path
      xfs: use WRITE_SYNC_PLUG for synchronous writeout
      xfs: cleanup data end I/O handlers
      xfs: remove IO_ISAIO
      xfs: simplify xfs_buf_get / xfs_buf_read interfaces
      xfs: rename xfs_attr_fetch to xfs_attr_get_int
      xfs: uninline xfs_get_extsz_hint
      xfs: kill the STATIC_INLINE macro
      xfs: remove incorrect sparse annotation for xfs_iget_cache_miss
      xfs: cleanup dmapi macros in the umount path

Jason Gunthorpe (1):
      xfs: Fix error return for fallocate() on XFS

 fs/xfs/linux-2.6/xfs_aops.c  |  114 ++++++++++++++----------------------------
 fs/xfs/linux-2.6/xfs_buf.c   |   14 +++---
 fs/xfs/linux-2.6/xfs_buf.h   |    9 +---
 fs/xfs/linux-2.6/xfs_file.c  |    4 +-
 fs/xfs/linux-2.6/xfs_iops.c  |    6 +-
 fs/xfs/linux-2.6/xfs_lrw.c   |    5 --
 fs/xfs/linux-2.6/xfs_super.c |   71 +++++++++++++++++---------
 fs/xfs/linux-2.6/xfs_sync.c  |   15 ++----
 fs/xfs/linux-2.6/xfs_sync.h  |    1 -
 fs/xfs/linux-2.6/xfs_vnode.h |    1 -
 fs/xfs/support/debug.h       |   18 -------
 fs/xfs/xfs_attr.c            |   16 ++++--
 fs/xfs/xfs_attr.h            |    1 -
 fs/xfs/xfs_attr_leaf.c       |    2 +-
 fs/xfs/xfs_bmap_btree.c      |    3 +-
 fs/xfs/xfs_filestream.h      |    8 ++--
 fs/xfs/xfs_fsops.c           |   25 +++++----
 fs/xfs/xfs_ialloc.c          |    2 +-
 fs/xfs/xfs_iget.c            |    5 ++-
 fs/xfs/xfs_iomap.c           |    9 +++-
 fs/xfs/xfs_log_recover.c     |   40 ++++++---------
 fs/xfs/xfs_mount.c           |   18 +++---
 fs/xfs/xfs_mount.h           |   27 ++++++++--
 fs/xfs/xfs_rw.c              |   30 ++++++++++--
 fs/xfs/xfs_rw.h              |   29 +----------
 fs/xfs/xfs_trans.c           |    7 ++-
 fs/xfs/xfs_trans.h           |    2 +-
 fs/xfs/xfs_trans_buf.c       |   13 ++---
 fs/xfs/xfs_vnodeops.c        |   79 ++++++++++-------------------
 fs/xfs/xfs_vnodeops.h        |    1 -
 30 files changed, 254 insertions(+), 321 deletions(-)
