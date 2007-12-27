Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXL0TCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXL0TCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbXL0TBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:01:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXL0TBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=iWMzw9i+z/WA2EnIQQ1uVIfpO6y+kzDFMig24tjBUxjZPxTG16z9eUdVKGga7klFK2FGtrLOUWIKy2TXCFOlhZX82+bF25FPwXP3z3jJE7en0AoA3Cww7BOZdxXnPSBYNMMU3nc1zsse64TaJcu8UE1RyW2Nde0TrgG1E56PL74=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 27 Dec 2007 20:12:07 +0100
Message-Id: <20071227191207.1357.24118.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: fix ide_intr() for non-PCI devices and CONFIG_BLK_DEV_IDEPCI=y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'hwif->pci_dev && !hwif->pci_dev->vendor' condition is never true,
check for 'hwif->chipset != ide_pci' instead.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1487,7 +1487,7 @@ irqreturn_t ide_intr (int irq, void *dev
 		 * remove all the ifdef PCI crap
 		 */
 #ifdef CONFIG_BLK_DEV_IDEPCI
-		if (hwif->pci_dev && !hwif->pci_dev->vendor)
+		if (hwif->chipset != ide_pci)
 #endif	/* CONFIG_BLK_DEV_IDEPCI */
 		{
 			/*
