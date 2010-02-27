Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968216Ab0B0Mwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:52:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:36083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968206Ab0B0Mwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:52:31 -0500
Date: Sat, 27 Feb 2010 12:51:52 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, fweisbec@gmail.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com>
References: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <tip-f850c30c8b426ba1688cb63b1a3e534eed03a138@git.kernel.org>
Git-Commit-ID: f850c30c8b426ba1688cb63b1a3e534eed03a138
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:51:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f850c30c8b426ba1688cb63b1a3e534eed03a138
Gitweb:     http://git.kernel.org/tip/f850c30c8b426ba1688cb63b1a3e534eed03a138
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Wed, 10 Feb 2010 17:25:17 +0100
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 17 Feb 2010 13:13:08 +0100

tracing/kprobes: Make Kconfig dependencies generic

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
