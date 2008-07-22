Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYGVVPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYGVVPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYGVVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:14:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:36875 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYGVVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r7m8ctu3QCjdECfJ/v2AAafYxzI9JUmgR/6kJCMn7PExYMU7zVeiUQAksaYyNhZBjn
         pxmVi7oyPhzU/JUKdDCNyykVKfaUxW+8GW0cwLAtwN423tWrmzYhKOKyAFE6bpmYswEV
         uw648hO+3VCsutXLGix7uuB0QWaBC5bTLqrGo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:06 +0200
Message-Id: <20080722211206.20478.65791.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/10] ide: fix pre-EIDE SWDMA support on big-endian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

id->tDMA is of 'unsigned char' type so endianness is already
correct and calling le16_to_cpu() is wrong.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -649,11 +649,7 @@ static unsigned int ide_get_mode_mask(id
 		if (id->field_valid & 2) {
 			mask = id->dma_1word & hwif->swdma_mask;
 		} else if (id->tDMA) {
-			/*
-			 * ide_fix_driveid() doesn't convert ->tDMA to the
-			 * CPU endianness so we need to do it here
-			 */
-			u8 mode = le16_to_cpu(id->tDMA);
+			u8 mode = id->tDMA;
 
 			/*
 			 * if the mode is valid convert it to the mask
