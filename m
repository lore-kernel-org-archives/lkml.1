Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbZFLNaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbZFLNaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759169AbZFLN0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:01 -0400
Received: from ozlabs.org ([203.10.76.45]:54990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763091AbZFLNZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:58 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 11/17] cpumask: don't define set_cpus_allowed() if CONFIG_CPUMASK_OFFSTACK=y
Message-Id: <20090612132600.77582DDD1C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You're not supposed to pass cpumasks on the stack in that case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/sched.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1682,10 +1682,13 @@ static inline int set_cpus_allowed_ptr(s
 	return 0;
 }
 #endif
+
+#ifndef CONFIG_CPUMASK_OFFSTACK
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
 	return set_cpus_allowed_ptr(p, &new_mask);
 }
+#endif
 
 /*
  * Architectures can set this to 1 if they have specified

