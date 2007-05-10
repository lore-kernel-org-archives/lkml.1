Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbXEJN6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbXEJN6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758506AbXEJN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:56:30 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:49968 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760038AbXEJN4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:56:21 -0400
Message-Id: <20070510135644.393485092@de.ibm.com>
References: <20070510135152.178104939@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 15:51:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ursula Braun <braunu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/15] qdio: re-add lost perf_stats.tl_runs change in qdio_handle_pci
Content-Disposition: inline; filename=007-qdio-stats.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ursula Braun <braunu@de.ibm.com>

Statement has been inadvertently lost with commit
00c0c6466c66bdf05f2a3dcf59e6895179ea8b76.

Signed-off-by: Ursula Braun <braunu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/drivers/s390/cio/qdio.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio.c
+++ quilt-2.6/drivers/s390/cio/qdio.c
@@ -1983,6 +1983,7 @@ qdio_handle_pci(struct qdio_irq *irq_ptr
 		if (q->is_input_q&QDIO_FLAG_NO_INPUT_INTERRUPT_CONTEXT)
 			qdio_mark_q(q);
 		else {
+			qdio_perf_stat_dec(&perf_stats.tl_runs);
 			__qdio_inbound_processing(q);
 		}
 	}

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

