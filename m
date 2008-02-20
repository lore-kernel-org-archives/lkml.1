Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbYBTUTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbYBTUTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbYBTUS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:18:57 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:20561 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbYBTUSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=idzr9Hf5dNp2+UMCfBVwxwkmXBNOwWZY3nvYVfaEfXrWvmzqcKvBI/TdiRuMPRyMjXEzYt7zzTYBcw0tag45VA4xhPw9qrSsEAEIo5LM51NfyZ2iiNbeThrd2S83Tl6LCHMCtOSLOgaoEaYffSZJIBhPKydgwt43wHfhjiD4VoY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: remove IDE_HFLAG_CY82C693 host flag
Date: Wed, 20 Feb 2008 21:33:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802202133.19126.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei suggested that it shouldn't be necessary + it had no effect
anyway since ide_id_dma_bug() is called earlier in ide_tune_dma().

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I went ahead since I urgently needed to re-cycle one host flag.

 drivers/ide/ide-dma.c      |   10 ++--------
 drivers/ide/pci/cy82c693.c |    2 +-
 include/linux/ide.h        |    2 --
 3 files changed, 3 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -747,14 +747,8 @@ static int ide_tune_dma(ide_drive_t *dri
 
 	speed = ide_max_dma_mode(drive);
 
-	if (!speed) {
-		 /* is this really correct/needed? */
-		if ((hwif->host_flags & IDE_HFLAG_CY82C693) &&
-		    ide_dma_good_drive(drive))
-			return 1;
-		else
-			return 0;
-	}
+	if (!speed)
+		return 0;
 
 	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
 		return 1;
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -410,7 +410,7 @@ static const struct ide_port_info cy82c6
 	.init_iops	= init_iops_cy82c693,
 	.init_hwif	= init_hwif_cy82c693,
 	.chipset	= ide_cy82c693,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_CY82C693,
+	.host_flags	= IDE_HFLAG_SINGLE,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2,
 	.mwdma_mask	= ATA_MWDMA2,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1089,8 +1089,6 @@ enum {
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
 	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
-	/* host is CY82C693 */
-	IDE_HFLAG_CY82C693		= (1 << 27),
 	/* force host out of "simplex" mode */
 	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 	/* DSC overlap is unsupported */
