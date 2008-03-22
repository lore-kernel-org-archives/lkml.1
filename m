Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYCVVvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYCVVvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYCVVv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:51:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:4232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYCVVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:subject;
        b=hHlnx/IYVXgnzT5VDVFqaCzqy9x/3BgsKT3f3mWAY0JWfuHKTdTR6SBZx1g75FtJwrNezjsWCmo22bJqTCyy1nKkrwbt4ok2QM451gKuRbw34RU0P1bnPwXEexUfNrVNoVfkCcXz88lEPtF0cmzLaInfiwSAsPW/1O2i6QQdCS4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:06:23 +0100
Message-Id: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/8] ide: always auto-tune PIO in legacy VLB host drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ali14xx.c |    2 +-
 drivers/ide/legacy/dtc2278.c |    3 +--
 drivers/ide/legacy/ht6560b.c |    1 -
 drivers/ide/legacy/qd65xx.c  |    5 +----
 drivers/ide/legacy/umc8672.c |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -202,7 +202,7 @@ static const struct ide_port_info ali14x
 	.name			= DRV_NAME,
 	.chipset		= ide_ali14xx,
 	.port_ops		= &ali14xx_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -101,8 +101,7 @@ static const struct ide_port_info dtc227
 				  IDE_HFLAG_IO_32BIT |
 				  /* disallow ->io_32bit changes */
 				  IDE_HFLAG_NO_IO_32BIT |
-				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE,
+				  IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -340,7 +340,6 @@ static const struct ide_port_info ht6560
 	.port_ops		= &ht6560b_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
 				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 	.pio_mask		= ATA_PIO4,
 };
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -12,8 +12,6 @@
  * QDI QD6500/QD6580 EIDE controller fast support
  *
  * To activate controller support, use "ide0=qd65xx"
- * To enable tuning, use "hda=autotune hdb=autotune"
- * To enable 2nd channel tuning (qd6580 only), use "hdc=autotune hdd=autotune"
  */
 
 /*
@@ -324,8 +322,7 @@ static const struct ide_port_info qd65xx
 	.name			= DRV_NAME,
 	.chipset		= ide_qd65xx,
 	.host_flags		= IDE_HFLAG_IO_32BIT |
-				  IDE_HFLAG_NO_DMA |
-				  IDE_HFLAG_NO_AUTOTUNE,
+				  IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -130,7 +130,7 @@ static const struct ide_port_info umc867
 	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO4,
 };
 
