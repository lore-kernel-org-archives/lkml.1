Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYFKU1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYFKU1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYFKU0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:26:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60994 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYFKU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=rJex7FplpcGwW7XVUP6ml5QVeRobUu5sH7e2J59Sve4tWwW55ZCGBELCM4di3txTEn
         vTpl0+XVfO3OPtLO6eEejCab4S6JD8H2cdvTuo+USgWWMGSvuGiJrcsXeOIN35XwNLZM
         arLhATcln0mYzNOqLvTBcJUzz810y2x5ZT8LQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/6] opti621: remove DMA support
Date: Wed, 11 Jun 2008 21:58:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Juergen Kosel <juergen.kosel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112158.18354.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These controllers don't support DMA.

Based on a bugreport from Juergen Kosel & inspired by pata_opti.c code.

Tested-by: Juergen Kosel <juergen.kosel@gmx.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/opti621.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -324,18 +324,14 @@ static const struct ide_port_info opti62
 		.name		= "OPTI621",
 		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 		.port_ops	= &opti621_port_ops,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+		.host_flags	= IDE_HFLAG_NO_DMA,
 		.pio_mask	= ATA_PIO3,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
 	}, {	/* 1 */
 		.name		= "OPTI621X",
 		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 		.port_ops	= &opti621_port_ops,
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
+		.host_flags	= IDE_HFLAG_NO_DMA,
 		.pio_mask	= ATA_PIO3,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
 	}
 };
 
