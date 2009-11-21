Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZKUNgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZKUNgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZKUNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:36:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:36245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZKUNgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:36:42 -0500
Date: Sat, 21 Nov 2009 13:34:57 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E314.7070004@cn.fujitsu.com>
References: <4A52E314.7070004@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Report error when failed to re-register hbp
Message-ID: <tip-0d109c8f70eab8b9f693bd5caea23012394e4876@git.kernel.org>
Git-Commit-ID: 0d109c8f70eab8b9f693bd5caea23012394e4876
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d109c8f70eab8b9f693bd5caea23012394e4876
Gitweb:     http://git.kernel.org/tip/0d109c8f70eab8b9f693bd5caea23012394e4876
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:54:28 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:43 +0200

ksym_tracer: Report error when failed to re-register hbp

When access type is changed, the hw break point will be
unregistered and then be registered again with new access
type. But the registration may fail, in this case, -errno
should be returned.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E314.7070004@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 8cbed5a..891e3b8 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -302,13 +302,13 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 				ret = count;
 				goto unlock_ret_path;
 			}
-		}
+		} else
+			ret = count;
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry->ksym_hbp);
 		kfree(entry);
-		ret = count;
 		goto err_ret;
 	} else {
 		/* Check for malformed request: (4) */
