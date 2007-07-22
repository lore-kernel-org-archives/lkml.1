Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXGVRdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXGVRdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbXGVRc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:32:57 -0400
Received: from homer.mvista.com ([63.81.120.158]:50815 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbXGVRc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:32:57 -0400
Subject: [PATCH -rt] drop spurious rcu unlock
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain
Date: Sun, 22 Jul 2007 10:22:37 -0700
Message-Id: <1185124958.2573.13.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Strange rcu_read_unlock() which causes a imbalance, and boot hang.. I
didn't notice a reason for it, and removing it allows my system to make
progress.

This should go into the preempt-realtime-sched.patch

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

Index: linux-2.6.22.1/kernel/sched.c
===================================================================
--- linux-2.6.22.1.orig/kernel/sched.c	2007-07-22 16:47:37.000000000 +0000
+++ linux-2.6.22.1/kernel/sched.c	2007-07-22 16:16:48.000000000 +0000
@@ -4900,7 +4900,6 @@ asmlinkage long sys_sched_yield(void)
 	 * no need to preempt or enable interrupts:
 	 */
 	spin_unlock_no_resched(&rq->lock);
-	rcu_read_unlock();
 
 	__schedule();
 


