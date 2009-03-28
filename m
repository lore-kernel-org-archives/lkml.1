Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZC1Tu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZC1Tu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZC1TuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:50:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:42678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZC1TuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:50:07 -0400
Message-Id: <20090328194929.679540505@chello.nl>
References: <20090328194359.426029037@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 28 Mar 2009 20:44:02 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/9] perf_counter: kerneltop: simplify data_head read
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

