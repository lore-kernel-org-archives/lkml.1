Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZKZHGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZKZHGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbZKZHGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:06:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64003 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758583AbZKZHGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:06:00 -0500
Message-ID: <4B0E28C2.1090906@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:05:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/9] tracing: Convert some power events to DEFINE_EVENT
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_EVENT_TEMPLATE to remove duplicate code:

   text    data     bss     dec     hex filename
   4312     524      12    4848    12f0 kernel/trace/power-traces.o.old
   3455     524       8    3987     f93 kernel/trace/power-traces.o

Two events are converted:

  power: power_start, power_frequency

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/power.h |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 9bb96e5..5cfa61a 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -16,7 +16,7 @@ enum {
 };
 #endif
 
-TRACE_EVENT(power_start,
+TRACE_EVENT_TEMPLATE(power,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
@@ -35,42 +35,36 @@ TRACE_EVENT(power_start,
 	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long)__entry->state)
 );
 
-TRACE_EVENT(power_end,
-
-	TP_PROTO(int dummy),
+DEFINE_EVENT(power, power_start,
 
-	TP_ARGS(dummy),
+	TP_PROTO(unsigned int type, unsigned int state),
 
-	TP_STRUCT__entry(
-		__field(	u64,		dummy		)
-	),
+	TP_ARGS(type, state)
+);
 
-	TP_fast_assign(
-		__entry->dummy = 0xffff;
-	),
+DEFINE_EVENT(power, power_frequency,
 
-	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
+	TP_PROTO(unsigned int type, unsigned int state),
 
+	TP_ARGS(type, state)
 );
 
+TRACE_EVENT(power_end,
 
-TRACE_EVENT(power_frequency,
-
-	TP_PROTO(unsigned int type, unsigned int state),
+	TP_PROTO(int dummy),
 
-	TP_ARGS(type, state),
+	TP_ARGS(dummy),
 
 	TP_STRUCT__entry(
-		__field(	u64,		type		)
-		__field(	u64,		state		)
+		__field(	u64,		dummy		)
 	),
 
 	TP_fast_assign(
-		__entry->type = type;
-		__entry->state = state;
+		__entry->dummy = 0xffff;
 	),
 
-	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long) __entry->state)
+	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
+
 );
 
 #endif /* _TRACE_POWER_H */
-- 
1.6.3


