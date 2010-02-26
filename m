Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935741Ab0BZJ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:29:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:39810 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935689Ab0BZJ3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:29:36 -0500
Date: Fri, 26 Feb 2010 09:29:07 GMT
From: tip-bot for Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, wenji.huang@oracle.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
       wenji.huang@oracle.com
In-Reply-To: <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Simplify memory recycle of trace_define_field
Message-ID: <tip-7b60997f73865b019e595720185c85285ca3df9a@git.kernel.org>
Git-Commit-ID: 7b60997f73865b019e595720185c85285ca3df9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:29:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b60997f73865b019e595720185c85285ca3df9a
Gitweb:     http://git.kernel.org/tip/7b60997f73865b019e595720185c85285ca3df9a
Author:     Wenji Huang <wenji.huang@oracle.com>
AuthorDate: Wed, 24 Feb 2010 15:40:26 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 25 Feb 2010 10:42:55 -0500

tracing: Simplify memory recycle of trace_define_field

Discard freeing field->type since it is not necessary.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c2a3077..3f972ad 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -60,10 +60,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	return 0;
 
 err:
-	if (field) {
+	if (field)
 		kfree(field->name);
-		kfree(field->type);
-	}
 	kfree(field);
 
 	return -ENOMEM;
