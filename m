Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZFFOjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZFFOjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZFFOjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:39:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:58060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZFFOjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:39:20 -0400
Subject: Re: [GIT PULL] headers_check fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090606130210.GA9343@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244292857.2473.4.camel@ht.satnam>
	 <20090606130210.GA9343@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 20:09:37 +0530
Message-Id: <1244299177.2473.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 14:02 +0100, Russell King wrote:
> On Sat, Jun 06, 2009 at 06:24:17PM +0530, Jaswinder Singh Rajput wrote:
> > Linus,
> > 
> > Please pull headers_check fixes:
> > 
> > The following changes since commit 064e38aaded5269e573ac1c765284fd65c8ebd13:
> >   Linus Torvalds (1):
> >         Merge git://git.kernel.org/.../mason/btrfs-unstable
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master
> > 
> > Jaswinder Singh Rajput (6):
> >       headers_check fix: arm, hwcap.h
> 
> So inspite of NAKing this patch you send it anyway.
> 

Ok dropping this patch as this issue is still open.

Here is new pull request:

The following changes since commit 064e38aaded5269e573ac1c765284fd65c8ebd13:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master

Jaswinder Singh Rajput (5):
      headers_check fix: ia64, fpswa.h
      headers_check fix: m68k, swab.h
      headers_check fix: mips, ioctl.h
      headers_check fix: mn10300, ptrace.h
      headers_check fix: mn10300, setup.h

 arch/ia64/include/asm/fpswa.h     |    3 ++-
 arch/m68k/include/asm/swab.h      |    2 +-
 arch/mips/include/asm/ioctl.h     |    4 ++++
 arch/mn10300/include/asm/ptrace.h |    5 ++---
 arch/mn10300/include/asm/setup.h  |    3 ++-
 5 files changed, 11 insertions(+), 6 deletions(-)

Complete diff :

diff --git a/arch/ia64/include/asm/fpswa.h b/arch/ia64/include/asm/fpswa.h
index 62edfce..797b064 100644
--- a/arch/ia64/include/asm/fpswa.h
+++ b/arch/ia64/include/asm/fpswa.h
@@ -68,6 +68,7 @@ typedef struct {
 	efi_fpswa_t	 fpswa;
 } fpswa_interface_t;
 
+#ifdef __KERNEL__
 extern fpswa_interface_t *fpswa_interface;
-
+#endif
 #endif /* _ASM_IA64_FPSWA_H */
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
diff --git a/arch/mips/include/asm/ioctl.h b/arch/mips/include/asm/ioctl.h
index 85067e2..9161634 100644
--- a/arch/mips/include/asm/ioctl.h
+++ b/arch/mips/include/asm/ioctl.h
@@ -60,12 +60,16 @@
 	 ((nr)   << _IOC_NRSHIFT) | \
 	 ((size) << _IOC_SIZESHIFT))
 
+#ifdef __KERNEL__
 /* provoke compile error for invalid uses of size argument */
 extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
 	  sizeof(t) : __invalid_size_argument_for_IOC)
+#else
+#define _IOC_TYPECHECK(t)	(sizeof(t))
+#endif
 
 /* used to create numbers */
 #define _IO(type, nr)		_IOC(_IOC_NONE, (type), (nr), 0)
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


