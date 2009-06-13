Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZFMFR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZFMFR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZFMFRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:17:19 -0400
Received: from relay3.sgi.com ([192.48.156.57]:49700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751698AbZFMFRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:17:19 -0400
Date: Sat, 13 Jun 2009 00:17:08 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.31-rc1
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090613051708.5B55DA0BB925@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f3ad116588151b3371ae4e092290e4f48e62b8bb:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jlbec/configfs

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (13):
      xfs: a couple getbmap cleanups
      xfs: fix getbmap vs mmap deadlock
      xfs: update max log size
      xfs: validate quota log items during log recovery
      xfs: kill xfs_qmops
      xfs: split inode flushing from xfs_sync_inodes_ag
      xfs: use generic inode iterator in xfs_qm_dqrele_all_inodes
      xfs: split xfs_sync_inodes
      xfs: remove SYNC_IOWAIT
      xfs: remove SYNC_BDFLUSH
      xfs: use generic Posix ACL code
      xfs: fix warnings with CONFIG_XFS_QUOTA disabled
      xfs: fix small mismerge in xfs_vn_mknod

Dave Chinner (4):
      xfs: split inode data writeback from xfs_sync_inodes_ag
      xfs: factor out inode validation for sync
      xfs: remove unused parameter from xfs_reclaim_inodes
      xfs: introduce a per-ag inode iterator

Eric Sandeen (1):
      xfs: fix overflow in xfs_growfs_data_private

Felix Blyakher (6):
      xfs: fix double unlock in xfs_swap_extents()
      xfs: prevent deadlock in xfs_qm_shake()
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
      xfs: fix freeing memory in xfs_getbmap()
      Merge branch 'master' of git://oss.sgi.com/xfs/xfs into for-linus

Lachlan McIlroy (1):
      xfs_file_last_byte() needs to acquire ilock

Olaf Weber (1):
      xfs: add more checks to superblock validation

 fs/xfs/Kconfig                  |    1 +
 fs/xfs/Makefile                 |    5 +-
 fs/xfs/linux-2.6/xfs_acl.c      |  523 +++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_ioctl.c    |   25 +-
 fs/xfs/linux-2.6/xfs_iops.c     |   53 +--
 fs/xfs/linux-2.6/xfs_lrw.c      |    1 -
 fs/xfs/linux-2.6/xfs_quotaops.c |    4 +-
 fs/xfs/linux-2.6/xfs_super.c    |   49 ++-
 fs/xfs/linux-2.6/xfs_sync.c     |  479 +++++++++++----------
 fs/xfs/linux-2.6/xfs_sync.h     |   19 +-
 fs/xfs/linux-2.6/xfs_xattr.c    |   67 +---
 fs/xfs/quota/xfs_dquot.c        |    5 +-
 fs/xfs/quota/xfs_dquot.h        |    1 -
 fs/xfs/quota/xfs_dquot_item.c   |    1 -
 fs/xfs/quota/xfs_qm.c           |  168 ++++----
 fs/xfs/quota/xfs_qm.h           |   21 -
 fs/xfs/quota/xfs_qm_bhv.c       |   77 +----
 fs/xfs/quota/xfs_qm_stats.c     |    1 -
 fs/xfs/quota/xfs_qm_syscalls.c  |  113 ++----
 fs/xfs/quota/xfs_trans_dquot.c  |   66 ++--
 fs/xfs/xfs_acl.c                |  874 ---------------------------------------
 fs/xfs/xfs_acl.h                |   97 ++---
 fs/xfs/xfs_ag.h                 |    2 +
 fs/xfs/xfs_arch.h               |   32 --
 fs/xfs/xfs_attr.c               |   13 +-
 fs/xfs/xfs_bmap.c               |   34 +-
 fs/xfs/xfs_bmap_btree.c         |    4 +-
 fs/xfs/xfs_filestream.c         |    6 +-
 fs/xfs/xfs_fs.h                 |   11 +-
 fs/xfs/xfs_iget.c               |    8 +-
 fs/xfs/xfs_inode.c              |    1 -
 fs/xfs/xfs_inode.h              |    6 +
 fs/xfs/xfs_iomap.c              |   13 +-
 fs/xfs/xfs_log_recover.c        |   38 ++-
 fs/xfs/xfs_mount.c              |  105 ++++-
 fs/xfs/xfs_mount.h              |   84 +----
 fs/xfs/xfs_qmops.c              |  152 -------
 fs/xfs/xfs_quota.h              |  129 +++---
 fs/xfs/xfs_rename.c             |    3 +-
 fs/xfs/xfs_rw.c                 |    1 -
 fs/xfs/xfs_trans.c              |   15 +-
 fs/xfs/xfs_utils.c              |    2 +-
 fs/xfs/xfs_vnodeops.c           |  114 +++---
 fs/xfs/xfs_vnodeops.h           |    1 +
 44 files changed, 1341 insertions(+), 2083 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_acl.c
 delete mode 100644 fs/xfs/xfs_acl.c
 delete mode 100644 fs/xfs/xfs_qmops.c
