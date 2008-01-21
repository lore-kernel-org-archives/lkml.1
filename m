Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbYAUXSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbYAUXSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759561AbYAUXRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:17:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbYAUXRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SlUJsj3V5tyq6XeXFBmaW7Xb1iBpxPtrXYCJ3RhbL+PibqeyxFjzrQGKzfm7EixOGv4J+MKL/CTbctvb1hqqWjp7/wisrDxGsdJyTas+tvYEBbMrbKKlgrFrlIXcQiwj/2f5K+/mEs1REbo3EMe1dIlg5nLbOscqt+OlOB2mX7Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:30:50 +0100
Message-Id: <20080121233050.30311.52949.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/16] ide-scsi: use ide_execute_command()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -596,11 +596,8 @@ static ide_startstop_t idescsi_issue_pc 
 		set_bit(PC_DMA_OK, &pc->flags);
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
-		BUG_ON(HWGROUP(drive)->handler != NULL);
-		ide_set_handler(drive, &idescsi_transfer_pc,
-				get_timeout(pc), idescsi_expiry);
-		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
+				    get_timeout(pc), idescsi_expiry);
 		return ide_started;
 	} else {
 		/* Issue the packet command */
