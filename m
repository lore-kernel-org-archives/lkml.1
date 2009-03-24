Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZCXMU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZCXMU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZCXMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:20:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39061 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZCXMUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:20:18 -0400
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Tue, 24 Mar 2009 12:20:39 +0000
Message-Id: <1237897239.3371.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 changes. There are two very small
(2 line) bug fixes since the posting to lkml, otherwise the tree is identical,

Steve.

The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (2):
      GFS2: Bring back lvb-related stuff to lock_nolock to support quotas
      GFS2: change gfs2_quota_scan into a shrinker

Benjamin Marzinski (1):
      GFS2: Fix locking bug in failed shared to exclusive conversion

Hannes Eder (2):
      GFS2: fix sparse warnings: constant is so big it is ...
      GFS2: fix sparse warning: Should it be static?

Hisashi Hifumi (1):
      GFS2: Pagecache usage optimization on GFS2

Steven Whitehouse (14):
      GFS2: Fix remount argument parsing
      GFS2: Remove "double" locking in quota
      GFS2: Merge lock_dlm module into GFS2
      GFS2: Remove unused field from glock
      GFS2: Fix error path ref counting for root inode
      GFS2: Fix deadlock on journal flush
      GFS2: Support generation of discard requests
      GFS2: Expose UUID via sysfs/uevent
      GFS2: Add a "demote a glock" interface to sysfs
      GFS2: Fix alignment issue and tidy gfs2_bitfit
      GFS2: Support quota/noquota mount arguments
      GFS2: Clean up of glops.c
      Fix a minor bug in the previous patch
      GFS2: Fix freeze issue

 fs/gfs2/Kconfig                |   17 +-
 fs/gfs2/Makefile               |    4 +-
 fs/gfs2/acl.c                  |    1 -
 fs/gfs2/bmap.c                 |    1 -
 fs/gfs2/dir.c                  |    1 -
 fs/gfs2/eaops.c                |    1 -
 fs/gfs2/eattr.c                |    1 -
 fs/gfs2/glock.c                |  268 +++++-----------
 fs/gfs2/glock.h                |  127 +++++++-
 fs/gfs2/glops.c                |  160 +++++-----
 fs/gfs2/glops.h                |    1 +
 fs/gfs2/incore.h               |   71 ++++-
 fs/gfs2/inode.c                |   13 +-
 fs/gfs2/inode.h                |   22 +-
 fs/gfs2/lock_dlm.c             |  241 ++++++++++++++
 fs/gfs2/locking.c              |  232 -------------
 fs/gfs2/locking/dlm/Makefile   |    3 -
 fs/gfs2/locking/dlm/lock.c     |  708 ----------------------------------------
 fs/gfs2/locking/dlm/lock_dlm.h |  166 ----------
 fs/gfs2/locking/dlm/main.c     |   48 ---
 fs/gfs2/locking/dlm/mount.c    |  276 ----------------
 fs/gfs2/locking/dlm/sysfs.c    |  226 -------------
 fs/gfs2/locking/dlm/thread.c   |   68 ----
 fs/gfs2/log.c                  |    1 -
 fs/gfs2/lops.c                 |    1 -
 fs/gfs2/main.c                 |   13 +-
 fs/gfs2/meta_io.c              |   22 --
 fs/gfs2/meta_io.h              |    1 -
 fs/gfs2/mount.c                |  128 ++------
 fs/gfs2/mount.h                |   17 -
 fs/gfs2/ops_address.c          |    5 +-
 fs/gfs2/ops_dentry.c           |    1 -
 fs/gfs2/ops_export.c           |    1 -
 fs/gfs2/ops_file.c             |   76 ++---
 fs/gfs2/ops_fstype.c           |  156 ++++++---
 fs/gfs2/ops_inode.c            |    1 -
 fs/gfs2/ops_super.c            |   44 ++-
 fs/gfs2/quota.c                |  203 ++++++------
 fs/gfs2/quota.h                |    2 +
 fs/gfs2/recovery.c             |   28 +-
 fs/gfs2/rgrp.c                 |  189 +++++++----
 fs/gfs2/super.c                |    3 -
 fs/gfs2/super.h                |   26 +-
 fs/gfs2/sys.c                  |  236 +++++++++++++-
 fs/gfs2/trans.c                |   19 +-
 fs/gfs2/util.c                 |   11 +-
 include/linux/lm_interface.h   |  277 ----------------
 47 files changed, 1347 insertions(+), 2770 deletions(-)
 create mode 100644 fs/gfs2/lock_dlm.c
 delete mode 100644 fs/gfs2/locking.c
 delete mode 100644 fs/gfs2/locking/dlm/Makefile
 delete mode 100644 fs/gfs2/locking/dlm/lock.c
 delete mode 100644 fs/gfs2/locking/dlm/lock_dlm.h
 delete mode 100644 fs/gfs2/locking/dlm/main.c
 delete mode 100644 fs/gfs2/locking/dlm/mount.c
 delete mode 100644 fs/gfs2/locking/dlm/sysfs.c
 delete mode 100644 fs/gfs2/locking/dlm/thread.c
 delete mode 100644 fs/gfs2/mount.h
 delete mode 100644 include/linux/lm_interface.h


