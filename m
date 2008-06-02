Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbYFBUYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbYFBUYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYFBUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:22:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYFBUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AN8pniujybdRMR411WgvgL4gO9nAGrvy2AVRsK2DUyvh6YYcB9SIsrisbGuZBXIjlqtthZCzFt7Twh/yp73p7tePQ2Q3N/JnZ+7YPoqv4QYV38ScqVZUOoDOiNCQOX+MI9xd1LHC/MLzfxcckKuIye4UWULKKDG++tvDTR0zgQU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:47 +0200
Message-Id: <20080602202347.7265.36700.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] au1xxx-ide: don't use hwif->hwif_data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use &auide_hwif directly instead of using hwif->hwif_data.

While at it:

* No need to initialize hwif->{select,config}_data.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/mips/au1xxx-ide.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -213,10 +213,8 @@ static int auide_build_dmatable(ide_driv
 {
 	int i, iswrite, count = 0;
 	ide_hwif_t *hwif = HWIF(drive);
-
 	struct request *rq = HWGROUP(drive)->rq;
-
-	_auide_hwif *ahwif = (_auide_hwif*)hwif->hwif_data;
+	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
 
 	iswrite = (rq_data_dir(rq) == WRITE);
@@ -402,7 +400,7 @@ static const struct ide_dma_ops au1xxx_d
 
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
+	_auide_hwif *auide = &auide_hwif;
 	dbdev_tab_t source_dev_tab, target_dev_tab;
 	u32 dev_id, tsize, devwidth, flags;
 
@@ -463,7 +461,7 @@ static int auide_ddma_init(ide_hwif_t *h
 #else
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
+	_auide_hwif *auide = &auide_hwif;
 	dbdev_tab_t source_dev_tab;
 	int flags;
 
@@ -608,11 +606,8 @@ static int au_ide_probe(struct device *d
 	hwif->input_data  = au1xxx_input_data;
 	hwif->output_data = au1xxx_output_data;
 #endif
-	hwif->select_data               = 0;    /* no chipset-specific code */
-	hwif->config_data               = 0;    /* no chipset-specific code */
 
 	auide_hwif.hwif                 = hwif;
-	hwif->hwif_data                 = &auide_hwif;
 
 	idx[0] = hwif->index;
 
