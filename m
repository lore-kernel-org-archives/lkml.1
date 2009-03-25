Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbZCYLi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbZCYLi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZCYLip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:39767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbZCYLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:44 -0400
Message-Id: <20090325113316.921433024@chello.nl>
References: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/6] perf_counter: sanity check on the output API
Content-Disposition: inline; filename=perf_counter-output-validate.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we never write more than we said we would.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1422,6 +1422,7 @@ struct perf_output_handle {
 	struct perf_counter *counter;
 	struct perf_mmap_data *data;
 	unsigned int offset;
+	unsigned int head;
 	int wakeup;
 };
 
@@ -1447,6 +1448,7 @@ static int perf_output_begin(struct perf
 	handle->counter = counter;
 	handle->data = data;
 	handle->offset = offset;
+	handle->head = head;
 	handle->wakeup = (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
 
 	return 0;
@@ -1478,6 +1480,8 @@ static void perf_output_copy(struct perf
 	} while (len);
 
 	handle->offset = offset;
+
+	WARN_ON(handle->offset > handle->head);
 }
 
 #define perf_output_put(handle, x) \

-- 

