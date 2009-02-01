Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZBARtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZBARtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbZBARsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:48:33 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:45568 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZBARsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JYerq846xZjxtiL0wNIoYuzyNTcYfNaSH4GCISQJY8O3go3A4rcOlow97occwPlxKw
         ETXGwDzF/Bg6GIA+6edW7ikvPNPD4JSvIMa6wjvp1p/3gzdnVfhJYRzBwb50xR++gWMb
         kI/sLNKrQJvW0EGFovlqU7IAq7r3zG/DFyLD8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:23 +0100
Message-Id: <20090201174923.19144.28927.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/15] scc_pata: remove DECLARE_SCC_DEV() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scc_pata: remove DECLARE_SCC_DEV() macro

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/scc_pata.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -882,21 +882,16 @@ static const struct ide_dma_ops scc_dma_
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
 
-#define DECLARE_SCC_DEV(name_str)			\
-  {							\
-      .name		= name_str,			\
-      .init_iops	= init_iops_scc,		\
-      .init_dma		= scc_init_dma,			\
-      .init_hwif	= init_hwif_scc,		\
-      .tp_ops		= &scc_tp_ops,		\
-      .port_ops		= &scc_port_ops,		\
-      .dma_ops		= &scc_dma_ops,			\
-      .host_flags	= IDE_HFLAG_SINGLE,		\
-      .pio_mask		= ATA_PIO4,			\
-  }
-
 static const struct ide_port_info scc_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_SCC_DEV("sccIDE"),
+	.name		= "sccIDE",
+	.init_iops	= init_iops_scc,
+	.init_dma	= scc_init_dma,
+	.init_hwif	= init_hwif_scc,
+	.tp_ops		= &scc_tp_ops,
+	.port_ops	= &scc_port_ops,
+	.dma_ops	= &scc_dma_ops,
+	.host_flags	= IDE_HFLAG_SINGLE,
+	.pio_mask	= ATA_PIO4,
 };
 
 /**
