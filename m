Return-Path: <linux-kernel-owner+w=401wt.eu-S938774AbZDJHaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938774AbZDJHaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938132AbZDJHSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:18:45 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:61550 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938106AbZDJHSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:18:18 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 00/29] souce files
Date: Fri, 10 Apr 2009 16:02:14 +0900
Message-Id: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This my third trial to post entire aufs2 source files for reviewing
(#3 and #4 were partial).
Kindly Greg KH reviewed them and gave me an advice to send full files.
These patches are aginst 2.6.30-rc1.

Here are changes since the post #2.
- bugfix: stop storing nd->intent.open.flags when the file is not a
  regular file
- convert some aufs entries from sysfs to debugfs
- support ramfs branch
- stop changing ->f_flags at modifying a branch permission
- stop copying-up in mmap(2) when MAP_PRIVATE is specified
- simplify, ->f_op is always set
- follow the changes in mainline
  + make file_operations const
  + acquire ->f_lock at touching ->f_flags
  + support credential and IMA at opening a file
  + support fmode_t
  + support relatime, ignore silently (temporary workaround)
- several fixes in documents.

In public aufs2 GIT tree, I made more enhancements which are NOT
included here. Because it is better to keep files smaller for reviewing
on LKML.
The dropped features are,
- VDIR variable size
- support exporting via NFS

Thnak you for reviewing.
And please consider merging aufs2.


J. R. Okajima (29):
  aufs documents
  aufs module global
  aufs super_block
  aufs branch directory/filesystem
  aufs xino
  aufs object lifetime management via sysfs
  aufs mount options/flags
  aufs workqueue
  aufs sub-VFS
  aufs sub-dcache
  aufs copy-up
  aufs whiteout
  aufs pseudo-link
  aufs policies to select one among multiple writable branches
  aufs dentry and lookup
  aufs file
  aufs direcotry
  aufs inode
  aufs ioctl
  aufs sysfs entries
  aufs debugfs entries
  aufs branch for loopback block device
  aufs internal inotify
  aufs test for fstype
  aufs debug
  aufs public header file
  export splice functions
  export lookup functions
  kbuild aufs

 Documentation/ABI/testing/debugfs-aufs             |   40 +
 Documentation/ABI/testing/sysfs-aufs               |   25 +
 Documentation/filesystems/aufs/README              |  252 ++++
 Documentation/filesystems/aufs/aufs.5              | 1538 ++++++++++++++++++++
 Documentation/filesystems/aufs/design/01intro.txt  |  128 ++
 Documentation/filesystems/aufs/design/02struct.txt |  205 +++
 Documentation/filesystems/aufs/design/03lookup.txt |   95 ++
 Documentation/filesystems/aufs/design/04branch.txt |   67 +
 .../filesystems/aufs/design/05wbr_policy.txt       |   57 +
 .../filesystems/aufs/design/06fmode_exec.txt       |   24 +
 Documentation/filesystems/aufs/design/07mmap.txt   |   44 +
 Documentation/filesystems/aufs/design/08plan.txt   |  169 +++
 fs/Kconfig                                         |    1 +
 fs/Makefile                                        |    1 +
 fs/aufs/Kconfig                                    |   91 ++
 fs/aufs/Makefile                                   |   20 +
 fs/aufs/aufs.h                                     |   44 +
 fs/aufs/branch.c                                   |  946 ++++++++++++
 fs/aufs/branch.h                                   |  205 +++
 fs/aufs/cpup.c                                     | 1023 +++++++++++++
 fs/aufs/cpup.h                                     |   68 +
 fs/aufs/dbgaufs.c                                  |  304 ++++
 fs/aufs/dbgaufs.h                                  |   68 +
 fs/aufs/dcsub.c                                    |  214 +++
 fs/aufs/dcsub.h                                    |   43 +
 fs/aufs/debug.c                                    |  414 ++++++
 fs/aufs/debug.h                                    |  243 +++
 fs/aufs/dentry.c                                   |  860 +++++++++++
 fs/aufs/dentry.h                                   |  213 +++
 fs/aufs/dinfo.c                                    |  351 +++++
 fs/aufs/dir.c                                      |  495 +++++++
 fs/aufs/dir.h                                      |  104 ++
 fs/aufs/f_op.c                                     |  551 +++++++
 fs/aufs/file.c                                     |  566 +++++++
 fs/aufs/file.h                                     |  148 ++
 fs/aufs/finfo.c                                    |  124 ++
 fs/aufs/fstype.h                                   |  464 ++++++
 fs/aufs/hinotify.c                                 |  746 ++++++++++
 fs/aufs/i_op.c                                     |  859 +++++++++++
 fs/aufs/i_op_add.c                                 |  625 ++++++++
 fs/aufs/i_op_del.c                                 |  471 ++++++
 fs/aufs/i_op_ren.c                                 |  929 ++++++++++++
 fs/aufs/iinfo.c                                    |  257 ++++
 fs/aufs/inode.c                                    |  356 +++++
 fs/aufs/inode.h                                    |  471 ++++++
 fs/aufs/ioctl.c                                    |   54 +
 fs/aufs/loop.c                                     |   46 +
 fs/aufs/loop.h                                     |   41 +
 fs/aufs/magic.mk                                   |   58 +
 fs/aufs/module.c                                   |  164 +++
 fs/aufs/module.h                                   |   66 +
 fs/aufs/opts.c                                     | 1441 ++++++++++++++++++
 fs/aufs/opts.h                                     |  180 +++
 fs/aufs/plink.c                                    |  335 +++++
 fs/aufs/rwsem.h                                    |   52 +
 fs/aufs/sbinfo.c                                   |  192 +++
 fs/aufs/spl.h                                      |   47 +
 fs/aufs/super.c                                    |  851 +++++++++++
 fs/aufs/super.h                                    |  285 ++++
 fs/aufs/sysaufs.c                                  |   95 ++
 fs/aufs/sysaufs.h                                  |  109 ++
 fs/aufs/sysfs.c                                    |  198 +++
 fs/aufs/sysrq.c                                    |  106 ++
 fs/aufs/vdir.c                                     |  776 ++++++++++
 fs/aufs/vfsub.c                                    |  748 ++++++++++
 fs/aufs/vfsub.h                                    |  165 +++
 fs/aufs/wbr_policy.c                               |  628 ++++++++
 fs/aufs/whout.c                                    | 1010 +++++++++++++
 fs/aufs/whout.h                                    |   78 +
 fs/aufs/wkq.c                                      |  249 ++++
 fs/aufs/wkq.h                                      |   72 +
 fs/aufs/xino.c                                     | 1176 +++++++++++++++
 fs/namei.c                                         |    4 +-
 fs/splice.c                                        |   10 +-
 include/linux/Kbuild                               |    1 +
 include/linux/aufs_type.h                          |   98 ++
 include/linux/namei.h                              |    3 +
 include/linux/splice.h                             |    6 +
 78 files changed, 24256 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-aufs
 create mode 100644 Documentation/ABI/testing/sysfs-aufs
 create mode 100644 Documentation/filesystems/aufs/README
 create mode 100644 Documentation/filesystems/aufs/aufs.5
 create mode 100644 Documentation/filesystems/aufs/design/01intro.txt
 create mode 100644 Documentation/filesystems/aufs/design/02struct.txt
 create mode 100644 Documentation/filesystems/aufs/design/03lookup.txt
 create mode 100644 Documentation/filesystems/aufs/design/04branch.txt
 create mode 100644 Documentation/filesystems/aufs/design/05wbr_policy.txt
 create mode 100644 Documentation/filesystems/aufs/design/06fmode_exec.txt
 create mode 100644 Documentation/filesystems/aufs/design/07mmap.txt
 create mode 100644 Documentation/filesystems/aufs/design/08plan.txt
 create mode 100644 fs/aufs/Kconfig
 create mode 100644 fs/aufs/Makefile
 create mode 100644 fs/aufs/aufs.h
 create mode 100644 fs/aufs/branch.c
 create mode 100644 fs/aufs/branch.h
 create mode 100644 fs/aufs/cpup.c
 create mode 100644 fs/aufs/cpup.h
 create mode 100644 fs/aufs/dbgaufs.c
 create mode 100644 fs/aufs/dbgaufs.h
 create mode 100644 fs/aufs/dcsub.c
 create mode 100644 fs/aufs/dcsub.h
 create mode 100644 fs/aufs/debug.c
 create mode 100644 fs/aufs/debug.h
 create mode 100644 fs/aufs/dentry.c
 create mode 100644 fs/aufs/dentry.h
 create mode 100644 fs/aufs/dinfo.c
 create mode 100644 fs/aufs/dir.c
 create mode 100644 fs/aufs/dir.h
 create mode 100644 fs/aufs/f_op.c
 create mode 100644 fs/aufs/file.c
 create mode 100644 fs/aufs/file.h
 create mode 100644 fs/aufs/finfo.c
 create mode 100644 fs/aufs/fstype.h
 create mode 100644 fs/aufs/hinotify.c
 create mode 100644 fs/aufs/i_op.c
 create mode 100644 fs/aufs/i_op_add.c
 create mode 100644 fs/aufs/i_op_del.c
 create mode 100644 fs/aufs/i_op_ren.c
 create mode 100644 fs/aufs/iinfo.c
 create mode 100644 fs/aufs/inode.c
 create mode 100644 fs/aufs/inode.h
 create mode 100644 fs/aufs/ioctl.c
 create mode 100644 fs/aufs/loop.c
 create mode 100644 fs/aufs/loop.h
 create mode 100644 fs/aufs/magic.mk
 create mode 100644 fs/aufs/module.c
 create mode 100644 fs/aufs/module.h
 create mode 100644 fs/aufs/opts.c
 create mode 100644 fs/aufs/opts.h
 create mode 100644 fs/aufs/plink.c
 create mode 100644 fs/aufs/rwsem.h
 create mode 100644 fs/aufs/sbinfo.c
 create mode 100644 fs/aufs/spl.h
 create mode 100644 fs/aufs/super.c
 create mode 100644 fs/aufs/super.h
 create mode 100644 fs/aufs/sysaufs.c
 create mode 100644 fs/aufs/sysaufs.h
 create mode 100644 fs/aufs/sysfs.c
 create mode 100644 fs/aufs/sysrq.c
 create mode 100644 fs/aufs/vdir.c
 create mode 100644 fs/aufs/vfsub.c
 create mode 100644 fs/aufs/vfsub.h
 create mode 100644 fs/aufs/wbr_policy.c
 create mode 100644 fs/aufs/whout.c
 create mode 100644 fs/aufs/whout.h
 create mode 100644 fs/aufs/wkq.c
 create mode 100644 fs/aufs/wkq.h
 create mode 100644 fs/aufs/xino.c
 create mode 100644 include/linux/aufs_type.h

