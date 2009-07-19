Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbZGSWg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbZGSWg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZGSWgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:36:55 -0400
Received: from verein.lst.de ([213.95.11.210]:45446 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZGSWgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:36:54 -0400
Date: Mon, 20 Jul 2009 00:36:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix blk_queue_alignment_offset
Message-ID: <20090719223649.GA32719@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to mask out bits inside the logical block, not outside of it,
otherwise we'll always get a 0 alignment_offset.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2009-07-19 23:53:13.674148645 +0200
+++ linux-2.6/block/blk-settings.c	2009-07-20 00:33:06.384900956 +0200
@@ -371,7 +371,7 @@ EXPORT_SYMBOL(blk_queue_physical_block_s
 void blk_queue_alignment_offset(struct request_queue *q, unsigned int offset)
 {
 	q->limits.alignment_offset =
-		offset & (q->limits.physical_block_size - 1);
+		offset & ~(q->limits.physical_block_size - 1);
 	q->limits.misaligned = 0;
 }
 EXPORT_SYMBOL(blk_queue_alignment_offset);
