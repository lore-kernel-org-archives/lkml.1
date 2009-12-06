Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbZLFLO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbZLFLO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbZLFLO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:14:26 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:58465 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659AbZLFLO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:14:26 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 06:14:25 EST
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: compile insn.c and inat.c only for KPROBES
Date: Sun, 06 Dec 2009 20:14:29 +0900
Message-ID: <878wdg8icq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At least, insn.c and inat.c is needed for kprobe for now. So, this
compile those only if KPROBES is enabled.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 arch/x86/Kconfig.debug |    4 ++--
 arch/x86/lib/Makefile  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -L arch/x86/lib/Kconfig -puN /dev/null /dev/null
diff -puN arch/x86/lib/Makefile~kconfig-decoder-only-for-kprobe arch/x86/lib/Makefile
--- linux-2.6/arch/x86/lib/Makefile~kconfig-decoder-only-for-kprobe	2009-12-06 19:49:06.000000000 +0900
+++ linux-2.6-hirofumi/arch/x86/lib/Makefile	2009-12-06 19:49:06.000000000 +0900
@@ -20,7 +20,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-y += insn.o inat.o
+lib-$(CONFIG_KPROBES) += insn.o inat.o
 
 obj-y += msr-reg.o msr-reg-export.o
 
diff -puN arch/x86/Kconfig.debug~kconfig-decoder-only-for-kprobe arch/x86/Kconfig.debug
--- linux-2.6/arch/x86/Kconfig.debug~kconfig-decoder-only-for-kprobe	2009-12-06 19:49:06.000000000 +0900
+++ linux-2.6-hirofumi/arch/x86/Kconfig.debug	2009-12-06 19:49:06.000000000 +0900
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
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
