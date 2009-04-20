Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZDTPow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZDTPow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZDTPoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:44:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbZDTPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:44:04 -0400
Message-Id: <20090420154400.576625110@goodmis.org>
References: <20090420154325.698204138@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 11:43:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] tracing: create menuconfig for tracing infrastructure
Content-Disposition: inline; filename=0002-tracing-create-menuconfig-for-tracing-infrastructur.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

During testing we often use randconfig to test various kernels.
The current configuration set up does not give an easy way to disable
all tracing with a single config. The case where randconfig would
test all tracing disabled is very unlikely.

This patch adds a config option to enable or disable all tracing.
It is hooked into the tracing menu just like other submenus are done.

[ Impact: allow randconfig to easily produce all traces disabled ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 3ee28db..3fa36d2 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -77,7 +77,12 @@ config TRACING_SUPPORT
 
 if TRACING_SUPPORT
 
-menu "Tracers"
+menuconfig FTRACE
+	bool "Tracers"
+	help
+	 Enable the kernel tracing infrastructure.
+
+if FTRACE
 
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
@@ -462,7 +467,7 @@ config MMIOTRACE_TEST
 
 	  Say N, unless you absolutely know what you are doing.
 
-endmenu
+endif # FTRACE
 
 endif # TRACING_SUPPORT
 
-- 
1.6.2.1

-- 
