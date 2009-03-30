Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZC3RNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZC3RNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZC3RL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:49746 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZC3RLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:24 -0400
Message-Id: <20090330171023.327144324@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/15] perf_counter: kerneltop: simplify data_head read
Content-Disposition: inline; filename=kerneltop-new-mmap.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the kernel side changed, match up again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -1125,22 +1125,10 @@ struct mmap_data {
 static unsigned int mmap_read_head(struct mmap_data *md)
 {
 	struct perf_counter_mmap_page *pc = md->base;
-	unsigned int seq, head;
-
-repeat:
-	rmb();
-	seq = pc->lock;
-
-	if (unlikely(seq & 1)) {
-		cpu_relax();
-		goto repeat;
-	}
+	int head;
 
 	head = pc->data_head;
-
 	rmb();
-	if (pc->lock != seq)
-		goto repeat;
 
 	return head;
 }

-- 

