Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZFJNaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZFJNaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZFJNaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:30:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:44363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZFJNaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:30:39 -0400
Subject: [git-pull -tip] headers_check fix patches 20090610
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 19:00:30 +0530
Message-Id: <1244640630.20890.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e271e1343a94e081723cb4180af3fdb5fecc1a49:
  Ingo Molnar (1):
        Merge branch 'x86/mce4'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-top.git master

Jaswinder Singh Rajput (3):
      headers_check fix: m68k, swab.h
      headers_check fix: mn10300, ptrace.h
      headers_check fix: mn10300, setup.h

 arch/m68k/include/asm/swab.h      |    2 +-
 arch/mn10300/include/asm/ptrace.h |    5 ++---
 arch/mn10300/include/asm/setup.h  |    3 ++-
 3 files changed, 5 insertions(+), 5 deletions(-)

Complete diff:

diff --git a/arch/m68k/include/asm/swab.h b/arch/m68k/include/asm/swab.h
index 9e3054e..5b754aa 100644
--- a/arch/m68k/include/asm/swab.h
+++ b/arch/m68k/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _M68K_SWAB_H
 #define _M68K_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #define __SWAB_64_THRU_32__
diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 7b06cc6..00aa680 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -77,8 +77,6 @@ struct pt_regs {
 };
 #endif
 
-extern struct pt_regs *__frame; /* current frame pointer */
-
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
@@ -90,6 +88,8 @@ extern struct pt_regs *__frame; /* current frame pointer */
 
 #if defined(__KERNEL__)
 
+extern struct pt_regs *__frame;		/* current frame pointer */
+
 #if !defined(__ASSEMBLY__)
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
@@ -99,5 +99,4 @@ extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
 
 #endif  /*  __KERNEL__  */
-
 #endif /* _ASM_PTRACE_H */
diff --git a/arch/mn10300/include/asm/setup.h b/arch/mn10300/include/asm/setup.h
index 08356c8..c229d1e 100644
--- a/arch/mn10300/include/asm/setup.h
+++ b/arch/mn10300/include/asm/setup.h
@@ -11,7 +11,8 @@
 #ifndef _ASM_SETUP_H
 #define _ASM_SETUP_H
 
+#ifdef __KERNEL__
 extern void __init unit_setup(void);
 extern void __init unit_init_IRQ(void);
-
+#endif
 #endif /* _ASM_SETUP_H */


