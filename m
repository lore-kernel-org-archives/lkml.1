Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZJGGlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZJGGlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZJGGlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:41:39 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:46174 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZJGGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=RnZN9YmrSB1Pw7N61frV+bpDPfHxN97V4rJPsc/JBv+Jc2NyckERXHqIvm94Mm5rRx
         5NxInrq89cF9r+K+fp+C8QjOXrzYNMQ4VfAQvskHrn2/jeg3KEmynnTVpeefzqorwiBo
         OlXWk5MHbxJd+GVJrhh6bXgn9DyHr6AVb+EQc=
Date: Wed, 7 Oct 2009 14:39:21 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] fix a warning on kernel/trace/trace_branch.c
Message-ID: <20091007063921.GA19756@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix this warning:

kernel/trace/trace_branch.c: In function ‘probe_likely_condition’:
kernel/trace/trace_branch.c:58: warning: passing argument 1 of ‘
trace_buffer_lock_reserve’ from incompatible pointer type

The "tr" should be "(struct buffer *)tr" or "tr->buffer" here!!!

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/trace/trace_branch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.3.3

-- 
--------------------------------
http://zhwen.org - Open and Free
