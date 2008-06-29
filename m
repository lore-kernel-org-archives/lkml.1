Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbYF2LDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbYF2LDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759634AbYF2K7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56267 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbYF2K7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=X2DD/1dFoF3rlfMbiPzC9Fi3NQhoxRlVt9Am6NkB5NVl9hS7xlY9l6qWkf4mt7lXFJ
         WwV4716rlUZ783Ye7KCQLZEuWcwDIc/ZxvwPNa5TiBObcKyPpgek8EqqDfWb+O8mJhV0
         Hm5kw4N9nZWlLuIxxcpi53+1QxZtEm8uaVOoE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 15/16] ide: remove unused PC_FLAG_DRQ_INTERRUPT
Date: Sun, 29 Jun 2008 12:59:18 +0200
Message-Id: <1214737159-1078-16-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    3 +--
 include/linux/ide.h     |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 951768a..1136247 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -292,8 +292,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			   bcount, dma);
 
 	/* Issue the packet command */
-	if ((pc->flags & PC_FLAG_DRQ_INTERRUPT) ||
-	    (drive->dev_flags & IDE_FLAG_DRQ_INTERRUPT)) {
+	if (drive->dev_flags & IDE_FLAG_DRQ_INTERRUPT) {
 		ide_execute_command(drive, WIN_PACKETCMD, handler,
 				    timeout, NULL);
 		return ide_started;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9ab55c5..70bfa8b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -657,7 +657,6 @@ enum {
 	PC_FLAG_WRITING			= (1 << 6),
 	/* command timed out */
 	PC_FLAG_TIMEDOUT		= (1 << 7),
-	PC_FLAG_DRQ_INTERRUPT		= (1 << 8),
 };
 
 struct ide_atapi_pc {
-- 
1.5.5.4

