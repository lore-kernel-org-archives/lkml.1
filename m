Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891Ab0ARRSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0ARRSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867Ab0ARRSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:17 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57477 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0ARRSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vYptqEAPGGa2rZrhzcA4cRGwo6Jz03mo8aX8vki/Zyi/xnRi8rv/vFykP4OdQpWQ1W
         aQy6TCxQYY1pVSe0IqBVoz+F1Txs7ZCPkWONPj0MU6z6u1Z7MRBY84eJ7rkKJyaV0k2h
         UxP3M1AzH7VAW12hT37TrnBgQHcGJHsDpdZeA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:03 +0100
Message-Id: <20100118171703.14623.85025.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 22/64] pata_via: fix address setup timings underlocking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: fix address setup timings underlocking

Correct via_do_set_mode() documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -229,7 +229,7 @@ static int via_pre_reset(struct ata_link
 
 
 /**
- *	via_do_set_mode	-	set initial PIO mode data
+ *	via_do_set_mode	-	set transfer mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: ATA mode being programmed
@@ -273,7 +273,7 @@ static void via_do_set_mode(struct ata_p
 
 		pci_read_config_byte(pdev, 0x4C, &setup);
 		setup &= ~(3 << shift);
-		setup |= clamp_val(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
+		setup |= (clamp_val(t.setup, 1, 4) - 1) << shift;
 		pci_write_config_byte(pdev, 0x4C, setup);
 	}
 
