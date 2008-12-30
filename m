Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYL3AVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYL3AVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYL3AVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:21:36 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:14840 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbYL3AVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding:from;
        b=Gh/d+7O4ZYOZ8DQnYYzUUno82X7UZ5TeQpkJZMliscBzPG7l0BgTSbtvnBMx4HVhsq
         Y6RND6dP+TdcrXDukE6w3elM5sYvy5OAI+Qe6WOBzpElcaG1mdn6tdd7vbfuceXENd1H
         pfVcvCs6v+6JXYigjloDjgJ220HKocOIbxwIE=
Date: Mon, 29 Dec 2008 19:21:28 -0500
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [pxamci] fix dma_unmap_sg length
Message-ID: <20081229192128.18a17619@vsauder-lx.localdomain>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Vernon Sauder <vernoninhand@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_unmap_sg should be given the same length as dma_map_sg, not the
value returned from dma_map_sg

Signed-off-by: Vernon Sauder <vsauder@inhand.com>
---
based on latest Linus tree
 drivers/mmc/host/pxamci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 83ffe8e..3fb2be9 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -283,7 +283,7 @@ static int pxamci_data_done(struct pxamci_host *host, unsigned int stat)
 		return 0;
 
 	DCSR(host->dma) = 0;
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
 		     host->dma_dir);
 
 	if (stat & STAT_READ_TIME_OUT)
-- 
1.5.2.4

