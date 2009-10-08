Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZJHBUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZJHBUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZJHBUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:20:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZJHBUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:20:04 -0400
Message-Id: <20091008011806.417870785@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 21:17:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org
Subject: [PATCH 3/3] [PATCH 3/3] ftrace: check for failure for all conversions
References: <20091008011711.701283454@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-check-for-failure-for-all-conversions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Due to legacy code from back when the dynamic tracer used a daemon,
only core kernel code was checking for failures. This is no longer
the case. We must check for failures any time we perform text modifications.

Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c701476..f136fe5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1074,14 +1074,9 @@ static void ftrace_replace_code(int enable)
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
 			rec->flags |= FTRACE_FL_FAILED;
-			if ((system_state == SYSTEM_BOOTING) ||
-			    !core_kernel_text(rec->ip)) {
-				ftrace_free_rec(rec);
-				} else {
-				ftrace_bug(failed, rec->ip);
-					/* Stop processing */
-					return;
-				}
+			ftrace_bug(failed, rec->ip);
+			/* Stop processing */
+			return;
 		}
 	} while_for_each_ftrace_rec();
 }
-- 
1.6.3.3


