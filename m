Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZD2FAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZD2FAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZD2E7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZD2E7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:09 -0400
Message-Id: <20090429045908.394874083@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 00:48:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] ring-buffer: fix printk output
Content-Disposition: inline; filename=0005-ring-buffer-fix-printk-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The warning output in trace_recursive_lock uses %d for a long when
it should be %ld.

[ Impact: fix compile warning ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9692f10..f4cc590 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1491,7 +1491,7 @@ static int trace_recursive_lock(void)
 	/* Disable all tracing before we do anything else */
 	tracing_off_permanent();
 
-	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
+	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
 		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
 		    current->trace_recursion,
 		    hardirq_count() >> HARDIRQ_SHIFT,
-- 
1.6.2.1

-- 
