Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbZEGDOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbZEGDOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZEGDOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031433.787764307@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] ring-buffer: check for failed allocation in ring buffer benchmark
Content-Disposition: inline; filename=0002-ring-buffer-check-for-failed-allocation-in-ring-buf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The result of the allocation of the ring buffer read page in the
ring buffer bench mark does not check the return to see if a page
was actually allocated. This patch fixes that.

[ Impact: avoid NULL dereference ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 747244a..dcd75e9 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -84,6 +84,9 @@ static enum event_status read_page(int cpu)
 	int i;
 
 	bpage = ring_buffer_alloc_read_page(buffer);
+	if (!bpage)
+		return EVENT_DROPPED;
+
 	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
 	if (ret >= 0) {
 		rpage = bpage;
-- 
1.6.2.4

-- 
