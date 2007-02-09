Return-Path: <linux-kernel-owner+w=401wt.eu-S1946655AbXBIQjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946655AbXBIQjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946636AbXBIQjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51725 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946655AbXBIQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:36 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] sata_svw: trivial iomem annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYmd-0006qA-Nl@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ata/sata_svw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 46d8a94..5f4e82a 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -116,7 +116,7 @@ static u32 k2_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
 {
 	if (sc_reg > SCR_CONTROL)
 		return 0xffffffffU;
-	return readl((void *) ap->ioaddr.scr_addr + (sc_reg * 4));
+	return readl((void __iomem *) ap->ioaddr.scr_addr + (sc_reg * 4));
 }
 
 
@@ -125,7 +125,7 @@ static void k2_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
 {
 	if (sc_reg > SCR_CONTROL)
 		return;
-	writel(val, (void *) ap->ioaddr.scr_addr + (sc_reg * 4));
+	writel(val, (void __iomem *) ap->ioaddr.scr_addr + (sc_reg * 4));
 }
 
 
@@ -262,7 +262,7 @@ static void k2_bmdma_start_mmio (struct ata_queued_cmd *qc)
 
 static u8 k2_stat_check_status(struct ata_port *ap)
 {
-       	return readl((void *) ap->ioaddr.status_addr);
+       	return readl((void __iomem *) ap->ioaddr.status_addr);
 }
 
 #ifdef CONFIG_PPC_OF
-- 
1.5.0-rc2.GIT


