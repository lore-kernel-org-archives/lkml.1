Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZCPHU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZCPHU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZCPHUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:20:44 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:35580 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZCPHUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:20:43 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #2 00/28] source files
Date: Mon, 16 Mar 2009 16:20:12 +0900
Message-Id: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second try to post aufs2 source files.
These are full aufs2 version against the mainline (linux-2.6.git).

Kindly review and let me know your comments.
And please consider incorporating into mainline.

Changes since last post,
(comments from Sam Ravnborg)
- correct my GIT work and split several patches against VFS. the number
  of patches became 28.
- add aufs_type.h to include/linux/Kbuild.
- remove priv.mk from fs/aufs/Makefile.
- and several tiny issues.


J. R. Okajima (28):
  aufs documents
  aufs public header file
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
  aufs branch for loopback block device
  aufs internal inotify
  aufs test for fstype
  aufs debug
  export splice functions
  export lookup functions
  kbuild aufs

 Documentation/filesystems/aufs/README              |  253 ++++
 Documentation/filesystems/aufs/aufs.5              | 1514 ++++++++++++++++++++
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
 fs/aufs/Kconfig                                    |   78 +
 fs/aufs/Makefile                                   |   19 +
 fs/aufs/aufs.h                                     |   43 +
 fs/aufs/branch.c                                   |  944 ++++++++++++
 fs/aufs/branch.h                                   |  200 +++
 fs/aufs/cpup.c                                     | 1028 +++++++++++++
 fs/aufs/cpup.h                                     |   68 +
 fs/aufs/dcsub.c                                    |  214 +++
 fs/aufs/dcsub.h                                    |   43 +
 fs/aufs/debug.c                                    |  406 ++++++
 fs/aufs/debug.h                                    |  245 ++++
 fs/aufs/dentry.c                                   |  858 +++++++++++
 fs/aufs/dentry.h                                   |  213 +++
 fs/aufs/dinfo.c                                    |  351 +++++
 fs/aufs/dir.c                                      |  493 +++++++
 fs/aufs/dir.h                                      |  104 ++
 fs/aufs/f_op.c                                     |  551 +++++++
 fs/aufs/file.c                                     |  552 +++++++
 fs/aufs/file.h                                     |  148 ++
 fs/aufs/finfo.c                                    |  126 ++
 fs/aufs/fstype.h                                   |  434 ++++++
 fs/aufs/hinotify.c                                 |  746 ++++++++++
 fs/aufs/i_op.c                                     |  857 +++++++++++
 fs/aufs/i_op_add.c                                 |  625 ++++++++
 fs/aufs/i_op_del.c                                 |  471 ++++++
 fs/aufs/i_op_ren.c                                 |  929 ++++++++++++
 fs/aufs/iinfo.c                                    |  257 ++++
 fs/aufs/inode.c                                    |  356 +++++
 fs/aufs/inode.h                                    |  471 ++++++
 fs/aufs/ioctl.c                                    |   54 +
 fs/aufs/loop.c                                     |   46 +
 fs/aufs/loop.h                                     |   41 +
 fs/aufs/magic.mk                                   |   52 +
 fs/aufs/module.c                                   |  164 +++
 fs/aufs/module.h                                   |   66 +
 fs/aufs/opts.c                                     | 1438 +++++++++++++++++++
 fs/aufs/opts.h                                     |  180 +++
 fs/aufs/plink.c                                    |  335 +++++
 fs/aufs/rwsem.h                                    |   52 +
 fs/aufs/sbinfo.c                                   |  192 +++
 fs/aufs/spl.h                                      |   47 +
 fs/aufs/super.c                                    |  846 +++++++++++
 fs/aufs/super.h                                    |  266 ++++
 fs/aufs/sysaufs.c                                  |   79 +
 fs/aufs/sysaufs.h                                  |  102 ++
 fs/aufs/sysfs.c                                    |  308 ++++
 fs/aufs/sysrq.c                                    |  106 ++
 fs/aufs/vdir.c                                     |  776 ++++++++++
 fs/aufs/vfsub.c                                    |  716 +++++++++
 fs/aufs/vfsub.h                                    |  137 ++
 fs/aufs/wbr_policy.c                               |  628 ++++++++
 fs/aufs/whout.c                                    | 1010 +++++++++++++
 fs/aufs/whout.h                                    |   78 +
 fs/aufs/wkq.c                                      |  249 ++++
 fs/aufs/wkq.h                                      |   72 +
 fs/aufs/xino.c                                     | 1181 +++++++++++++++
 fs/namei.c                                         |    4 +-
 fs/splice.c                                        |   10 +-
 include/linux/Kbuild                               |    1 +
 include/linux/aufs_type.h                          |   98 ++
 include/linux/namei.h                              |    3 +
 include/linux/splice.h                             |    6 +
 74 files changed, 23724 insertions(+), 7 deletions(-)
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

