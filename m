Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564Ab0ARRQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0ARRQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509Ab0ARRQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:35 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53275 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0ARRQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:16:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bplLlQpkZ05dYg2eixd6I5+toNyeIjX+IlnwqezI8QZ9BvbB0NLdQbPv88PYvFxGKu
         yGuE8gGgiU/E6+oMVbwanhnU2O7WBCPqgf+CGbju4IHvoaslQTWY1wb0+E7lbmYs8urt
         8nhbg/LqXBSNrT/B9llJ/dacXWQePea5aNuPI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:15:11 +0100
Message-Id: <20100118171511.14623.43642.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 10/64] pata_cmd64x: cmd648_bmdma_stop() fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: cmd648_bmdma_stop() fix

Clear the primary channel pending interrupt bit
instead of the reserved one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -40,7 +40,7 @@
 
 enum {
 	CFR 		= 0x50,
-		CFR_INTR_CH0  = 0x02,
+		CFR_INTR_CH0  = 0x04,
 	CNTRL 		= 0x51,
 		CNTRL_DIS_RA0 = 0x40,
 		CNTRL_DIS_RA1 = 0x80,
