Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYG1Uo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYG1Uo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbYG1UnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:43:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:15694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759609AbYG1UnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=s0N9TbI38MZ8DE23/RoFg3Ktr9GKrGbhJUey8jPbO2oLEkmo5Fw8NHo7ELGn3EqvdX
         8cAnBP540bSa9uq8NpQP3k/XoDTjTTyLY6ENcuzBOpwaVjB9QJHQ+oGAiYVyindwVCYR
         XFk2oLEvrGH9R0Zg7wMJlcqKZ1sEC6rU3NqB0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2008 22:41:16 +0200
Message-Id: <20080728204116.4283.46297.sendpatchset@localhost.localdomain>
In-Reply-To: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
References: <20080728204102.4283.74632.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/5] ide: remove read-only ->atapi_overlap field from ide_drive_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c   |    1 -
 include/linux/ide.h |    1 -
 2 files changed, 2 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -585,7 +585,6 @@ int generic_ide_ioctl(ide_drive_t *drive
 			return ide_get_identity_ioctl(drive, cmd, arg);
 		case HDIO_GET_NICE:
 			return put_user(drive->dsc_overlap	<<	IDE_NICE_DSC_OVERLAP	|
-					drive->atapi_overlap	<<	IDE_NICE_ATAPI_OVERLAP	|
 					drive->nice1 << IDE_NICE_1,
 					(long __user *) arg);
 #ifdef CONFIG_IDE_TASK_IOCTL
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -424,7 +424,6 @@ struct ide_drive_s {
 	unsigned forced_geom	: 1;	/* 1 if hdx=c,h,s was given at boot */
 	unsigned no_unmask	: 1;	/* disallow setting unmask bit */
 	unsigned no_io_32bit	: 1;	/* disallow enabling 32bit I/O */
-	unsigned atapi_overlap	: 1;	/* ATAPI overlap (not supported) */
 	unsigned doorlocking	: 1;	/* for removable only: door lock/unlock works */
 	unsigned nodma		: 1;	/* disallow DMA */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
