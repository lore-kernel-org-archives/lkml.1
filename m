Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZBAT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZBAT1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZBAT0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:26:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:64635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZBAT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:26:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S5yhFduLzYvJm/gAJ6UmQWlMjD+RS7jI+06DT/qKTLA7lAUCmFdZiw2HISfjR5yCoD
         27R/e6oRLmFKA4gBviZZr55mOlOOiTs3OamlG42BQcbFZ54FlgQU9B9N/ineotWaGn9D
         TO0IfNR/+hsxsobttpx66IroP0HgLn0vvK/mo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:27:38 +0100
Message-Id: <20090201192738.1592.37936.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/8] ide: remove no longer needed PC_FLAG_TIMEDOUT packet command flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove no longer needed PC_FLAG_TIMEDOUT packet command flag

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |    5 -----
 include/linux/ide.h     |    2 --
 2 files changed, 7 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -324,11 +324,6 @@ static ide_startstop_t ide_pc_intr(ide_d
 	timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
 					       : WAIT_TAPE_CMD;
 
-	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		drive->pc_callback(drive, 0);
-		return ide_stopped;
-	}
-
 	/* Clear the interrupt */
 	stat = tp_ops->read_status(hwif);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -350,8 +350,6 @@ enum {
 	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
 	PC_FLAG_DMA_ERROR		= (1 << 5),
 	PC_FLAG_WRITING			= (1 << 6),
-	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 7),
 };
 
 /*
