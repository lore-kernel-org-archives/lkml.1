Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYDDPnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYDDPnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYDDPnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:43:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41871 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbYDDPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:43:07 -0400
Subject: [PATCH -rt] shorten softirq kernel thread names
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>, Clark Williams <williams@redhat.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 17:42:53 +0200
Message-Id: <1207323773.15579.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: -rt: shorten softirq kernel thread names

Shorten the softirq kernel thread names because they often overflow
the limited comm length.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/softirq.c b/kernel/softirq.c
index a9e1b08..385ed5b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -923,7 +923,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 		for (i = 0; i < MAX_SOFTIRQ; i++) {
 			p = kthread_create(ksoftirqd,
 					   &per_cpu(ksoftirqd, hotcpu)[i],
-					   "softirq-%s/%d", softirq_names[i],
+					   "sirq-%s/%d", softirq_names[i],
 					   hotcpu);
 			if (IS_ERR(p)) {
 				printk("ksoftirqd %d for %i failed\n", i,


