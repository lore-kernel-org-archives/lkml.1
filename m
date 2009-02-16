Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZBPAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZBPAOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZBPAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:34049 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZBPAMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GhMqd+Lla+RrTrOiWftECEdPTdq8QFdnV3qcwU20CB9KCRdnirjbToZCJLTbVuMefo
         t7dFvAYfmCs5blG3VVFxjWRB5Qwd06xirqI7cNQ8kkw149jZhM8XCasRkGqrqFLvrz3j
         z0uO8/9wIgM/hiHXblfphZHJa3AiK3ahnCNQc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:13:55 +0100
Message-Id: <20090216001355.27491.56986.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/20] ide-cd: remove no longer needed 'ignore' module parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: remove no longer needed 'ignore' module parameter

ide-scsi is gone...

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1932,9 +1932,6 @@ static struct block_device_operations id
 };
 
 /* module options */
-static char *ignore;
-module_param(ignore, charp, 0400);
-
 static unsigned long debug_mask;
 module_param(debug_mask, ulong, 0644);
 
@@ -1955,15 +1952,6 @@ static int ide_cd_probe(ide_drive_t *dri
 	if (drive->media != ide_cdrom && drive->media != ide_optical)
 		goto failed;
 
-	/* skip drives that we were told to ignore */
-	if (ignore != NULL) {
-		if (strstr(ignore, drive->name)) {
-			printk(KERN_INFO PFX "ignoring drive %s\n",
-					 drive->name);
-			goto failed;
-		}
-	}
-
 	drive->debug_mask = debug_mask;
 	drive->irq_handler = cdrom_newpc_intr;
 
