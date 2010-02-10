Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0BJQZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:25:20 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:38328 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab0BJQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:25:19 -0500
Date: Wed, 10 Feb 2010 17:25:17 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tracing/kprobes: make Kconfig dependencies generic
Message-ID: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

KPROBES_EVENT actually depends on the regs and stack access API (b1cf540f)
and not on x86.
So introduce a new config option which architectures can select if they
have the API implemented and switch x86.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig         |    3 +++
 arch/x86/Kconfig     |    1 +
 kernel/trace/Kconfig |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
 config USE_GENERIC_SMP_HELPERS
 	bool
 
+config HAVE_REGS_AND_STACK_ACCESS_API
+	bool
+
 config HAVE_CLK
 	bool
 	help
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -45,6 +45,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -449,7 +449,7 @@ config BLK_DEV_IO_TRACE
 
 config KPROBE_EVENT
 	depends on KPROBES
-	depends on X86
+	depends on HAVE_REGS_AND_STACK_ACCESS_API
 	bool "Enable kprobes-based dynamic events"
 	select TRACING
 	default y
