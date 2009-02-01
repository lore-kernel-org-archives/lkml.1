Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZBATPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZBATPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZBATPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:15:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:63098 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZBATPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:15:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=gPjYNuLCIfNtXTCCH1iMXlzUOnls7+U4OqYyzyW/tLfhHAOrlCHERFcDE+cQl5RuUt
         xFS2kWMz5o+6TylLVIH36Lp5Rj2+bxHMFdVdSIjORAQcm89cAuQ5gKrdEwnYOAbjFMkl
         /BCfsVzGoEi7KYpV0DnAJixaCT0tRYx0b3MPM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] trm290: trm290_dma_setup() fix
Date: Sun, 1 Feb 2009 20:14:32 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc2-next-20090126; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012014.33037.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-map sg table if necessary (not that it really matters since
DMA support is disabled currently).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
we should consider removing the driver (or at least DMA support)...

 drivers/ide/trm290.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -198,6 +198,7 @@ static int trm290_dma_setup(ide_drive_t 
 		rw = 2;
 
 	if (!(count = ide_build_dmatable(drive, rq))) {
+		ide_map_sg(drive, rq);
 		/* try PIO instead of DMA */
 		trm290_prepare_drive(drive, 0); /* select PIO xfer */
 		return 1;
