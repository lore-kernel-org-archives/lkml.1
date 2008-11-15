Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYKOAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYKOAqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYKOAqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:46:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYKOAqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:46:08 -0500
Message-Id: <20081115004604.201580005@goodmis.org>
References: <20081115004537.616030629@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 19:45:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: remove condition from ftrace_record_ip
Content-Disposition: inline; filename=0001-ftrace-remove-condition-from-ftrace_record_ip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: let module functions be recorded when dyn ftrace not enabled

When dynamic ftrace had a daemon and a hash to record the locations
of mcount callers at run time, the recording needed to stop when
ftrace was disabled. But now that the recording is done at compile time
and the ftrace_record_ip is only called at boot up and when a module
is loaded, we no longer need to check if ftrace_enabled is set.
In fact, this breaks module load if it is not set because we skip
over module functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index beb21a5..66aa19e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -335,7 +335,7 @@ ftrace_record_ip(unsigned long ip)
 {
 	struct dyn_ftrace *rec;
 
-	if (!ftrace_enabled || ftrace_disabled)
+	if (ftrace_disabled)
 		return NULL;
 
 	rec = ftrace_alloc_dyn_node(ip);
-- 
1.5.6.5

-- 
