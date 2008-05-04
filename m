Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYEDOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYEDOun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYEDOud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:50:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:1243 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYEDOuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:date:user-agent:cc:mime-version:content-disposition:message-id:subject:content-type:content-transfer-encoding;
        b=TTiMcO5nDyeOZPNgtcVFnG08uxJNYfHjBz8MsOZFtP98d5RLsOfnHQWavKPLCuFHpfgWCNH9x/5XyiAm14z3cF9u0Mz2EF2Id3pinDcQWrHLPvo985noX8irBUNb1Yg5y8aQWU/muniCvJniAkXIkj4/ggwPQwbk33El0H9H5WQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 May 2008 17:05:52 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805041705.53129.bzolnier@gmail.com>
Subject: [git patches] IDE fixes
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix regression affecting SL82C105 host driver.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-probe.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


Bartlomiej Zolnierkiewicz (1):
      ide: IDE_HFLAG_SERIALIZE_DMA bugfix


diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 591deda..34b0d4f 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1355,12 +1355,6 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
 		hwif->port_ops = d->port_ops;
 
-	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
-	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
-		if (hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
-	}
-
 	hwif->swdma_mask = d->swdma_mask;
 	hwif->mwdma_mask = d->mwdma_mask;
 	hwif->ultra_mask = d->udma_mask;
@@ -1382,6 +1376,12 @@ static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
 			hwif->dma_ops = d->dma_ops;
 	}
 
+	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
+	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
+		if (hwif->mate)
+			hwif->mate->serialized = hwif->serialized = 1;
+	}
+
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
 		hwif->rqsize = 256;
 
