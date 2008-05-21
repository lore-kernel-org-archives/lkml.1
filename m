Return-Path: <linux-kernel-owner+w=401wt.eu-S935955AbYEUDtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935955AbYEUDtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933846AbYEUDez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:34:55 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44125 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762916AbYEUDdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:03 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 03/39] aufs configuration and Makefile
Date: Wed, 21 May 2008 12:22:33 +0900
Message-Id: <1211340189-11813-4-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs configuration and Makefile

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/Kconfig  |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/Makefile |   39 ++++++++++++
 2 files changed, 213 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/Kconfig
 create mode 100644 fs/aufs/Makefile

diff --git a/fs/aufs/Kconfig b/fs/aufs/Kconfig
new file mode 100644
index 0000000..338c01c
--- /dev/null
+++ b/fs/aufs/Kconfig
@@ -0,0 +1,174 @@
+config AUFS
+	bool "Another unionfs (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	Aufs is a stackable unification filesystem such as Unionfs,
+	which unifies several directories and provides a merged single
+	directory.
+	In the early days, aufs was entirely re-designed and
+	re-implemented Unionfs Version 1.x series. After many original
+	ideas, approaches and improvements, it becomes totally
+	different from Unionfs while keeping the basic features.
+	See Unionfs for the basic features.
+
+if AUFS
+choice
+	prompt "Maximum number of branches"
+	default AUFS_BRANCH_MAX_127
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has an impact to performance.
+config AUFS_BRANCH_MAX_127
+	bool "127"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has an impact to performance.
+config AUFS_BRANCH_MAX_511
+	bool "511"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has an impact to performance.
+config AUFS_BRANCH_MAX_1023
+	bool "1023"
+	help
+	Specifies the maximum number of branches (or member directories)
+	in a single aufs. The larger value consumes more system
+	resources and has an impact to performance.
+# config AUFS_BRANCH_MAX_32767
+# 	bool "32767"
+# 	help
+# 	Specifies the maximum number of branches (or member directories)
+# 	in a single aufs. The larger value consumes more system
+# 	resources and has an impact to performance.
+endchoice
+
+config AUFS_STAT
+	bool "Use <sysfs>/fs/aufs/stat"
+	depends on SYSFS
+	help
+	Shows some statistic data via <sysfs>/fs/aufs/stat.
+	See detail in aufs.5.
+
+config AUFS_HINOTIFY
+	bool "Use inotify to detect actions on a branch"
+	depends on INOTIFY
+	help
+	If you want to modify files on branches directly, eg. bypassing aufs,
+	and want aufs to detect the changes of them fully, then enable this
+	option and use 'udba=inotify' mount option.
+	It will have a negative impact to the performance.
+	See detail in aufs.5.
+
+config AUFS_EXPORT
+	bool "NFS-exportable aufs"
+	# module will be available in the future
+	depends on EXPORTFS = y
+	help
+	If you want to export your mounted aufs, then enable this
+	option. There are several requirements to export aufs.
+	See detail in aufs.5.
+
+config AUFS_ROBR
+	bool "Aufs as an readonly branch of another aufs"
+	help
+	If you want make your aufs to be a part of another aufs, then
+	enable this option. In other words, you can specify your aufs
+	path in 'br:' mount option for another aufs, but cannot
+	specify 'rw' as the branch permission.
+	It will have a negative impact to the performance.
+	See detail in aufs.5.
+
+config AUFS_DLGT
+	bool "Delegate the internal branch access the kernel thread"
+	help
+	If you want aufs to delegate
+	the internal access to the branches which is made by aufs, to
+	the kernel thread, in order to hide the access issued by your
+	application from your LSM or something or make your
+	application to be traced strictly by the task I/O accounting,
+	then enable this option and use 'dlgt' mount option.
+	It will have a negative impact to the performance.
+	See detail in aufs.5.
+
+config AUFS_HIN_OR_DLGT
+	bool
+	depends on AUFS_HINOTIFY || AUFS_DLGT
+	default y
+	help
+	Automatic configuration for internal use.
+
+config AUFS_SHWH
+	bool "Show whiteouts"
+	help
+	If you want to make the whiteouts in aufs visible, then enable
+	this option and specify 'shwh' mount option. Although it may
+	sounds like philosophy or something, but in technically it
+	simply shows the name of whiteout with keeping its behaviour.
+
+config AUFS_BR_NFS
+	bool
+	depends on NFS_FS
+	default y
+	help
+	Automatic configuration for internal use.
+	When aufs supports NFS branch, enabled automatically.
+
+config AUFS_BR_XFS
+	bool
+	depends on XFS_FS
+	default y
+	help
+	Automatic configuration for internal use.
+	When aufs supports XFS branch, enabled automatically.
+
+config AUFS_WORKAROUND_FUSE
+	bool "Special handling for FUSE-based filesystem"
+	depends on FUSE_FS
+	help
+	A FUSE-based filesystem may not initialize its inode
+	attributes and the FUSE developer thinks the inode attributes
+	in a positive dentry which is returned by VFS lookup operation
+	are not reliable.
+	If you use a FUSE-based filesystem as an aufs branch, and it
+	customizes the inode attribute on it without overriding
+	fuse_lowlevel_ops.lookup, probably you need to enable this
+	configuration.
+	If you enable this configuration, aufs calls getattr operation
+	in every lookup and revalidate operation for the FUSE-based
+	filesystem branch.
+	It will have a negative impact to the performance even if you don't use a
+	FUSE-based filesystem branch.
+
+config AUFS_DEBUG
+	bool "Debug aufs"
+	help
+	Enable this to compile aufs internal debug code.
+	It will have a negative impact to the performance.
+
+config AUFS_MAGIC_SYSRQ
+	bool
+	depends on AUFS_DEBUG && MAGIC_SYSRQ
+	default y
+	help
+	Automatic configuration for internal use.
+	When aufs supports Magic SysRq, enabled automatically.
+
+config AUFS_COMPAT
+	bool "Compatibility with Unionfs"
+	help
+	This makes aufs compatible with unionfs-style mount options and some
+	behaviours.
+	The dirs= mount option and =nfsro branch permission flag are always
+	interpreted as br: mount option and =ro flag respectively. The
+	'debug', 'delete' and 'imap' mount options are ignored.
+	If you disable this option, you will get,
+	- aufs issues a warning about the ignored mount options
+	- the default branch permission flag is set. RW for the first branch,
+	  and RO for the rests.
+	- the name of a internal file which represents the directory is
+	  'opaque', becomes '.wh..wh..opq'
+	- the 'diropq=w' mount option is set by default
+endif
diff --git a/fs/aufs/Makefile b/fs/aufs/Makefile
new file mode 100644
index 0000000..4255dbe
--- /dev/null
+++ b/fs/aufs/Makefile
@@ -0,0 +1,39 @@
+
+# defined in ${srctree}/fs/fuse/inode.c
+ccflags-$(AUFS_WORKAROUND_FUSE) += -DFUSE_SUPER_MAGIC=0x65735546
+
+# defined in ${srctree}/fs/xfs/xfs_sb.h
+ifdef CONFIG_XFS_FS
+ccflags-y += -DXFS_SB_MAGIC=0x58465342
+endif
+
+# defined in ${srctree}/mm/shmem.c
+ifdef CONFIG_TMPFS
+ccflags-y += -DTMPFS_MAGIC=0x01021994
+endif
+
+########################################
+
+obj-$(CONFIG_AUFS) += aufs.o
+aufs-y := module.o super.o sbinfo.o branch.o xino.o sysaufs.o opts.o \
+	wkq.o vfsub.o dcsub.o \
+	cpup.o whout.o plink.o wbr_policy.o \
+	dentry.o dinfo.o \
+	file.o f_op.o finfo.o \
+	dir.o vdir.o \
+	inode.o i_op.o i_op_add.o i_op_del.o i_op_ren.o iinfo.o \
+	misc.o
+
+aufs-$(CONFIG_SYSFS) += sysfs.o
+aufs-$(CONFIG_AUFS_BR_NFS) += br_nfs.o
+aufs-$(CONFIG_AUFS_BR_XFS) += br_xfs.o
+aufs-$(CONFIG_AUFS_WORKAROUND_FUSE) += br_fuse.o
+aufs-$(CONFIG_AUFS_DLGT) += dlgt.o
+aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o
+aufs-$(CONFIG_AUFS_HIN_OR_DLGT) += hin_or_dlgt.o
+aufs-$(CONFIG_AUFS_EXPORT) += export.o
+aufs-$(CONFIG_AUFS_ROBR) += robr.o
+# reserved for future use
+#aufs-$(CONFIG_AUFS_XATTR) += xattr.o
+aufs-$(CONFIG_AUFS_DEBUG) += debug.o
+aufs-$(CONFIG_AUFS_MAGIC_SYSRQ) += sysrq.o
-- 
1.5.5.1.308.g1fbb5.dirty

