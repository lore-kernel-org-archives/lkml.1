Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYBDNoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYBDNoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYBDNmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:25871 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYBDNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=wO4oGponIlYyZf7bqNu77a8xJ4vGrLQcxGgpdX76W5b/gzy6O9kJzqlN3qi4mHWsO6gS3nR2u+mBPzBsLN2GetFBB5gAZmCuQgZ04EQTwhErHN5dw/GB8eul9oO37pvXVRZmMSpTUTcLPS7vDdC5lY3f1++COWS2YylS+SPN0iE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 12/22] ide-tape: dump gcw fields on error in idetape_identify_device()
Date: Mon,  4 Feb 2008 14:40:30 +0100
Message-Id: <1202132440-26648-13-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

goes before "ide-tape: remove IDETAPE_DEBUG_INFO" patch in IDE quilt tree

Cc: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1c4f94c..712c5df 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3402,16 +3402,17 @@ static int idetape_identify_device (ide_drive_t *drive)
 
 	/* Check that we can support this device */
 
-	if (gcw.protocol !=2 )
-		printk(KERN_ERR "ide-tape: Protocol is not ATAPI\n");
+	if (gcw.protocol != 2)
+		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
+				gcw.protocol);
 	else if (gcw.device_type != 1)
-		printk(KERN_ERR "ide-tape: Device type is not set to tape\n");
+		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
+				"to tape\n", gcw.device_type);
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
 	else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-tape: Packet size is not 12 bytes long\n");
-		if (gcw.packet_size == 1)
-			printk(KERN_ERR "ide-tape: Sorry, padding to 16 bytes is still not supported\n");
+		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
+				"bytes long\n", gcw.packet_size);
 	} else
 		return 1;
 	return 0;
-- 
1.5.3.7

