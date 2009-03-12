Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZCLJ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZCLJ05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZCLJ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:26:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbZCLJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:26:47 -0400
Date: Thu, 12 Mar 2009 02:24:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] Wrapper macros for struct task_struct and struct
 mm_struct cpumask transition
Message-Id: <20090312022445.354af358.akpm@linux-foundation.org>
In-Reply-To: <200903121943.02799.rusty@rustcorp.com.au>
References: <200903121436.53055.rusty@rustcorp.com.au>
	<200903121745.23448.rusty@rustcorp.com.au>
	<20090312003709.1196ce15.akpm@linux-foundation.org>
	<200903121943.02799.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 19:43:02 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 12 March 2009 18:07:09 Andrew Morton wrote:
> > On Thu, 12 Mar 2009 17:45:22 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> ...
> > Please prefer to put the patches in the email if practical?  More
> > eyeballs and all that.
> 
> Hmm, yes.  Is there a preferred way of doing that with git request-pull?
> Or just append the diff?

You're asking me about git?

> > : +/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
> > : +#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
> > : +
> ...
> > It would be pretty perverse to run tsk_cpumask() against a `struct
> > cpuset*', but your proposed implementation would merrily permit that
> > mistake.
> > 
> > Can we write the kernel in C please??
> 
> You mean use an inline?  No, it's a bad idea for two reasons.  The minor
> reason is that this macro is a temporary so it makes more sense to fix the
> final version.
> 
> But the major one is const correctness.  Macros give a const value for
> const input.

hm.  Sounds weaselly.

>  We can enhance the macro to check, but that's even uglier:
> 
>   static inline int check_is_task_struct(const struct task_struct *t) { }
>   #define tsk_cpumask(t) (sizeof(check_is_task_struct(t)), &(t)->cpu_vm_mask)

include/linux/typecheck.h has help?

> > yup, the patches are quite safe and mergeable.  And if they'd been in the
> > email body, Linus might have seen that and pulled them ;)
> 
> Probably not, as that's not what he complained about last time.

Linus?  Complain?

>  He might have
> been enlightened by the commit messages tho.

