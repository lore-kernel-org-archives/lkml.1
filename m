Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYCaQVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYCaQVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYCaQVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:21:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:42308 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYCaQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:21:40 -0400
Date: Mon, 31 Mar 2008 11:17:22 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       wei.zhang@freescale.com
Subject: [PATCH] [POWERPC] fsldma: Use compatiable binding as spec
Message-ID: <Pine.LNX.4.64.0803311115540.5470@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/powerpc/booting-without-of.txt specifies the
compatiables we should bind to for this driver (elo, eloplus).
Use these instead of the extremely specific 'mpc8540' and 'mpc8349'
compatiables.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Dan, if you don't have any issue with this I'll sent it via the powerpc
tree (since its not really about functionality).

- k

 drivers/dma/fsldma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 7269230..df16368 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1021,11 +1021,11 @@ const u32 mpc8349_dma_ip_feature = FSL_DMA_IP_83XX | FSL_DMA_LITTLE_ENDIAN;

 static struct of_device_id of_fsl_dma_chan_ids[] = {
 	{
-		.compatible = "fsl,mpc8540-dma-channel",
+		.compatible = "fsl,eloplus-dma-channel",
 		.data = (void *)&mpc8540_dma_ip_feature,
 	},
 	{
-		.compatible = "fsl,mpc8349-dma-channel",
+		.compatible = "fsl,elo-dma-channel",
 		.data = (void *)&mpc8349_dma_ip_feature,
 	},
 	{}
@@ -1107,8 +1107,8 @@ err:
 }

 static struct of_device_id of_fsl_dma_ids[] = {
-	{ .compatible = "fsl,mpc8540-dma", },
-	{ .compatible = "fsl,mpc8349-dma", },
+	{ .compatible = "fsl,eloplus-dma", },
+	{ .compatible = "fsl,elo-dma", },
 	{}
 };

-- 
1.5.4.1

