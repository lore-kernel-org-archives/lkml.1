Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZLCPBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZLCPBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZLCPBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:01:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbZLCPBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:01:22 -0500
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 03 Dec 2009 15:01:21 +0000
Message-Id: <1259852481.6052.980.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the patches were posted to lkml, I'd fixed two typos in the git
comments and added one bug fix to the mix (GFS2: Fix glock refcount
issues). Otherwise, this is identical to the patch set I posted last
week. Please consider pulling the following changes:


The following changes since commit 22763c5cf3690a681551162c15d34d935308c8d7:
  Linus Torvalds (1):
        Linux 2.6.32

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Benjamin Marzinski (3):
      GFS2: Improve statfs and quota usability
      GFS2: remove division from new statfs code
      GFS2: drop rindex glock to refresh rindex list

Christoph Hellwig (1):
      GFS2: add barrier/nobarrier mount options

Steven Whitehouse (26):
      GFS2: Fix potential race in glock code
      GFS2: Fix -o meta mounts for subsequent mounts (i.e. all but the first one)
      GFS2: Fix up system xattrs
      VFS: Add forget_all_cached_acls()
      GFS2: Use forget_all_cached_acls()
      GFS2: Use gfs2_set_mode() instead of munge_mode()
      GFS2: Clean up ACLs
      GFS2: Add cached ACLs support
      VFS: Use GFP_NOFS in posix_acl_from_xattr()
      GFS2: Alter arguments of gfs2_quota/statfs_sync
      GFS2: Hook gfs2_quota_sync into VFS via gfs2_quotactl_ops
      GFS2: Remove obsolete code in quota.c
      GFS2: Add get_xstate quota function
      GFS2: Add proper error reporting to quota sync via sysfs
      GFS2: Remove constant argument from qdsb_get()
      GFS2: Remove constant argument from qd_get()
      GFS2: Clean up gfs2_adjust_quota() and do_glock()
      GFS2: Add get_xquota support
      GFS2: Add set_xquota support
      VFS: Export dquot_send_warning
      GFS2: Use dquot_send_warning()
      GFS2: Display nobarrier option in /proc/mounts
      GFS2: Remove dirent_first() function
      GFS2: Locking order fix in gfs2_check_blk_state
      GFS2: Tag all metadata with jid
      GFS2: Fix glock refcount issues

Wu Fengguang (1):
      writeback: remove unused nonblocking and congestion checks (gfs2)

 fs/gfs2/Kconfig             |    2 +
 fs/gfs2/acl.c               |  357 +++++++++++++++++++++++----------------
 fs/gfs2/acl.h               |   24 +--
 fs/gfs2/aops.c              |   20 +--
 fs/gfs2/dir.c               |   34 +----
 fs/gfs2/glock.c             |   31 ++--
 fs/gfs2/glock.h             |    9 -
 fs/gfs2/glops.c             |    5 +-
 fs/gfs2/incore.h            |    5 +
 fs/gfs2/inode.c             |    4 +-
 fs/gfs2/log.c               |    2 +
 fs/gfs2/lops.c              |    4 +
 fs/gfs2/ops_fstype.c        |  154 +++++++++++++++---
 fs/gfs2/quota.c             |  393 +++++++++++++++++++++++++++++++++----------
 fs/gfs2/quota.h             |    5 +-
 fs/gfs2/recovery.c          |    2 +
 fs/gfs2/rgrp.c              |   14 +-
 fs/gfs2/super.c             |  110 +++++++++++--
 fs/gfs2/super.h             |    4 +-
 fs/gfs2/sys.c               |   14 +-
 fs/gfs2/xattr.c             |   74 +++++----
 fs/gfs2/xattr.h             |    8 +-
 fs/quota/Kconfig            |    2 +-
 fs/quota/dquot.c            |   93 +---------
 fs/quota/quota.c            |   93 ++++++++++
 fs/xattr_acl.c              |    2 +-
 include/linux/gfs2_ondisk.h |    6 +-
 include/linux/posix_acl.h   |   14 ++
 include/linux/quota.h       |   11 ++
 29 files changed, 991 insertions(+), 505 deletions(-)


