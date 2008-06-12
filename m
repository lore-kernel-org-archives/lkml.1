Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYFLJ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYFLJ2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYFLJ1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:27:33 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:53205 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755700AbYFLJ13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:27:29 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/1] tracer: fix printout
Date: Thu, 12 Jun 2008 11:27:03 +0200
Message-Id: <1213262823-31560-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not print loglevel before "entries of %ld bytes". Move it to the previous
pr_info.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a864dd2..d70c567 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3084,9 +3084,8 @@ __init static int tracer_alloc_buffers(void)
 	}
 	max_tr.entries = global_trace.entries;
 
-	pr_info("tracer: %d pages allocated for %ld",
-		pages, trace_nr_entries);
-	pr_info(" entries of %ld bytes\n", (long)TRACE_ENTRY_SIZE);
+	pr_info("tracer: %d pages allocated for %ld entries of %ld bytes\n",
+		pages, trace_nr_entries, (long)TRACE_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", global_trace.entries);
 
 	tracer_init_debugfs();
-- 
1.5.5.1

