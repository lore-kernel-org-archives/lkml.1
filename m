Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZAHUff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZAHUff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZAHUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:35:27 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42313 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZAHUf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:35:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=X40yg7Kf12H5k/urSudOfk7b/AwANqMPXVVrs2suenw7hoamTZn9q0nnI2XEFyM88s
         t7oUSkX6bUNpyq70gGNgsDqSIBMluPJAlhfFuObhCy/tuw2AxBCv4dC25OlHLUppRxpD
         OP2a3YYopOETSw8mt2TPLQrgEfVypxcBcfZSc=
Date: Thu, 8 Jan 2009 22:35:20 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace: move the MMIO-tracer to the tracer menu
Message-ID: <20090108223520.0b713475@daedalus.pq.iki.fi>
In-Reply-To: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
References: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a9fefe5d5775939ae3bb76fad16510cfd89521f8 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 3 Jan 2009 21:23:51 +0200
Subject: [PATCH] trace: move the MMIO-tracer to the tracer menu

This patch was originally suggested by Peter Zijlstra, but seems it
was forgotten.

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

