Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbYEHTWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbYEHTWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYEHTWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:22:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:2284 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYEHTV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JYflhpvz5c5eGQZjZn/oRUMrg2GpOuFsgZbOucmxpQE69jr+o9F+aQdTLn5l2LpKTzc7wsL1GgviKlXhnTjfE6gzBuH6iAHhAUFFnvdoczoBI8h7gktT/ZtcF9Q1Y2bhvOIaw9hyCooJb8SjBDqGF/SMdPFXwV4mwokJa7Ycx88=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide: use ->OUTBSYNC in init_irq()
Date: Thu, 8 May 2008 21:36:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082136.19742.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1068,7 +1068,7 @@ static int init_irq (ide_hwif_t *hwif)
 
 		if (io_ports->ctl_addr)
 			/* clear nIEN */
-			hwif->OUTB(0x08, io_ports->ctl_addr);
+			hwif->OUTBSYNC(hwif, 0x08, io_ports->ctl_addr);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
