Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbYERSmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbYERSmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYERSif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbYERSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l20i5sWOUa8ELoeLE7cQS1ONC0CcXpJ8SGZ6xH4BO+WQZ9esEKJ/QF9GxZFcCr2IhNYWwf+shVc4XaFxa0P26Rr2HEDah07T1mmZZ3LyyR4SxyoQggGRBfh7ZdX3nsywdGfZduoiX7Ry8gti8YRla+8SINcVNXPSBoA9SktSPVU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:58 +0200
Message-Id: <20080518185558.5636.56122.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/40] ide-tape: remove superfluous warning message from idetape_issue_pc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_dma_off() prints info about DMA being disabled.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1038,8 +1038,6 @@ static ide_startstop_t idetape_issue_pc(
 
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->flags &= ~PC_FLAG_DMA_ERROR;
-		printk(KERN_WARNING "ide-tape: DMA disabled, "
-				"reverting to PIO\n");
 		ide_dma_off(drive);
 	}
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
