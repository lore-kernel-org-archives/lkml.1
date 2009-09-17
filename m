Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZIQT54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZIQT54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZIQT5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:57:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZIQT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:57:43 -0400
Message-Id: <20090917195746.436527380@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Sep 2009 15:55:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/5] [PATCH 4/5] softirq: add BLOCK_IOPOLL to softirq_to_name
References: <20090917195508.189551309@goodmis.org>
Content-Disposition: inline; filename=0004-softirq-add-BLOCK_IOPOLL-to-softirq_to_name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

With BLOCK_IOPOLL_SOFTIRQ added, softirq_to_name[] and
show_softirq_name() needs to be updated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AB20398.8070209@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h |   21 +++++++++++----------
 kernel/softirq.c           |    2 +-
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 1cb0c3a..b89f9db 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -8,16 +8,17 @@
 #include <linux/interrupt.h>
 
 #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
-#define show_softirq_name(val)			\
-	__print_symbolic(val,			\
-			 softirq_name(HI),	\
-			 softirq_name(TIMER),	\
-			 softirq_name(NET_TX),	\
-			 softirq_name(NET_RX),	\
-			 softirq_name(BLOCK),	\
-			 softirq_name(TASKLET),	\
-			 softirq_name(SCHED),	\
-			 softirq_name(HRTIMER),	\
+#define show_softirq_name(val)				\
+	__print_symbolic(val,				\
+			 softirq_name(HI),		\
+			 softirq_name(TIMER),		\
+			 softirq_name(NET_TX),		\
+			 softirq_name(NET_RX),		\
+			 softirq_name(BLOCK),		\
+			 softirq_name(BLOCK_IOPOLL),	\
+			 softirq_name(TASKLET),		\
+			 softirq_name(SCHED),		\
+			 softirq_name(HRTIMER),		\
 			 softirq_name(RCU))
 
 /**
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7db2506..f8749e5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -57,7 +57,7 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
-	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
+	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER",	"RCU"
 };
 
-- 
1.6.3.3


