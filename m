Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbYHEQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbYHEQnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762242AbYHEQmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:42:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:46473 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762197AbYHEQmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KwSIOLhp+3c41e8Tphm5QsyuUVsMWK99uDcwZuQHTG3iRTsMTI7MgFAjoSpsjcXF2s
         g//rgjYhWx6J0ykx3z9q3qvFSF1YpW5IsQAIDh5qTuryjkxH9clGdubtm82jYYbIoa8D
         YEPfc9N36HqKv0MVsOZaKu/5l8D6oJXALIH3E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 05 Aug 2008 18:40:35 +0200
Message-Id: <20080805164035.17094.760.sendpatchset@localhost.localdomain>
In-Reply-To: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
References: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/4] ide: cleanup generic_ide_ioctl()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fix intendation for the main 'switch ()'.

* 'switch ()' -> 'if ()' for HDIO_DRIVE_TASKFILE case.

* Move HDIO_SET_NICE case under HDIO_GET_NICE one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   97 +++++++++++++++++++++++++-----------------------------
 1 file changed, 45 insertions(+), 52 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -565,8 +565,9 @@ static const struct ide_ioctl_devset ide
 { 0 }
 };
 
-int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
-			unsigned int cmd, unsigned long arg)
+int generic_ide_ioctl(ide_drive_t *drive, struct file *file,
+		      struct block_device *bdev,
+		      unsigned int cmd, unsigned long arg)
 {
 	int err;
 
@@ -575,57 +576,49 @@ int generic_ide_ioctl(ide_drive_t *drive
 		return err;
 
 	switch (cmd) {
-		case HDIO_OBSOLETE_IDENTITY:
-		case HDIO_GET_IDENTITY:
-			if (bdev != bdev->bd_contains)
-				return -EINVAL;
-			return ide_get_identity_ioctl(drive, cmd, arg);
-		case HDIO_GET_NICE:
-			return ide_get_nice_ioctl(drive, arg);
-#ifdef CONFIG_IDE_TASK_IOCTL
-		case HDIO_DRIVE_TASKFILE:
-		        if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-				return -EACCES;
-			switch(drive->media) {
-				case ide_disk:
-					return ide_taskfile_ioctl(drive, cmd, arg);
-				default:
-					return -ENOMSG;
-			}
-#endif /* CONFIG_IDE_TASK_IOCTL */
-
-		case HDIO_DRIVE_CMD:
-			if (!capable(CAP_SYS_RAWIO))
-				return -EACCES;
-			return ide_cmd_ioctl(drive, cmd, arg);
-
-		case HDIO_DRIVE_TASK:
-			if (!capable(CAP_SYS_RAWIO))
-				return -EACCES;
-			return ide_task_ioctl(drive, cmd, arg);
-		case HDIO_SET_NICE:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-			return ide_set_nice_ioctl(drive, arg);
-		case HDIO_DRIVE_RESET:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-
-			return generic_drive_reset(drive);
-
-		case HDIO_GET_BUSSTATE:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-			if (put_user(BUSSTATE_ON, (long __user *)arg))
-				return -EFAULT;
-			return 0;
-
-		case HDIO_SET_BUSSTATE:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EACCES;
-			return -EOPNOTSUPP;
-		default:
+	case HDIO_OBSOLETE_IDENTITY:
+	case HDIO_GET_IDENTITY:
+		if (bdev != bdev->bd_contains)
 			return -EINVAL;
+		return ide_get_identity_ioctl(drive, cmd, arg);
+	case HDIO_GET_NICE:
+		return ide_get_nice_ioctl(drive, arg);
+	case HDIO_SET_NICE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return ide_set_nice_ioctl(drive, arg);
+#ifdef CONFIG_IDE_TASK_IOCTL
+	case HDIO_DRIVE_TASKFILE:
+		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		if (drive->media == ide_disk)
+			return ide_taskfile_ioctl(drive, cmd, arg);
+		return -ENOMSG;
+#endif
+	case HDIO_DRIVE_CMD:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return ide_cmd_ioctl(drive, cmd, arg);
+	case HDIO_DRIVE_TASK:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return ide_task_ioctl(drive, cmd, arg);
+	case HDIO_DRIVE_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return generic_drive_reset(drive);
+	case HDIO_GET_BUSSTATE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		if (put_user(BUSSTATE_ON, (long __user *)arg))
+			return -EFAULT;
+		return 0;
+	case HDIO_SET_BUSSTATE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
 	}
 }
 EXPORT_SYMBOL(generic_ide_ioctl);
