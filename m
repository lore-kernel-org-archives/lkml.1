Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYHQRZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYHQRZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYHQRX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:23:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37405 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYHQRXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=mdvvuvfGObagHpjSLJKtTz8sCEnmKFCaB9dsavIcvB++3WGWnGRieZkGQBwHq2g1ET
         vBq6lT067hg4ZlDLeNtaQFnUD8kkpjvijgivT8kwa8r+bjDCtl46A9Yni3WXy8SZs6dn
         7GmNSdxBxj6vVh9iXSVLsvqhe7/Ky9CSAlgIY=
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/5] ide-floppy: add a debug_mask module parameter
Date: Sun, 17 Aug 2008 19:23:46 +0200
Message-Id: <1218993826-4571-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... with which to control to verbosity of debug messages on module load time.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3de9478..85022b8 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -49,6 +49,9 @@
 
 #include "ide-floppy.h"
 
+/* module parameters */
+static unsigned long debug_mask = 0x0;
+
 /* define to see debug info */
 #define IDEFLOPPY_DEBUG_LOG	0
 
@@ -679,6 +682,8 @@ static ide_driver_t idefloppy_driver = {
 #endif
 };
 
+module_param(debug_mask, ulong, 0644);
+
 static int idefloppy_open(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
@@ -692,6 +697,8 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 
 	drive = floppy->drive;
 
+	drive->debug_mask = debug_mask;
+
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	floppy->openers++;
-- 
1.5.5.4

