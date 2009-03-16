Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZCPIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZCPIV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbZCPIUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:20:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:44701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490AbZCPIUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:20:11 -0400
Date: Mon, 16 Mar 2009 08:19:33 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237164303-11476-1-git-send-email-fweisbec@gmail.com>
References: <1237164303-11476-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/core: fix early free of cpumasks
Message-ID: <tip-2fc1dfbe17e7705c55b7a99da995fa565e26f151@git.kernel.org>
Git-Commit-ID: 2fc1dfbe17e7705c55b7a99da995fa565e26f151
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:19:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fc1dfbe17e7705c55b7a99da995fa565e26f151
Gitweb:     http://git.kernel.org/tip/2fc1dfbe17e7705c55b7a99da995fa565e26f151
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 16 Mar 2009 01:45:03 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:18 +0100

tracing/core: fix early free of cpumasks

Impact: fix crashes when tracing cpumasks

While ring-buffer allocation, the cpumasks are allocated too,
including the tracing cpumask and the per-cpu file mask handler.
But these cpumasks are freed accidentally just after.
Fix it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237164303-11476-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c0cf946..ae32d3b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4125,7 +4125,8 @@ __init static int tracer_alloc_buffers(void)
 				       &trace_panic_notifier);
 
 	register_die_notifier(&trace_die_notifier);
-	ret = 0;
+
+	return 0;
 
 out_free_cpumask:
 	free_cpumask_var(tracing_reader_cpumask);
