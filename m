Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYEKA0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYEKA0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 20:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYEKAZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 20:25:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:45499 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYEKAZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 20:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=XbFZIMjWPveT64f8Z6GIExBKZ1a5j4iM7+qkUYCTJcmvkavlGbSzYYRtHHEfLlUV3BahGWI9psnpNcXlVAHfNXHgX3d4pFbbrLa9q1pp6TTo8PtYziZCVil3Z8knIIVN5C2bz9IgB15l9Oeb/AaAo+v5qKEqOSuYof3lVssE2A8=
Date: Sun, 11 May 2008 05:55:33 +0530
From: Rabin Vincent <rabin@rab.in>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix defined-but-unused warning
Message-ID: <20080511002532.GA29515@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warning, which appears with !CONFIG_SMP:
kernel/sched.c:1216: warning: `init_hrtick' defined but not used

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 58fb8af..5aa8c5d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1161,6 +1161,7 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+#ifdef CONFIG_SMP
 static void hotplug_hrtick_disable(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -1216,6 +1217,7 @@ static void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
+#endif /* CONFIG_SMP */
 
 static void init_rq_hrtick(struct rq *rq)
 {
-- 
1.5.5.1

