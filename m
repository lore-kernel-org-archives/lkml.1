Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXI1MWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXI1MWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXI1MV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:21:58 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38188 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbXI1MV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:21:57 -0400
Date: Fri, 28 Sep 2007 14:21:54 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 01/12] lockdep: syscall exit check
Message-ID: <20070928122154.GD25726@osiris.boeblingen.de.ibm.com>
References: <20070928074200.436463000@chello.nl> <20070928080040.893443000@chello.nl> <20070928120331.GC25726@osiris.boeblingen.de.ibm.com> <1190981651.13204.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190981651.13204.6.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 02:14:11PM +0200, Peter Zijlstra wrote:
> On Fri, 2007-09-28 at 14:03 +0200, Heiko Carstens wrote:
> > > +void lockdep_sys_exit(void)
> > > +{
> > > +	struct task_struct *curr = current;
> > > +
> > > +	if (unlikely(curr->lockdep_depth)) {
> > > +		if (!debug_locks_off())
> > > +			return;
> > > +		printk("\n========================================\n");
> > > +		printk(  "[ BUG: lock held at syscall exit time! ]\n");
> > > +		printk(  "----------------------------------------\n");
> > > +		printk("%s/%d is leaving the kernel with locks still held!\n",
> > > +				curr->comm, curr->pid);
> > > +		lockdep_print_held_locks(curr);
> > > +	}
> > > +}
> > 
> > By the way, the s390 patch I just posted also checks if we hold any locks
> > when returning from interrupt context to user space. Maybe the above text
> > could be changed to "lock held when returning to user space" ?
> 
> Good idea, I'll look at doing the same for i386/x86_64. Traps (page
> faults) would also make sense I guess.

Yes, traps and syscalls have the same exit path on s390. So we do that
alreasy as well.
