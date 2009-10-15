Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZJOGPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZJOGPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZJOGPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:15:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:48442 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbZJOGPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:15:11 -0400
Date: Thu, 15 Oct 2009 06:13:24 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AD6523D.5030909@zytor.com>
References: <4AD6523D.5030909@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "x86: linker script syntax nits"
Message-ID: <tip-db8590f5043f3436a65b24155a3a7af2604df876@git.kernel.org>
Git-Commit-ID: db8590f5043f3436a65b24155a3a7af2604df876
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 06:13:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db8590f5043f3436a65b24155a3a7af2604df876
Gitweb:     http://git.kernel.org/tip/db8590f5043f3436a65b24155a3a7af2604df876
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 15 Oct 2009 08:08:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 08:09:55 +0200

Revert "x86: linker script syntax nits"

This reverts commit e9a63a4e559fbdc522072281d05e6b13c1022f4b.

This breaks older binutils, where sink-less asserts are broken.

See this commit for further details:

  d2ba8b2: x86: Fix assert syntax in vmlinux.lds.S

Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4AD6523D.5030909@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
 arch/x86/kernel/vmlinux.lds.S              |   17 +++++++++--------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 0e50e1e..7da00b7 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -56,6 +56,6 @@ SECTIONS
 	/DISCARD/ : {
 		*(.note*)
 	}
-}
 
-ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
+	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
+}
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 8d6001a..92929fb 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,8 +305,8 @@ SECTIONS
 
 
 #ifdef CONFIG_X86_32
-ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-       "kernel image bigger than KERNEL_IMAGE_SIZE");
+. = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #else
 /*
  * Per-cpu symbols which need to be offset from __per_cpu_load
@@ -319,12 +319,12 @@ INIT_PER_CPU(irq_stack_union);
 /*
  * Build-time check on the image size:
  */
-ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
-       "kernel image bigger than KERNEL_IMAGE_SIZE");
+. = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
+	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 
 #ifdef CONFIG_SMP
-ASSERT((per_cpu__irq_stack_union == 0),
-       "irq_stack_union is not at start of per-cpu area");
+. = ASSERT((per_cpu__irq_stack_union == 0),
+           "irq_stack_union is not at start of per-cpu area");
 #endif
 
 #endif /* CONFIG_X86_32 */
@@ -332,6 +332,7 @@ ASSERT((per_cpu__irq_stack_union == 0),
 #ifdef CONFIG_KEXEC
 #include <asm/kexec.h>
 
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big");
+. = ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+           "kexec control code size is too big");
 #endif
+
