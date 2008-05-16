Return-Path: <linux-kernel-owner+w=401wt.eu-S1764356AbYEPPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764356AbYEPPCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYEPOoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:44:32 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49284 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYEPOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:21 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 4/67] aufs configuration
Date: Fri, 16 May 2008 23:32:18 +0900
Message-Id: <12109484013051-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484012997-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs configuration

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/Kconfig |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 198 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/Kconfig b/fs/aufs/Kconfig
new file mode 100644
index 0000000..aa99e50
--- /dev/null
+++ b/fs/aufs/Kconfig
@@ -0,0 +1,198 @@
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
+config AUFS_FAKE_DM
+	bool
+	depends on AUFS
+	default n
+
+choice
+	prompt "Maximum number of branches"
+	depends on AUFS
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
+	depends on AUFS
+	depends on SYSFS
+	default n
+	help
+	Shows some statistic data via <sysfs>/fs/aufs/stat.
+	See detail in aufs.5.
+
+config AUFS_HINOTIFY
+	bool "Use inotify to detect actions on a branch"
+	depends on AUFS
+	depends on INOTIFY
+	default n
+	help
+	If you want to modify files on branches directly, eg. bypassing aufs,
+	and want aufs to detect the changes of them fully, then enable this
+	option and use 'udba=inotify' mount option.
+	It will damage the performance.
+	See detail in aufs.5.
+
+config AUFS_EXPORT
+	bool "NFS-exportable aufs"
+	depends on AUFS
+	select EXPORTFS
+	default n
+	help
+	If you want to export your mounted aufs, then enable this
+	option. There are several requirements to export aufs.
+	See detail in aufs.5.
+
+config AUFS_ROBR
+	bool "Aufs as an readonly branch of another aufs"
+	depends on AUFS
+	default n
+	help
+	If you want make your aufs to be a part of another aufs, then
+	enable this option. In other words, you can specify your aufs
+	path in 'br:' mount option for another aufs, but cannot
+	specify 'rw' as the branch permission.
+	It will damage the performance.
+	See detail in aufs.5.
+
+config AUFS_DLGT
+	bool "Delegate the internal branch access the kernel thread"
+	depends on AUFS
+	default n
+	help
+	If you want aufs to delegate
+	the internal access to the branches which is made by aufs, to
+	the kernel thread, in order to hide the access issued by your
+	application from your LSM or something or make your
+	application to be traced strictly by the task I/O accounting,
+	then enable this option and use 'dlgt' mount option.
+	It will damage the performance.
+	See detail in aufs.5.
+
+config AUFS_SHWH
+	bool "show whiteouts"
+	depends on AUFS
+	default n
+	help
+	If you want to make the whiteouts in aufs visible, then enable
+	this option and specify 'shwh' mount option. Although it may
+	sounds like philosophy or something, but in technically it
+	simply shows the name of whiteout with keeping its behaviour.
+
+config AUFS_SPLICE_PATCH
+	bool
+	depends on AUFS
+	default y
+
+config AUFS_LHASH_PATCH
+	bool
+	depends on AUFS
+	depends on NFS_FS
+	depends on AUFS_FAKE_DM = n
+	default y
+
+config AUFS_BR_NFS
+	bool
+	depends on AUFS
+	depends on NFS_FS
+	depends on !AUFS_FAKE_DM
+	default n if (!AUFS_LHASH_PATCH || AUFS_FAKE_DM)
+	default y
+
+config AUFS_BR_XFS
+	bool
+	depends on AUFS
+	depends on XFS_FS
+	default y
+
+config AUFS_WORKAROUND_FUSE
+	bool "Special handling for FUSE-based filesystem"
+	depends on AUFS && FUSE_FS
+	default n
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
+	It will damage the performance even if you don't use a
+	FUSE-based filesystem branch.
+
+config AUFS_DEBUG
+	bool "Debug aufs"
+	depends on AUFS
+	default y
+	help
+	Enable this to compile aufs internal debug code.
+	The performance will be damaged.
+
+config AUFS_MAGIC_SYSRQ
+	bool
+	depends on AUFS
+	depends on AUFS_DEBUG
+	depends on MAGIC_SYSRQ
+	default y
+
+config AUFS_COMPAT
+	bool "Compatibility with Unionfs (obsolete)"
+	depends on AUFS
+	default n
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
-- 
1.4.4.4

