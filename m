Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbYA0VcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbYA0VcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYA0VcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:32:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33284 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbYA0VcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:32:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 Jan 2008 22:31:27 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.24-git3] firewire: fw-sbp2: relax SCSI DMA alignment
To: linux1394-devel@lists.sourceforge.net
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1201373642.4387.0.camel@localhost.localdomain>
Message-ID: <tkrat.6b01fb9bb536c584@s5r6.in-berlin.de>
References: <479B80A3.5070207@s5r6.in-berlin.de>
 <1201373642.4387.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Not run-time tested yet.

 drivers/firewire/fw-sbp2.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.24-git3/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.24-git3.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.24-git3/drivers/firewire/fw-sbp2.c
@@ -1309,11 +1309,8 @@ static int sbp2_scsi_slave_alloc(struct 
 
 	sdev->allow_restart = 1;
 
-	/*
-	 * Update the dma alignment (minimum alignment requirements for
-	 * start and end of DMA transfers) to be a sector
-	 */
-	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+	/* SBP-2 requires quadlet alignment of the data buffers. */
+	blk_queue_update_dma_alignment(sdev->request_queue, 4 - 1);
 
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;

-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/

