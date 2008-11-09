Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYKIQ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYKIQ0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYKIQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:24:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37779 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbYKIQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aYcG7AL3yAxShwlqhZBfakkGc7o1m0jcZMRfOsexPsUQa77MnaYqfg7bQM3jDarHed
         RV2hLfcE7ckgptRTEBoMSLU7kMIaQ2DsM/8SVImzg7gSZjRocb4YngZ78mGz9rVS4Jp+
         Fuvw3fVRBkKQeSO4a7GluhQ3CK7DOxm50AxFY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:22:40 +0100
Message-Id: <20081109162240.18999.50977.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/11] ide: remove redundant code from ide_end_drive_cmd()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove redundant code from ide_end_drive_cmd()

rq->errors is overwritten later in this function.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -289,9 +289,6 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = (ide_task_t *)rq->special;
 
-		if (rq->errors == 0)
-			rq->errors = !OK_STAT(stat, ATA_DRDY, BAD_STAT);
-
 		if (task) {
 			struct ide_taskfile *tf = &task->tf;
 
