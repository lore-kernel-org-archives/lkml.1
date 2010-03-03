Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0CCWVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:21:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38386 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0CCWVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:21:09 -0500
Date: Wed, 3 Mar 2010 22:21:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches, beginning
Message-ID: <20100303222105.GU30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Assorted stuff for that cycle, part 1.  There will be more tomorrow.
Most of that coincides with the last for-next, with several more fixes added.
Two patches (do_lookup() ones) are dropped from queue, due to unfixable
problems they cause for autofs4; broken autofs4 patch that went in during
the last cycle gets reverted.  write_inode branch is *not* included into
today's queue due to conflicts in XFS.
	do_filp_open() patch series will go in tomorrow pile.

Please, pull from the usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (37):
      Lose the new_name argument of fsnotify_move()
      Lose the first argument of audit_inode_child()
      switch inotify_user to anon_inode
      Revert "autofs4: always use lookup for lookup"
      Switch may_open() and break_lease() to passing O_...
      Switch gfs2 to nd_set_link()
      Kill CL_PROPAGATION, sanitize fs/pnode.c:get_source()
      add several pieces to shared subtree documentation
      switch infiniband uverbs to anon_inodes
      Sanitize autofs_dev_ioctl_ismountpoint()
      Get rid of mnt_mountpoint abuses in ext4
      Use kill_litter_super() in autofs4 ->kill_sb()
      Don't bother with d_genocide in rpc_pipe
      Simplify failure exits in s390/hypfs fill_super()
      New helper: path_is_under(path1, path2)
      Switch alloc_nfs_open_context() to struct path
      a couple of mntget+dget -> path_get in nfs4proc
      fix mnt_mountpoint abuse in smack
      Clean follow_dotdot() up a bit
      fix NFS4 handling of mountpoint stat
      new helper: iterate_mounts()
      sanitize signedness/const for pointers to char in hpfs a bit
      sanitize const/signedness of ufs a bit
      nilfs really shouldn't slap struct dentry on stack...
      nilfs: sanitize const/signedness in dealing with ->d_name.name
      sanitize const/signedness for udf
      Don't mess with generic_permission() under ->d_lock in hpfs
      take check for new events in namespace (guts of mounts_poll()) to namespace.c
      get rid of insanity with namespace roots in tomoyo
      Take vfsmount_lock to fs/internal.h
      get rid of useless vfsmount_lock use in put_mnt_ns()
      Mirror MS_KERNMOUNT in ->mnt_flags
      hppfs can use existing proc_mnt, no need for do_kern_mount() in there
      get rid of ->mnt_parent in tomoyo/realpath
      set S_DEAD on unlink() and non-directory rename() victims
      fix race in d_splice_alias()
      Merge branch 'for-fsnotify' into for-linus

André Goddard Rosa (6):
      mqueue: fix mq_open() file descriptor leak on user-space processes
      mqueue: remove unneeded info->messages initialization
      mqueue: apply mathematics distributivity on mq_bytes calculation
      mqueue: simplify do_open() error handling
      mqueue: only set error codes if they are really necessary
      mqueue: fix typo "failues" -> "failures"

Boaz Harrosh (2):
      libfs: Open code simple_commit_write into only user
      libfs: Unexport and kill simple_prepare_write

Christoph Hellwig (1):
      kill unused invalidate_inode_pages helper

Eric W. Biederman (1):
      init: Open /dev/console from rootfs

H Hartley Sweeten (1):
      fs/dcache.c: CodingStyle cleanup

Helight.Xu (1):
      some clean up in fs/proc

Miklos Szeredi (1):
      vfs: add NOFOLLOW flag to umount(2)

Nick Piggin (1):
      fs: improve remount,ro vs buffercache coherency

Richard Kennedy (1):
      fs: re-order super_block to remove 16 bytes of padding on 64bit builds

Valerie Aurora (1):
      VFS: Clean up shared mount flag propagation

Diffstat:
 Documentation/filesystems/sharedsubtree.txt |   16 +-
 arch/s390/hypfs/inode.c                     |   42 +--
 arch/um/drivers/mconsole_kern.c             |    2 +-
 drivers/infiniband/Kconfig                  |    1 +
 drivers/infiniband/core/uverbs.h            |    2 +-
 drivers/infiniband/core/uverbs_cmd.c        |   25 ++-
 drivers/infiniband/core/uverbs_main.c       |   82 +-----
 drivers/usb/gadget/f_mass_storage.c         |    2 +-
 drivers/usb/gadget/file_storage.c           |    2 +-
 fs/autofs4/autofs_i.h                       |    7 -
 fs/autofs4/dev-ioctl.c                      |   11 +-
 fs/autofs4/expire.c                         |    6 +-
 fs/autofs4/inode.c                          |   63 +----
 fs/autofs4/root.c                           |  474 +++++++++------------------
 fs/cifs/file.c                              |    4 +-
 fs/dcache.c                                 |   70 +++--
 fs/debugfs/inode.c                          |    2 +-
 fs/ext4/file.c                              |    6 +-
 fs/gfs2/ops_inode.c                         |  113 ++-----
 fs/hpfs/anode.c                             |    2 +-
 fs/hpfs/dentry.c                            |   14 +-
 fs/hpfs/dir.c                               |   14 +-
 fs/hpfs/dnode.c                             |   21 +-
 fs/hpfs/ea.c                                |    7 +-
 fs/hpfs/hpfs_fn.h                           |   30 +-
 fs/hpfs/inode.c                             |    4 +-
 fs/hpfs/map.c                               |    6 +-
 fs/hpfs/name.c                              |   21 +-
 fs/hpfs/namei.c                             |   75 +++--
 fs/hppfs/hppfs.c                            |    2 +-
 fs/internal.h                               |    2 +
 fs/libfs.c                                  |   77 +++---
 fs/locks.c                                  |    5 +-
 fs/namei.c                                  |   44 +--
 fs/namespace.c                              |   53 +++-
 fs/nfs/inode.c                              |    8 +-
 fs/nfs/nfs4proc.c                           |    8 +-
 fs/nfsctl.c                                 |    5 +-
 fs/nfsd/nfs4xdr.c                           |   12 +-
 fs/nfsd/vfs.c                               |    4 +-
 fs/nilfs2/dir.c                             |   14 +-
 fs/nilfs2/namei.c                           |   13 +-
 fs/nilfs2/nilfs.h                           |    4 +-
 fs/notify/inotify/inotify_user.c            |   59 +---
 fs/open.c                                   |    2 +-
 fs/pnode.c                                  |   28 +-
 fs/pnode.h                                  |    5 +-
 fs/proc/base.c                              |   10 +-
 fs/proc/generic.c                           |    5 +
 fs/proc/root.c                              |    6 -
 fs/super.c                                  |   21 +-
 fs/udf/balloc.c                             |    2 +-
 fs/udf/dir.c                                |    4 +-
 fs/udf/inode.c                              |    2 +-
 fs/udf/namei.c                              |   20 +-
 fs/udf/symlink.c                            |   10 +-
 fs/ufs/dir.c                                |   10 +-
 fs/ufs/ufs.h                                |    4 +-
 include/linux/audit.h                       |   11 +-
 include/linux/fs.h                          |   26 +-
 include/linux/fsnotify.h                    |   11 +-
 include/linux/magic.h                       |    1 -
 include/linux/mnt_namespace.h               |    1 +
 include/linux/mount.h                       |   14 +-
 init/do_mounts_initrd.c                     |    4 -
 init/main.c                                 |   11 +-
 ipc/mqueue.c                                |  120 ++++---
 kernel/audit_tree.c                         |  100 ++----
 kernel/auditsc.c                            |    7 +-
 kernel/sysctl_binary.c                      |    7 +-
 mm/filemap.c                                |    2 +-
 net/sunrpc/rpc_pipe.c                       |    9 +-
 security/smack/smack_lsm.c                  |    2 +-
 security/tomoyo/realpath.c                  |   23 +-
 74 files changed, 777 insertions(+), 1135 deletions(-)
