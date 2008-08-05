Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbYHEQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbYHEQmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbYHEQmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:42:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:50079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbYHEQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=CXKv8LZ8ocp17OIUJNO7rmWJnjTa4QHxxcQQlGPhBRfC3y1coNhfAveRpaJ1ji2hZV
         A/SDwysy4N6ye0EM0rq3dRVQ/6WWIoEDvnghJwI2dICRXu97tp4RJx8MibvvI4pgw6D7
         1zuu9qATYwQ0zLAAh2XoAT8Lvmv35cd+cS7Es=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 05 Aug 2008 18:40:22 +0200
Message-Id: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/4] ide: remove ->bus_state field from ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is always set to BUSSTATE_ON.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c   |    4 +---
 include/linux/ide.h |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -96,8 +96,6 @@ void ide_init_port_data(ide_hwif_t *hwif
 	hwif->name[2]	= 'e';
 	hwif->name[3]	= '0' + index;
 
-	hwif->bus_state	= BUSSTATE_ON;
-
 	init_completion(&hwif->gendev_rel_comp);
 
 	hwif->tp_ops = &default_tp_ops;
@@ -620,7 +618,7 @@ int generic_ide_ioctl(ide_drive_t *drive
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
-			if (put_user(HWIF(drive)->bus_state, (long __user *)arg))
+			if (put_user(BUSSTATE_ON, (long __user *)arg))
 				return -EFAULT;
 			return 0;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -560,7 +560,6 @@ typedef struct hwif_s {
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
 	u8 channel;	/* for dual-port chips: 0=primary, 1=secondary */
-	u8 bus_state;	/* power state of the IDE bus */
 
 	u32 host_flags;
 
