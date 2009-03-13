Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZCMFIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZCMFIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbZCMFF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:05:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbZCMFFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:05:23 -0400
Message-Id: <20090313050521.050453564@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 01:04:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] tracing: left align location header in stack_trace
Content-Disposition: inline; filename=0001-tracing-left-align-location-header-in-stack_trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molnar suggested, instead of:

        Depth    Size      Location    (27 entries)
        -----    ----      --------
  0)     2880      48   lock_timer_base+0x2b/0x4f
  1)     2832      80   __mod_timer+0x33/0xe0
  2)     2752      16   __ide_set_handler+0x63/0x65

To have it be:

        Depth    Size   Location    (27 entries)
        -----    ----   --------
  0)     2880      48   lock_timer_base+0x2b/0x4f
  1)     2832      80   __mod_timer+0x33/0xe0
  2)     2752      16   __ide_set_handler+0x63/0x65

Requested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_stack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 91ccbf3..c750f65 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -262,9 +262,9 @@ static int t_show(struct seq_file *m, void *v)
 	int size;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(m, "        Depth    Size      Location"
+		seq_printf(m, "        Depth    Size   Location"
 			   "    (%d entries)\n"
-			   "        -----    ----      --------\n",
+			   "        -----    ----   --------\n",
 			   max_stack_trace.nr_entries);
 
 		if (!stack_tracer_enabled && !max_stack_size)
-- 
1.6.1.3

-- 
