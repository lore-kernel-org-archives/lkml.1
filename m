Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZFNGz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZFNGz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFNGzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:55:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:36980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZFNGzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:55:48 -0400
Subject: [GIT-PULL] headers_check fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 12:26:14 +0530
Message-Id: <1244962574.24224.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull headers_check fixes :

The following changes since commit 44b7532b8b464f606053562400719c9c21276037:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jejb/scsi-rc-fixes-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master

Jaswinder Singh Rajput (2):
      headers_check fix: mn10300, ptrace.h
      headers_check fix: mn10300, setup.h

 arch/mn10300/include/asm/ptrace.h |    5 ++---
 arch/mn10300/include/asm/setup.h  |    3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

Complete diff :

diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 921942e..1b0ba5e 100644
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
 struct task_struct;
 
@@ -107,5 +107,4 @@ extern void user_disable_single_step(struct task_struct *);
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


