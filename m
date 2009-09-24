Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZIXO4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZIXO4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZIXO4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:56:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42963 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbZIXO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:56:45 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: try to ensure that scheduling bugs reach the user
Date: Thu, 24 Sep 2009 17:56:18 +0300
Message-Id: <1253804178-7324-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 24 Sep 2009 14:56:22.0104 (UTC) FILETIME=[2E2A8D80:01CA3D27]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help debugging on some embedded devices where bugs and oopses
are recorded by mtdoops.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2f76e06..19fe1ef 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5279,6 +5279,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	bust_spinlocks(1);
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
@@ -5291,6 +5292,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		show_regs(regs);
 	else
 		dump_stack();
+	bust_spinlocks(0);
 }
 
 /*
-- 
1.5.4.3

