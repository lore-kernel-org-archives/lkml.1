Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYKLVdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYKLVdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYKLVdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:33:01 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:18390 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbYKLVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:32:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ttzhibDZzXJHk1V5fzMwxPhE4gmvWSw4Lw/JZRX+O0tld3iUyinKFAgPIA/Nvzou2S
         l3QUFUKcCGG9K4FpPYp9xSjix0g/ShLLK+jkhTn55jViYsEE3F9784DFxTI/5/bIOZLW
         BFsQeGv8U/T7jFlJ+OzGWQAx+pNfFFezlVUm4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/6] ide: small ide_register_port() cleanup
Date: Wed, 12 Nov 2008 22:16:06 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122216.06257.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -640,14 +640,9 @@ static int ide_register_port(ide_hwif_t 
 	/* register with global device tree */
 	dev_set_name(&hwif->gendev, hwif->name);
 	hwif->gendev.driver_data = hwif;
-	if (hwif->gendev.parent == NULL) {
-		if (hwif->dev)
-			hwif->gendev.parent = hwif->dev;
-		else
-			/* Would like to do = &device_legacy */
-			hwif->gendev.parent = NULL;
-	}
+	hwif->gendev.parent = hwif->dev;
 	hwif->gendev.release = hwif_release_dev;
+
 	ret = device_register(&hwif->gendev);
 	if (ret < 0) {
 		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
