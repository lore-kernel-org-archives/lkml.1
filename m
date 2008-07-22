Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYGVA3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYGVA3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYGVA2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:28:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYGVA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=sXcuE3TTFryMuGLqXeE+GSqwkY8jd3hXZT4SqNjGJLxCVkb+/9YbfXvpI3R96YMmvj
         LP/9UCk5Oj+/geGBvJNax38uroxYaD/gbf+UBPG6JPpirtjX0wVFgxMQHOtKaGbgYvZY
         stYDEkVouRqEFDLGHluKY81EQlppAR+YWMy7o=
Message-ID: <488529B2.1080609@gmail.com>
Date: Mon, 21 Jul 2008 20:28:34 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: mingo@elte.hu, rml@tech9.net, a.p.zijlstra@chello.nl
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] sched: test below 0 on unsigned sysctl_sched_rt_period
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, you added the test in global_rt_runtime(), in commit
d0b27fa77854b149ad4af08b0fe47fe712a47ade
could you take a look at it and tell whether this test should
be replaced by something else?

The patch was only checkpatch tested
---
sysctl_sched_rt_period is unsigned so the test doesn't work.
state_filter is an unsigned long so the test didn't work

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 99e6d85..2030340 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -832,9 +832,6 @@ static inline u64 global_rt_period(void)
 
 static inline u64 global_rt_runtime(void)
 {
-	if (sysctl_sched_rt_period < 0)
-		return RUNTIME_INF;
-
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
@@ -5707,7 +5704,7 @@ void show_state_filter(unsigned long state_filter)
 	/*
 	 * Only show locks if all tasks are dumped:
 	 */
-	if (state_filter == -1)
+	if (state_filter == -1ul)
 		debug_show_all_locks();
 }
 
