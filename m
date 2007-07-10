Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXGJBJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXGJBJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXGJBJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:09:24 -0400
Received: from ozlabs.org ([203.10.76.45]:44594 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbXGJBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:09:23 -0400
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <4691D82F.3030401@qumranet.com>
References: <11838994974161-git-send-email-avi@qumranet.com>
	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>
	 <20070708134850.GB22911@elte.hu>
	 <1183937563.6005.365.camel@localhost.localdomain>
	 <4691D82F.3030401@qumranet.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 11:09:04 +1000
Message-Id: <1184029745.6005.402.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 09:39 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> > I think a "struct preempt_ops *" and a "void *preempt_ops_data" inside
> > every task struct is a better idea.  Call the config option
> > PREEMPT_SCHED_HOOKS and now there's nothing kvm-specific about it...
> >   
> 
> I considered that, but your proposal does not allow a single task to
> have multiple preemption hooks installed (hookers?!).  Since in general
> there's no reason to suppose that users would be mutually exclusive, we
> need to have a struct hlist of these things.  All in all this seemed to
> indicate that the second user should have the honor of figuring out that
> stuff.

No; this is a "I'm doing something magic and need to know before someone
else takes the CPU".  Almost by definition, you cannot have two of them
at the same time.  Let someone else try that if and when...

But having different hooks for different tasks makes a great deal of
sense.  This hook makes a great deal of sense.

But KVM-specific code in the scheduler is just wrong, and I think we all
know that.

Cheers,
Rusty.

