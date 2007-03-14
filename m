Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbXCNP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbXCNP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXCNP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:28:33 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:58674 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXCNP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:28:23 -0400
Date: Wed, 14 Mar 2007 15:26:03 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [IDE] au1xxx: Fix use of mixed declarations and code
Message-ID: <20070314152603.GA5934@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ide/mips/au1xxx-ide.c:684: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index b2dc028..d54d9fe 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -639,6 +639,7 @@ static int au_ide_probe(struct device *dev)
 	_auide_hwif *ahwif = &auide_hwif;
 	ide_hwif_t *hwif;
 	struct resource *res;
+	hw_regs_t *hw;
 	int ret = 0;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
@@ -681,7 +682,7 @@ static int au_ide_probe(struct device *dev)
 	/* FIXME:  This might possibly break PCMCIA IDE devices */
 
 	hwif                            = &ide_hwifs[pdev->id];
-	hw_regs_t *hw 			= &hwif->hw;
+	hw 				= &hwif->hw;
 	hwif->irq = hw->irq             = ahwif->irq;
 	hwif->chipset                   = ide_au1xxx;
 
