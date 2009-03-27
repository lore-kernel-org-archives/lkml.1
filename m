Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZC0XMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZC0XMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZC0XMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:12:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZC0XMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:12:45 -0400
Date: Fri, 27 Mar 2009 23:12:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs - first pile
Message-ID: <20090327231242.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Isolated bits and pieces.  More interesting stuff will follow
tomorrow.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-linus

Shortlog:
Al Viro (16):
      constify dentry_operations: NFS
      constify dentry_operations: misc filesystems
      constify dentry_operations: 9p
      constify dentry_operations: autofs, autofs4
      constify dentry_operations: AFS
      constify dentry_operations: CIFS
      constify dentry_operations: ecryptfs
      constify dentry_operations: procfs
      constify dentry_operations: FUSE
      constify dentry_operations: FAT
      constify dentry_operations: GFS2
      constify dentry_operations: OCFS2
      constify dentry_operations: JFS
      constify dentry_operations: sysfs
      constify dentry_operations: configfs
      constify dentry_operations: rest

Cheng Renquan (1):
      do_pipe cleanup: drop its last user in arch/alpha/

Christoph Hellwig (4):
      affs: fix missing unlocks in affs_remove_link
      generic compat_sys_ustat
      cleanup d_add_ci
      cleanup may_open

Duane Griffin (4):
      ufs: validate maximum fast symlink size from superblock
      ufs: don't truncate longer ufs2 fast symlinks
      ufs: ensure fast symlinks are NUL-terminated
      ufs: copy symlink data into the correct union member

Jan Engelhardt (1):
      fs: make struct dentry->d_op const

Nick Piggin (2):
      fs: move bdev code out of buffer.c
      fs: avoid I_NEW inodes

Steven Whitehouse (2):
      vfs: Update fs.h to use inline functions when no file locking set
      vfs: Further changes from macro to inline function in fs.h

Sukadev Bhattiprolu (7):
      devpts: Must release s_umount on error
      vfs: simple_set_mnt() should return void
      Unroll essentials of do_remount_sb() into devpts
      Parse mount options just once and copy them to super block
      Move common mknod_ptmx() calls into caller
      Remove get_init_pts_sb()
      Merge code for single and multiple-instance mounts

Diffstat:
 arch/alpha/kernel/entry.S          |    3 +-
 arch/alpha/kernel/osf_sys.c        |    2 -
 arch/ia64/ia32/ia32_entry.S        |    2 +-
 arch/ia64/kernel/perfmon.c         |    2 +-
 arch/mips/kernel/linux32.c         |   34 ------
 arch/mips/kernel/scall64-n32.S     |    2 +-
 arch/mips/kernel/scall64-o32.S     |    2 +-
 arch/parisc/kernel/syscall_table.S |    2 +-
 arch/powerpc/include/asm/systbl.h  |    2 +-
 arch/s390/kernel/compat_wrapper.S  |    2 +-
 arch/x86/ia32/ia32entry.S          |    2 +-
 arch/x86/ia32/sys_ia32.c           |   22 ----
 arch/x86/include/asm/ia32.h        |    7 -
 arch/x86/include/asm/sys_ia32.h    |    2 -
 drivers/mtd/mtdsuper.c             |    7 +-
 fs/9p/v9fs_vfs.h                   |    4 +-
 fs/9p/vfs_dentry.c                 |    4 +-
 fs/9p/vfs_super.c                  |    5 +-
 fs/adfs/adfs.h                     |    2 +-
 fs/adfs/dir.c                      |    2 +-
 fs/affs/affs.h                     |    3 +-
 fs/affs/amigaffs.c                 |    8 +-
 fs/affs/namei.c                    |    4 +-
 fs/afs/dir.c                       |    2 +-
 fs/anon_inodes.c                   |    2 +-
 fs/autofs/root.c                   |    2 +-
 fs/autofs4/inode.c                 |    2 +-
 fs/autofs4/root.c                  |    4 +-
 fs/block_dev.c                     |  146 ++++++++++++++++++++++++
 fs/buffer.c                        |  145 ------------------------
 fs/cifs/cifsfs.c                   |    3 +-
 fs/cifs/cifsfs.h                   |    4 +-
 fs/cifs/dir.c                      |    4 +-
 fs/coda/dir.c                      |    2 +-
 fs/compat.c                        |   28 +++++
 fs/configfs/dir.c                  |    2 +-
 fs/dcache.c                        |   48 +++-----
 fs/devpts/inode.c                  |  188 ++++++++-----------------------
 fs/dquot.c                         |   10 ++-
 fs/drop_caches.c                   |    2 +-
 fs/ecryptfs/dentry.c               |    2 +-
 fs/ecryptfs/ecryptfs_kernel.h      |    2 +-
 fs/fat/namei_msdos.c               |    2 +-
 fs/fat/namei_vfat.c                |    4 +-
 fs/fuse/dir.c                      |    2 +-
 fs/fuse/fuse_i.h                   |    2 +-
 fs/gfs2/ops_dentry.c               |    2 +-
 fs/gfs2/super.h                    |    2 +-
 fs/hfs/hfs_fs.h                    |    2 +-
 fs/hfs/sysdep.c                    |    2 +-
 fs/hfsplus/hfsplus_fs.h            |    2 +-
 fs/hfsplus/inode.c                 |    2 +-
 fs/hostfs/hostfs_kern.c            |    4 +-
 fs/hpfs/dentry.c                   |    2 +-
 fs/inode.c                         |    2 +
 fs/isofs/inode.c                   |    2 +-
 fs/jfs/jfs_inode.h                 |    2 +-
 fs/jfs/namei.c                     |    4 +-
 fs/libfs.c                         |    5 +-
 fs/namei.c                         |   26 ++---
 fs/namespace.c                     |    3 +-
 fs/ncpfs/dir.c                     |    4 +-
 fs/nfs/dir.c                       |    4 +-
 fs/nfs/nfs4_fs.h                   |    2 +-
 fs/notify/inotify/inotify.c        |   16 ++--
 fs/ocfs2/dcache.c                  |    2 +-
 fs/ocfs2/dcache.h                  |    2 +-
 fs/pipe.c                          |    7 +-
 fs/proc/base.c                     |    6 +-
 fs/proc/generic.c                  |    2 +-
 fs/proc/proc_sysctl.c              |    4 +-
 fs/proc/root.c                     |    3 +-
 fs/reiserfs/xattr.c                |    2 +-
 fs/smbfs/dir.c                     |    4 +-
 fs/super.c                         |    9 +-
 fs/sysfs/dir.c                     |    2 +-
 fs/sysv/namei.c                    |    2 +-
 fs/sysv/sysv.h                     |    2 +-
 fs/ubifs/super.c                   |    3 +-
 fs/ufs/inode.c                     |   39 +++----
 fs/ufs/namei.c                     |    2 +-
 fs/ufs/super.c                     |   11 ++
 fs/ufs/ufs.h                       |    2 +-
 include/linux/buffer_head.h        |    7 -
 include/linux/compat.h             |    8 ++
 include/linux/dcache.h             |    2 +-
 include/linux/fs.h                 |  220 ++++++++++++++++++++++++++++++------
 include/linux/ncp_fs.h             |    2 +-
 include/linux/nfs_fs.h             |    2 +-
 include/linux/nfs_xdr.h            |    2 +-
 kernel/cgroup.c                    |    5 +-
 net/socket.c                       |    2 +-
 net/sunrpc/rpc_pipe.c              |    2 +-
 93 files changed, 603 insertions(+), 574 deletions(-)
