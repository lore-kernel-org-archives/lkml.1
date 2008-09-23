Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYIWJau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYIWJau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYIWJal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:30:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:9441 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYIWJak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=GIQ7VS/SqSkSEIDEIPdnDMivntLNgDr+185NFGxewyV+z3OxiUX7wiwJMiDIHz/gG1
         RO7u7+Qe1blkmRtWUdbAKBW6njdHweYsmmf2AdpyfCXeofBXnQtR66Mgl73hd/en9Uw5
         xF44dEeLK5kCkAGEkelMlKIfn1T9o+bRZfdQ8=
Message-ID: <48D8C6A4.5000400@gmail.com>
Date: Tue, 23 Sep 2008 11:36:20 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [Patch -tip 3/4] Tracing/ftrace: Give an entry on the config for
 initcall tracer
Content-Type: multipart/mixed;
 boundary="------------050705010103030606010209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050705010103030606010209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bring the entry to choose the initcall tracer on the kernel config.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

--------------050705010103030606010209
Content-Type: text/plain;
 name="patch3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch3.diff"

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 254328d..53952b7 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -126,6 +126,16 @@ config STACK_TRACER
 	  This tracer records the max stack of the kernel, and displays
 	  it in debugfs/tracing/stack_trace
 
+config INITCALL_TRACER
+	bool "Trace initcalls"
+	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer records the initcalls which occur after SMP initialization. 
+	  Its aim is to be parsed by the /scripts/bootgraph.pl to produce a graph,
+	  giving a visual representation of the delays during initcalls.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 73ba13f..1d7cc74 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -22,5 +22,6 @@ obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
 obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
+obj-$(CONFIG_INITCALL_TRACER) += trace_initcall.o
 
 libftrace-y := ftrace.o

--------------050705010103030606010209--
