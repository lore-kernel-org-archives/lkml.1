Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZJWXgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZJWXgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZJWXgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:36:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZJWXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:36:42 -0400
Message-Id: <20091023233646.399670810@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Oct 2009 19:36:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] [PATCH 1/4] tracing: updating *ppos instead of filp->f_pos
References: <20091023233615.661789185@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-updating-ppos-instead-of-filp-f_pos.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Instead of direct updating filp->f_pos we should update *ppos argument.
The filp->f_pos gets updated within the file_pos_write function called
from sys_write.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1256135801-1849-2-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 kernel/trace/trace.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b10c0d9..1ed514f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -751,7 +751,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&ftrace_profile_lock);
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 026e715..9d3067a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2440,7 +2440,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			return ret;
 	}
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
@@ -2582,7 +2582,7 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 	}
 	mutex_unlock(&trace_types_lock);
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	return cnt;
 }
@@ -2764,7 +2764,7 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	if (err)
 		return err;
 
-	filp->f_pos += ret;
+	*ppos += ret;
 
 	return ret;
 }
@@ -3299,7 +3299,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 		}
 	}
 
-	filp->f_pos += cnt;
+	*ppos += cnt;
 
 	/* If check pages failed, return ENOMEM */
 	if (tracing_disabled)
-- 
1.6.3.3


