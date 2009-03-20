Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbZCTQpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbZCTQpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbZCTQog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:44:36 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41453 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759426AbZCTQof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:44:35 -0400
Date: Fri, 20 Mar 2009 19:44:33 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing: Tracers that use CALLER_ADDR macros should
	select FRAME_POINTER
Message-ID: <20090320164433.GC28037@oksana.dev.rtsoft.ru>
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irqsoff, switch and preempt tracers use CALLER_ADDR macros, so they
should select FRAME_POINTER. Otherwise traces are meaningless.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 kernel/trace/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 774aba7..9fc98a7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -107,6 +107,7 @@ config IRQSOFF_TRACER
 	select TRACE_IRQFLAGS
 	select TRACING
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -128,6 +129,7 @@ config PREEMPT_TRACER
 	depends on PREEMPT
 	select TRACING
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This option measures the time spent in preemption off critical
 	  sections, with microsecond accuracy.
@@ -156,6 +158,7 @@ config SCHED_TRACER
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
-- 
1.5.6.5
