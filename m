Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZEHEeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZEHEeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZEHEde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:33:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63071 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZEHEdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:33:31 -0400
Message-Id: <20090508043331.726786617@goodmis.org>
References: <20090508043250.372421144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 00:32:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] ring-buffer: change WARN_ON from checking preempt_count to preemptible
Content-Disposition: inline; filename=0004-ring-buffer-change-WARN_ON-from-checking-preempt_co.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's a WARN_ON in the ring buffer code that makes sure preemption
is disabled. It checks "!preempt_count()". But when CONFIG_PREEMPT is not
enabled, preempt_count() is always zero, and this will trigger the warning.

[ Impact: prevent false warning on non preemptible kernels ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ae5ccf..3611706 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1688,7 +1688,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 * committed yet. Thus we can assume that preemption
 	 * is still disabled.
 	 */
-	RB_WARN_ON(buffer, !preempt_count());
+	RB_WARN_ON(buffer, preemptible());
 
 	cpu = smp_processor_id();
 	cpu_buffer = buffer->buffers[cpu];
-- 
1.6.2.4

-- 
