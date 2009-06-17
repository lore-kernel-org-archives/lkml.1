Return-Path: <linux-kernel-owner+w=401wt.eu-S1763572AbZFQX0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763572AbZFQX0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZFQX03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZFQX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:28 -0400
Message-Id: <20090617232629.637459226@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:25:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/7] ring-buffer: use BUF_PAGE_HDR_SIZE in calculating index
Content-Disposition: inline; filename=0001-ring-buffer-use-BUF_PAGE_HDR_SIZE-in-calculating-ind.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The index of the event is found by masking PAGE_MASK to it and
subtracting the header size. Currently the header size is calculate
by PAGE_SIZE - BUF_PAGE_SIZE, when we already have a macro
BUF_PAGE_HDR_SIZE to define it.

If we want to change BUF_PAGE_SIZE to something less than filling
the rest of the page (this is done for debugging), then we break
the algorithm to find the index.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ed35599..6b17a11 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1013,7 +1013,7 @@ rb_event_index(struct ring_buffer_event *event)
 {
 	unsigned long addr = (unsigned long)event;
 
-	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
+	return (addr & ~PAGE_MASK) - BUF_PAGE_HDR_SIZE;
 }
 
 static inline int
-- 
1.6.3.1

-- 
