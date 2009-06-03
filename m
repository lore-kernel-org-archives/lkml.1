Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZFCIC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZFCIC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZFCICD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:02:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:21202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZFCICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WJv2nsQqWd4mQk8HWY88GtrY8J2yYbvvdf1O4tDqz7gnrEtUZsP+hZyg5/B0TDmdbG
         Nkhn7oT4vWrrqErp2xLAh2hBlIwJTxi6eVSDzpIWfPZH2cC4GNo99pBoPtxtrzol1iCA
         VrisBvL4C3JF/9rx+rUo5CRz/9ZTcmfugR+o8=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracing/trace_stack: fix the number of entries in the header
Date: Wed,  3 Jun 2009 16:01:28 +0800
Message-Id: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last entry in the stack_dump_trace is ULONG_MAX, which is not
a valid entry, but max_stack_trace.nr_entries has accounted for it.
So when printing the header, we should decrease it by one.
Before fix, print as following, for example:

	Depth    Size   Location    (53 entries)	<--- should be 52
	-----    ----   --------
  0)     3264     108   update_wall_time+0x4d5/0x9a0
  ...
 51)       80      80   syscall_call+0x7/0xb
 ^^^
   it's correct.

Signed-off-by: walimis <walimisdev@gmail.com>
---
 kernel/trace/trace_stack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 1796f00..2d7aebd 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -265,7 +265,7 @@ static int t_show(struct seq_file *m, void *v)
 		seq_printf(m, "        Depth    Size   Location"
 			   "    (%d entries)\n"
 			   "        -----    ----   --------\n",
-			   max_stack_trace.nr_entries);
+			   max_stack_trace.nr_entries - 1);
 
 		if (!stack_tracer_enabled && !max_stack_size)
 			print_disabled(m);
-- 
1.6.0.3

