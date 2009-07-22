Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZGVQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZGVQSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZGVQSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:18:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56005 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZGVQSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:18:11 -0400
Date: Wed, 22 Jul 2009 09:18:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kmemleak: Scan all thread stacks
Message-ID: <20090722161809.GH6757@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com> <20090717164346.GC5131@elte.hu> <1247849826.6313.64.camel@pc1117.cambridge.arm.com> <1247850069.6522.91.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247850069.6522.91.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 07:01:09PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-17 at 17:57 +0100, Catalin Marinas wrote:
> > On Fri, 2009-07-17 at 18:43 +0200, Ingo Molnar wrote:
> > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > 2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
> > > >    corresponding kernel stack (thread_info structure)? The loop doesn't
> > > >    do any modification to the task list. The reason for this is to
> > > >    allow kernel preemption when scanning the stacks.
> > > 
> > > you cannot generally preempt while holding the RCU read-lock.
> > 
> > This may work with rcupreempt enabled. But, with classic RCU is it safe
> > to call schedule (or cond_resched) while holding the RCU read-lock?
> 
> No.

What Peter said!  ;-)

However, you might be able to use SRCU (http://lwn.net/Articles/202847/),
which does allow blocking within read-side critical sections.

							Thanx, Paul
