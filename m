Return-Path: <linux-kernel-owner+w=401wt.eu-S1765518AbYD1GAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765518AbYD1GAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765320AbYD1F72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:59:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43504 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765251AbYD1F70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:59:26 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] more icside breakage (from next ide merge)
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, bzolnier@gmail.com
Message-Id: <E1JqMOb-0004lx-VW@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:59:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ide/arm/icside.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 124445c..65038ca 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -419,17 +419,19 @@ icside_setup(void __iomem *base, struct cardinfo *info, struct expansion_card *e
 
 	hwif = ide_find_port();
 	if (hwif) {
-		int i;
-
 		/*
 		 * Ensure we're using MMIO
 		 */
 		default_hwif_mmiops(hwif);
 
-		for (i = 0; i <= 7; i++) {
-			hwif->io_ports_array[i] = port;
-			port += 1 << info->stepping;
-		}
+		hwif->io_ports.data_addr = port;
+		hwif->io_ports.error_addr = port + (1 << info->stepping);
+		hwif->io_ports.nsect_addr = port + (2 << info->stepping);
+		hwif->io_ports.lbal_addr = port + (3 << info->stepping);
+		hwif->io_ports.lbam_addr = port + (4 << info->stepping);
+		hwif->io_ports.lbah_addr = port + (5 << info->stepping);
+		hwif->io_ports.device_addr = port + (6 << info->stepping);
+		hwif->io_ports.status_addr = port + (7 << info->stepping);
 		hwif->io_ports.ctl_addr =
 			(unsigned long)base + info->ctrloffset;
 		hwif->irq     = ec->irq;
-- 
1.5.3.GIT


