Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZLBKpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZLBKpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZLBKpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:45:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:45008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbZLBKpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:45:40 -0500
Date: Wed, 2 Dec 2009 10:45:07 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B135F50.8070302@ct.jp.nec.com>
References: <4B135F50.8070302@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, task_struct: Reduce size on TRACE_IRQFLAGS and 64bit
Message-ID: <tip-fa1452e808732ae10e8b1267fd75fc2d028d634b@git.kernel.org>
Git-Commit-ID: fa1452e808732ae10e8b1267fd75fc2d028d634b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa1452e808732ae10e8b1267fd75fc2d028d634b
Gitweb:     http://git.kernel.org/tip/fa1452e808732ae10e8b1267fd75fc2d028d634b
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Mon, 30 Nov 2009 14:59:44 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:24:37 +0100

locking, task_struct: Reduce size on TRACE_IRQFLAGS and 64bit

Reorder task_struct field for TRACE_IRQFLAGS to remove padding
on 64-bit.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4B135F50.8070302@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..49be8f7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1421,17 +1421,17 @@ struct task_struct {
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	unsigned int irq_events;
-	int hardirqs_enabled;
 	unsigned long hardirq_enable_ip;
-	unsigned int hardirq_enable_event;
 	unsigned long hardirq_disable_ip;
+	unsigned int hardirq_enable_event;
 	unsigned int hardirq_disable_event;
-	int softirqs_enabled;
+	int hardirqs_enabled;
+	int hardirq_context;
 	unsigned long softirq_disable_ip;
-	unsigned int softirq_disable_event;
 	unsigned long softirq_enable_ip;
+	unsigned int softirq_disable_event;
 	unsigned int softirq_enable_event;
-	int hardirq_context;
+	int softirqs_enabled;
 	int softirq_context;
 #endif
 #ifdef CONFIG_LOCKDEP
