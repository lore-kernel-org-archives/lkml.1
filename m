Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZGWLTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZGWLTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZGWLTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:19:54 -0400
Received: from cmpxchg.org ([85.214.51.133]:57147 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZGWLTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:19:54 -0400
Date: Thu, 23 Jul 2009 13:18:34 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, mingo@elte.hu,
       Chris Zankel <chris@zankel.net>
Subject: Re: [Patch 2/2] xtensa: use generic sys_pipe()
Message-ID: <20090723111834.GA901@cmpxchg.org>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090722091100.6621.80645.sendpatchset@localhost.localdomain> <20090722101032.GA2102@cmpxchg.org> <4A6831AC.3080704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6831AC.3080704@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 05:47:24PM +0800, Amerigo Wang wrote:
> Johannes Weiner wrote:
> >[CC Chris]
> >
> >On Wed, Jul 22, 2009 at 05:08:42AM -0400, Amerigo Wang wrote:
> >  
> >>As suggested by Al, we can use the generic sys_pipe() instead of 
> >>xtensa_pipe()
> >>for xtensa.
> >>
> >>Signed-off-by: WANG Cong <amwang@redhat.com>
> >>Cc: Al Viro <viro@zeniv.linux.org.uk> 
> >>CC: Linus Torvalds <torvalds@linux-foundation.org>
> >>    
> >
> >Reviewed-by: Johannes Weiner <jw@emlix.com>
> >
> >  
> 
> Thanks for your review.
> >>---
> >>diff --git a/arch/xtensa/include/asm/syscall.h 
> >>b/arch/xtensa/include/asm/syscall.h
> >>index 05cebf8..76a1fb8 100644
> >>--- a/arch/xtensa/include/asm/syscall.h
> >>+++ b/arch/xtensa/include/asm/syscall.h
> >>@@ -12,7 +12,6 @@ struct pt_regs;
> >> struct sigaction;
> >> asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
> >> asmlinkage long xtensa_clone(unsigned long, unsigned long, struct 
> >> pt_regs*);
> >>-asmlinkage long xtensa_pipe(int __user *);
> >> asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
> >>     			     unsigned long, unsigned long, unsigned 
> >>     			     long);
> >> asmlinkage long xtensa_ptrace(long, long, long, long);
> >>diff --git a/arch/xtensa/include/asm/unistd.h 
> >>b/arch/xtensa/include/asm/unistd.h
> >>index c092c8f..b6880c8 100644
> >>--- a/arch/xtensa/include/asm/unistd.h
> >>+++ b/arch/xtensa/include/asm/unistd.h
> >>@@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
> >> #define __NR_mknod 				 36
> >> __SYSCALL( 36, sys_mknod, 3)
> >> #define __NR_pipe 				 37
> >>-__SYSCALL( 37, xtensa_pipe, 1)
> >>+__SYSCALL(37, sys_pipe, 1)
> >>    
> >
> >It would have been nice to keep the spacing but that shouldn't be a
> >show stopper..
> >
> >  
> 
> I did this, but checkpatch.pl complained about this... so I removed the
> space.

Yeah, but look at the file.  checkpatch suggests alignment that is
common for function calls, but this doesn't look like a sequence of
function calls, rather like a table - and we align other tables (like
fields in structure definitions) as well because you usually don't
read them in a linear fashion but want to spot key values immediately.

Please ignore checkpatch in this case.
