Return-Path: <linux-kernel-owner+w=401wt.eu-S1762372AbXLTB45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762372AbXLTB45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbXLTBed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbXLTBeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=wYK+8HjwAtXLgLU2wr/fn1qxRj5upPoavqMHViZrXMUarQzItS6BDb0XkgVLafg8zJbxsRN1iyTw1tVxST5x/+Hjnuk+IbzGS53qTaDyK81dARXB6y5GbIIuMqMvk74hi8xyeF+FeBk82ZZ6gGsV8JyFpJccZeCY3G/LV5bdPgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 05/63] ide-cd: add missing 'ireason' masking to cdrom_write_intr()
Date: Thu, 20 Dec 2007 01:55:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200155.17499.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mask 'ireason' variable with 0x3 so the valid interrupt reason value
is passed to cdrom_write_check_ireason() for checking.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1820,7 +1820,7 @@ static ide_startstop_t cdrom_write_intr(
 	}
 
 	/* Read the interrupt reason and the transfer length. */
-	ireason = HWIF(drive)->INB(IDE_IREASON_REG);
+	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
 	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
 	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
 
