Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbYETNgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbYETNgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYETNg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:36:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39133 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765312AbYETNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:36:22 -0400
Date: Mon, 19 May 2008 20:24:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] block: blk_queue_bounce_limits can actually sleep
Message-ID: <20080519202409.6d1055be@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] block: blk_queue_bounce_limits can actually sleep

blk_queue_bounce_limit can call init_emergency_isa_pool, which
does sleeping allocations... document it as such by adding might_sleep() to the driver

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 block/blk-settings.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8dd8641..c420a67 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -148,6 +148,7 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 dma_addr)
 	q->bounce_pfn = b_pfn;
 #endif
 	if (dma) {
+		might_sleep();
 		init_emergency_isa_pool();
 		q->bounce_gfp = GFP_NOIO | GFP_DMA;
 		q->bounce_pfn = b_pfn;
-- 
1.5.4.5

