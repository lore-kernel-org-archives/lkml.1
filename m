Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZBDPJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZBDPJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZBDPIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:08:44 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:60220 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754337AbZBDPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:08:42 -0500
Date: Wed, 4 Feb 2009 18:08:40 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH 3/3] tracing: Tracers that use CALLER_ADDR macros should
	select FRAME_POINTER
Message-ID: <20090204150840.GC30027@oksana.dev.rtsoft.ru>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
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
index e2a4ff6..48f7a37 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -86,6 +86,7 @@ config IRQSOFF_TRACER
 	select TRACE_IRQFLAGS
 	select TRACING
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -108,6 +109,7 @@ config PREEMPT_TRACER
 	depends on DEBUG_KERNEL
 	select TRACING
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This option measures the time spent in preemption off critical
 	  sections, with microsecond accuracy.
@@ -136,6 +138,7 @@ config SCHED_TRACER
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
+	select FRAME_POINTER
 	help
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
-- 
1.5.6.5
