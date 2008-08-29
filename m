Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYH2Vhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYH2Vhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYH2Vhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:37:31 -0400
Received: from nebensachen.de ([195.34.83.29]:49689 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYH2Vha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:37:30 -0400
X-Hashcash: 1:20:080829:bzolnier@gmail.com::YyNzrjvtKAoqX5ik:0000000000000000000000000000000000000000000AGdv
X-Hashcash: 1:20:080829:linux-ide@vger.kernel.org::/APTvs9fQWa5Gexi:0000000000000000000000000000000000000xtk
X-Hashcash: 1:20:080829:linux-kernel@vger.kernel.org::TrZdsntMX1msKlUq:0000000000000000000000000000000004kEK
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
Message-ID: <20080829213217.4826.91622.stgit@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Aug 2008 23:37:20 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes have broken compilation when CONFIG_IDE_PROC_FS is not set.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---
Applies to next-20080829.

 drivers/ide/Makefile     |    9 +++++++--
 drivers/ide/ide-disk.h   |    2 ++
 drivers/ide/ide-floppy.h |    2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 95a6135..e6e7811 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -36,9 +36,14 @@ obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
-ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o ide-disk_proc.o
+ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
-ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o ide-floppy_proc.o
+ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
+
+ifeq ($(CONFIG_IDE_PROC_FS), y)
+	ide-disk_mod-y += ide-disk_proc.o
+	ide-floppy_mod-y += ide-floppy_proc.o
+endif
 
 obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk_mod.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
diff --git a/drivers/ide/ide-disk.h b/drivers/ide/ide-disk.h
index f937772..5254cae 100644
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -23,8 +23,10 @@ ide_decl_devset(acoustic);
 /* ide-disk_ioctl.c */
 int ide_disk_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
 
+#ifdef CONFIG_IDE_PROC_FS
 /* ide-disk_proc.c */
 extern ide_proc_entry_t ide_disk_proc[];
 extern const struct ide_proc_devset ide_disk_settings[];
+#endif /* CONFIG_IDE_PROC_FS */
 
 #endif /* __IDE_DISK_H */
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
index 2ad373e..86ee37e 100644
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -53,8 +53,10 @@ sector_t ide_floppy_capacity(ide_drive_t *);
 /* ide-floppy_ioctl.c */
 int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
 
+#ifdef CONFIG_IDE_PROC_FS
 /* ide-floppy_proc.c */
 extern ide_proc_entry_t ide_floppy_proc[];
 extern const struct ide_proc_devset ide_floppy_settings[];
+#endif /* CONFIG_IDE_PROC_FS */
 
 #endif /*__IDE_FLOPPY_H */


