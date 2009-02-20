Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZBTBRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZBTBRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZBTBP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:15:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZBTBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:15:22 -0500
Message-Id: <20090220011521.489432611@goodmis.org>
References: <20090220011316.379904625@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Feb 2009 20:13:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/6] ftrace: break out modify loop immediately on detection of error
Content-Disposition: inline; filename=0006-ftrace-break-out-modify-loop-immediately-on-detecti.patch
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
 kernel/trace/ftrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index de3bd93..f9fe29d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -557,10 +557,14 @@ static void ftrace_replace_code(int enable)
 			if ((system_state == SYSTEM_BOOTING) ||
 			    !core_kernel_text(rec->ip)) {
 				ftrace_free_rec(rec);
-			} else
+			} else {
 				ftrace_bug(failed, rec->ip);
+				goto out;
+			}
 		}
 	} while_for_each_ftrace_rec();
+ out:
+	return;
 }
 
 static int
-- 
1.5.6.5

-- 
