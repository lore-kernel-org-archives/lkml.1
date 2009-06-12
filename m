Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZFLBpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZFLBpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZFLBpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:45:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36938 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZFLBpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:45:06 -0400
Date: Fri, 12 Jun 2009 02:45:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches, part 1
Message-ID: <20090612014507.GA8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	All sorts of stuff, from more people than usual.  Among other stuff:
* sanitizing superblock methods (me, hch, Jan Kara)
* more pushing of lock_super() and BKL down into fs (by now only ->get_sb()
  has the latter held by caller and nothing in VFS touches the former) (me,
  hch, Alessio Igor Bogani)
* ->fsync() sanitizing and fixes (tangentially related to sb methods work;
  file_fsync() must die and it's getting on the way to extinction)
* _very_ welcome speedup of mnt_want_write() from Nick Piggin
* solution for Trond's "nfs wants to have pathname resolution starting
  at isolate vfsmount, with automounting" problem

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (36):
      Get rid of path_lookup in autofs4
      Preparations to caching root in path_walk()
      Cache root in nameidata
      Make vfs_path_lookup() use starting point as root
      Don't bother with check_mnt() in do_add_mount() on shrinkable ones
      nfsd struct path use: exp_get_by_name()
      switch exp_parent() to struct path
      switch rqst_exp_get_by_name()
      switch rqst_exp_parent()
      switch follow_up() to struct path
      Switch collect_mounts() to struct path
      switch follow_down()
      switch follow_mount()
      switch lookup_mnt()
      Move junk from proc_fs.h to fs/proc/internal.h
      Make sure that all callers of remount hold s_umount exclusive
      Trim a bit of crap from fs.h
      No need to do lock_super() for exclusion in generic_shutdown_super()
      Push lock_super() into the ->remount_fs() of filesystems that care about it
      Push BKL into do_mount()
      Push BKL down beyond VFS-only parts of do_mount()
      Push BKL down into do_remount_sb()
      New helper - simple_fsync()
      Sanitize qnx4 fsync handling
      fs/qnx4: sanitize includes
      Sanitize ->fsync() for FAT
      switch ext2 to simple_fsync()
      switch minix to simple_fsync()
      repair sysv_write_inode(), switch sysv to simple_fsync()
      switch ufs to simple_fsync()
      switch udf to simple_fsync()
      switch omfs to simple_fsync()
      repair adfs ->write_inode(), switch to simple_fsync()
      Fix adfs GET_FRAG_ID() on big-endian
      repair bfs_write_inode(), switch bfs to simple_fsync()
      sanitize ->fsync() for affs

Alessio Igor Bogani (1):
      Push BKL down into ->remount_fs()

Alexey Dobriyan (1):
      dcache: extrace and use d_unlinked()

Christoph Hellwig (26):
      remove s_async_list
      quota: cleanup dquota sync functions (version 4)
      btrfs: remove ->write_super and stop maintaining ->s_dirt
      ext3: remove ->write_super and stop maintaining ->s_dirt
      gfs2: remove ->write_super and stop maintaining ->s_dirt
      ocfs2: remove ->write_super and stop maintaining ->s_dirt
      qnx4: remove ->write_super
      remove ->write_super call in generic_shutdown_super
      cleanup sync_supers
      enforce ->sync_fs is only called for rw superblock
      push BKL down into ->put_super
      jffs2: move jffs2_write_super to super.c
      ->write_super lock_super pushdown
      xfs: remove ->write_super and stop maintaining ->s_dirt
      affs: add ->sync_fs
      bfs: add ->sync_fs
      exofs: add ->sync_fs
      ext2: add ->sync_fs
      fat: add ->sync_fs
      hfs: add ->sync_fs
      hfsplus: add ->sync_fs
      sysv: add ->sync_fs
      ufs: add ->sync_fs
      jffs2: call jffs2_write_super from jffs2_sync_fs
      nilfs2: call nilfs2_write_super from nilfs2_sync_fs
      remove the call to ->write_super in __sync_filesystem

Jan Kara (7):
      vfs: Fix sys_sync() and fsync_super() reliability (version 4)
      vfs: Call ->sync_fs() even if s_dirt is 0 (version 4)
      vfs: Make __fsync_super() a static function (version 4)
      vfs: Make sys_sync() use fsync_super() (version 4)
      vfs: Move syncing code from super.c to sync.c (version 4)
      vfs: Rename fsync_super() to sync_filesystem() (version 4)
      quota: Introduce writeout_quota_sb() (version 4)

Jeff Mahoney (1):
      reiserfs: allow exposing privroot w/ xattrs enabled

Jens Axboe (1):
      ntfs: remove old debug check for dirty data in ntfs_put_super()

Mike Frysinger (1):
      linux/magic.h: move cramfs magic out of cramfs_fs.h

Nick Piggin (5):
      fs: remove incorrect I_NEW warnings
      fs: block_dump missing dentry locking
      fs: mnt_want_write speedup
      fs: introduce mnt_clone_write
      fs: move mark_files_ro into file_table.c

Ryusuke Konishi (6):
      nilfs2: remove meaningless EBUSY case from nilfs_get_sb function
      nilfs2: get rid of sget use for acquiring nilfs object
      nilfs2: get rid of sget use for checking if current mount is present
      nilfs2: simplify remaining sget() use
      nilfs2: correct exclusion control in nilfs_remount function
      nilfs2: get rid of bd_mount_sem use from nilfs

Theodore Ts'o (2):
      fs: Remove i_cindex from struct inode
      fs: Rearrange inode structure elements to avoid waste due to padding

Diffstat:
 arch/alpha/kernel/osf_sys.c      |    3 -
 drivers/ieee1394/dv1394.c        |    5 +-
 drivers/ieee1394/ieee1394_core.h |    6 +-
 drivers/usb/core/inode.c         |    5 +
 fs/adfs/adfs.h                   |    4 +-
 fs/adfs/dir.c                    |   10 +-
 fs/adfs/dir_f.c                  |   17 ++
 fs/adfs/dir_fplus.c              |   17 ++
 fs/adfs/file.c                   |    2 +-
 fs/adfs/inode.c                  |    4 +-
 fs/adfs/map.c                    |    2 +-
 fs/adfs/super.c                  |    4 +
 fs/affs/affs.h                   |    1 +
 fs/affs/dir.c                    |    2 +-
 fs/affs/file.c                   |   14 ++-
 fs/affs/super.c                  |   54 +++++--
 fs/afs/mntpt.c                   |    2 +-
 fs/afs/super.c                   |    4 +
 fs/autofs/dirhash.c              |    5 +-
 fs/autofs4/autofs_i.h            |    6 +-
 fs/autofs4/dev-ioctl.c           |  195 +++++++----------------
 fs/autofs4/expire.c              |   15 +-
 fs/autofs4/root.c                |    7 +-
 fs/befs/linuxvfs.c               |    5 +-
 fs/bfs/dir.c                     |    8 +-
 fs/bfs/inode.c                   |   52 +++++--
 fs/block_dev.c                   |   19 ++-
 fs/btrfs/inode.c                 |    7 -
 fs/btrfs/super.c                 |   11 --
 fs/cachefiles/interface.c        |    4 +-
 fs/char_dev.c                    |   14 ++-
 fs/cifs/cifs_dfs_ref.c           |    2 +-
 fs/cifs/cifsfs.c                 |    6 +-
 fs/compat.c                      |    2 -
 fs/dcache.c                      |    7 +-
 fs/ecryptfs/super.c              |    5 +
 fs/exofs/super.c                 |   25 +++-
 fs/ext2/Makefile                 |    2 +-
 fs/ext2/dir.c                    |    2 +-
 fs/ext2/ext2.h                   |    3 -
 fs/ext2/file.c                   |    4 +-
 fs/ext2/fsync.c                  |   50 ------
 fs/ext2/inode.c                  |   11 +-
 fs/ext2/super.c                  |   60 +++++--
 fs/ext3/balloc.c                 |    3 +-
 fs/ext3/ialloc.c                 |    3 +-
 fs/ext3/inode.c                  |    1 -
 fs/ext3/resize.c                 |    2 -
 fs/ext3/super.c                  |   34 ++---
 fs/ext3/xattr.c                  |    1 -
 fs/ext4/super.c                  |   16 ++-
 fs/fat/dir.c                     |   16 +-
 fs/fat/fat.h                     |    6 +
 fs/fat/fatent.c                  |   13 +-
 fs/fat/file.c                    |   14 ++-
 fs/fat/inode.c                   |   31 ++++-
 fs/fat/namei_msdos.c             |    4 +-
 fs/fat/namei_vfat.c              |    4 +-
 fs/file_table.c                  |   40 +++++-
 fs/freevxfs/vxfs_super.c         |    4 +
 fs/fs-writeback.c                |   92 +++--------
 fs/gfs2/log.c                    |    2 -
 fs/gfs2/super.c                  |   15 +--
 fs/hfs/super.c                   |   23 +++-
 fs/hfsplus/super.c               |   25 +++-
 fs/hpfs/super.c                  |   12 ++
 fs/inode.c                       |    2 +-
 fs/internal.h                    |   17 ++
 fs/isofs/inode.c                 |    5 +
 fs/jffs2/fs.c                    |   18 +--
 fs/jffs2/os-linux.h              |    1 -
 fs/jffs2/super.c                 |   26 +++
 fs/jfs/super.c                   |   27 +++-
 fs/libfs.c                       |   25 +++
 fs/minix/dir.c                   |    2 +-
 fs/minix/file.c                  |   20 +---
 fs/minix/inode.c                 |   37 ++---
 fs/minix/minix.h                 |    2 -
 fs/namei.c                       |  129 +++++++++------
 fs/namespace.c                   |  327 ++++++++++++++++----------------------
 fs/ncpfs/inode.c                 |    4 +
 fs/nfs/namespace.c               |    2 +-
 fs/nfs/super.c                   |    2 +
 fs/nfsd/export.c                 |   78 ++++------
 fs/nfsd/vfs.c                    |   54 +++---
 fs/nilfs2/cpfile.c               |    6 +-
 fs/nilfs2/sb.h                   |    1 +
 fs/nilfs2/super.c                |  256 +++++++++++-------------------
 fs/nilfs2/the_nilfs.c            |  113 +++++++++++++-
 fs/nilfs2/the_nilfs.h            |   23 +++-
 fs/ntfs/super.c                  |   54 +++----
 fs/ocfs2/super.c                 |   22 +--
 fs/omfs/file.c                   |   17 +--
 fs/open.c                        |    4 +-
 fs/proc/internal.h               |   25 +++
 fs/proc/proc_devtree.c           |    1 +
 fs/qnx4/Makefile                 |    2 +-
 fs/qnx4/bitmap.c                 |    7 +-
 fs/qnx4/dir.c                    |    9 +-
 fs/qnx4/file.c                   |    5 +-
 fs/qnx4/fsync.c                  |  169 --------------------
 fs/qnx4/inode.c                  |   58 ++-----
 fs/qnx4/namei.c                  |   13 +--
 fs/qnx4/qnx4.h                   |   57 +++++++
 fs/qnx4/truncate.c               |    6 +-
 fs/quota/quota.c                 |   25 ++--
 fs/reiserfs/dir.c                |   10 +-
 fs/reiserfs/super.c              |   33 +++--
 fs/reiserfs/xattr.c              |    3 +-
 fs/smbfs/inode.c                 |    4 +
 fs/squashfs/super.c              |    4 +
 fs/super.c                       |  192 ++++-------------------
 fs/sync.c                        |  117 ++++++++++++--
 fs/sysv/dir.c                    |    2 +-
 fs/sysv/file.c                   |   17 +--
 fs/sysv/inode.c                  |   75 +++++----
 fs/sysv/sysv.h                   |    1 -
 fs/ubifs/super.c                 |   17 ++-
 fs/udf/Makefile                  |    2 +-
 fs/udf/dir.c                     |    2 +-
 fs/udf/file.c                    |    2 +-
 fs/udf/fsync.c                   |   52 ------
 fs/udf/super.c                   |   11 ++-
 fs/udf/udfdecl.h                 |    3 -
 fs/ufs/dir.c                     |    2 +-
 fs/ufs/file.c                    |   23 +---
 fs/ufs/super.c                   |   65 ++++++--
 fs/ufs/ufs.h                     |    1 -
 fs/xattr.c                       |    4 +-
 fs/xfs/linux-2.6/xfs_super.c     |   12 --
 fs/xfs/xfs_trans.c               |    2 -
 include/linux/Kbuild             |    2 +-
 include/linux/cdev.h             |    2 +
 include/linux/cramfs_fs.h        |    3 +-
 include/linux/dcache.h           |    7 +-
 include/linux/fs.h               |   21 +--
 include/linux/magic.h            |    2 +
 include/linux/mount.h            |   25 +++-
 include/linux/namei.h            |    5 +-
 include/linux/nfsd/export.h      |    6 +-
 include/linux/proc_fs.h          |   24 ---
 include/linux/qnx4_fs.h          |   61 -------
 include/linux/quotaops.h         |   20 ++-
 include/linux/reiserfs_fs_sb.h   |    2 +
 include/linux/writeback.h        |    1 -
 kernel/audit_tree.c              |    6 +-
 kernel/cgroup.c                  |    3 +
 147 files changed, 1707 insertions(+), 1834 deletions(-)
