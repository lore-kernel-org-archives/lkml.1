Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZAEJjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZAEJjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAEJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:39:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZAEJjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:39:10 -0500
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 05 Jan 2009 09:34:37 +0000
Message-Id: <1231148077.9571.463.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes. There have been two
changes since the patches were posted for review:

1. Revert and apply a new (smaller, neater, better) fix for the
use-after-free bug.
2. Julia's one-liner DEFINE_SPINLOCK clean up

Otherwise, everything is the same,

Steve.

---------------------------------------------------------------------------------
The following changes since commit fe0bdec68b77020281dc814805edfe594ae89e0f:
  Linus Torvalds (1):
        Merge branch 'audit.b61' of git://git.kernel.org/.../viro/audit-current

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Harvey Harrison (1):
      GFS2: sparse annotation of gl->gl_spin

Julia Lawall (1):
      GFS2: Use DEFINE_SPINLOCK

Steven Whitehouse (25):
      GFS2: Support for FIEMAP ioctl
      GFS2: Rationalise header files
      GFS2: Fix up jdata writepage/delete_inode
      GFS2: Move generation number into "proper" part of inode
      GFS2: Move "entries" into "proper" inode
      GFS2: Move di_eattr into "proper" inode
      GFS2: Move i_size from gfs2_dinode_host and rename it to i_disksize
      GFS2: Banish struct gfs2_dinode_host
      GFS2: Move rg_igeneration into struct gfs2_rgrpd
      GFS2: Move rg_free from gfs2_rgrpd_host to gfs2_rgrpd
      GFS2: Banish struct gfs2_rgrpd_host
      GFS2: Add more detail to debugfs glock dumps
      GFS2: Clean up & move gfs2_quotad
      GFS2: Fix "truncate in progress" hang
      GFS2: Move gfs2_recoverd into recovery.c
      GFS2: Kill two daemons with one patch
      GFS2: Send some sensible sysfs stuff
      GFS2: Fix bug in gfs2_lock_fs_check_clean()
      GFS2: Move four functions from super.c
      GFS2: Remove ancient, unused code
      GFS2: Fix use-after-free bug on umount
      GFS2: Send useful information with uevent messages
      GFS2: Streamline alloc calculations for writes
      Revert "GFS2: Fix use-after-free bug on umount"
      GFS2: Fix use-after-free bug on umount (try #2)

 fs/gfs2/Makefile            |    2 +-
 fs/gfs2/acl.c               |    2 +-
 fs/gfs2/bmap.c              |   77 +++--------
 fs/gfs2/bmap.h              |   34 +++++-
 fs/gfs2/daemon.c            |  136 -------------------
 fs/gfs2/daemon.h            |   17 ---
 fs/gfs2/dir.c               |   62 +++++-----
 fs/gfs2/dir.h               |    1 +
 fs/gfs2/eattr.c             |   40 +++---
 fs/gfs2/glock.c             |  303 ++++++++++++++++++++++---------------------
 fs/gfs2/glock.h             |    2 +-
 fs/gfs2/glops.c             |   56 ++++++---
 fs/gfs2/incore.h            |   55 +++------
 fs/gfs2/inode.c             |   53 ++++----
 fs/gfs2/inode.h             |   13 ++-
 fs/gfs2/locking/dlm/mount.c |   12 ++-
 fs/gfs2/locking/dlm/sysfs.c |   16 ++-
 fs/gfs2/main.c              |   15 ++-
 fs/gfs2/mount.c             |   29 +----
 fs/gfs2/ops_address.c       |   32 +++---
 fs/gfs2/ops_dentry.c        |    2 +-
 fs/gfs2/ops_dentry.h        |   17 ---
 fs/gfs2/ops_export.c        |    5 +-
 fs/gfs2/ops_file.c          |   22 ++--
 fs/gfs2/ops_fstype.c        |  125 ++++++++++++------
 fs/gfs2/ops_fstype.h        |   19 ---
 fs/gfs2/ops_inode.c         |   75 +++++++++--
 fs/gfs2/ops_inode.h         |   25 ----
 fs/gfs2/ops_super.c         |  149 +++++++++++++++++++--
 fs/gfs2/ops_super.h         |   17 ---
 fs/gfs2/quota.c             |  113 +++++++++++++++--
 fs/gfs2/quota.h             |   24 ++--
 fs/gfs2/recovery.c          |   48 +++++++-
 fs/gfs2/recovery.h          |   14 +-
 fs/gfs2/rgrp.c              |   58 ++++-----
 fs/gfs2/super.c             |  246 +----------------------------------
 fs/gfs2/super.h             |   13 +-
 fs/gfs2/sys.c               |   66 +++-------
 fs/gfs2/sys.h               |    4 -
 fs/gfs2/util.c              |    1 +
 fs/gfs2/util.h              |    1 +
 fs/ioctl.c                  |   44 +++++--
 include/linux/fs.h          |    3 +
 43 files changed, 964 insertions(+), 1084 deletions(-)
 delete mode 100644 fs/gfs2/daemon.c
 delete mode 100644 fs/gfs2/daemon.h
 delete mode 100644 fs/gfs2/ops_dentry.h
 delete mode 100644 fs/gfs2/ops_fstype.h
 delete mode 100644 fs/gfs2/ops_inode.h
 delete mode 100644 fs/gfs2/ops_super.h


