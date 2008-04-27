Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYD0FMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYD0FMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYD0FMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:12:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55211 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYD0FMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:12:30 -0400
Date: Sun, 27 Apr 2008 06:12:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russell King <rmk@arm.linux.org.uk>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fix icside breakage
Message-ID: <20080427051227.GM5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fallout from commit ac95beedf8bc97b24f9540d4da9952f07221c023

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 7d642f4..c0cf7fc 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -547,14 +547,13 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
 
-	mate->maskproc    = icside_maskproc;
 	mate->hwif_data   = state;
 	mate->config_data = (unsigned long)ioc_base;
 	mate->select_data = sel | 1;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		d.init_dma = icside_dma_init;
-		d.port_ops = &icside_v6_dma_port_ops;
+		d.port_ops = &icside_v6_port_ops;
 		d.dma_ops = NULL;
 	}
 
