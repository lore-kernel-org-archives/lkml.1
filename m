Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbZGXJCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbZGXJCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZGXJCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:02:06 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:42737 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZGXJCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MjqVA0ZatkExZ7yHtbki+DRafDguxbxYBgko3k1TYQ0FoBB9t6tnEiuhVC8Nnz2JoA
         2akhpNISp/A7FjVCAAVNrstLL9TOhFGq0Ik3DBBrwCu7ndutKFlXyOQfTWy/k7QIp42w
         ExSY7/DTv32oeurx2ApLdtsFiSUo8OwamHJvk=
Date: Fri, 24 Jul 2009 17:04:16 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, mingo@elte.hu,
       Chris Zankel <chris@zankel.net>
Subject: Re: [Patch 2/2] xtensa: use generic sys_pipe()
Message-ID: <20090724090416.GC6372@cr0.nay.redhat.com>
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090722091100.6621.80645.sendpatchset@localhost.localdomain> <20090722101032.GA2102@cmpxchg.org> <4A6831AC.3080704@redhat.com> <20090723111834.GA901@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723111834.GA901@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 01:18:34PM +0200, Johannes Weiner wrote:
>On Thu, Jul 23, 2009 at 05:47:24PM +0800, Amerigo Wang wrote:
>> Johannes Weiner wrote:



<snip>

>> >>--- a/arch/xtensa/include/asm/unistd.h
>> >>+++ b/arch/xtensa/include/asm/unistd.h
>> >>@@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
>> >> #define __NR_mknod 				 36
>> >> __SYSCALL( 36, sys_mknod, 3)
>> >> #define __NR_pipe 				 37
>> >>-__SYSCALL( 37, xtensa_pipe, 1)
>> >>+__SYSCALL(37, sys_pipe, 1)
>> >>    
>> >
>> >It would have been nice to keep the spacing but that shouldn't be a
>> >show stopper..
>> >
>> >  
>> 
>> I did this, but checkpatch.pl complained about this... so I removed the
>> space.
>
>Yeah, but look at the file.  checkpatch suggests alignment that is
>common for function calls, but this doesn't look like a sequence of
>function calls, rather like a table - and we align other tables (like
>fields in structure definitions) as well because you usually don't
>read them in a linear fashion but want to spot key values immediately.
>
>Please ignore checkpatch in this case.

Ok, thanks! Below is it.

--------------------------->

As suggested by Al, we can use the generic sys_pipe() instead of xtensa_pipe()
for xtensa.

Signed-off-by: WANG Cong <amwang@redhat.com>
Reviewed-by: Johannes Weiner <jw@emlix.com>
Cc: Al Viro <viro@zeniv.linux.org.uk> 
CC: Linus Torvalds <torvalds@linux-foundation.org>

---
diff --git a/arch/xtensa/include/asm/syscall.h b/arch/xtensa/include/asm/syscall.h
index 05cebf8..76a1fb8 100644
--- a/arch/xtensa/include/asm/syscall.h
+++ b/arch/xtensa/include/asm/syscall.h
@@ -12,7 +12,6 @@ struct pt_regs;
 struct sigaction;
 asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
 asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
-asmlinkage long xtensa_pipe(int __user *);
 asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
     			     unsigned long, unsigned long, unsigned long);
 asmlinkage long xtensa_ptrace(long, long, long, long);
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index c092c8f..b6880c8 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
 #define __NR_mknod 				 36
 __SYSCALL( 36, sys_mknod, 3)
 #define __NR_pipe 				 37
-__SYSCALL( 37, xtensa_pipe, 1)
+__SYSCALL( 37, sys_pipe, 1)
 #define __NR_unlink 				 38
 __SYSCALL( 38, sys_unlink, 1)
 #define __NR_rmdir 				 39
diff --git a/arch/xtensa/kernel/syscall.c b/arch/xtensa/kernel/syscall.c
index ac15ecb..c7279be 100644
--- a/arch/xtensa/kernel/syscall.c
+++ b/arch/xtensa/kernel/syscall.c
@@ -39,24 +39,6 @@ syscall_t sys_call_table[__NR_syscall_count] /* FIXME __cacheline_aligned */= {
 #include <asm/unistd.h>
 };
 
-/*
- * xtensa_pipe() is the normal C calling standard for creating a pipe. It's not
- * the way unix traditional does this, though.
- */
-
-asmlinkage long xtensa_pipe(int __user *userfds)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe_flags(fd, 0);
-	if (!error) {
-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
 
 asmlinkage long xtensa_mmap2(unsigned long addr, unsigned long len,
    			     unsigned long prot, unsigned long flags,
