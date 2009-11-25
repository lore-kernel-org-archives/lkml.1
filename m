Return-Path: <linux-kernel-owner+w=401wt.eu-S934852AbZKYRS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbZKYRS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbZKYRKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:10:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337AbZKYRKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=O288haSRMFYcG2HKT8ElIYZGNev4FAZAIIW4/yn3QjM0vpmuzmvnLZ6pdbG8QxOxfR
         cChqev9foHTo9qHEc6BuNzuBN7EMF8tnMNPCnzCcsFw4DcKdEOfkS5Kqux9gEdnqxZ8k
         PKdQMg9whEYCc+BrzGEEVqBL2RlRpW3BA2jvk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:33 +0100
Message-Id: <20091125170933.5446.67311.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 60/86] pata_pdc202xx_old: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: add 32-bit PIO support

There shouldn't be any problems with it as IDE pdc202xx_old host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc202xx_old.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -240,7 +240,7 @@ static int pdc2026x_port_start(struct at
 		u8 burst = ioread8(bmdma + 0x1f);
 		iowrite8(burst | 0x01, bmdma + 0x1f);
 	}
-	return ata_sff_port_start(ap);
+	return ata_sff_port_start32(ap);
 }
 
 /**
@@ -266,7 +266,7 @@ static struct scsi_host_template pdc202x
 };
 
 static struct ata_port_operations pdc2024x_port_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= pdc202xx_set_piomode,
