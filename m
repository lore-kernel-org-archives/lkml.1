Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYAUXTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYAUXTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760504AbYAUXR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:17:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760412AbYAUXR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xQkIUA6bQZChTLZeM/YE9KdxxWzuE7k1PlJJPIOeVrB33w+y+j/qxmXMmhdxsecjBnnQG78G5twHDrlJiapDRplMlhHMSbYi168VQusobcXMuQxVGVonOMPiGddLIP2rMNGHLP14YLcWjKD2ZvIC81zRKMa7fR45FNuwPHXE3Xg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:03 +0100
Message-Id: <20080121233103.30311.22721.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/16] ide-cris: use ide_execute_command()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -1034,11 +1034,7 @@ static int cris_dma_setup(ide_drive_t *d
 
 static void cris_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
-	/* set the irq handler which will finish the request when DMA is done */
-	ide_set_handler(drive, &cris_dma_intr, WAIT_CMD, NULL);
-
-	/* issue cmd to drive */
-	cris_ide_outb(command, IDE_COMMAND_REG);
+	ide_execute_command(drive, command, &cris_dma_intr, WAIT_CMD, NULL);
 }
 
 static void cris_dma_start(ide_drive_t *drive)
