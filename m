Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZIQUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZIQUQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZIQUQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:16:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:47782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZIQUQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:16:39 -0400
Date: Thu, 17 Sep 2009 20:16:20 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AB20398.8070209@cn.fujitsu.com>
References: <4AB20398.8070209@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] softirq: add BLOCK_IOPOLL to softirq_to_name
Message-ID: <tip-5dd4de587fd9c25cb32a7a0fe9feec3647509b6f@git.kernel.org>
Git-Commit-ID: 5dd4de587fd9c25cb32a7a0fe9feec3647509b6f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 20:16:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dd4de587fd9c25cb32a7a0fe9feec3647509b6f
Gitweb:     http://git.kernel.org/tip/5dd4de587fd9c25cb32a7a0fe9feec3647509b6f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 17 Sep 2009 17:38:32 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 17 Sep 2009 15:53:44 -0400

softirq: add BLOCK_IOPOLL to softirq_to_name

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
 
