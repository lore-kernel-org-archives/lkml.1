Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbZJMOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbZJMOae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbZJMOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:30:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:59051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760007AbZJMOad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:30:33 -0400
Message-ID: <4AD48EC4.8040701@kernel.org>
Date: Tue, 13 Oct 2009 23:29:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] this_cpu: Use this_cpu_xx in trace_functions_graph.c
References: <20091013144812.bdb376aa.sfr@canb.auug.org.au>
In-Reply-To: <20091013144812.bdb376aa.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 14:29:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_cpu_disabled usage in trace_functions_graph.c were left out
during this_cpu_xx conversion in commit 9288f99a causing compile
failure.  Convert them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
This patch has been committed to percpu#for-next.  Thanks.

 kernel/trace/trace_functions_graph.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..90a6daa 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -176,7 +176,7 @@ static int __trace_graph_entry(struct trace_array *tr,
 	struct ring_buffer *buffer = tr->buffer;
 	struct ftrace_graph_ent_entry *entry;

-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
 		return 0;

 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_ENT,
@@ -240,7 +240,7 @@ static void __trace_graph_return(struct trace_array *tr,
 	struct ring_buffer *buffer = tr->buffer;
 	struct ftrace_graph_ret_entry *entry;

-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
 		return;

 	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
-- 
1.6.4.2

