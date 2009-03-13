Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbZCMCmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbZCMCmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZCMCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541AbZCMCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:29 -0400
Message-Id: <20090313023826.906365262@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/16] tracing: fix stack tracer header
Content-Disposition: inline; filename=0010-tracing-fix-stack-tracer-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The stack tracer use to look like this:

 # cat /debug/tracing/stack_trace
         Depth  Size      Location    (57 entries)
         -----  ----      --------
  0)     5088      16   mempool_alloc_slab+0x16/0x18
  1)     5072     144   mempool_alloc+0x4d/0xfe
  2)     4928      16   scsi_sg_alloc+0x48/0x4a [scsi_mod]

Now it looks like this:

 # cat /debug/tracing/stack_trace

        Depth    Size      Location    (57 entries)
        -----    ----      --------
  0)     5088      16   mempool_alloc_slab+0x16/0x18
  1)     5072     144   mempool_alloc+0x4d/0xfe
  2)     4928      16   scsi_sg_alloc+0x48/0x4a [scsi_mod]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_stack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index d0871bc..4564fd9 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -251,9 +251,9 @@ static int t_show(struct seq_file *m, void *v)
 	int size;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(m, "        Depth   Size      Location"
+		seq_printf(m, "        Depth    Size      Location"
 			   "    (%d entries)\n"
-			   "        -----   ----      --------\n",
+			   "        -----    ----      --------\n",
 			   max_stack_trace.nr_entries);
 		return 0;
 	}
-- 
1.6.1.3

-- 
