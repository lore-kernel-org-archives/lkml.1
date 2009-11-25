Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbZKYRHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbZKYRHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbZKYRHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:07:18 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42882 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbZKYRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gg7SJ8T/ieHDUll3LrWu2UfCFP4/wP3hSLG5n8pWrQflPS1tk0Podqwh2KqjoRhl2r
         AsrQFf5eHW9x+tlprxUebI5bqPmwhRIaoM8GKMixSG+Qw1YzaIvkK9wxOTGRpJjB8UnZ
         G+VAzA0+yEBwLGahd4yAz4RdwQ7EHpLNTKEzs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:37 +0100
Message-Id: <20091125170637.5446.77089.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 36/86] pata_it8213: add UDMA100 and UDMA133 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: add UDMA100 and UDMA133 support

There shouldn't be any problems with it as IDE it8213 host driver
has been supporting UDMA100 and UDMA133 for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -164,7 +164,7 @@ static void it8213_set_dmamode (struct a
 
 		/* Clocks follow the PIIX style */
 		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
+		if (udma > 4)
 			u_clock = 0x1000;	/* 100Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
@@ -264,7 +264,7 @@ static int it8213_init_one (struct pci_d
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
+		.udma_mask 	= ATA_UDMA6,
 		.port_ops	= &it8213_ops,
 	};
 	/* Current IT8213 stuff is single port */
