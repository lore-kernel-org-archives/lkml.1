Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYGTNVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYGTNVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 09:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbYGTNU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 09:20:57 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:35945
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876AbYGTNU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 09:20:57 -0400
Date: Sun, 20 Jul 2008 14:17:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       matthew@wil.cx, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       chris@zankel.net
Subject: Re: [PATCH] Introducing asm/syscalls.h
Message-ID: <20080720131727.GA22822@linux-mips.org>
References: <1216544940.12650.13.camel@jaswinder.satnam> <20080720100039.GA12514@linux-mips.org> <1216556263.2707.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216556263.2707.2.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 05:47:43PM +0530, Jaswinder Singh wrote:

> index 7cd25b8..af24926 100644
> --- a/include/asm-generic/Kbuild.asm
> +++ b/include/asm-generic/Kbuild.asm
> @@ -27,6 +27,7 @@ unifdef-y += socket.h
>  unifdef-y += sockios.h
>  unifdef-y += stat.h
>  unifdef-y += statfs.h
> +unifdef-y += syscalls.h
>  unifdef-y += termbits.h
>  unifdef-y += termios.h
>  unifdef-y += types.h
> 
> Thank you,

No.  Why would userspace want to know about these entry points?

I'd also like to point you at two other commits I just made:

  http://www.linux-mips.org/g/linux/a599080f
  http://www.linux-mips.org/g/linux/3c339dba

The first deletes the unused sys_truncate64 and sys_ftruncate64 entry-points
and the second resolves conflicting prototypes for sys_pipe() - MIPS uses
it's own sys_pipe() which conflicts with the one declared in
<linux/syscalls.h>.  The patch below takes care of that and also includes
the ptrace.h which is needed to make <asm/syscalls.h> work without
relying on other headers having been included previously.  Could you fold
that into your patch?  Thanks,

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/asm-mips/syscalls.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux-mips/include/asm-mips/syscalls.h
===================================================================
--- linux-mips.orig/include/asm-mips/syscalls.h
+++ linux-mips/include/asm-mips/syscalls.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_MIPS_SYSCALLS_H
 #define _ASM_MIPS_SYSCALLS_H
 
+#include <linux/ptrace.h>
 #include <asm/sim.h>
 
 /* kernel/signal.c */
@@ -26,14 +27,8 @@ asmlinkage int sys_rt_sigsuspend(nabi_no
 asmlinkage int sys_sigaltstack(nabi_no_regargs struct pt_regs);
 asmlinkage void sys_rt_sigreturn(nabi_no_regargs struct pt_regs);
 
-/* kernel/linux32.c */
-asmlinkage int sys_truncate64(const char __user *, unsigned int,
-			      unsigned int);
-asmlinkage int sys_ftruncate64(unsigned int, unsigned int,
-			      unsigned int);
-
 /* kernel/syscalls.c */
-asmlinkage int sys_pipe(nabi_no_regargs volatile struct pt_regs);
+asmlinkage int sysm_pipe(nabi_no_regargs volatile struct pt_regs);
 asmlinkage unsigned long old_mmap(unsigned long, unsigned long,
 				  int, int, int, off_t);
 
