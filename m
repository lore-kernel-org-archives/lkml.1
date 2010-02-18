Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0BRLOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:14:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56669 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0BRLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gbvJ2VxtGetNXNmrx2y0WHU5eO3SHotrcVtSxS+dLcvJSyfDemCNkIsDmDQFDKGI47
         IqCkNiu2I1b9KdEfy6Nhotu0unshrPxpteIlV5CmP6aPqaCzcDs8rggdrtq5IISH6+aH
         2gihpEeUnkX2QveewB+789iMpTu11Dhgu6x30=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier@gentoo.org>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Date: Thu, 18 Feb 2010 12:13:35 +0100
Message-Id: <1266491616-6270-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

KPROBES_EVENT actually depends on the regs and stack access API
(b1cf540f) and not on x86.
So introduce a new config option which architectures can select if
they have the API implemented and switch x86.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/Kconfig         |    3 +++
 arch/x86/Kconfig     |    1 +
 kernel/trace/Kconfig |    2 +-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9d055b4..04e3aa7 100644
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 55298e8..07baa12 100644
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
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6c22d8a..40fef55 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -451,7 +451,7 @@ config BLK_DEV_IO_TRACE
 
 config KPROBE_EVENT
 	depends on KPROBES
-	depends on X86
+	depends on HAVE_REGS_AND_STACK_ACCESS_API
 	bool "Enable kprobes-based dynamic events"
 	select TRACING
 	default y
-- 
1.6.2.3

