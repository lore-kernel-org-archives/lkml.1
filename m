Return-Path: <linux-kernel-owner+w=401wt.eu-S965726AbXBHRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965726AbXBHRId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965723AbXBHRId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:08:33 -0500
Received: from havoc.gtf.org ([69.61.125.42]:39765 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965716AbXBHRIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:08:31 -0500
Date: Thu, 8 Feb 2007 12:08:30 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] remove jffs (v1)
Message-ID: <20070208170830.GA1399@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'kill-jffs' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git kill-jffs

to receive the following updates:

 Documentation/feature-removal-schedule.txt |    7 -
 fs/Kconfig                                 |   26 -
 fs/Makefile                                |    1 -
 fs/jffs/Makefile                           |   11 -
 fs/jffs/inode-v23.c                        | 1847 ---------------
 fs/jffs/intrep.c                           | 3449 ----------------------------
 fs/jffs/intrep.h                           |   58 -
 fs/jffs/jffs_fm.c                          |  798 -------
 fs/jffs/jffs_fm.h                          |  149 --
 fs/jffs/jffs_proc.c                        |  261 ---
 fs/jffs/jffs_proc.h                        |   28 -
 include/linux/jffs.h                       |  224 --
 12 files changed, 0 insertions(+), 6859 deletions(-)
 delete mode 100644 fs/jffs/Makefile
 delete mode 100644 fs/jffs/inode-v23.c
 delete mode 100644 fs/jffs/intrep.c
 delete mode 100644 fs/jffs/intrep.h
 delete mode 100644 fs/jffs/jffs_fm.c
 delete mode 100644 fs/jffs/jffs_fm.h
 delete mode 100644 fs/jffs/jffs_proc.c
 delete mode 100644 fs/jffs/jffs_proc.h
 delete mode 100644 include/linux/jffs.h

Jeff Garzik (1):
      Delete JFFS (version 1), as scheduled.

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0ba6af0..fc53239 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -318,10 +318,3 @@ Why:	/proc/acpi/button has been replaced by events to the input layer
 Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
-
-What:	JFFS (version 1)
-When:	2.6.21
-Why:	Unmaintained for years, superceded by JFFS2 for years.
-Who:	Jeff Garzik <jeff@garzik.org>
-
----------------------------
diff --git a/fs/Kconfig b/fs/Kconfig
index 8cd2417..67a50c9 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1196,32 +1196,6 @@ config EFS_FS
 	  To compile the EFS file system support as a module, choose M here: the
 	  module will be called efs.
 
-config JFFS_FS
-	tristate "Journalling Flash File System (JFFS) support"
-	depends on MTD && BLOCK && BROKEN
-	help
-	  JFFS is the Journalling Flash File System developed by Axis
-	  Communications in Sweden, aimed at providing a crash/powerdown-safe
-	  file system for disk-less embedded devices. Further information is
-	  available at (<http://developer.axis.com/software/jffs/>).
-
-	  NOTE: This filesystem is deprecated and is scheduled for removal in
-	  2.6.21.  See Documentation/feature-removal-schedule.txt
-
-config JFFS_FS_VERBOSE
-	int "JFFS debugging verbosity (0 = quiet, 3 = noisy)"
-	depends on JFFS_FS
-	default "0"
-	help
-	  Determines the verbosity level of the JFFS debugging messages.
-
-config JFFS_PROC_FS
-	bool "JFFS stats available in /proc filesystem"
-	depends on JFFS_FS && PROC_FS
-	help
-	  Enabling this option will cause statistics from mounted JFFS file systems
-	  to be made available to the user in the /proc/fs/jffs/ directory.
-
 config JFFS2_FS
 	tristate "Journalling Flash File System v2 (JFFS2) support"
 	select CRC32
diff --git a/fs/Makefile b/fs/Makefile
index b9ffa63..9edf411 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -94,7 +94,6 @@ obj-$(CONFIG_HPFS_FS)		+= hpfs/
 obj-$(CONFIG_NTFS_FS)		+= ntfs/
 obj-$(CONFIG_UFS_FS)		+= ufs/
 obj-$(CONFIG_EFS_FS)		+= efs/
-obj-$(CONFIG_JFFS_FS)		+= jffs/
 obj-$(CONFIG_JFFS2_FS)		+= jffs2/
 obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/

[snip obvious diff that deletes fs/jffs/* and include/linux/jffs.h]
