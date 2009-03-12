Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZCLJNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZCLJNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZCLJNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:13:11 -0400
Received: from ozlabs.org ([203.10.76.45]:47567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbZCLJNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:13:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PULL] Wrapper macros for struct task_struct and struct mm_struct cpumask transition
Date: Thu, 12 Mar 2009 19:43:02 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200903121436.53055.rusty@rustcorp.com.au> <200903121745.23448.rusty@rustcorp.com.au> <20090312003709.1196ce15.akpm@linux-foundation.org>
In-Reply-To: <20090312003709.1196ce15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121943.02799.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 18:07:09 Andrew Morton wrote:
> On Thu, 12 Mar 2009 17:45:22 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
...
> Please prefer to put the patches in the email if practical?  More
> eyeballs and all that.

Hmm, yes.  Is there a preferred way of doing that with git request-pull?
Or just append the diff?

> : +/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
> : +#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
> : +
...
> It would be pretty perverse to run tsk_cpumask() against a `struct
> cpuset*', but your proposed implementation would merrily permit that
> mistake.
> 
> Can we write the kernel in C please??

You mean use an inline?  No, it's a bad idea for two reasons.  The minor
reason is that this macro is a temporary so it makes more sense to fix the
final version.

But the major one is const correctness.  Macros give a const value for
const input.  We can enhance the macro to check, but that's even uglier:

  static inline int check_is_task_struct(const struct task_struct *t) { }
  #define tsk_cpumask(t) (sizeof(check_is_task_struct(t)), &(t)->cpu_vm_mask)

> yup, the patches are quite safe and mergeable.  And if they'd been in the
> email body, Linus might have seen that and pulled them ;)

Probably not, as that's not what he complained about last time.  He might have
been enlightened by the commit messages tho.

Cheers,
Rusty.
