Return-Path: <linux-kernel-owner+w=401wt.eu-S1765375AbXGKPPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765375AbXGKPPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765195AbXGKPPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:15:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58036 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765098AbXGKPPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:15:36 -0400
Date: Wed, 11 Jul 2007 17:16:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Miles Bader <miles@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] re-add required code to include/asm-v850/unistd.h
Message-ID: <20070711151608.GG3492@stusta.de>
References: <20070707211124.GN3492@stusta.de> <200707072341.16389.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707072341.16389.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 11:41:15PM +0200, Arnd Bergmann wrote:
> On Saturday 07 July 2007, Adrian Bunk wrote:
> > 
> > Commit f5738ceed46782aea7663d62cb6398eb05fc4ce0 removed a bit too much, 
> > resulting in the following compile error:
> 
> Sorry about the trouble this has caused you.

No problem, I only ran into it when doing crosscompile tests.

> >  #ifdef __KERNEL__
> >  
> > +/* Syscall protocol:
> > +   Syscall number in r12, args in r6-r9, r13-r14
> > +   Return value in r10
> > +   Trap 0 for `short' syscalls, where all the args can fit in function
> > +   call argument registers, and trap 1 when there are additional args in
> > +   r13-r14.  */
> > +
> > +#define SYSCALL_NUM    "r12"
> > +#define SYSCALL_ARG0   "r6"
> > +#define SYSCALL_ARG1   "r7"
> > +#define SYSCALL_ARG2   "r8"
> > +#define SYSCALL_ARG3   "r9"
> > +#define SYSCALL_ARG4   "r13"
> > +#define SYSCALL_ARG5   "r14"
> > +#define SYSCALL_RET    "r10"
> > +
> > +#define SYSCALL_SHORT_TRAP     "0"
> > +#define SYSCALL_LONG_TRAP      "1"
> > +
> > +/* Registers clobbered by any syscall.  This _doesn't_ include the syscall
> > +   number (r12) or the `extended arg' registers (r13, r14), even though
> > +   they are actually clobbered too (this is because gcc's `asm' statement
> > +   doesn't allow a clobber to be used as an input or output).  */
> > +#define SYSCALL_CLOBBERS       "r1", "r5", "r11", "r15", "r16", \
> > +                               "r17", "r18", "r19"
> > +
> > +/* Registers clobbered by a `short' syscall.  This includes all clobbers
> > +   except the syscall number (r12).  */
> > +#define SYSCALL_SHORT_CLOBBERS SYSCALL_CLOBBERS, "r13", "r14"
> > +
> 
> Wouldn't it be more appropriate to just open-code the contents of these
> macros in the place where they are used?
> 
> Even better probably would be to convert the v850 kernel_thread code
> to call do_fork directly, like most other architectures do.

The bigger problem seems to be that v850 is not that near at compiling 
at all...  :-(

> 	Arnd <><

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

