Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZCTPJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZCTPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZCTPJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:09:18 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41178 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752921AbZCTPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:09:17 -0400
Date: Fri, 20 Mar 2009 18:09:14 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Fix TRACING_SUPPORT dependency
Message-ID: <20090320150914.GA22769@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 40ada30f9621fbd831ac2437b9a2a399aad34b00 ("tracing: clean up
menu"), despite the "clean up" in its purpose, introduced behavioural
change for Kconfig symbols: we no longer able to select tracing
support on PPC32 (because IRQFLAGS_SUPPORT isn't yet implemented).

The IRQFLAGS_SUPPORT is not mandatory for most tracers, tracing core
has a special case for platforms w/o irqflags (which, by the way, has
become useless as of the commit above).

This patch restores the old behaviour, and thus brings the tracing
back on PPC32.

p.s.
The IRQSOFF_TRACER (which is the only tracer that requires IRQFLAGS
support) still depends on TRACE_IRQFLAGS_SUPPORT Kconfig symbol.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 kernel/trace/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index ee70841..774aba7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -63,7 +63,6 @@ config TRACING
 #
 config TRACING_SUPPORT
 	bool
-	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on STACKTRACE_SUPPORT
 	default y
 
-- 
1.5.6.5
