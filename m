Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbZIDRHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbZIDRHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbZIDRHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:07:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:36424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775AbZIDRHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:07:05 -0400
Date: Fri, 4 Sep 2009 17:06:47 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de
In-Reply-To: <20090904140834.GA15789@elte.hu>
References: <20090904140834.GA15789@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: change msr-reg.o to obj-y, and export its symbols
Message-ID: <tip-b19ae3999891cad21a3995c34d313dda5df014e2@git.kernel.org>
Git-Commit-ID: b19ae3999891cad21a3995c34d313dda5df014e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 17:06:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b19ae3999891cad21a3995c34d313dda5df014e2
Gitweb:     http://git.kernel.org/tip/b19ae3999891cad21a3995c34d313dda5df014e2
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 4 Sep 2009 10:00:09 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 4 Sep 2009 10:00:09 -0700

x86, msr: change msr-reg.o to obj-y, and export its symbols

Change msr-reg.o to obj-y (it will be included in virtually every
kernel since it is used by the initialization code for AMD processors)
and add a separate C file to export its symbols to modules, so that
msr.ko can use them; on uniprocessors we bypass the helper functions
in msr.o and use the accessor functions directly via inlines.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <20090904140834.GA15789@elte.hu>
Cc: Borislav Petkov <petkovbb@googlemail.com>


---
 arch/x86/lib/Makefile         |    3 ++-
 arch/x86/lib/msr-reg-export.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index b59c064..9e60920 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -8,7 +8,8 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-y += msr-reg.o
+
+obj-y += msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/msr-reg-export.c b/arch/x86/lib/msr-reg-export.c
new file mode 100644
index 0000000..a311cc5
--- /dev/null
+++ b/arch/x86/lib/msr-reg-export.c
@@ -0,0 +1,5 @@
+#include <linux/module.h>
+#include <asm/msr.h>
+
+EXPORT_SYMBOL(native_rdmsr_safe_regs);
+EXPORT_SYMBOL(native_wrmsr_safe_regs);
