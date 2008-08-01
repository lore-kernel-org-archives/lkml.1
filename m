Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYHAPhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYHAPhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYHAPg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:36:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHAPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:36:57 -0400
Date: Fri, 1 Aug 2008 16:36:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches
Message-ID: <20080801153655.GP28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes, better dup2() atomicity, more nameidata eviction, Alexey's
sanitizing of procfs inumbers and of IDR use in fs/*/* in general.  Please,
pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (7):
      ipv4_static_sysctl_init() should be under CONFIG_SYSCTL
      merge locate_fd() and get_unused_fd()
      clean dup2() up a bit
      fix races and leaks in vfs_quota_on() users
      fix bdev leak in block_dev.c do_open()
      switch mtd and dm-table to lookup_bdev()
      pass struct path * to do_add_mount()

Alexey Dobriyan (3):
      proc: fix inode number bogorithmetic
      proc: switch inode number allocation to IDA
      devpts: switch to IDA

Miklos Szeredi (1):
      [patch 3/4] vfs: remove unused nameidata argument of may_create()

Stephen Smalley (1):
      Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree

Diffstat:
 drivers/md/dm-table.c    |   29 ++--------
 drivers/mtd/mtdsuper.c   |   33 ++++-------
 fs/afs/mntpt.c           |    2 +-
 fs/block_dev.c           |    5 +-
 fs/cifs/cifs_dfs_ref.c   |    2 +-
 fs/devpts/inode.c        |   16 +++---
 fs/dquot.c               |   33 +++++++----
 fs/ext3/super.c          |    3 +-
 fs/ext4/super.c          |    3 +-
 fs/fcntl.c               |  140 +++++++++++++--------------------------------
 fs/file.c                |   61 ++++++++++++++++++++
 fs/namei.c               |   17 +++---
 fs/namespace.c           |   16 +++---
 fs/nfs/namespace.c       |    2 +-
 fs/open.c                |   56 ------------------
 fs/proc/generic.c        |   27 ++++-----
 fs/reiserfs/super.c      |   16 +++--
 include/linux/file.h     |    3 +-
 include/linux/mount.h    |    3 +-
 include/linux/quotaops.h |    2 +
 net/ipv4/route.c         |    2 +
 21 files changed, 203 insertions(+), 268 deletions(-)

