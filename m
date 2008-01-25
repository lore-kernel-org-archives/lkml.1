Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYAYJuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYAYJuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYAYJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:50:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbYAYJuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:50:06 -0500
Subject: GFS2 Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 25 Jan 2008 09:46:13 +0000
Message-Id: <1201254373.22038.277.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've dropped out a couple of the patches related to journaling. Those
will now do an extra round of my git tree and will likely be merged next
time. Other than that, the patches in the GFS2 -nme git tree are exactly
as recently posted.

Please consider pulling the following changes,

Steve.

---------------------------------------------------------------------------------

The following changes since commit 49914084e797530d9baaf51df9eda77babc98fa8:
  Linus Torvalds (1):
        Linux 2.6.24

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Abhijith Das (2):
      [GFS2] patch to check for recursive lock requests in gfs2_rename code path
      [GFS2] Allow journal recovery on read-only mount

Bob Peterson (16):
      [GFS2] Given device ID rather than s_id in "id" sysfs file
      [GFS2] Remove function gfs2_get_block
      [GFS2] Journal extent mapping
      [GFS2] Get rid of useless "found" variable in quota.c
      [GFS2] Run through full bitmaps quicker in gfs2_bitfit
      [GFS2] Reorganize function gfs2_glmutex_lock
      [GFS2] Only fetch the dinode once in block_map
      [GFS2] Function meta_read optimization
      [GFS2] Incremental patch to fix compiler warning
      [GFS2] Eliminate the no longer needed sd_statfs_mutex
      [GFS2] Minor correction
      [GFS2] Initialize extent_list earlier
      [GFS2] Remove unneeded i_spin
      [GFS2] gfs2_alloc_required performance
      [GFS2] Fix typo
      [GFS2] Lockup on error

David Teigland (3):
      [GFS2] check kthread_should_stop when waiting
      [GFS2] tidy up error message
      [GFS2] use pid for plock owner for nfs clients

Fabio M. Di Nitto (1):
      [GFS2] Remove unrequired code

Fabio Massimo Di Nitto (3):
      [GFS2] Check for installation of mount helpers for DLM mounts
      [GFS2] Fix runtime issue with UP kernels
      [GFS2] Fix build warnings

Ryan O'Hara (1):
      [GFS2] remove unnecessary permission checks

Steven Whitehouse (28):
      [GFS2] Clean up internal read function
      [GFS2] Use ->page_mkwrite() for mmap()
      [GFS2] Remove useless i_cache from inodes
      [GFS2] Remove unused field in struct gfs2_inode
      [GFS2] Add gfs2_is_writeback()
      [GFS2] Introduce gfs2_set_aops()
      [GFS2] Split gfs2_writepage into three cases
      [GFS2] Add writepages for GFS2 jdata
      [GFS2] Don't hold page lock when starting transaction
      [GFS2] Use correct include file in ops_address.c
      [GFS2] Remove unused variables
      [GFS2] Remove "reclaim limit"
      [GFS2] Add sync_page to metadata address space operations
      [GFS2] Reorder writeback for glock sync
      [GFS2] Remove flags no longer required
      [GFS2] Don't add glocks to the journal
      [GFS2] Use atomic_t for journal free blocks counter
      [GFS2] Move gfs2_logd into log.c
      [GFS2] Don't periodically update the jindex
      [GFS2] Remove unused variable
      [GFS2] Fix log block mapper
      [GFS2] Remove unused variable
      [GFS2] Allow page migration for writeback and ordered pages
      [GFS2] Fix problems relating to execution of files on GFS2
      [GFS2] Fix assert in log code
      [GFS2] Reduce inode size by moving i_alloc out of line
      [GFS2] Fix write alloc required shortcut calculation
      [GFS2] Fix page_mkwrite truncation race path

Wendy Cheng (2):
      [GFS2] Handle multiple glock demote requests
      [GFS2] Remove lock methods for lock_nolock protocol

 fs/gfs2/Makefile             |    2 +-
 fs/gfs2/bmap.c               |   37 ++--
 fs/gfs2/bmap.h               |    2 +-
 fs/gfs2/daemon.c             |   50 ----
 fs/gfs2/daemon.h             |    1 -
 fs/gfs2/dir.c                |    4 +-
 fs/gfs2/eaops.c              |   84 +-----
 fs/gfs2/eattr.c              |    2 +-
 fs/gfs2/glock.c              |   83 ++----
 fs/gfs2/glops.c              |  110 ++------
 fs/gfs2/incore.h             |   47 +--
 fs/gfs2/inode.c              |   41 ++--
 fs/gfs2/inode.h              |   12 +
 fs/gfs2/locking/dlm/mount.c  |    5 +
 fs/gfs2/locking/dlm/plock.c  |   18 +-
 fs/gfs2/locking/dlm/thread.c |    9 +-
 fs/gfs2/log.c                |  119 +++++---
 fs/gfs2/log.h                |   14 +-
 fs/gfs2/lops.c               |   71 +----
 fs/gfs2/main.c               |    3 +-
 fs/gfs2/meta_io.c            |   97 ++-----
 fs/gfs2/meta_io.h            |    1 -
 fs/gfs2/ops_address.c        |  649 ++++++++++++++++++++++++++++++------------
 fs/gfs2/ops_address.h        |    7 +-
 fs/gfs2/ops_file.c           |  229 +++++++++++-----
 fs/gfs2/ops_file.h           |   24 --
 fs/gfs2/ops_fstype.c         |   73 +++++-
 fs/gfs2/ops_inode.c          |   20 +-
 fs/gfs2/ops_inode.h          |    6 +
 fs/gfs2/ops_super.c          |    1 -
 fs/gfs2/ops_vm.c             |  169 -----------
 fs/gfs2/ops_vm.h             |   18 --
 fs/gfs2/quota.c              |   29 +--
 fs/gfs2/recovery.c           |   18 +-
 fs/gfs2/rgrp.c               |  104 ++++---
 fs/gfs2/rgrp.h               |    4 +-
 fs/gfs2/super.c              |   25 +-
 fs/gfs2/sys.c                |    7 +-
 fs/gfs2/trans.c              |    5 -
 fs/gfs2/trans.h              |    1 -
 40 files changed, 1092 insertions(+), 1109 deletions(-)
 delete mode 100644 fs/gfs2/ops_file.h
 delete mode 100644 fs/gfs2/ops_vm.c
 delete mode 100644 fs/gfs2/ops_vm.h


