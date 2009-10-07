Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZJGIWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZJGIWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbZJGIWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:22:07 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:54746 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZJGIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=t/syMLunl3alLRLzLav7zxwVI745ROTyj+CGdP1Aps19mdSTJK5dM+I+kSha0nb7Jh
         ai0x7cI+BSNl2ueMfJAn5BzAHb1cd5w+C8NP6OqBk9FvnMk7BHytOdLggP7RDHpwDZ8M
         iYBmqhLEtGE8Z9yvx62H5Uhr6yauLlUEYzqYU=
Date: Wed, 7 Oct 2009 16:19:46 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH V2] fix a warning on kernel/trace/trace_branch.c and
	trace_hw_branches.c
Message-ID: <20091007081946.GA25350@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warnings that caused the API change of trace_buffer_lock_reserve()
change files: kernel/trace/trace_hw_branch.c
	      kernel/trace/trace_branch.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/trace/trace_branch.c      |    2 +-
 kernel/trace/trace_hw_branches.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7a7a9fd..216e2dd 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 		goto out;
 
 	pc = preempt_count();
-	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
+	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		goto out;
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 23b6385..1cc17ca 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -180,7 +180,7 @@ void trace_hw_branch(u64 from, u64 to)
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
+	event = trace_buffer_lock_reserve(tr->buffer, TRACE_HW_BRANCHES,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
-- 
1.6.3.3

-- 
--------------------------------
http://zhwen.org - Open and Free
