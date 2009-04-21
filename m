Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZDUDoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZDUDoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZDUDop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:44:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34393 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDUDoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:44:44 -0400
Date: Tue, 21 Apr 2009 04:44:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches for -rc3
Message-ID: <20090421034443.GD8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are safe bits (including outright bug fixes). Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Adrian McMenamin (1):
      Documentation/filesystems: remove out of date reference to BKL being held

Al Viro (7):
      Fix AUTOFS_DEV_IOCTL_REQUESTER_CMD
      Touch all affected namespaces on propagation of mount
      Safer nfsd_cross_mnt()
      No need for crossing to mountpoint in audit_tag_tree()
      Fix autofs_expire()
      autofs4: use memchr() in invalid_string()
      reiserfs: fix j_last_flush_trans_id type

Alexander Beregalov (1):
      fs/compat_ioctl: fix build when !BLOCK

Christoph Hellwig (1):
      kill vfs_stat_fd / vfs_lstat_fd

David Woodhouse (1):
      Fix i_mutex vs. readdir handling in nfsd

Li Zefan (6):
      xattr: use memdup_user()
      btrfs: use memdup_user()
      sysfs: use memdup_user()
      xfs: use memdup_user()
      ncpfs: use memdup_user()
      ecryptfs: use memdup_user()

Oleg Drokin (1):
      Separate out common fstatat code into vfs_fstatat

Tetsuo Handa (1):
      fs: Mark get_filesystem_list() as __init function.


Diffstat:
 Documentation/filesystems/vfs.txt |    3 +-
 arch/arm/kernel/sys_oabi-compat.c |   19 ++----
 arch/s390/kernel/compat_linux.c   |   18 ++----
 arch/sparc/kernel/sys_sparc32.c   |   19 ++----
 arch/x86/ia32/sys_ia32.c          |   19 ++----
 fs/autofs/dirhash.c               |   34 +++++----
 fs/autofs4/dev-ioctl.c            |   12 ++--
 fs/btrfs/ioctl.c                  |   49 +++----------
 fs/btrfs/super.c                  |   13 +---
 fs/compat.c                       |   37 ++++------
 fs/compat_ioctl.c                 |    7 +-
 fs/dcache.c                       |    1 -
 fs/ecryptfs/miscdev.c             |   15 ++---
 fs/filesystems.c                  |    2 +-
 fs/namei.c                        |    2 +
 fs/namespace.c                    |    2 +-
 fs/ncpfs/ioctl.c                  |   21 ++----
 fs/nfsd/nfs4recover.c             |   46 +++----------
 fs/nfsd/vfs.c                     |   34 +++++++--
 fs/stat.c                         |  137 ++++++++++++++++---------------------
 fs/sysfs/bin.c                    |   13 +---
 fs/xattr.c                        |   10 +--
 fs/xfs/linux-2.6/xfs_ioctl.c      |   23 ++----
 fs/xfs/linux-2.6/xfs_ioctl32.c    |   12 +--
 include/linux/fs.h                |    5 +-
 include/linux/reiserfs_fs_sb.h    |    2 +-
 kernel/audit_tree.c               |    3 -
 27 files changed, 207 insertions(+), 351 deletions(-)
