Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZK3GA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZK3GA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZK3GA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:00:26 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:64318 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZK3GAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:00:25 -0500
Message-ID: <4B135F50.8070302@ct.jp.nec.com>
Date: Mon, 30 Nov 2009 14:59:44 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] task_struct: reduce size on TRACE_IRQFLAGS and 64bit
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Reorder task_struct field for TRACE_IRQFLAGS to remove padding on 64bit.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/sched.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b9c0bcd..7341cd7 100644
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
-- 
1.6.3.3

