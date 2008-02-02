Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbYBBSZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbYBBSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbYBBSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:25:13 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:48056 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933536AbYBBSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FLw1UmEgNwMFE4tDpIH88tSEWKSrraVn6unwx5xGZlR1pjWckJRzrvP5VBeoNhU397Bca+hy+l8hx3bouvB6Jypt3rGV5PUjdINdSShVAqhF7YTKHJ+0GrGNrA4toQzI5Lsj8liutVTSuKUqD8qjq+apl5qCCDv1C2hkNTILkUY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-tape: dump gcw fields on error in idetape_identify_device()
Date: Sat, 2 Feb 2008 19:22:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802021922.56703.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide-tape: remove IDETAPE_DEBUG_INFO" patch in IDE quilt tree

 drivers/ide/ide-tape.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3852,16 +3852,17 @@ static int idetape_identify_device (ide_
 
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
