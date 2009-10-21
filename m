Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZJUOhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZJUOhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZJUOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:36:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZJUOg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:36:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] tracing: updating *ppos instead of filp->f_pos
Date: Wed, 21 Oct 2009 16:36:38 +0200
Message-Id: <1256135801-1849-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of direct updating filp->f_pos we should update *ppos argument.
The filp->f_pos gets updated within the file_pos_write function called
from sys_write.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.6.2.5

