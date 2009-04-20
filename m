Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZDTRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZDTRlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZDTRkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:40:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZDTRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:40:19 -0400
Message-Id: <20090420174018.377934858@goodmis.org>
References: <20090420173819.957332585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:38:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] tracing: remove recursive test from ring_buffer_event_discard
Content-Disposition: inline; filename=0004-tracing-remove-recursive-test-from-ring_buffer_even.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_event_discard is not tied to ring_buffer_lock_reserve.
It can be called inside or outside the reserve/commit. Even if it
is called inside the reserve/commit the commit part must also be called.

Only ring_buffer_discard_commit can be used as a replacement for
ring_buffer_unlock_commit.

This patch removes the trace_recursive_unlock from ring_buffer_event_discard
since it would be the wrong place to do so.

[Impact: prevent breakage in trace recursive testing ]

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index aa40ae9..a699767 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1667,7 +1667,6 @@ static inline void rb_event_discard(struct ring_buffer_event *event)
 void ring_buffer_event_discard(struct ring_buffer_event *event)
 {
 	rb_event_discard(event);
-	trace_recursive_unlock();
 }
 EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
 
-- 
1.6.2.1

-- 
