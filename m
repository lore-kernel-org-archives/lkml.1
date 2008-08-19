Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYHSJWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYHSJWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYHSJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:21:37 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:44361
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753543AbYHSJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:21:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT 2/2] ftrace: fix elevated preempt_count in wakeup-tracer
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: ghaskins@novell.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Date: Tue, 19 Aug 2008 05:19:23 -0400
Message-ID: <20080819091923.21725.41087.stgit@dev.haskins.net>
In-Reply-To: <20080819091817.21725.81831.stgit@dev.haskins.net>
References: <20080819091817.21725.81831.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Steve Rostedt to fix an observed "+1" in the preempt-count

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/trace/trace_sched_wakeup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index c3a15bd..ae523fd 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -70,7 +70,9 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	if (task_cpu(wakeup_task) != cpu)
 		goto unlock;
 
+	preempt_enable_no_resched_notrace();
 	trace_function(tr, data, ip, parent_ip, flags);
+	preempt_disable_notrace();
 
  unlock:
 	__raw_spin_unlock(&wakeup_lock);

