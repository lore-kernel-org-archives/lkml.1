Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0CJNZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:25:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:53683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab0CJNZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:25:35 -0500
Date: Wed, 10 Mar 2010 13:25:05 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Add INSTRUCTION_DECODER config flag
Message-ID: <tip-ba7e4d13fc7e25af1d167d40e6f028298dfc55ad@git.kernel.org>
Git-Commit-ID: ba7e4d13fc7e25af1d167d40e6f028298dfc55ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba7e4d13fc7e25af1d167d40e6f028298dfc55ad
Gitweb:     http://git.kernel.org/tip/ba7e4d13fc7e25af1d167d40e6f028298dfc55ad
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 13:58:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:34:12 +0100

perf, x86: Add INSTRUCTION_DECODER config flag

The PEBS+LBR decoding magic needs the insn_get_length() infrastructure
to be able to decode x86 instruction length.

So split it out of KPROBES dependency and make it enabled when either
KPROBES or PERF_EVENTS is enabled.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig      |    3 +++
 arch/x86/lib/Makefile |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e984403..e1240f6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -58,6 +58,9 @@ config X86
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 
+config INSTRUCTION_DECODER
+	def_bool (KPROBES || PERF_EVENTS)
+
 config OUTPUT_FORMAT
 	string
 	default "elf32-i386" if X86_32
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 419386c..cbaf8f2 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -20,7 +20,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-$(CONFIG_KPROBES) += insn.o inat.o
+lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
 
