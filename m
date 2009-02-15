Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZBOMK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZBOMK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZBOMIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:36 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:39233 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZBOMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JjqsoM+kZ49/Sxr+9QaQ2TLfiIjp4AJnOGFkcoA+FyWGrVc9rNKZjrLDGF3huDAO0Q
         9b0S8hYdAA/XF8BQcxzfjclmmVcKMHr6ujpUKQUNytUUyv2n2JSEdeaOdVUQCYsLUKSU
         NGsYdA0x1Numx00W+hnSdGOdMQVdOdkm5rOsw=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 07/10] ide-devsets: use flags query macros
Date: Sun, 15 Feb 2009 13:08:09 +0100
Message-Id: <1234699692-9452-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-devsets.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index 5bf958e..ca6a097 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -8,7 +8,7 @@ ide_devset_get(io_32bit, io_32bit);
 
 static int set_io_32bit(ide_drive_t *drive, int arg)
 {
-	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
+	if (ide_drv_no_32bit_io(drive))
 		return -EPERM;
 
 	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
@@ -115,12 +115,10 @@ static int set_pio_mode(ide_drive_t *drive, int arg)
 		} else
 			port_ops->set_pio_mode(drive, arg);
 	} else {
-		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-
 		ide_set_pio(drive, arg);
 
 		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
-			if (keep_dma)
+			if (ide_drv_using_dma(drive))
 				ide_dma_on(drive);
 		}
 	}
@@ -132,7 +130,7 @@ ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
 
 static int set_unmaskirq(ide_drive_t *drive, int arg)
 {
-	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
+	if (ide_drv_no_unmask(drive))
 		return -EPERM;
 
 	if (arg < 0 || arg > 1)
-- 
1.6.0.4

