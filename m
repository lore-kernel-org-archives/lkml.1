Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZIPDRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZIPDRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZIPDRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:17:41 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59573 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbZIPDRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:17:40 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [GIT PULL] XFS update for 2.6.32-rc1
Date: Tue, 15 Sep 2009 22:15:44 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AC93@cf--amer001e--3.americas.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PULL] XFS update for 2.6.32-rc1
Thread-Index: Aco2e/v8C2RDwI7OS4CKnQiHC93q9w==
From: "Alex Elder" <aelder@sgi.com>
To: <torvalds@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <xfs@oss.sgi.com>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0cb583fd2862f19ea88b02eb307d11c09e51e2f8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-next-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git for-linus

Alex Elder (4):
      xfs: xfs_showargs() reports group *and* project quotas enabled
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      xfs: Record new maintainer information
      Merge branch 'master' of git://oss.sgi.com/xfs/xfs into for-linus

Alexey Dobriyan (1):
      xfs: switch to seq_file

Christoph Hellwig (21):
      xfs: avoid memory allocation under m_peraglock in growfs code
      xfs: switch to NOFS allocation under i_lock in xfs_getbmap
      xfs: switch to NOFS allocation under i_lock in xfs_da_state_alloc
      xfs: switch to NOFS allocation under i_lock in xfs_da_buf_make
      xfs: switch to NOFS allocation under i_lock in xfs_dir_cilookup_result
      xfs: switch to NOFS allocation under i_lock in xfs_buf_associate_memory
      xfs: switch to NOFS allocation under i_lock in xfs_attr_rmtval_set
      xfs: switch to NOFS allocation under i_lock in xfs_readlink_bmap
      xfs: switch to NOFS allocation under i_lock in xfs_attr_rmtval_get
      xfs: check for dinode realtime flag corruption
      xfs: fix spin_is_locked assert on uni-processor builds
      xfs: fix locking in xfs_iget_cache_hit
      xfs: improve xfs_inobt_get_rec prototype
      xfs: improve xfs_inobt_update prototype
      xfs: untangle xfs_dialloc
      xfs: rationalize xfs_inobt_lookup*
      xfs: merge fsync and O_SYNC handling
      xfs: simplify xfs_trans_iget
      xfs: actually enable the swapext compat handler
      xfs: un-static xfs_inobt_lookup
      xfs: use correct log reservation when handling ENOSPC in xfs_create

Dave Chinner (3):
      xfs: factor out inode initialisation
      xfs: factor out debug checks from xfs_dialloc and xfs_difree
      xfs: speed up free inode search

Eric Sandeen (9):
      xfs: add more statics & drop some unused functions
      un-static xfs_read_agf
      xfs: remove XFS_INO64_OFFSET
      xfs: reduce bmv_count in xfs_vn_fiemap
      xfs: bump up nr_to_write in xfs_vm_writepage
      use XFS_CORRUPTION_ERROR in xfs_btree_check_sblock
      xfs: add more statics & drop some unused functions
      un-static xfs_read_agf
      xfs: remove XFS_INO64_OFFSET

Felix Blyakher (1):
      Merge branch 'master' of ssh+git://oss.sgi.com/oss/git/xfs/xfs

Jaswinder Singh Rajput (1):
      xfs: includecheck fix for fs/xfs/xfs_iops.c

Julia Lawall (2):
      fs/xfs: Correct redundant test
      fs/xfs: Correct redundant test

 MAINTAINERS                  |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c  |    1 -
 fs/xfs/linux-2.6/xfs_file.c  |   19 +-
 fs/xfs/linux-2.6/xfs_iops.c  |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c   |    8 +-
 fs/xfs/linux-2.6/xfs_stats.c |   51 ++--
 fs/xfs/linux-2.6/xfs_super.c |   24 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   15 -
 fs/xfs/linux-2.6/xfs_sync.h  |    1 -
 fs/xfs/quota/xfs_qm_stats.c  |   78 ++---
 fs/xfs/xfs_ag.h              |    9 +
 fs/xfs/xfs_bmap.c            |    2 +-
 fs/xfs/xfs_bmap.h            |   11 -
 fs/xfs/xfs_bmap_btree.c      |   20 +-
 fs/xfs/xfs_bmap_btree.h      |    1 -
 fs/xfs/xfs_btree.c           |   42 +---
 fs/xfs/xfs_btree.h           |   15 -
 fs/xfs/xfs_ialloc.c          |  805 +++++++++++++++++++++---------------------
 fs/xfs/xfs_ialloc.h          |   18 +-
 fs/xfs/xfs_iget.c            |   27 --
 fs/xfs/xfs_inode.c           |    8 +-
 fs/xfs/xfs_inode.h           |    8 -
 fs/xfs/xfs_inode_item.c      |   10 -
 fs/xfs/xfs_inode_item.h      |    2 -
 fs/xfs/xfs_inum.h            |    1 -
 fs/xfs/xfs_itable.c          |   98 +++---
 fs/xfs/xfs_itable.h          |    5 -
 fs/xfs/xfs_log_priv.h        |    2 -
 fs/xfs/xfs_log_recover.c     |    2 +-
 fs/xfs/xfs_mount.c           |    2 +-
 fs/xfs/xfs_mount.h           |    3 -
 fs/xfs/xfs_mru_cache.c       |   29 --
 fs/xfs/xfs_mru_cache.h       |    1 -
 fs/xfs/xfs_rw.c              |   84 -----
 fs/xfs/xfs_rw.h              |    7 -
 fs/xfs/xfs_trans.h           |    2 +-
 fs/xfs/xfs_trans_buf.c       |    4 +-
 fs/xfs/xfs_trans_inode.c     |   86 +-----
 fs/xfs/xfs_vnodeops.c        |   17 +-
 39 files changed, 593 insertions(+), 928 deletions(-)
