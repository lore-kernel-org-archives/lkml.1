Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZIQJjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZIQJjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZIQJjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:39:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50083 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZIQJjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:39:45 -0400
Message-ID: <4AB20398.8070209@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 17:38:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] softirq: Fix softirq_to_name
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With BLOCK_IOPOLL_SOFTIRQ added, softirq_to_name[] and
show_softirq_name() needs to be updated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

We can automatically generate softirq_to_name[] and
show_softirq_name(), but since it's rare to add new softirq,
I decide to just add the missing one.

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
1.6.3

