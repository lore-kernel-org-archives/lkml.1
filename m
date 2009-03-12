Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZCLHjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZCLHjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZCLHj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:39:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbZCLHjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:39:25 -0400
Date: Thu, 12 Mar 2009 00:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] Wrapper macros for struct task_struct and struct
 mm_struct cpumask transition
Message-Id: <20090312003709.1196ce15.akpm@linux-foundation.org>
In-Reply-To: <200903121745.23448.rusty@rustcorp.com.au>
References: <200903121436.53055.rusty@rustcorp.com.au>
	<200903121520.12245.nickpiggin@yahoo.com.au>
	<200903121745.23448.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 17:45:22 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 12 March 2009 14:50:11 Nick Piggin wrote:
> > On Thursday 12 March 2009 15:06:52 Rusty Russell wrote:
> > > Rusty Russell (2):
> > >       cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
> > >       cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.
> > >
> > >  include/linux/mm_types.h |    3 +++
> > >  include/linux/sched.h    |    3 +++

Please prefer to put the patches in the email if practical?  More
eyeballs and all that.

<goes fishing in linux-next>


: commit ccbc7af2a675bce8a9d4d3ab8e9c8a71a39d9158
: Author:     Rusty Russell <rusty@rustcorp.com.au>
: AuthorDate: Tue Mar 10 10:03:44 2009 +1100
: Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
: CommitDate: Tue Mar 10 10:03:44 2009 +1100
: 
:     cpumask:task_cpumask
:     
:     This allows us to change the representation (to a dangling bitmap)
:     without breaking all the callers: they can use tsk_cpumask() now and
:     won't see a difference as the changes roll into linux-next.
:     
:     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
: 
: diff --git a/include/linux/sched.h b/include/linux/sched.h
: index 8c216e0..011db2f 100644
: --- a/include/linux/sched.h
: +++ b/include/linux/sched.h
: @@ -1419,6 +1419,9 @@ struct task_struct {
:  #endif
:  };
:  
: +/* Future-safe accessor for struct task_struct's cpus_allowed. */
: +#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
: +
:  /*
:   * Priority of a process goes from 0..MAX_PRIO-1, valid RT
:   * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
: 
: 
: 
: commit 614e0176340928efb92cba676126048fdd466f0f
: Author:     Rusty Russell <rusty@rustcorp.com.au>
: AuthorDate: Tue Mar 10 10:03:44 2009 +1100
: Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
: CommitDate: Tue Mar 10 10:03:44 2009 +1100
: 
:     cpumask:mm_cpumask
:     
:     This allows us to change the representation (to a dangling bitmap)
:     without breaking all the callers: they can use mm_cpumask() now and
:     won't see a difference as the changes roll into linux-next.
:     
:     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
: 
: diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
: index 92915e8..d84feb7 100644
: --- a/include/linux/mm_types.h
: +++ b/include/linux/mm_types.h
: @@ -276,4 +276,7 @@ struct mm_struct {
:  #endif
:  };
:  
: +/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
: +#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
: +
:  #endif /* _LINUX_MM_TYPES_H */
: 


It would be pretty perverse to run tsk_cpumask() against a `struct
cpuset*', but your proposed implementation would merrily permit that
mistake.

Can we write the kernel in C please??


> And if the
> wrappers are in Linus' tree, it's easy to get the conversions into linux-next.

yup, the patches are quite safe and mergeable.  And if they'd been in the
email body, Linus might have seen that and pulled them ;)

