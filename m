Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbZBATP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbZBATP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZBATPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:15:08 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:60208 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZBATPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Lzo6HktrINjy5Ycc3C+hrI6pQK0uB794uvjT7b07e51zlHKJ2q4PMoiRq+qnOfb0mq
         p6KxzR0PIev7zrhwovR1Jxgsii8KVL4dW0QxpZGrImi9ljOrPcjsJ3eJLsIl8yqQX8bi
         MJNFVr8EyGMQpgp8INl1zVcVQtt/2og34/yJo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] au1xxx-ide: auide_dma_end() cleanup
Date: Sun, 1 Feb 2009 20:15:29 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc2-next-20090126; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012015.29284.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check / clear hwif->sg_nents.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -286,12 +286,7 @@ static int auide_build_dmatable(ide_driv
 
 static int auide_dma_end(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
-
-	if (hwif->sg_nents) {
-		ide_destroy_dmatable(drive);
-		hwif->sg_nents = 0;
-	}
+	ide_destroy_dmatable(drive);
 
 	return 0;
 }
