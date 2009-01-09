Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbZAIA34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbZAIA34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbZAIA2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:28:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbZAIA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:28:42 -0500
Message-Id: <20090109002840.525800746@goodmis.org>
References: <20090109002747.240318148@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 08 Jan 2009 19:27:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] trace: mmiotrace to the tracer menu in Kconfig
Content-Disposition: inline; filename=0002-trace-mmiotrace-to-the-tracer-menu-in-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Paalanen <pq@iki.fi>

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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
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
1.5.6.5

-- 
