Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZLGIQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZLGIQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZLGIQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:16:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53031 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888AbZLGIQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:16:14 -0500
Date: Mon, 7 Dec 2009 08:15:44 GMT
From: tip-bot for OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <878wdg8icq.fsf@devron.myhome.or.jp>
References: <878wdg8icq.fsf@devron.myhome.or.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86: Compile insn.c and inat.c only for KPROBES
Message-ID: <tip-cbe5c34c8c1f8ed1afbe6273f4ad57fcfad7822f@git.kernel.org>
Git-Commit-ID: cbe5c34c8c1f8ed1afbe6273f4ad57fcfad7822f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbe5c34c8c1f8ed1afbe6273f4ad57fcfad7822f
Gitweb:     http://git.kernel.org/tip/cbe5c34c8c1f8ed1afbe6273f4ad57fcfad7822f
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Sun, 6 Dec 2009 20:14:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 08:31:28 +0100

x86: Compile insn.c and inat.c only for KPROBES

At least, insn.c and inat.c is needed for kprobe for now. So,
this compile those only if KPROBES is enabled.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <878wdg8icq.fsf@devron.myhome.or.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug |    4 ++--
 arch/x86/lib/Makefile  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 7d0b681..0e90929 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -187,8 +187,8 @@ config HAVE_MMIOTRACE_SUPPORT
 	def_bool y
 
 config X86_DECODER_SELFTEST
-     bool "x86 instruction decoder selftest"
-     depends on DEBUG_KERNEL
+	bool "x86 instruction decoder selftest"
+	depends on DEBUG_KERNEL && KPROBES
 	---help---
 	 Perform x86 instruction decoder selftests at build time.
 	 This option is useful for checking the sanity of x86 instruction
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index a2d6472..442b3b3 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -20,7 +20,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-y += insn.o inat.o
+lib-$(CONFIG_KPROBES) += insn.o inat.o
 
 obj-y += msr-reg.o msr-reg-export.o
 
