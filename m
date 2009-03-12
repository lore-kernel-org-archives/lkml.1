Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZCLHPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZCLHPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZCLHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:15:30 -0400
Received: from ozlabs.org ([203.10.76.45]:59725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbZCLHP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:15:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PULL] Wrapper macros for struct task_struct and struct mm_struct cpumask transition
Date: Thu, 12 Mar 2009 17:45:22 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200903121436.53055.rusty@rustcorp.com.au> <200903121520.12245.nickpiggin@yahoo.com.au>
In-Reply-To: <200903121520.12245.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121745.23448.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 14:50:11 Nick Piggin wrote:
> On Thursday 12 March 2009 15:06:52 Rusty Russell wrote:
> > Rusty Russell (2):
> >       cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
> >       cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.
> >
> >  include/linux/mm_types.h |    3 +++
> >  include/linux/sched.h    |    3 +++
> 
> What's the transition?

Generally, cpumask_t to cpumask_var_t, ie. a struct cpumask [1] normally,
or a struct cpumask * for CONFIG_CPUMASK_OFFSTACK=y (currently x86 only).

In these cases though, we're allocating them anyway so it makes more sense to
do a dangling bitmap at the end of the struct (and only allocate nr_cpu_ids
bits when CONFIG_CPUMASK_OFFSTACK=y).

I had a patch which used a const struct cpumask * for task_struct: we only
ever replace the whole thing, so we can often use the standard cpu_mask_all
or cpumask_of() and only allocate when it's set to something else.  But
the code was pretty ugly.

Anyway, it's a trivial to change if people use the wrappers.  And if the
wrappers are in Linus' tree, it's easy to get the conversions into linux-next.

Cheers,
Rusty.
