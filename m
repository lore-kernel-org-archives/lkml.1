Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZEFE0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZEFE0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZEFEXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56433 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZEFEXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:35 -0400
Message-Id: <20090506042334.706348370@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/11] tracing: use proper export symbol for tracing api
Content-Disposition: inline; filename=0009-tracing-use-proper-export-symbol-for-tracing-api.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When adding the EXPORT_SYMBOL to some of the tracing API, I accidently
used EXPORT_SYMBOL instead of EXPORT_SYMBOL_GPL. This patch fixes
that mistake.

[ Impact: export the tracing code only for GPL modules ]

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 74df029..4164a34 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -887,21 +887,21 @@ trace_current_buffer_lock_reserve(int type, unsigned long len,
 	return trace_buffer_lock_reserve(&global_trace,
 					 type, len, flags, pc);
 }
-EXPORT_SYMBOL(trace_current_buffer_lock_reserve);
+EXPORT_SYMBOL_GPL(trace_current_buffer_lock_reserve);
 
 void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
 	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
 }
-EXPORT_SYMBOL(trace_current_buffer_unlock_commit);
+EXPORT_SYMBOL_GPL(trace_current_buffer_unlock_commit);
 
 void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
 	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
 }
-EXPORT_SYMBOL(trace_nowake_buffer_unlock_commit);
+EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
 
 void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
 {
-- 
1.6.2.4

-- 
