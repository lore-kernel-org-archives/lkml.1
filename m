Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbXHQIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbXHQIbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 04:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXHQIbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 04:31:32 -0400
Received: from ozlabs.org ([203.10.76.45]:37239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbXHQIbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 04:31:25 -0400
Subject: Re: [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
From: Rusty Russell <rusty@rustcorp.com.au>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>, Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46C54FB8.7050504@bull.net>
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>
	 <46C4725A.4070607@bull.net>  <46C4740F.2050701@bull.net>
	 <1187303955.6449.7.camel@localhost.localdomain> <46C54FB8.7050504@bull.net>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 18:30:50 +1000
Message-Id: <1187339450.6449.115.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 09:35 +0200, Laurent Vivier wrote:
> Rusty Russell wrote:
> > Hi Laurent,
> 
> Hi Rusty,
> how are your puppies ?

They're getting a little fat, actually.  Too many features ...

> - remove PATCH 3, and add in task_struct a "ktime vtime" where we accumulate
> guest time (by calling something like guest_enter() and guest_exit() from the
> virtualization engine), and when in account_system_time() we have cputime >
> vtime we substrate vtime from cputime and add vtime to user time and guest time.
> But doing like this we freeze in kernel/sched.c the link between system time,
> user time and guest time (i.e. system time = system time - vtime, user time =
> user time + vtime and guest time = guest time + vtime).

Actually, I think we can set a per-cpu "in_guest" flag for the scheduler
code, which then knows to add the tick to the guest time.  That seems
the simplest possible solution.

lguest or kvm would set the flag before running the guest (which is done
with preempt disabled or using preemption hooks), and reset it
afterwards.

Thoughts?
Rusty.

