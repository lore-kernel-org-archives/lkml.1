Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZBTTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZBTTvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZBTTu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:50:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZBTTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:50:23 -0500
Message-Id: <20090220195022.398043630@goodmis.org>
References: <20090220193239.561624242@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 14:32:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] ftrace: break out modify loop immediately on detection of error
Content-Disposition: inline; filename=0004-ftrace-break-out-modify-loop-immediately-on-detecti.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: added precaution on failure detection

Break out of the modifying loop as soon as a failure is detected.
This is just an added precaution found by code review and was not
found by any bug chasing.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 72316d9..11ad796 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -561,8 +561,11 @@ static void ftrace_replace_code(int enable)
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
 					ftrace_free_rec(rec);
-				} else
+				} else {
 					ftrace_bug(failed, rec->ip);
+					/* Stop processing */
+					return;
+				}
 			}
 		}
 	}
-- 
1.5.6.5

-- 
