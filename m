Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYCTAxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYCTAxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYCTAxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:53:38 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49525 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYCTAxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:53:37 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] net: yellowfin parenthesis fix
Date: Thu, 20 Mar 2008 01:53:27 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803200153.27730.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	The code is under unused #ifdef NO_TXSTATS branch but its better
to have it fixed. The patch is against 2.6.25-rc5-mm1.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

--- linux-2.6.25-rc5-mm1-a/drivers/net/yellowfin.c	2008-03-20 01:35:48.000000000 +0100
+++ linux-2.6.25-rc5-mm1-b/drivers/net/yellowfin.c	2008-03-20 01:36:46.000000000 +0100
@@ -770,14 +770,14 @@ static void yellowfin_init_ring(struct n
 		/* Branch on Tx error. */
 		yp->tx_ring[j].dbdma_cmd = cpu_to_le32(CMD_STOP);
 		yp->tx_ring[j].branch_addr = cpu_to_le32(yp->tx_ring_dma +
-			(j+1)*sizeof(struct yellowfin_desc);
+			(j+1)*sizeof(struct yellowfin_desc));
 		j++;
 		if (yp->flags & FullTxStatus) {
 			yp->tx_ring[j].dbdma_cmd =
 				cpu_to_le32(CMD_TXSTATUS | sizeof(*yp->tx_status));
 			yp->tx_ring[j].request_cnt = sizeof(*yp->tx_status);
 			yp->tx_ring[j].addr = cpu_to_le32(yp->tx_status_dma +
-				i*sizeof(struct tx_status_words);
+				i*sizeof(struct tx_status_words));
 		} else {
 			/* Symbios chips write only tx_errs word. */
 			yp->tx_ring[j].dbdma_cmd =
