Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbYBMR0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbYBMR0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763124AbYBMR0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:26:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:4044 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760708AbYBMR0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=tLDy75/RVESIWygYYLwdEux3YnXl7hnhH2n3Noij/t3WXL8B8JxvIGvo0/jkkRtlk8n7NYB3hy5WHBw761dknLLZ6NCxKo+5JbzeftxdbL1ThbPx4Q5fpeD/XO2Atjj4DK5j5LHCLXgdBydlk536lhGMJb5OUjOvZb+Ie+MdvhY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/2] ide: use generic ATAPI packet command flags in ide-{floppy,tape}
Date: Wed, 13 Feb 2008 18:25:43 +0100
Message-Id: <1202923544-19551-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |   14 --------------
 drivers/ide/ide-tape.c   |   16 ----------------
 include/linux/ide.h      |   15 +++++++++++++++
 3 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index bf1ef60..5f133df 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -78,20 +78,6 @@
  */
 #define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
 
-/* Packet command flag bits. */
-enum {
-	/* 1 when we prefer to use DMA if possible */
-	PC_FLAG_DMA_RECOMMENDED	= (1 << 0),
-	/* 1 while DMA in progress */
-	PC_FLAG_DMA_IN_PROGRESS	= (1 << 1),
-	/* 1 when encountered problem during DMA */
-	PC_FLAG_DMA_ERROR	= (1 << 2),
-	/* Data direction */
-	PC_FLAG_WRITING		= (1 << 3),
-	/* Suppress error reporting */
-	PC_FLAG_SUPPRESS_ERROR	= (1 << 4),
-};
-
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3a10208..3f9fbd8 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -181,22 +181,6 @@ struct idetape_bh {
 	char *b_data;
 };
 
-/* Packet command flag bits. */
-enum {
-	/* Set when an error is considered normal - We won't retry */
-	PC_FLAG_ABORT		= (1 << 0),
-	/* 1 When polling for DSC on a media access command */
-	PC_FLAG_WAIT_FOR_DSC	= (1 << 1),
-	/* 1 when we prefer to use DMA if possible */
-	PC_FLAG_DMA_RECOMMENDED	= (1 << 2),
-	/* 1 while DMA in progress */
-	PC_FLAG_DMA_IN_PROGRESS	= (1 << 3),
-	/* 1 when encountered problem during DMA */
-	PC_FLAG_DMA_ERROR	= (1 << 4),
-	/* Data direction */
-	PC_FLAG_WRITING		= (1 <<	5),
-};
-
 /* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 509d806..0e5f09b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -629,6 +629,21 @@ typedef struct ide_settings_s {
 
 int ide_add_setting(ide_drive_t *, const char *, int, int, int, int, int, int, void *, ide_procset_t *set);
 
+/* ATAPI packet command flags */
+enum {
+	/* set when an error is considered normal - no retry (ide-tape) */
+	PC_FLAG_ABORT			= (1 << 0),
+	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
+	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
+	PC_FLAG_DMA_OK			= (1 << 3),
+	PC_FLAG_DMA_RECOMMENDED		= (1 << 4),
+	PC_FLAG_DMA_IN_PROGRESS		= (1 << 5),
+	PC_FLAG_DMA_ERROR		= (1 << 6),
+	PC_FLAG_WRITING			= (1 << 7),
+	/* command timed out */
+	PC_FLAG_TIMEDOUT		= (1 << 8),
+};
+
 struct ide_atapi_pc {
 	/* actual packet bytes */
 	u8 c[12];
-- 
1.5.3.7

