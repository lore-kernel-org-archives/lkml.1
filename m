Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZFQHHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZFQHHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbZFQHH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:07:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35275 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZFQHH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:07:29 -0400
Date: Wed, 17 Jun 2009 08:07:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches, part 2
Message-ID: <20090617070731.GH8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostlty BKL removal in VFS and filesystems. Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-linus

Al Viro (8):
      No instance of ->bmap() needs BKL
      fuse doesn't need BKL in ->umount_begin()
      9P doesn't need BKL in ->umount_begin()
      Cleanup of adfs headers
      befs ->pust_super() doesn't need BKL
      get rid of BKL in fs/efs
      get rid of BKL in fs/minix
      get rid of BKL in fs/sysv

J. R. Okajima (1):
      remove unlock_kernel() left accidentally

Linus Torvalds (1):
      ext3: avoid unnecessary spinlock in critical POSIX ACL path

Theodore Ts'o (1):
      ext4: avoid unnecessary spinlock in critical POSIX ACL path

 Documentation/filesystems/Locking |    2 +-
 fs/9p/vfs_super.c                 |    3 --
 fs/adfs/adfs.h                    |   55 +++++++++++++++++++++++++++++++++++++
 fs/adfs/dir.c                     |    8 -----
 fs/adfs/dir_f.c                   |    8 -----
 fs/adfs/dir_fplus.c               |    8 -----
 fs/adfs/file.c                    |    4 ---
 fs/adfs/inode.c                   |   10 -------
 fs/adfs/map.c                     |    6 ----
 fs/adfs/super.c                   |   17 +----------
 fs/befs/linuxvfs.c                |    4 ---
 fs/efs/dir.c                      |    5 +---
 fs/efs/namei.c                    |    9 +-----
 fs/efs/symlink.c                  |    7 +----
 fs/ext3/acl.c                     |   13 +++++---
 fs/ext4/acl.c                     |   15 ++++++----
 fs/fuse/inode.c                   |    3 --
 fs/ioctl.c                        |    2 -
 fs/minix/bitmap.c                 |   25 +++++++++--------
 fs/minix/dir.c                    |    5 +---
 fs/minix/inode.c                  |    4 ---
 fs/super.c                        |   12 ++------
 fs/sysv/dir.c                     |    5 +---
 fs/sysv/inode.c                   |   11 -------
 include/linux/adfs_fs.h           |   13 ---------
 include/linux/adfs_fs_i.h         |   24 ----------------
 include/linux/adfs_fs_sb.h        |   38 -------------------------
 27 files changed, 96 insertions(+), 220 deletions(-)
 delete mode 100644 include/linux/adfs_fs_i.h
 delete mode 100644 include/linux/adfs_fs_sb.h
