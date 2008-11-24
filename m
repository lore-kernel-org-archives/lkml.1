Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYKXMFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYKXMFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYKXMFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:05:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:54070 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYKXMFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:05:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZJO9f3hnA+5+cBlLfVvAGY8h0/bQc89Gbi8ULxEYxZMQVsEAxjzuX4Pw2BgeED8ndc
         YCtil25x0m3EXkM+YRf8pg1DuI6m8Je3xMpz0XiVMMLCYbNgCb9SsS2R8J8JdVXX2wgB
         0wPdicYqPK1o4JWzd7FwKusvQ9woG9YCJyXD4=
Message-ID: <492A986D.8030809@gmail.com>
Date: Mon, 24 Nov 2008 20:05:01 +0800
From: jia zhang <jia.zhang2008@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: inaccurate calculation for normal priority
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here we should check to see if the task is a rt ktherad or normal rt process, although right now MAX_USER_RT_PRIO is equal MAX_RT_PRIO.

Signed-off-by: jia zhang <jia.zhang2008@gmail.com>
---
 b/kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9b1e793..b3038e4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1711,7 +1711,8 @@ static inline int normal_prio(struct task_struct *p)
 	int prio;
 
 	if (task_has_rt_policy(p))
-		prio = MAX_RT_PRIO-1 - p->rt_priority;
+		prio = p->mm ? MAX_USER_RT_PRIO-1 - p->rt_priority :
+			MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio = __normal_prio(p);
 	return prio;

