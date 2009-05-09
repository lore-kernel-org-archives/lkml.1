Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZEIPWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZEIPWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZEIPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:22:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43898 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZEIPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:22:25 -0400
Date: Sat, 9 May 2009 16:22:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] VFS patches for -rc6
Message-ID: <20090509152224.GE8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted patches, including reiserfs stuff that had been caught by WARN_ON in
-rc3, a bunch of race fixes all over the place, etc.  Please, pull from

git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (11):
      Always lookup priv_root on reiserfs mount and keep it
      New helper: deactivate_locked_super()
      Convert obvious places to deactivate_locked_super()
      Fix a leak in failure exit in 9p ->get_sb()
      Fix deadlock in ipathfs ->get_sb()
      Reduce path_lookup() abuses
      Make open_exec() and sys_uselib() use may_open(), instead of duplicating its parts
      Switch open_exec() and sys_uselib() to do_open_filp()
      switch ufs directories to ufs_sync_file()
      Fix races around the access to ->s_options
      Fix the race between capifs remount and node creation

Alessio Igor Bogani (1):
      vfs: umount_begin BKL pushdown

Christoph Hellwig (1):
      romfs: cleanup romfs_fs.h

H Hartley Sweeten (1):
      NULL noise in fs/super.c:kill_bdev_super()

Jeff Mahoney (4):
      reiserfs: Expand i_mutex to enclose lookup_one_len
      reiserfs: fixup xattr_root caching
      reiserfs: dont associate security.* with xattr files
      reiserfs: remove privroot hiding in lookup

Joel Becker (1):
      ocfs2: Use nd_set_link().

Manish Katiyar (1):
      Make checkpatch.pl shut up on fs/inode.c

Roel Kluin (1):
      ROMFS: romfs_dev_read() error ignored

npiggin@suse.de (1):
      fs: dcache fix LRU ordering

Diffstat:
 drivers/infiniband/hw/ipath/ipath_fs.c |    2 +-
 drivers/isdn/capi/capifs.c             |   11 ++-
 drivers/mtd/mtdsuper.c                 |    3 +-
 drivers/scsi/osd/osd_uld.c             |   20 ++--
 fs/9p/vfs_super.c                      |   12 ++-
 fs/affs/super.c                        |    3 +-
 fs/afs/super.c                         |    7 +-
 fs/btrfs/super.c                       |   12 +--
 fs/cifs/cifsfs.c                       |    6 +-
 fs/dcache.c                            |    2 +-
 fs/devpts/inode.c                      |    5 +-
 fs/ecryptfs/main.c                     |    5 +-
 fs/exec.c                              |   79 +++++----------
 fs/fuse/inode.c                        |    3 +
 fs/gfs2/ops_fstype.c                   |    8 +-
 fs/hpfs/super.c                        |    3 +-
 fs/inode.c                             |   81 ++++++--------
 fs/libfs.c                             |    3 +-
 fs/namei.c                             |   13 ++-
 fs/namespace.c                         |   23 +++-
 fs/nfs/super.c                         |   22 ++--
 fs/ocfs2/symlink.c                     |   77 +++++++-------
 fs/open.c                              |    2 +-
 fs/proc/root.c                         |    3 +-
 fs/reiserfs/dir.c                      |   24 +++--
 fs/reiserfs/namei.c                    |   17 +---
 fs/reiserfs/super.c                    |    9 +-
 fs/reiserfs/xattr.c                    |  181 ++++++++++++++++----------------
 fs/reiserfs/xattr_security.c           |   12 ++-
 fs/romfs/super.c                       |    3 +-
 fs/super.c                             |   48 ++++++---
 fs/ubifs/super.c                       |    3 +-
 fs/ufs/dir.c                           |    2 +-
 fs/ufs/file.c                          |    2 +-
 fs/ufs/ufs.h                           |    2 +-
 include/linux/Kbuild                   |    2 +-
 include/linux/fs.h                     |    4 +-
 include/linux/namei.h                  |    1 -
 include/linux/reiserfs_fs_sb.h         |    3 +-
 include/linux/reiserfs_xattr.h         |    3 +-
 include/linux/romfs_fs.h               |    5 -
 kernel/cgroup.c                        |    3 +-
 security/tomoyo/common.c               |    6 +-
 security/tomoyo/realpath.c             |   16 ++--
 44 files changed, 369 insertions(+), 382 deletions(-)
