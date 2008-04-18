Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYDRQzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYDRQzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYDRQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:55:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYDRQzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:55:37 -0400
Subject: [GFS2] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 18 Apr 2008 17:53:49 +0100
Message-Id: <1208537629.3635.421.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches. The tree is almost
unchanged from the patch posting with the exception of the addition of
Roel's patch to fix a calculation in the logging code. Once these
patches go in, I'll look into creating a follow-up patch as suggested by
Christoph.

There are no changes outside of the GFS2 code in this patch set,

Steve.


The following changes since commit 4a72ef9f7ad36ea0fb3b42f31b2b0c5b9871969a:
  Linus Torvalds (1):
        Merge branch 'pci_id_updates' of git://git.kernel.org/.../mchehab/v4l-dvb

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Abhijith Das (1):
      [GFS2] gfs2_adjust_quota has broken unstuffing code

Adrian Bunk (3):
      [GFS2] make gfs2_glock_hold() static
      [GFS2] gfs2/ops_file.c should #include "ops_inode.h"
      [GFS2] proper extern for gfs2/locking/dlm/mount.c:gdlm_ops

Benjamin Marzinski (1):
      [GFS2] Invalidate cache at correct point

Bob Peterson (13):
      [GFS2] Get rid of unneeded parameter in gfs2_rlist_alloc
      [GFS2] Fix debug inode printing
      [GFS2] Only do lo_incore_commit once
      [GFS2] Misc fixups
      [GFS2] Only wake the reclaim daemon if we need to
      [GFS2] Plug an unlikely leak
      [GFS2] Allocate gfs2_rgrpd from slab memory
      [GFS2] Combine rg_flags and rd_flags
      [GFS2] Get rid of gl_waiters2
      [GFS2] Eliminate gl_req_bh
      [GFS2] Remove rgrp and glock version numbers
      [GFS2] Remove unused counters
      [GFS2] Faster gfs2_bitfit algorithm

Christoph Hellwig (1):
      [GFS2] fix file_system_type leak on gfs2meta mount

Cyrill Gorcunov (1):
      [GFS2] possible null pointer dereference fixup

Denis Cheng (2):
      [GFS2] remove gfs2_dev_iops
      [GFS2] re-support special inode

Josef Bacik (1):
      [GFS2] fix GFP_KERNEL misuses

Julia Lawall (1):
      [GFS2] test for IS_ERR rather than 0

Marcin Slusarz (1):
      [GFS2] be*_add_cpu conversion

Roel Kluin (1):
      [GFS2] fix assertion in log_refund()

Steven Whitehouse (22):
      [GFS2] Speed up gfs2_write_alloc_required, deprecate gfs2_extent_map
      [GFS2] Streamline indirect pointer tree height calculation
      [GFS2] Move part of gfs2_block_map into a separate function
      [GFS2] Introduce array of buffers to struct metapath
      [GFS2] Add consts to various bits of rgrp.c
      [GFS2] Remove lm.[ch] and distribute content
      [GFS2] Shrink & rename di_depth
      [GFS2] Reduce inode size by merging fields
      [GFS2] Merge the rd_last_alloc_meta and rd_last_alloc_data fields
      [GFS2] Update gfs2_trans_add_unrevoke to accept extents
      [GFS2] Merge gfs2_alloc_meta and gfs2_alloc_data
      [GFS2] Add extent allocation to block allocator
      [GFS2] The case of the missing asterisk
      [GFS2] Add a function to interate over an extent
      [GFS2] Eliminate (almost) duplicate field from gfs2_inode
      [GFS2] Get inode buffer only once per block map call
      [GFS2] Fix bug where we called drop_bh incorrectly
      [GFS2] Fix a page lock / glock deadlock
      [GFS2] Allow bmap to allocate extents
      [GFS2] Need to ensure that sector_t is 64bits for GFS2
      [GFS2] Remove drop of module ref where not needed
      [GFS2] Streamline quota lock/check for no-quota case

akpm@linux-foundation.org (1):
      [GFS2] fs/gfs2/recovery.c: suppress warnings

 fs/gfs2/Kconfig                |    2 +-
 fs/gfs2/Makefile               |    2 +-
 fs/gfs2/acl.c                  |    6 +-
 fs/gfs2/bmap.c                 |  670 ++++++++++++++++++++++------------------
 fs/gfs2/dir.c                  |   84 +++---
 fs/gfs2/eattr.c                |   58 ++--
 fs/gfs2/glock.c                |  188 +++++++-----
 fs/gfs2/glock.h                |   14 +-
 fs/gfs2/glops.c                |   10 +-
 fs/gfs2/incore.h               |   40 +--
 fs/gfs2/inode.c                |   72 +++--
 fs/gfs2/inode.h                |   22 +-
 fs/gfs2/lm.c                   |  210 -------------
 fs/gfs2/lm.h                   |   42 ---
 fs/gfs2/locking/dlm/lock.c     |    7 +-
 fs/gfs2/locking/dlm/lock_dlm.h |    5 +
 fs/gfs2/locking/dlm/main.c     |    2 -
 fs/gfs2/locking/dlm/sysfs.c    |    2 -
 fs/gfs2/locking/dlm/thread.c   |   10 +-
 fs/gfs2/locking/nolock/main.c  |    2 +-
 fs/gfs2/log.c                  |   19 +-
 fs/gfs2/lops.c                 |   21 +-
 fs/gfs2/lops.h                 |   11 +-
 fs/gfs2/main.c                 |   10 +
 fs/gfs2/ops_address.c          |   44 ++--
 fs/gfs2/ops_dentry.c           |    4 +-
 fs/gfs2/ops_export.c           |    2 -
 fs/gfs2/ops_file.c             |   37 ++-
 fs/gfs2/ops_fstype.c           |   80 +++++-
 fs/gfs2/ops_inode.c            |   42 +--
 fs/gfs2/ops_inode.h            |    1 -
 fs/gfs2/ops_super.c            |    1 -
 fs/gfs2/quota.c                |   74 ++---
 fs/gfs2/quota.h                |   17 +
 fs/gfs2/recovery.c             |   15 +-
 fs/gfs2/rgrp.c                 |  370 ++++++++++++-----------
 fs/gfs2/rgrp.h                 |    8 +-
 fs/gfs2/super.c                |    6 +-
 fs/gfs2/super.h                |    1 +
 fs/gfs2/sys.c                  |    7 -
 fs/gfs2/trans.c                |   25 +-
 fs/gfs2/trans.h                |    2 +-
 fs/gfs2/util.c                 |   24 ++-
 fs/gfs2/util.h                 |    2 +
 include/linux/lm_interface.h   |   10 +
 45 files changed, 1150 insertions(+), 1131 deletions(-)
 delete mode 100644 fs/gfs2/lm.c
 delete mode 100644 fs/gfs2/lm.h


