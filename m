Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZBSDio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZBSDio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZBSDiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:38:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZBSDiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:38:21 -0500
Message-Id: <20090219033819.943632629@goodmis.org>
References: <20090219033531.360862326@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 18 Feb 2009 22:35:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] tracing: have function trace select kallsyms
Content-Disposition: inline; filename=0002-tracing-have-function-trace-select-kallsyms.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix output of function tracer to be useful

The function tracer is pretty useless if KALLSYMS is not configured.
Unless you are good at reading hex values, the function tracer should
select the KALLSYMS configuration.

Also, the dynamic function tracer will fail its self test if KALLSYMS
is not selected.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 58a93fb..34e707e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -52,6 +52,7 @@ config FUNCTION_TRACER
 	depends on HAVE_FUNCTION_TRACER
 	depends on DEBUG_KERNEL
 	select FRAME_POINTER
+	select KALLSYMS
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	help
@@ -238,6 +239,7 @@ config STACK_TRACER
 	depends on DEBUG_KERNEL
 	select FUNCTION_TRACER
 	select STACKTRACE
+	select KALLSYMS
 	help
 	  This special tracer records the maximum stack footprint of the
 	  kernel and displays it in debugfs/tracing/stack_trace.
-- 
1.5.6.5

-- 
