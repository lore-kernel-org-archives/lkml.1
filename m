Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbZEBAPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbZEBAPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbZEBAO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:14:26 -0400
Received: from ru.mvista.com ([213.79.90.228]:7159 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760497AbZEBAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:14:25 -0400
Date: Sat, 2 May 2009 04:14:25 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tracing: Tracers that use CALLER_ADDR macros should
	select FRAME_POINTER
Message-ID: <20090502001425.GC9342@oksana.dev.rtsoft.ru>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
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
index 450d3c2..ad44791 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -122,6 +122,7 @@ config IRQSOFF_TRACER
 	select TRACE_IRQFLAGS
 	select TRACING
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -143,6 +144,7 @@ config PREEMPT_TRACER
 	depends on PREEMPT
 	select TRACING
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This option measures the time spent in preemption off critical
 	  sections, with microsecond accuracy.
@@ -171,6 +173,7 @@ config SCHED_TRACER
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
-- 
1.6.2.2
