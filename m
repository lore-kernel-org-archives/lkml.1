Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbZKYRJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbZKYRJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbZKYRJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:09:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZKYRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:09:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qY4neLdh/xe3InH4DAKmdgMInOzz4NjmwUJvRHDl5RCb9l+aMPz0x0dcRWSIqGJqBG
         UIVZ+OtxkzLTTN0OaiBfeJJ+0/UV2prFdUzVFZ7DEqtcURbDknCrjbaNvT8dzENO886t
         S5oZxRxqZglumAswBAX8QYyIXGQ6yzdmAwjsg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:10 +0100
Message-Id: <20091125170910.5446.60507.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 57/86] pata_opti: add 32-bit PIO support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_opti: add 32-bit PIO support

There shouldn't be any problems with it as IDE opti621 host driver
has been allowing 32-bit PIO operations for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_opti.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ata/pata_opti.c
===================================================================
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -157,6 +157,8 @@ static struct ata_port_operations opti_p
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= opti_set_piomode,
 	.prereset	= opti_pre_reset,
+	.sff_data_xfer	= ata_sff_data_xfer32,
+	.port_start	= ata_sff_port_start32,
 };
 
 static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
