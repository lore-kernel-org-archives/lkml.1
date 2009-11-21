Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZKUNgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZKUNgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZKUNg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:36:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:36219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZKUNg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:36:27 -0500
Date: Sat, 21 Nov 2009 13:34:45 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E300.7020601@cn.fujitsu.com>
References: <4A52E300.7020601@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: NIL-terminate user input filter
Message-ID: <tip-011ed56853e07e30653d6f1bfddc56b396218664@git.kernel.org>
Git-Commit-ID: 011ed56853e07e30653d6f1bfddc56b396218664
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  011ed56853e07e30653d6f1bfddc56b396218664
Gitweb:     http://git.kernel.org/tip/011ed56853e07e30653d6f1bfddc56b396218664
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:54:08 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:42 +0200

ksym_tracer: NIL-terminate user input filter

Make sure the user input string is NULL-terminated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E300.7020601@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 72fcb46..8cbed5a 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -264,11 +264,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	unsigned long ksym_addr = 0;
 	int ret, op, changed = 0;
 
-	/* Ignore echo "" > ksym_trace_filter */
-	if (count == 0)
-		return 0;
-
-	input_string = kzalloc(count, GFP_KERNEL);
+	input_string = kzalloc(count + 1, GFP_KERNEL);
 	if (!input_string)
 		return -ENOMEM;
 
@@ -276,6 +272,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		kfree(input_string);
 		return -EFAULT;
 	}
+	input_string[count] = '\0';
 
 	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
 	if (ret < 0) {
