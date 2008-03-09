Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYCITiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYCITiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYCITiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:38:10 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4134 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYCITiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:38:09 -0400
Subject: [PATCH] x86 - cleanup duplicate includes
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 12:35:00 -0700
Message-Id: <1205091300.656.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 arch/x86/kernel/reboot.c      |    1 -
 include/asm-x86/elf.h         |    5 ++---
 include/asm-x86/posix_types.h |    8 +-------
 include/asm-x86/processor.h   |    3 +--
 include/asm-x86/unistd.h      |    8 +-------
 5 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 55ceb8c..b1e428b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -1,5 +1,4 @@
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/pm.h>
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index fb62f99..7732564 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -82,8 +82,9 @@ extern unsigned int vdso_enabled;
 #define elf_check_arch_ia32(x) \
 	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
 
-#ifdef CONFIG_X86_32
 #include <asm/processor.h>
+
+#ifdef CONFIG_X86_32
 #include <asm/system.h>		/* for savesegment */
 #include <asm/desc.h>
 
@@ -135,8 +136,6 @@ extern unsigned int vdso_enabled;
 
 #else /* CONFIG_X86_32 */
 
-#include <asm/processor.h>
-
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
diff --git a/include/asm-x86/posix_types.h b/include/asm-x86/posix_types.h
index bb7133d..fe312a5 100644
--- a/include/asm-x86/posix_types.h
+++ b/include/asm-x86/posix_types.h
@@ -1,11 +1,5 @@
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "posix_types_32.h"
-# else
-#  include "posix_types_64.h"
-# endif
-#else
-# ifdef __i386__
+# if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "posix_types_32.h"
 # else
 #  include "posix_types_64.h"
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 45a2f0a..614362e 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -3,8 +3,7 @@
 
 #include <asm/processor-flags.h>
 
-/* migration helpers, for KVM - will be removed in 2.6.25: */
-#include <asm/vm86.h>
+/* migration helper, for KVM - will be removed in 2.6.25: */
 #define Xgt_desc_struct	desc_ptr
 
 /* Forward declaration, a strange C thing */
diff --git a/include/asm-x86/unistd.h b/include/asm-x86/unistd.h
index 2a58ed3..effc7ad 100644
--- a/include/asm-x86/unistd.h
+++ b/include/asm-x86/unistd.h
@@ -1,11 +1,5 @@
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "unistd_32.h"
-# else
-#  include "unistd_64.h"
-# endif
-#else
-# ifdef __i386__
+# if defined(CONFIG_X86_32) || defined(__i386__)
 #  include "unistd_32.h"
 # else
 #  include "unistd_64.h"


