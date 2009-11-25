Return-Path: <linux-kernel-owner+w=401wt.eu-S934731AbZKYRLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731AbZKYRLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933582AbZKYRL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39574 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbZKYRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fZH85udg2gytmsoXq2MXTgYf0wMNtmwh5q9vCem9j5NsfA61DRjlF9HuMf34XYUi6h
         C4GNqBE3w6aF5WfcegxBOYmQ0mkazi2WVtBB9Th1wCaipAq+3JysJJ5UYWgfX75AJpI8
         ulGU9I3P9zVNsKltgnwhOCP8EMH+xz/k9LCw8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:46 +0100
Message-Id: <20091125171046.5446.49179.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 70/86] pata_scc: add proper cable detection method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_scc: add proper cable detection method

Use standard ata_cable_80wire() method for the cable detection,
as a bonus this allows us to use the default ->prereset method.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_scc.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

Index: b/drivers/ata/pata_scc.c
===================================================================
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -865,18 +865,6 @@ static void scc_freeze (struct ata_port
 }
 
 /**
- *	scc_pata_prereset - prepare for reset
- *	@ap: ATA port to be reset
- *	@deadline: deadline jiffies for the operation
- */
-
-static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
-{
-	link->ap->cbl = ATA_CBL_PATA80;
-	return ata_sff_prereset(link, deadline);
-}
-
-/**
  *	scc_postreset - standard postreset callback
  *	@ap: the target ata_port
  *	@classes: classes of attached devices
@@ -986,7 +974,7 @@ static struct ata_port_operations scc_pa
 	.sff_data_xfer		= scc_data_xfer,
 
 	.freeze			= scc_freeze,
-	.prereset		= scc_pata_prereset,
+	.cable_detect		= ata_cable_80wire,
 	.softreset		= scc_softreset,
 	.postreset		= scc_postreset,
 	.post_internal_cmd	= scc_bmdma_stop,
