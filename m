Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbZCZBWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbZCZBWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZCZBWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:22:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZCZBWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:22:15 -0400
Date: Thu, 26 Mar 2009 02:22:07 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tytso@mit.edu, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] Quota changes for 2.6.30
Message-ID: <20090326012207.GG11024@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus

  to get quota related changes for 2.6.30:

Jan Kara (20):
      ext3: Remove unnecessary quota functions
      ext4: Remove unnecessary quota functions
      reiserfs: Remove unnecessary quota functions
      quota: Move quota files into separate directory
      quota: Make global quota locks cacheline aligned
      quota: Remove NODQUOT macro
      quota: Remove dqbuf_t and other cleanups
      vfs: Use lowercase names of quota functions
      ramfs: Remove quota call
      ext2: Use lowercase names of quota functions
      ext3: Use lowercase names of quota functions
      ext4: Use lowercase names of quota functions
      reiserfs: Use lowercase names of quota functions
      ufs: Use lowercase names of quota functions
      udf: Use lowercase names of quota functions
      jfs: Use lowercase names of quota functions
      nfsd: Use lowercase names of quota functions
      quota: Remove uppercase aliases for quota functions.
      quota: Remove superfluous inlines
      quota: Coding style fixes

Manish Katiyar (1):
      ext2: Zero our b_size in ext2_quota_read()

Matt LaPlante (1):
      trivial: fix typos/grammar errors in fs/Kconfig

Mingming Cao (5):
      quota: Add quota reservation support
      quota: Add quota reservation claim and released operations
      quota: Use inode->i_blkbits to get block bits
      quota: Move EXPORT_SYMBOL immediately next to the functions/varibles
      ext4: quota reservation for delayed allocation

  The diffstat is:

 fs/Kconfig               |   56 +-
 fs/Makefile              |    6 +-
 fs/attr.c                |    3 +-
 fs/dquot.c               | 2410 ------------------------------------------
 fs/ext2/balloc.c         |    8 +-
 fs/ext2/ialloc.c         |   10 +-
 fs/ext2/inode.c          |    2 +-
 fs/ext2/super.c          |    1 +
 fs/ext2/xattr.c          |    8 +-
 fs/ext3/balloc.c         |    8 +-
 fs/ext3/ialloc.c         |   12 +-
 fs/ext3/inode.c          |    6 +-
 fs/ext3/namei.c          |    6 +-
 fs/ext3/super.c          |   48 +-
 fs/ext3/xattr.c          |    6 +-
 fs/ext4/balloc.c         |    2 +-
 fs/ext4/ext4.h           |    2 +
 fs/ext4/ialloc.c         |   12 +-
 fs/ext4/inode.c          |   40 +-
 fs/ext4/mballoc.c        |   46 +-
 fs/ext4/namei.c          |    6 +-
 fs/ext4/super.c          |   54 +-
 fs/ext4/xattr.c          |    6 +-
 fs/inode.c               |    4 +-
 fs/jfs/acl.c             |    2 +-
 fs/jfs/inode.c           |    6 +-
 fs/jfs/jfs_dtree.c       |   18 +-
 fs/jfs/jfs_extent.c      |   10 +-
 fs/jfs/jfs_inode.c       |    4 +-
 fs/jfs/jfs_xtree.c       |   14 +-
 fs/jfs/namei.c           |    6 +-
 fs/jfs/xattr.c           |   12 +-
 fs/namei.c               |   22 +-
 fs/nfsd/vfs.c            |    4 +-
 fs/open.c                |    2 +-
 fs/quota.c               |  513 ---------
 fs/quota/Kconfig         |   59 +
 fs/quota/Makefile        |   14 +
 fs/quota/dquot.c         | 2614 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/quota/quota.c         |  524 ++++++++++
 fs/quota/quota_tree.c    |  651 ++++++++++++
 fs/quota/quota_tree.h    |   25 +
 fs/quota/quota_v1.c      |  234 +++++
 fs/quota/quota_v2.c      |  237 +++++
 fs/quota/quotaio_v1.h    |   33 +
 fs/quota/quotaio_v2.h    |   60 ++
 fs/quota_tree.c          |  645 ------------
 fs/quota_tree.h          |   25 -
 fs/quota_v1.c            |  218 ----
 fs/quota_v2.c            |  236 -----
 fs/quotaio_v1.h          |   33 -
 fs/quotaio_v2.h          |   60 --
 fs/ramfs/file-nommu.c    |    6 -
 fs/reiserfs/bitmap.c     |   14 +-
 fs/reiserfs/inode.c      |   10 +-
 fs/reiserfs/namei.c      |    6 +-
 fs/reiserfs/stree.c      |   14 +-
 fs/reiserfs/super.c      |   60 +-
 fs/super.c               |    8 +-
 fs/sync.c                |    2 +-
 fs/udf/balloc.c          |   14 +-
 fs/udf/ialloc.c          |    8 +-
 fs/ufs/balloc.c          |   12 +-
 fs/ufs/ialloc.c          |    8 +-
 include/linux/quota.h    |   11 +-
 include/linux/quotaops.h |  119 ++-
 66 files changed, 4770 insertions(+), 4565 deletions(-)

							Thanks.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
