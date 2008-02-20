Return-Path: <linux-kernel-owner+w=401wt.eu-S1764968AbYBTUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764968AbYBTUTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYBTUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:18:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:47278 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYBTUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=r58bjk7y9vuCn6J/SCG+Xv+fnD222ECyhnHKx18zdLWugsjsXIkvWqi6+DYHJZ6qJJkSvn2Kps6cdxgjelp9FxcaVxttR+6g4WMHeuqh0NGvFZXG9fsRJ5W+ud5DeNzLQ9Xh+G2PqUHbGTmLpOWHfdLJEm52+nQhcgx4+qL9Jj0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide: fix enabling DMA on it821x in "smart" mode
Date: Wed, 20 Feb 2008 21:31:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802202131.19761.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_tune_dma() should return '1' if IDE_HFLAG_NO_SET_MODE host flag is set.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I wonder how this could have slipped in :(

Sergei, please double-check this patch.  Thanks!

 drivers/ide/ide-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -757,7 +757,7 @@ static int ide_tune_dma(ide_drive_t *dri
 	}
 
 	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 0;
+		return 1;
 
 	if (ide_set_dma_mode(drive, speed))
 		return 0;
