Return-Path: <linux-kernel-owner+w=401wt.eu-S937145AbXLTPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937145AbXLTPnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbXLTPWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:51 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62513 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763951AbXLTPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:08 -0500
Message-Id: <20071220152105.992479981@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:39 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Sebastian Ott <sebott@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/47] qdio: Remove double checked value.
Content-Disposition: inline; filename=113-qdio-doublecheck.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@de.ibm.com>

Signed-off-by: Sebastian Ott <sebott@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/cio/qdio.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio.c
+++ quilt-2.6/drivers/s390/cio/qdio.c
@@ -1408,8 +1408,7 @@ __tiqdio_inbound_processing(struct qdio_
 	if (q->hydra_gives_outbound_pcis) {
 		if (!q->siga_sync_done_on_thinints) {
 			SYNC_MEMORY_ALL;
-		} else if ((!q->siga_sync_done_on_outb_tis)&&
-			 (q->hydra_gives_outbound_pcis)) {
+		} else if (!q->siga_sync_done_on_outb_tis) {
 			SYNC_MEMORY_ALL_OUTB;
 		}
 	} else {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

