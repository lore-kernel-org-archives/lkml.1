Return-Path: <linux-kernel-owner+w=401wt.eu-S966346AbXG3Crj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966346AbXG3Crj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936748AbXG3CrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41605 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754109AbXG3CrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:22 -0400
Message-Id: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:35 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=add-warn-on-rcu-read-unlock-imbalance.patch
Subject: [PATCH -rt 1/9] preempt rcu: check for underflow
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple WARN_ON to catch any underflow in rcu_read_lock_nesting.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/rcupreempt.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.22/kernel/rcupreempt.c
===================================================================
--- linux-2.6.22.orig/kernel/rcupreempt.c
+++ linux-2.6.22/kernel/rcupreempt.c
@@ -157,6 +157,12 @@ void __rcu_read_unlock(void)
 	}
 
 	local_irq_restore(oldirq);
+
+	/*
+	 * If our rcu_read_lock_nesting went negative, likely
+	 * something is wrong..
+	 */
+	WARN_ON(current->rcu_read_lock_nesting < 0);
 }
 
 static void __rcu_advance_callbacks(void)

-- 
