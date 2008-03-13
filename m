Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYCMQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYCMQmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYCMQmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:42:05 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41382 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYCMQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:42:03 -0400
Message-ID: <47D95957.80507@tiscali.nl>
Date: Thu, 13 Mar 2008 17:41:59 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, rml@tech9.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/sched.c: remove double unlikely
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine two unlikely's

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 1cb53fb..532a7f4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3875,7 +3875,7 @@ need_resched_nonpreemptible:
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
-				unlikely(signal_pending(prev)))) {
+				signal_pending(prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
 			deactivate_task(rq, prev, 1);
