Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYEMVok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYEMVok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbYEMVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:44:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:64322 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396AbYEMVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=XFYvoEwOlTc1AYnJD9XUKPoWJcJRZQbp0tJk9ixSJ4Efzz0ZfEMc0mTJPnVnkILAv1tslyD/mX7lJRFCMySjlc+KOBdLQ12aROczQA/RFz7gFTJmH63qDAPZKrWOxDieO7902caZD2W1pG8C7fH2b1AFR5ODyhlN/MRqea1swNY=
Message-ID: <482A0BAB.7050505@gmail.com>
Date: Tue, 13 May 2008 23:44:11 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, rml@tech9.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: unite unlikely pairs in rt_policy() and schedule_debug()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes obfuscation and may improve assembly

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 8841a91..86a0cd3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -136,7 +136,7 @@ static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
 
 static inline int rt_policy(int policy)
 {
-	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
+	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
 		return 1;
 	return 0;
 }
@@ -4430,7 +4430,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	 * schedule() atomically, we ignore that path for now.
 	 * Otherwise, whine if we are scheduling when we should not be.
 	 */
-	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
+	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
 		__schedule_bug(prev);
 
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
