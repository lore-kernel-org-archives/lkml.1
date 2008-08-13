Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYHMIMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYHMIMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYHMIL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:11:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752944AbYHMILv (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:11:51 -0400
Date: Wed, 13 Aug 2008 18:11:47 +1000
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.27-rc4
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
  Linus Torvalds (1):
        Linux 2.6.27-rc3

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/linux-2.6 master

Christoph Hellwig (22):
      [XFS] don't leak m_fsname/m_rtname/m_logname
      [XFS] Remove vn_from_inode()
      [XFS] kill vn_to_inode
      [XFS] remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c
      [XFS] remove remaining VN_HOLD calls
      [XFS] implement IHOLD/IRELE directly
      [XFS] kill INDUCE_IO_ERROR
      [XFS] kill xfs_lock_dir_and_entry
      [XFS] remove some easy bhv_vnode_t instances
      [XFS] kill bhv_vnode_t
      [XFS] sanitize xfs_initialize_vnode
      [XFS] small cleanups in xfs_btree.c
      [XFS] Use the same btree_cur union member for alloc and inobt trees.
      [XFS] update timestamp in xfs_ialloc manually
      [XFS] optimize xfs_ichgtime
      [XFS] stop using file_update_time
      [XFS] move root inode IRELE into xfs_unmountfs
      [XFS] cleanup xfs_mountfs
      [XFS] xfs_unmountfs should return void
      [XFS] don't call xfs_freesb from xfs_unmountfs
      [XFS] refactor xfs_mount_free
      [XFS] use KM_MAYFAIL in xfs_mountfs

David Chinner (12):
      [XFS] Use the generic bitops rather than implementing them ourselves.
      [XFS] Avoid directly referencing the VFS inode.
      [XFS] kill shouty XFS_ITOV_NULL macro
      [XFS] Kill shouty XFS_ITOV() macro
      [XFS] XFS: Kill xfs_vtoi()
      [XFS] Use KM_NOFS for incore inode extent tree allocation V2
      [XFS] clean up stale references to semaphores
      [XFS] replace the XFS buf iodone semaphore with a completion
      [XFS] extend completions to provide XFS object flush requirements
      [XFS] replace inode flush semaphore with a completion
      [XFS] replace dquot flush semaphore with a completion
      [XFS] remove the sema_t from XFS.

Eric Sandeen (3):
      [XFS] remove INT_GET and friends
      [XFS] convert xfs to use ERR_CAST
      [XFS] remove shouting-indirection macros from xfs_trans.h

Harvey Harrison (1):
      [XFS] use get_unaligned_* helpers

Lachlan McIlroy (4):
      [XFS] Do not access buffers after dropping reference count
      [XFS] Fix compile failure in xfs_buf_trace()
      [XFS] Use KM_NOFS for debug trace buffers
      [XFS] Fix use after free in xfs_log_done().

Niv Sardi (2):
      [XFS] Move attr log alloc size calculator to another function.
      [XFS] Move xfs_attr_rolltrans to xfs_trans_roll

Ruben Porras (1):
      [XFS] Make xfs_bmap_*_count_leaves void.

 fs/xfs/linux-2.6/sema.h        |   52 -----------
 fs/xfs/linux-2.6/xfs_aops.c    |    3 +-
 fs/xfs/linux-2.6/xfs_buf.c     |   16 ++--
 fs/xfs/linux-2.6/xfs_buf.h     |    4 +-
 fs/xfs/linux-2.6/xfs_export.c  |   10 +-
 fs/xfs/linux-2.6/xfs_fs_subr.c |    6 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |    4 +-
 fs/xfs/linux-2.6/xfs_iops.c    |  192 +++++++++++++++++++++++++---------------
 fs/xfs/linux-2.6/xfs_iops.h    |   15 +---
 fs/xfs/linux-2.6/xfs_linux.h   |    4 +-
 fs/xfs/linux-2.6/xfs_lrw.c     |    6 +-
 fs/xfs/linux-2.6/xfs_super.c   |  189 +++++++++++-----------------------------
 fs/xfs/linux-2.6/xfs_super.h   |    3 -
 fs/xfs/linux-2.6/xfs_vnode.c   |   22 +----
 fs/xfs/linux-2.6/xfs_vnode.h   |   65 +++++---------
 fs/xfs/quota/xfs_dquot.c       |   38 +++-----
 fs/xfs/quota/xfs_dquot.h       |   29 ++++---
 fs/xfs/quota/xfs_dquot_item.c  |    8 +-
 fs/xfs/quota/xfs_qm.c          |   14 ++--
 fs/xfs/quota/xfs_qm.h          |    2 +-
 fs/xfs/quota/xfs_qm_bhv.c      |    7 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    4 +-
 fs/xfs/xfs_acl.c               |   52 +++++------
 fs/xfs/xfs_acl.h               |   14 ++--
 fs/xfs/xfs_arch.h              |   68 --------------
 fs/xfs/xfs_attr.c              |  110 ++++++++++++++---------
 fs/xfs/xfs_attr.h              |    1 +
 fs/xfs/xfs_attr_leaf.c         |   75 ++--------------
 fs/xfs/xfs_attr_leaf.h         |    2 -
 fs/xfs/xfs_bit.c               |  103 ---------------------
 fs/xfs/xfs_bit.h               |   34 ++++++-
 fs/xfs/xfs_bmap.c              |   34 +++-----
 fs/xfs/xfs_btree.c             |  105 ++++++++--------------
 fs/xfs/xfs_btree.h             |    8 +--
 fs/xfs/xfs_buf_item.c          |    4 +-
 fs/xfs/xfs_dfrag.c             |   33 ++-----
 fs/xfs/xfs_error.c             |    5 +-
 fs/xfs/xfs_error.h             |   12 +--
 fs/xfs/xfs_filestream.c        |    2 +-
 fs/xfs/xfs_ialloc_btree.c      |   30 +++---
 fs/xfs/xfs_iget.c              |   48 ++++------
 fs/xfs/xfs_inode.c             |   66 +++++++-------
 fs/xfs/xfs_inode.h             |   46 ++++++++--
 fs/xfs/xfs_inode_item.c        |   11 +--
 fs/xfs/xfs_itable.c            |    4 +-
 fs/xfs/xfs_log.c               |   86 ++++++++----------
 fs/xfs/xfs_log.h               |    2 +-
 fs/xfs/xfs_log_priv.h          |   14 ++--
 fs/xfs/xfs_log_recover.c       |    7 +-
 fs/xfs/xfs_mount.c             |   82 ++++++------------
 fs/xfs/xfs_mount.h             |   17 +---
 fs/xfs/xfs_rtalloc.c           |   19 ++---
 fs/xfs/xfs_rw.c                |    2 +-
 fs/xfs/xfs_trans.c             |   75 ++++++++++++++--
 fs/xfs/xfs_trans.h             |   12 +---
 fs/xfs/xfs_trans_buf.c         |   12 ++--
 fs/xfs/xfs_trans_item.c        |   66 +++++++-------
 fs/xfs/xfs_utils.c             |    4 +-
 fs/xfs/xfs_utils.h             |    3 -
 fs/xfs/xfs_vfsops.c            |   13 ++--
 fs/xfs/xfs_vnodeops.c          |  190 +++++++++++----------------------------
 include/linux/completion.h     |   45 +++++++++
 62 files changed, 883 insertions(+), 1326 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sema.h
