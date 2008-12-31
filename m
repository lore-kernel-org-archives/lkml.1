Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYLaHoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYLaHoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 02:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYLaHn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 02:43:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYLaHn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 02:43:57 -0500
Date: Wed, 31 Dec 2008 07:43:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches, part 1
Message-ID: <20081231074356.GA28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beginning of VFS queue for .29-rc1; that's just the first part. Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus.

Shortlog:

Al Viro (8):
      fix switch_names() breakage in short-to-short case
      take init_fs to saner place
      kill ->dir_notify()
      nfsd/create race fixes, infrastructure
      nfsd races, ext2
      nfsd races, ext3
      nfsd races, ext4
      nfsd races, reiserfs

Arjan van de Ven (1):
      [patch 10/11] vfs: expand some comments (d_path / seq_path)

Christoph Hellwig (4):
      remove incorrect comment in inode_permission
      kill walk_init_root
      pass a struct path * to may_open
      kill vfs_permission

Dave Kleikamp (1):
      nfsd races, jfs

Denis ChengRq (1):
      [patch 05/11] fs/block_dev.c: __read_mostly improvement and sb_is_blkdev_sb utilization

Duane Griffin (9):
      eCryptfs: check readlink result was not an error before using it
      vfs: introduce helper function to safely NUL-terminate symlinks
      vfs: ensure page symlinks are NUL-terminated
      ext2: ensure fast symlinks are NUL-terminated
      ext3: ensure fast symlinks are NUL-terminated
      ext4: ensure fast symlinks are NUL-terminated
      sysv: ensure fast symlinks are NUL-terminated
      freevxfs: ensure fast symlinks are NUL-terminated
      befs: ensure fast symlinks are NUL-terminated

Eric Dumazet (2):
      fix f_count description in Documentation/filesystems/files.txt
      filp_cachep can be static in fs/file_table.c

Eric Paris (1):
      filesystem notification: create fs/notify to contain all fs

Jan Engelhardt (1):
      [patch 02/11] include: linux/fs.h: put declarations in __KERNEL__

Julia Lawall (1):
      [patch 03/11] fs/namespace.c: drop code after return

Kentaro Takeda (1):
      introduce new LSM hooks where vfsmount is available.

Nick Piggin (1):
      [patch][rfc] fs: shrink struct dentry

Richard Kennedy (1):
      fs: reorder struct inotify_device on 64bits to remove

Steven Rostedt (1):
      make INIT_FS use the __RW_LOCK_UNLOCKED initialization

Zhaolei (1):
      [patch 09/11] vfs: correct wrong function name of d_put in kernel document and source comment

Diffstat:
 Documentation/filesystems/Locking          |    2 -
 Documentation/filesystems/files.txt        |    6 +-
 Documentation/filesystems/vfs.txt          |    5 +-
 arch/alpha/kernel/init_task.c              |    1 -
 arch/arm/kernel/init_task.c                |    1 -
 arch/avr32/kernel/init_task.c              |    1 -
 arch/blackfin/kernel/init_task.c           |    1 -
 arch/cris/kernel/process.c                 |    1 -
 arch/frv/kernel/init_task.c                |    1 -
 arch/h8300/kernel/init_task.c              |    1 -
 arch/ia64/kernel/init_task.c               |    1 -
 arch/m32r/kernel/init_task.c               |    1 -
 arch/m68k/kernel/process.c                 |    1 -
 arch/m68knommu/kernel/init_task.c          |    1 -
 arch/mips/kernel/init_task.c               |    1 -
 arch/mn10300/kernel/init_task.c            |    1 -
 arch/parisc/kernel/init_task.c             |    1 -
 arch/powerpc/kernel/init_task.c            |    1 -
 arch/powerpc/oprofile/cell/spu_task_sync.c |    2 +-
 arch/s390/kernel/init_task.c               |    1 -
 arch/sh/kernel/init_task.c                 |    1 -
 arch/sparc/kernel/init_task.c              |    1 -
 arch/um/kernel/init_task.c                 |    1 -
 arch/x86/kernel/init_task.c                |    1 -
 arch/xtensa/kernel/init_task.c             |    1 -
 drivers/oprofile/buffer_sync.c             |    2 +-
 fs/Kconfig                                 |   39 +--------
 fs/Makefile                                |    5 +-
 fs/bad_inode.c                             |    6 -
 fs/befs/linuxvfs.c                         |    5 +-
 fs/block_dev.c                             |    9 +-
 fs/cifs/Makefile                           |    2 +-
 fs/cifs/cifsfs.c                           |    7 --
 fs/cifs/cifsfs.h                           |    1 -
 fs/cifs/fcntl.c                            |  118 ------------------------
 fs/dcache.c                                |   25 ++---
 fs/dcookies.c                              |   28 ++++--
 fs/ecryptfs/inode.c                        |    3 +-
 fs/exec.c                                  |    5 +-
 fs/ext2/ialloc.c                           |    6 +-
 fs/ext2/inode.c                            |    7 +-
 fs/ext2/namei.c                            |   15 +++-
 fs/ext3/ialloc.c                           |    6 +-
 fs/ext3/inode.c                            |    7 +-
 fs/ext3/namei.c                            |   15 +++-
 fs/ext4/ialloc.c                           |    6 +-
 fs/ext4/inode.c                            |    7 +-
 fs/ext4/namei.c                            |   14 +++-
 fs/file_table.c                            |   10 ++-
 fs/freevxfs/vxfs_inode.c                   |    4 +-
 fs/inode.c                                 |   59 ++++++++++++
 fs/jfs/jfs_inode.c                         |   29 ++++--
 fs/jfs/namei.c                             |   24 +++--
 fs/namei.c                                 |  115 +++++++++++++++--------
 fs/namespace.c                             |    2 +-
 fs/nfsctl.c                                |    5 +-
 fs/notify/Kconfig                          |    2 +
 fs/notify/Makefile                         |    2 +
 fs/notify/dnotify/Kconfig                  |   10 ++
 fs/notify/dnotify/Makefile                 |    1 +
 fs/{ => notify/dnotify}/dnotify.c          |    3 -
 fs/notify/inotify/Kconfig                  |   27 ++++++
 fs/notify/inotify/Makefile                 |    2 +
 fs/{ => notify/inotify}/inotify.c          |    0 
 fs/{ => notify/inotify}/inotify_user.c     |    2 +-
 fs/open.c                                  |    5 +
 fs/reiserfs/inode.c                        |   15 ++-
 fs/reiserfs/namei.c                        |    8 ++
 fs/seq_file.c                              |   10 ++-
 fs/sysv/inode.c                            |    6 +-
 include/linux/dcache.h                     |   21 +++--
 include/linux/fdtable.h                    |    2 -
 include/linux/fs.h                         |   24 +++---
 include/linux/fs_struct.h                  |    6 -
 include/linux/init_task.h                  |    1 +
 include/linux/namei.h                      |    5 +
 include/linux/security.h                   |  137 ++++++++++++++++++++++++++++
 net/unix/af_unix.c                         |    4 +
 security/Kconfig                           |    9 ++
 security/capability.c                      |   57 ++++++++++++
 security/security.c                        |   66 +++++++++++++
 81 files changed, 696 insertions(+), 351 deletions(-)
