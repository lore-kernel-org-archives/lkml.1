Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZCPAp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZCPAp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZCPApK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:45:10 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:32813 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZCPApJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZErKzFBeSgHXTG4FeCNjYKKwqTTYOk30VAFwLC+/cMzwOByiHwgON4c3+56ZqbqxTt
         kuXWoywCja/E/lJenMpOjxJEs6dRmsPgl+92LfFhKwP3j9EJxXl8nGPWJ79DnDninMQY
         aKkqW/EEnJIrVmntZtql2bNftbY9hKB/2Wyyk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tracing/core: fix early free of cpumasks
Date: Mon, 16 Mar 2009 01:45:03 +0100
Message-Id: <1237164303-11476-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix weird bugs with tracing cpumasks

While ring-buffer allocation, the cpumasks are allocated too, including
the tracing cpumask and the per-cpu file mask handler.
But these cpumasks are freed accidentally just after.
Fix it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.1

