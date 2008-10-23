Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYJWJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYJWJwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYJWJwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:52:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYJWJwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:52:12 -0400
Date: Thu, 23 Oct 2008 10:52:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches
Message-ID: <20081023095210.GJ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted VFS patches; a _lot_ is still pending (and part of the pending pile
consists of outright bug fixes).  This series at least should collect most
of the other folks' patches from the last cycle; I'd been sick
most of the last month, so there'd been a lot of delays with all that
stuff ;-/  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Adrian Bunk (1):
      [patch 1/3] FS_MBCACHE: don't needlessly make it built-in

Al Viro (16):
      new helper - kern_path()
      finally get rid of nameidata in namespace.c
      no need for noinline stuff in fs/namespace.c anymore
      switch quota_on-related stuff to kern_path()
      sanitize svc_export_parse()
      switch nfsd to kern_path()
      assorted path_lookup() -> kern_path() conversions
      get rid of nameidata in audit_tree
      get rid of path_lookup_create()
      don't pass bogus flags to LOOKUP_PARENT lookup in spufs
      make O_EXCL in nd->intent.flags visible in nd->flags
      reduce the stack footprint of exportfs_decode_fh()
      get rid of on-stack fake dentry in ext3_get_parent()
      get rid of on-stack dentry in ext2_get_parent()
      prepare vfs_readdir() callers to returning filldir result
      get rid of on-stack dentry in udf

Alexey Dobriyan (2):
      anondev: init IDR statically
      anondev: switch to IDA

Arjan van de Ven (1):
      fs: add a sanity check in d_free

Christoph Hellwig (9):
      dm: kill lookup_device wrapper
      hpfs: cleanup ->setattr
      tidy up chrdev_open
      generic_file_llseek tidyups
      new helper: d_obtain_alias
      switch all filesystems over to d_obtain_alias
      kill d_alloc_anon
      fix ->llseek for more directories
      reiserfs: add missing llseek method

Dan Williams (1):
      [RFC PATCH] touch_mnt_namespace when the mount flags change

David Woodhouse (6):
      Factor out nfsd_do_readdir() into its own function
      Copy XFS readdir hack into nfsd code.
      Remove XFS buffered readdir hack
      [JFFS2] Reinstate NFS exportability
      Optimise NFS readdir hack slightly.
      [JFFS2] Use d_splice_alias() not d_add() in jffs2_lookup()

Miklos Szeredi (2):
      move executable checking into ->permission()
      [patch] vfs: make security_inode_setattr() calling consistent

Mimi Zohar (1):
      i_version: remount support

OGAWA Hirofumi (6):
      vfs: replace parent == dentry->d_parent by IS_ROOT()
      vfs: add d_ancestor()
      vfs: add __d_instantiate() helper
      vfs: remove unnecessary fsnotify_d_instantiate()
      vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT lookup
      vfs: add LOOKUP_RENAME_TARGET intent

Qinghuang Feng (1):
      fs/dcache.c: update comment of d_validate()


Diffstat:
 arch/alpha/kernel/osf_sys.c                  |    7 +-
 arch/parisc/hpux/fs.c                        |    5 +-
 arch/powerpc/platforms/cell/spufs/syscalls.c |    4 +-
 drivers/md/dm-table.c                        |   21 +--
 fs/Kconfig                                   |    7 +-
 fs/afs/dir.c                                 |    1 +
 fs/attr.c                                    |   10 +-
 fs/bfs/dir.c                                 |    1 +
 fs/block_dev.c                               |   14 +-
 fs/char_dev.c                                |   21 ++-
 fs/cifs/cifsfs.c                             |   10 +-
 fs/coda/dir.c                                |    3 +
 fs/coda/pioctl.c                             |    2 +-
 fs/compat.c                                  |   22 +--
 fs/configfs/symlink.c                        |   16 +-
 fs/dcache.c                                  |  184 +++++++++++++-------------
 fs/dquot.c                                   |   10 +-
 fs/ecryptfs/main.c                           |   23 ++--
 fs/efs/namei.c                               |   29 +----
 fs/exportfs/expfs.c                          |   20 +--
 fs/ext2/dir.c                                |   14 +-
 fs/ext2/ext2.h                               |    4 +-
 fs/ext2/namei.c                              |   30 +----
 fs/ext3/namei.c                              |   84 +++++-------
 fs/ext3/super.c                              |   22 ++--
 fs/ext4/namei.c                              |   11 +--
 fs/ext4/super.c                              |   24 ++--
 fs/fat/dir.c                                 |    1 +
 fs/fat/inode.c                               |   52 +++-----
 fs/fuse/inode.c                              |   23 +--
 fs/gfs2/ops_export.c                         |   33 ++----
 fs/gfs2/ops_inode.c                          |    2 +-
 fs/hfs/inode.c                               |    8 -
 fs/hfsplus/inode.c                           |   13 --
 fs/hpfs/file.c                               |    2 +-
 fs/hpfs/hpfs_fn.h                            |    2 +-
 fs/hpfs/inode.c                              |   29 +++--
 fs/hpfs/namei.c                              |    2 +-
 fs/isofs/export.c                            |   33 +----
 fs/jffs2/dir.c                               |    7 +-
 fs/jffs2/super.c                             |   48 +++++++
 fs/jfs/namei.c                               |   16 +--
 fs/libfs.c                                   |   26 +----
 fs/namei.c                                   |  146 ++++++++++-----------
 fs/namespace.c                               |  133 +++++++++----------
 fs/nfs/dir.c                                 |    9 +-
 fs/nfs/getroot.c                             |   14 +-
 fs/nfsd/export.c                             |  125 ++++++++----------
 fs/nfsd/nfs4recover.c                        |   50 ++++----
 fs/nfsd/nfs4state.c                          |    8 +-
 fs/nfsd/nfsctl.c                             |    8 +-
 fs/nfsd/vfs.c                                |  126 +++++++++++++++---
 fs/ntfs/namei.c                              |   22 +---
 fs/ocfs2/export.c                            |   30 +----
 fs/omfs/dir.c                                |    1 +
 fs/openpromfs/inode.c                        |    1 +
 fs/proc/proc_sysctl.c                        |   11 ++-
 fs/read_write.c                              |   58 ++++++---
 fs/readdir.c                                 |   22 +--
 fs/reiserfs/file.c                           |    1 +
 fs/reiserfs/inode.c                          |   13 +--
 fs/reiserfs/namei.c                          |   11 +--
 fs/reiserfs/super.c                          |   18 ++--
 fs/super.c                                   |   15 +--
 fs/sysfs/dir.c                               |    1 +
 fs/udf/namei.c                               |   43 ++----
 fs/ufs/dir.c                                 |    1 +
 fs/xfs/linux-2.6/xfs_export.c                |   32 +----
 fs/xfs/linux-2.6/xfs_file.c                  |  128 ------------------
 fs/xfs/linux-2.6/xfs_ioctl.c                 |    7 +-
 include/linux/dcache.h                       |    3 +-
 include/linux/fs.h                           |    8 +-
 include/linux/namei.h                        |    8 +-
 init/main.c                                  |    1 -
 kernel/audit_tree.c                          |   48 ++++----
 net/unix/af_unix.c                           |   18 ++-
 76 files changed, 883 insertions(+), 1133 deletions(-)
