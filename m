Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZCXS0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZCXS0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760532AbZCXSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:25:08 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:59760 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625AbZCXSZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:25:05 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #4 3/3] aufs: convert some aufs entries from sysfs to debugfs, documentation
Date: Wed, 25 Mar 2009 03:24:07 +0900
Message-Id: <1237919047-8751-4-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1237919047-8751-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1237919047-8751-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comments from Greg KH on LKML.
Move 'xib', 'xigen' and 'xi0 ... xiN' entries from sysaufs to debugfs.
They show how many disk blocks are consumed.
- move the description of some aufs entries from sysfs-aufs to debugfs-aufs.
- fix the manual.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/ABI/testing/debugfs-aufs |   40 ++++++++++++++++++++++
 Documentation/ABI/testing/sysfs-aufs   |   37 --------------------
 Documentation/filesystems/aufs/README  |    3 +-
 Documentation/filesystems/aufs/aufs.5  |   57 ++++++++++++++++++-------------
 4 files changed, 75 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-aufs

diff --git a/Documentation/ABI/testing/debugfs-aufs b/Documentation/ABI/testing/debugfs-aufs
new file mode 100644
index 0000000..4110b94
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-aufs
@@ -0,0 +1,40 @@
+What:		/debug/aufs/si_<id>/
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		Under /debug/aufs, a directory named si_<id> is created
+		per aufs mount, where <id> is a unique id generated
+		internally.
+
+What:		/debug/aufs/si_<id>/xib
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xib (External Inode Number
+		Bitmap), its block size and file size.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/debug/aufs/si_<id>/xino0, xino1 ... xinoN
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xino (External Inode Number
+		Translation Table), its link count, block size and file
+		size.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
+
+What:		/debug/aufs/si_<id>/xigen
+Date:		March 2009
+Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
+Description:
+		It shows the consumed blocks by xigen (External Inode
+		Generation Table), its block size and file size.
+		If CONFIG_AUFS_EXPORT is disabled, this entry will not
+		be created.
+		When the aufs mount option 'noxino' is specified, it
+		will be empty. About XINO files, see
+		Documentation/filesystems/aufs/aufs.5 in detail.
diff --git a/Documentation/ABI/testing/sysfs-aufs b/Documentation/ABI/testing/sysfs-aufs
index 1552d3e..ca49330 100644
--- a/Documentation/ABI/testing/sysfs-aufs
+++ b/Documentation/ABI/testing/sysfs-aufs
@@ -23,40 +23,3 @@ Description:
 		When the aufs mount option 'noxino' is specified, it
 		will be empty. About XINO files, see
 		Documentation/filesystems/aufs/aufs.5 in detail.
-
-What:		/sys/fs/aufs/si_<id>/xib
-Date:		March 2009
-Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
-Description:
-		It shows the consumed blocks by xib (External Inode Number
-		Bitmap), its block size and file size.
-		When the aufs mount option 'noxino' is specified, it
-		will be empty. About XINO files, see
-		Documentation/filesystems/aufs/aufs.5 in detail.
-
-What:		/sys/fs/aufs/si_<id>/xino0, xino1 ... xinoN
-Date:		March 2009
-Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
-Description:
-		It shows the consumed blocks by xino (External Inode Number
-		Translation Table), its link count, block size and file
-		size.
-		When the aufs mount option 'noxino' is specified, it
-		will be empty. About XINO files, see
-		Documentation/filesystems/aufs/aufs.5 in detail.
-
-What:		/sys/fs/aufs/si_<id>/xigen
-Date:		March 2009
-Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
-Description:
-		It shows the consumed blocks by xigen (External Inode
-		Generation Table), its block size and file size.
-		If CONFIG_AUFS_EXPORT is disabled, this entry will not
-		be created.
-		When the aufs mount option 'noxino' is specified, it
-		will be empty. About XINO files, see
-		Documentation/filesystems/aufs/aufs.5 in detail.
-
-# Local variables: ;
-# mode: text;
-# End: ;
diff --git a/Documentation/filesystems/aufs/README b/Documentation/filesystems/aufs/README
index 8d4ba1f..3e323ac 100644
--- a/Documentation/filesystems/aufs/README
+++ b/Documentation/filesystems/aufs/README
@@ -201,8 +201,9 @@ See sample dir in CVS tree on SourceForge.
 When you have any problems or strange behaviour in aufs, please let me
 know with:
 - /proc/mounts (instead of the output of mount(8))
-- /sys/fs/aufs/* (if you have them)
 - /sys/module/aufs/*
+- /sys/fs/aufs/* (if you have them)
+- /debug/aufs/* (if you have them)
 - linux kernel version
   if your kernel is not plain, for example modified by distributor,
   the url where i can download its source is necessary too.
diff --git a/Documentation/filesystems/aufs/aufs.5 b/Documentation/filesystems/aufs/aufs.5
index b3bca05..b81baf1 100644
--- a/Documentation/filesystems/aufs/aufs.5
+++ b/Documentation/filesystems/aufs/aufs.5
@@ -1,4 +1,4 @@
-.ds AUFS_VERSION aufs2-base6
+.ds AUFS_VERSION aufs2
 .ds AUFS_XINO_FNAME .aufs.xino
 .ds AUFS_XINO_DEFPATH /tmp/.aufs.xino
 .ds AUFS_DIRWH_DEF 3
@@ -156,6 +156,12 @@ unlinked. So you
 cannot find this file, but it exists and is read/written frequently by
 aufs.
 (cf. External Inode Number Bitmap, Translation Table).
+
+If you enable CONFIG_SYSFS, the path of xino files are not shown in
+/proc/mounts (and /etc/mtab), instead it is shown in
+<sysfs>/fs/aufs/si_<id>/xi_path.
+Otherwise, it is shown in /proc/mounts unless it is not the default
+path.
 .
 .TP
 .B noxino
@@ -325,24 +331,15 @@ Specifies to use the branch path data file under sysfs or not.
 If the number of your branches is large or their path is long
 and you meet the limitation of mount(8) ro /etc/mtab, you need to
 enable CONFIG_SYSFS and set aufs module parameter brs=1.
-If your linux version is linux\-2.6.24 and earlier, you need to enable
-CONFIG_AUFS_SYSAUFS too.
 
 When this parameter is set as 1, aufs does not show \[oq]br:\[cq] (or dirs=)
-mount option through /proc/mounts, and /sbin/mount.aufs does not put it
-to /etc/mtab. So you can keep yourself from the page limitation of
+mount option through /proc/mounts (and /etc/mtab). So you can
+keep yourself from the page limitation of
 mount(8) or /etc/mtab.
 Aufs shows branch paths through <sysfs>/fs/aufs/si_XXX/brNNN.
 Actually the file under sysfs has also a size limitation, but I don\[aq]t
 think it is harmful.
 
-The default is brs=0, which means <sysfs>/fs/aufs/si_XXX/brNNN does not exist
-and \[oq]br:\[cq] option will appear in /proc/mounts, and /etc/mtab if you
-install /sbin/mount.aufs.
-If you did not enable CONFIG_AUFS_SYSAUFS (for
-linux\-2.6.24 and earlier), this parameter will be
-ignored.
-
 There is one more side effect in setting 1 to this parameter.
 If you rename your branch, the branch path written in /etc/mtab will be
 obsoleted and the future remount will meet some error due to the
@@ -352,13 +349,13 @@ If you set 1, /etc/mtab will not hold the branch path and you will not
 meet such trouble. On the other hand, the entires for the
 branch path under sysfs are generated dynamically. So it must not be obsoleted.
 But I don\[aq]t think users want to rename branches so often.
+
+If CONFIG_SYSFS is disable, this paramater is always set to 0.
 .
 .TP
 .B sysrq=key
 Specifies MagicSysRq key for debugging aufs.
 You need to enable both of CONFIG_MAGIC_SYSRQ and CONFIG_AUFS_DEBUG.
-If your linux version is linux\-2.6.24 and earlier, you need to enable
-CONFIG_AUFS_SYSAUFS too.
 Currently this is for developers only.
 The default is \[oq]a\[cq].
 .
@@ -371,6 +368,10 @@ Currently this is for developers only.
 The default is \[oq]0\[cq] (disable).
 
 .\" ----------------------------------------------------------------------
+.SH Entries under Sysfs and Debugfs
+See linux/Documentation/ABI/*/{sys,debug}fs-aufs.
+
+.\" ----------------------------------------------------------------------
 .SH Branch Syntax
 .TP
 .B dir_path[ =permission [ + attribute ] ]
@@ -384,7 +385,8 @@ permission flags for that branch.
 Comma, colon and the permission flags string (including \[oq]=\[cq])in the path
 are not allowed.
 
-Any filesystem can be a branch, except aufs, sysfs, procfs and unionfs.
+Any filesystem can be a branch, But some are not accepted such like
+sysfs, procfs and unionfs.
 If you specify such filesystems as an aufs branch, aufs will return an error
 saying it is unsupported.
 
@@ -559,6 +561,12 @@ will be \*[AUFS_XINO_DEFPATH].
 .\" A user who executes mount(8) needs the privilege to create xino
 .\" file.
 
+If you enable CONFIG_SYSFS, the path of xino files are not shown in
+/proc/mounts (and /etc/mtab), instead it is shown in
+<sysfs>/fs/aufs/si_<id>/xi_path.
+Otherwise, it is shown in /proc/mounts unless it is not the default
+path.
+
 Those files are always opened and read/write by aufs frequently.
 If your writable branch is on flash memory device, it is recommended
 to put xino files on other than flash memory by specifying \[oq]xino=\[cq]
@@ -599,11 +607,11 @@ supported largest inode number is less than LLONG_MAX/8\-1.
 
 The xino files are always hidden, i.e. removed. So you cannot
 do \[oq]ls \-l xino_file\[cq].
-If you enable CONFIG_SYSFS, you can check these information through
-<sysfs>/fs/aufs/<si_id>/xino (for linux\-2.6.24 and earlier, you
-need to enable CONFIG_AUFS_SYSAUFS too).
-The first line in <sysfs>/fs/aufs/<si_id>/xino (and xigen) shows the
-information of the bitmap file, in the format of,
+If you enable CONFIG_DEBUG_FS, you can check these information through
+<debugfs>/aufs/<si_id>/{xib,xi[0-9]*,xigen}. xib is for the bitmap file,
+xi0 ix for the first branch, and xi1 is for the next. xigen is for the
+generation table.
+xib and xigen are in the format of,
 
 .nf
 <blocks>x<block size> <file size>
@@ -620,7 +628,7 @@ pre-allocation feature.
 The rests are hidden xino file information in the format of,
 
 .nf
-<branch index>: <file count>, <blocks>x<block size> <file size>
+<file count>, <blocks>x<block size> <file size>
 .fi
 
 If the file count is larger than 1, it means some of your branches are
@@ -630,7 +638,8 @@ since xino file is a sparse file, i.e. a hole in a file which does not
 consume any disk blocks.
 
 Once you unmount aufs, the xino files for that aufs are totally gone.
-It means that the inode number is not permanent.
+It means that the inode number is not permanent across umount or
+shutdown.
 
 The xino files should be created on the filesystem except NFS.
 If your first writable branch is NFS, you will need to specify xino
@@ -941,8 +950,8 @@ about the file will be discarded and aufs re-lookup it. So the data will
 be updated.
 When an error condition occurs between UDBA and aufs operation, aufs
 will return an error, including EIO.
-To use this option, you need linux\-2.6.18 and later, and need to
-enable CONFIG_INOTIFY and CONFIG_AUFS_UDBA_INOTIFY.
+To use this option, you need to enable CONFIG_INOTIFY and
+CONFIG_AUFS_UDBA_INOTIFY.
 
 To rename/rmdir a directory on a branch directory may reveal the same named
 directory on the lower branch. Aufs tries re-lookuping the renamed
-- 
1.6.1.284.g5dc13

