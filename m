Return-Path: <linux-kernel-owner+w=401wt.eu-S1763110AbZAHWPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763110AbZAHWPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZAHWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:15:38 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:45653 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZAHWPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=cl+vpd5aC8vQWtkXaJMvRNCNL/z+zwNPhiLxQ2oF9T9DcKQNp05S0na0TtxlwUjpc2
         6z1HacvA4Lqjvs7he7OCqC47XnvrIM67PAkoE/3fDunizWapQWFYMRDTfxKJG7iEX/QF
         mKCeuzMaeK07gaVE+lE4Z0hk9KHw8fRBm84xQ=
Date: Fri, 9 Jan 2009 00:15:31 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, pq@iki.fi
Subject: [PATCH v2 2/3] trace: mmiotrace to the tracer menu in Kconfig
Message-ID: <20090109001531.09970d3e@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
References: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9ce66da6670fd92e626d5adbcdabe81f2a79f2dc Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 3 Jan 2009 21:23:51 +0200
Subject: [PATCH] trace: mmiotrace to the tracer menu in Kconfig

Impact: cosmetic change in Kconfig menu layout

This patch was originally suggested by Peter Zijlstra, but seems it
was forgotten.

CONFIG_MMIOTRACE and CONFIG_MMIOTRACE_TEST were selectable
directly under the Kernel hacking / debugging menu in the kernel
configuration system. They were present only for x86 and x86_64.

Other tracers that use the ftrace tracing framework are in their own
sub-menu. This patch moves the mmiotrace configuration options there.
Since the Kconfig file, where the tracer menu is, is not architecture
specific, HAVE_MMIOTRACE_SUPPORT is introduced and provided only by
x86/x86_64. CONFIG_MMIOTRACE now depends on it.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug |   24 ++----------------------
 kernel/trace/Kconfig   |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 01649e1..097d79a 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -175,28 +175,8 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config MMIOTRACE
-	bool "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL && PCI
-	select TRACING
-	help
-	  Mmiotrace traces Memory Mapped I/O access and is meant for
-	  debugging and reverse engineering. It is called from the ioremap
-	  implementation and works via page faults. Tracing is disabled by
-	  default and can be enabled at run-time.
-
-	  See Documentation/tracers/mmiotrace.txt.
-	  If you are not helping to develop drivers, say N.
-
-config MMIOTRACE_TEST
-	tristate "Test module for mmiotrace"
-	depends on MMIOTRACE && m
-	help
-	  This is a dumb module for testing mmiotrace. It is very dangerous
-	  as it will write garbage to IO memory starting at a given address.
-	  However, it should be safe to use on e.g. unused portion of VRAM.
-
-	  Say N, unless you absolutely know what you are doing.
+config HAVE_MMIOTRACE_SUPPORT
+	def_bool y
 
 #
 # IO delay types:
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1c0b750..9442392 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -323,4 +323,27 @@ config FTRACE_STARTUP_TEST
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
 
+config MMIOTRACE
+	bool "Memory mapped IO tracing"
+	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
+	select TRACING
+	help
+	  Mmiotrace traces Memory Mapped I/O access and is meant for
+	  debugging and reverse engineering. It is called from the ioremap
+	  implementation and works via page faults. Tracing is disabled by
+	  default and can be enabled at run-time.
+
+	  See Documentation/tracers/mmiotrace.txt.
+	  If you are not helping to develop drivers, say N.
+
+config MMIOTRACE_TEST
+	tristate "Test module for mmiotrace"
+	depends on MMIOTRACE && m
+	help
+	  This is a dumb module for testing mmiotrace. It is very dangerous
+	  as it will write garbage to IO memory starting at a given address.
+	  However, it should be safe to use on e.g. unused portion of VRAM.
+
+	  Say N, unless you absolutely know what you are doing.
+
 endmenu
-- 
1.6.0.6

