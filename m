Return-Path: <linux-kernel-owner+w=401wt.eu-S1765993AbYCGJZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765993AbYCGJZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763616AbYCGJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:40 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:63359 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763463AbYCGJNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/7] Add blk_q_mask
Message-Id: <20080307091325.04DE91B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:25 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:54.0736 (UTC) FILETIME=[96D59900:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Converts the queue bounce_pfn to a DMA mask suitable for the mask allocator

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/blkdev.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -814,6 +814,11 @@ static inline unsigned int block_size(st
 	return bdev->bd_block_size;
 }
 
+static inline u64 blk_q_mask(struct request_queue *q)
+{
+	return ~(-1LL << (PAGE_SHIFT + fls64(q->bounce_pfn)));
+}
+
 typedef struct {struct page *v;} Sector;
 
 unsigned char *read_dev_sector(struct block_device *, sector_t, Sector *);
