Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZBTQlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZBTQlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZBTQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:40:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZBTQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:40:48 -0500
Message-Id: <20090220164046.287797665@goodmis.org>
References: <20090220163846.709775139@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 11:38:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: break out modify loop immediately on detection of error
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
 kernel/trace/ftrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cf54ba4..3b3e0e0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -561,11 +561,15 @@ static void ftrace_replace_code(int enable)
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
 					ftrace_free_rec(rec);
-				} else
+				} else {
 					ftrace_bug(failed, rec->ip);
+					goto out;
+				}
 			}
 		}
 	}
+ out:
+	return;
 }
 
 static int
-- 
1.5.6.5

-- 
