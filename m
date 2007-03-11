Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXCJXiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXCJXiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 18:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXCJXix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 18:38:53 -0500
Received: from mail27.syd.optusnet.com.au ([211.29.133.168]:45230 "EHLO
	mail27.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbXCJXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 18:38:53 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Nicolas.Mailhot@laposte.net
Subject: sched rsdl fix for 0.28
Date: Sun, 11 Mar 2007 11:07:00 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111107.00704.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a big bugfix for sched rsdl 0.28

---
 kernel/sched.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.21-rc3-mm2/kernel/sched.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/sched.c	2007-03-11 11:04:38.000000000 +1100
+++ linux-2.6.21-rc3-mm2/kernel/sched.c	2007-03-11 11:05:46.000000000 +1100
@@ -3328,6 +3328,13 @@ static inline void rotate_runqueue_prior
 	int new_prio_level, remaining_quota = rq_quota(rq, rq->prio_level);
 	struct prio_array *array = rq->active;
 
+	/*
+	 * Make sure we don't have tasks still on the active array that
+	 * haven't run due to not preempting (merging or smp balancing)
+	 */
+	if (find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO) <
+		rq->prio_level)
+			return;
 	if (rq->prio_level > MAX_PRIO - 2) {
 		/* Major rotation required */
 		struct prio_array *new_queue = rq->expired;

-- 
-ck
