Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZELHMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZELHMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbZELHMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:12:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759101AbZELHMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:12:15 -0400
Date: Tue, 12 May 2009 03:11:09 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, akpm@linux-foundation.org,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090512071156.5664.17626.sendpatchset@localhost.localdomain>
In-Reply-To: <20090512071148.5664.91161.sendpatchset@localhost.localdomain>
References: <20090512071148.5664.91161.sendpatchset@localhost.localdomain>
Subject: [PATCH] trace: fix a wrong usage of simple_read_from_buffer()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The last argument of simple_read_from_buffer() is the amount of the
available bytes in the buffer, not the size of the buffer.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a884c09..3a0bc70 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2125,7 +2125,7 @@ tracing_cpumask_read(struct file *filp, char __user *ubuf,
 		goto out_err;
 	}
 	len += sprintf(mask_str + len, "\n");
-	count = simple_read_from_buffer(ubuf, count, ppos, mask_str, NR_CPUS+1);
+	count = simple_read_from_buffer(ubuf, count, ppos, mask_str, len);
 
 out_err:
 	mutex_unlock(&tracing_cpumask_update_lock);
