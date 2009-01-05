Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZAEREb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZAEREb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZAEREW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:04:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZAEREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:04:21 -0500
Date: Mon, 5 Jan 2009 17:04:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] VFS patch pile #2
Message-ID: <20090105170418.GO28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted VFS cleanups and fixes.  That should sweep the rest of simple stuff;
remaining bits (to go in the 3rd pile) are more interesting.  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (7):
      affs: do not zero ->i_op
      isofs check for NULL ->i_op in root directory is dead code
      ntfs: don't NULL i_op
      inode->i_op is never NULL
      zero i_uid/i_gid on inode allocation
      fix the treatment of jfs special inodes
      fix breakage in reiserfs_new_inode()

Alain Knaff (1):
      vfs: lseek(fd, 0, SEEK_CUR) race condition

Christoph Hellwig (1):
      add a vfs_fsync helper

Dmitri Monakhov (1):
      kill suid bit only for regular files

Eric Paris (1):
      sys_execve and sys_uselib do not call into fsnotify

Li Zefan (1):
      vfs: remove duplicate code in get_fs_type()

Michael Kerrisk (1):
      inotify: fix type errors in interfaces

Diffstat:
 arch/powerpc/platforms/cell/spufs/inode.c |    1 -
 arch/s390/hypfs/inode.c                   |    1 -
 drivers/infiniband/hw/ipath/ipath_fs.c    |    3 --
 drivers/isdn/capi/capifs.c                |    2 -
 drivers/misc/ibmasm/ibmasmfs.c            |    2 -
 drivers/oprofile/oprofilefs.c             |    3 --
 drivers/usb/core/inode.c                  |    1 -
 drivers/usb/gadget/file_storage.c         |   18 +----------
 drivers/usb/gadget/inode.c                |    1 -
 fs/affs/inode.c                           |    3 +-
 fs/autofs/inode.c                         |    2 -
 fs/autofs4/inode.c                        |    4 --
 fs/binfmt_misc.c                          |    3 --
 fs/cifs/inode.c                           |    2 +-
 fs/coda/file.c                            |   12 +------
 fs/configfs/inode.c                       |    3 --
 fs/cramfs/inode.c                         |    2 -
 fs/debugfs/inode.c                        |    3 --
 fs/devpts/inode.c                         |    4 --
 fs/ecryptfs/file.c                        |   15 ++-------
 fs/ecryptfs/inode.c                       |    3 +-
 fs/exec.c                                 |    5 +++
 fs/filesystems.c                          |   23 ++++++++------
 fs/hugetlbfs/inode.c                      |    1 -
 fs/inode.c                                |    2 +
 fs/isofs/inode.c                          |    6 ---
 fs/jfs/jfs_imap.c                         |   10 ++++--
 fs/libfs.c                                |    5 ---
 fs/namei.c                                |   32 ++++++++-----------
 fs/nfsd/vfs.c                             |   43 ++++---------------------
 fs/notify/inotify/inotify_user.c          |    2 +-
 fs/ntfs/inode.c                           |    3 --
 fs/ocfs2/dlm/dlmfs.c                      |    2 -
 fs/omfs/inode.c                           |    1 -
 fs/open.c                                 |    2 +-
 fs/openpromfs/inode.c                     |    3 --
 fs/proc/base.c                            |    4 --
 fs/proc/proc_sysctl.c                     |    1 -
 fs/ramfs/inode.c                          |    1 -
 fs/read_write.c                           |   13 ++++++++
 fs/reiserfs/inode.c                       |   13 +++----
 fs/romfs/inode.c                          |    1 -
 fs/stat.c                                 |    2 +-
 fs/sync.c                                 |   48 ++++++++++++++++++++++------
 fs/sysfs/inode.c                          |    3 --
 fs/xattr.c                                |    2 +-
 include/linux/fs.h                        |    2 +-
 include/linux/syscalls.h                  |    2 +-
 ipc/mqueue.c                              |    1 -
 kernel/cgroup.c                           |    1 -
 mm/filemap.c                              |    2 +-
 mm/memory.c                               |    4 +-
 mm/msync.c                                |    2 +-
 mm/nommu.c                                |    2 +-
 net/sunrpc/rpc_pipe.c                     |    2 -
 security/commoncap.c                      |    6 ++--
 security/inode.c                          |    3 --
 security/selinux/selinuxfs.c              |    2 -
 58 files changed, 126 insertions(+), 219 deletions(-)
