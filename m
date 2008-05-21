Return-Path: <linux-kernel-owner+w=401wt.eu-S1763640AbYEUDXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763640AbYEUDXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYEUDXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:23:14 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:43922 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYEUDXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:23:12 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 00/39] AUFS: merging/stacking several filesystems
Date: Wed, 21 May 2008 12:22:30 +0900
Message-Id: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

I have posted some of ideas, design or approaches which are implemented
in AUFS stackable filesystem about a month before.
While I have a plan to implement some more features still, the current
AUFS status is better and used many people for years.
Since I have received requests to submit AUFS into the mainline more
than once, Now I'd ask you to include AUFS into mainline.

After last posts last week, I received several review comments and fixed
several things.
Thank you all reviewers.

- grouping/folding some files into a single patch (67 --> 39 patches)
- more description texts
- refine and remove some obsoleted lines from fs/aufs/Kconfig, Makefile,
  fs/aufs/aufs.h, fs/aufs/module.c, and
  Documentation/filesystems/aufs/README.
- new file Documentation/filesystems/aufs/Design
- new configuration AUFS_HIN_OR_DLGT
- convert '//' comment style into '/* */'
- remove some lines for local test and debugging

----------------------------------------------------------------------

Junjiro Okajima (39):
  aufs documents
  aufs manual
  aufs configuration and Makefile
  aufs module global
  aufs super_block
  aufs branch directory/filesystem
  aufs xino
  aufs branch filesystem type specific
  aufs object lifetime management via sysfs
  aufs mount options/flags
  aufs workqueue
  aufs sub-VFS
  aufs sub-dcache
  aufs copy-up
  aufs whiteout
  aufs pseudo-link
  aufs policies to select one among multiple writable branches
  aufs dentry (main lookup)
  aufs dentry (except lookup)
  aufs file
  aufs file (vm op)
  aufs direcotry
  aufs virtual or vertical(stacked) directory
  aufs inode
  aufs inode add operations
  aufs inode del operations
  aufs inode rename operation
  aufs inode other operations
  aufs lower inode and internal inotify
  aufs delegate mode
  aufs lower inode and delegate-mode
  aufs export via NFS
  aufs robr-mode
  aufs sysfs entries
  aufs misc functions
  aufs debug print and magic sysrq
  aufs mount/umount helpers
  aufs global header file
  merge aufs

 Documentation/filesystems/aufs/Design      |  311 ++++++
 Documentation/filesystems/aufs/README      |  152 +++
 Documentation/filesystems/aufs/aufs.5      | 1609 ++++++++++++++++++++++++++++
 Documentation/filesystems/aufs/aulchown.c  |   28 +
 Documentation/filesystems/aufs/auplink     |  168 +++
 Documentation/filesystems/aufs/mount.aufs  |  203 ++++
 Documentation/filesystems/aufs/umount.aufs |   31 +
 fs/Kconfig                                 |    2 +
 fs/Makefile                                |    1 +
 fs/aufs/Kconfig                            |  174 +++
 fs/aufs/Makefile                           |   39 +
 fs/aufs/aufs.h                             |   52 +
 fs/aufs/br_fuse.c                          |  107 ++
 fs/aufs/br_nfs.c                           |  347 ++++++
 fs/aufs/br_xfs.c                           |   67 ++
 fs/aufs/branch.c                           |  912 ++++++++++++++++
 fs/aufs/branch.h                           |  352 ++++++
 fs/aufs/cpup.c                             | 1021 ++++++++++++++++++
 fs/aufs/cpup.h                             |   80 ++
 fs/aufs/dcsub.c                            |  244 +++++
 fs/aufs/dcsub.h                            |   52 +
 fs/aufs/debug.c                            |  466 ++++++++
 fs/aufs/debug.h                            |  208 ++++
 fs/aufs/dentry.c                           |  959 +++++++++++++++++
 fs/aufs/dentry.h                           |  381 +++++++
 fs/aufs/dinfo.c                            |  409 +++++++
 fs/aufs/dir.c                              |  548 ++++++++++
 fs/aufs/dir.h                              |  145 +++
 fs/aufs/dlgt.c                             |  110 ++
 fs/aufs/export.c                           |  578 ++++++++++
 fs/aufs/f_op.c                             |  645 +++++++++++
 fs/aufs/file.c                             |  747 +++++++++++++
 fs/aufs/file.h                             |  223 ++++
 fs/aufs/finfo.c                            |  182 ++++
 fs/aufs/hin_or_dlgt.c                      |  705 ++++++++++++
 fs/aufs/hinode.h                           |  184 ++++
 fs/aufs/hinotify.c                         | 1059 ++++++++++++++++++
 fs/aufs/i_op.c                             |  728 +++++++++++++
 fs/aufs/i_op_add.c                         |  765 +++++++++++++
 fs/aufs/i_op_del.c                         |  562 ++++++++++
 fs/aufs/i_op_ren.c                         |  788 ++++++++++++++
 fs/aufs/iinfo.c                            |  275 +++++
 fs/aufs/inode.c                            |  400 +++++++
 fs/aufs/inode.h                            |  334 ++++++
 fs/aufs/misc.c                             |  266 +++++
 fs/aufs/misc.h                             |  201 ++++
 fs/aufs/module.c                           |  153 +++
 fs/aufs/module.h                           |   72 ++
 fs/aufs/opts.c                             | 1492 ++++++++++++++++++++++++++
 fs/aufs/opts.h                             |  243 +++++
 fs/aufs/plink.c                            |  344 ++++++
 fs/aufs/robr.c                             |  109 ++
 fs/aufs/sbinfo.c                           |  261 +++++
 fs/aufs/super.c                            |  835 +++++++++++++++
 fs/aufs/super.h                            |  405 +++++++
 fs/aufs/sysaufs.c                          |  102 ++
 fs/aufs/sysaufs.h                          |  137 +++
 fs/aufs/sysfs.c                            |  353 ++++++
 fs/aufs/sysrq.c                            |  101 ++
 fs/aufs/vdir.c                             |  928 ++++++++++++++++
 fs/aufs/vfsub.c                            |  633 +++++++++++
 fs/aufs/vfsub.h                            |  472 ++++++++
 fs/aufs/wbr_policy.c                       |  685 ++++++++++++
 fs/aufs/whout.c                            | 1026 ++++++++++++++++++
 fs/aufs/whout.h                            |  138 +++
 fs/aufs/wkq.c                              |  294 +++++
 fs/aufs/wkq.h                              |  158 +++
 fs/aufs/xino.c                             | 1212 +++++++++++++++++++++
 fs/namei.c                                 |    2 +-
 include/linux/aufs_type.h                  |  111 ++
 include/linux/lockdep.h                    |    4 +
 include/linux/namei.h                      |    1 +
 72 files changed, 28090 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/filesystems/aufs/Design
 create mode 100644 Documentation/filesystems/aufs/README
 create mode 100644 Documentation/filesystems/aufs/aufs.5
 create mode 100644 Documentation/filesystems/aufs/aulchown.c
 create mode 100644 Documentation/filesystems/aufs/auplink
 create mode 100644 Documentation/filesystems/aufs/mount.aufs
 create mode 100644 Documentation/filesystems/aufs/umount.aufs
 create mode 100644 fs/aufs/Kconfig
 create mode 100644 fs/aufs/Makefile
 create mode 100644 fs/aufs/aufs.h
 create mode 100644 fs/aufs/br_fuse.c
 create mode 100644 fs/aufs/br_nfs.c
 create mode 100644 fs/aufs/br_xfs.c
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
 create mode 100644 fs/aufs/dlgt.c
 create mode 100644 fs/aufs/export.c
 create mode 100644 fs/aufs/f_op.c
 create mode 100644 fs/aufs/file.c
 create mode 100644 fs/aufs/file.h
 create mode 100644 fs/aufs/finfo.c
 create mode 100644 fs/aufs/hin_or_dlgt.c
 create mode 100644 fs/aufs/hinode.h
 create mode 100644 fs/aufs/hinotify.c
 create mode 100644 fs/aufs/i_op.c
 create mode 100644 fs/aufs/i_op_add.c
 create mode 100644 fs/aufs/i_op_del.c
 create mode 100644 fs/aufs/i_op_ren.c
 create mode 100644 fs/aufs/iinfo.c
 create mode 100644 fs/aufs/inode.c
 create mode 100644 fs/aufs/inode.h
 create mode 100644 fs/aufs/misc.c
 create mode 100644 fs/aufs/misc.h
 create mode 100644 fs/aufs/module.c
 create mode 100644 fs/aufs/module.h
 create mode 100644 fs/aufs/opts.c
 create mode 100644 fs/aufs/opts.h
 create mode 100644 fs/aufs/plink.c
 create mode 100644 fs/aufs/robr.c
 create mode 100644 fs/aufs/sbinfo.c
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

