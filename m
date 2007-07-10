Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbXGJGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbXGJGsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbXGJGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:47:54 -0400
Received: from ozlabs.org ([203.10.76.45]:34165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbXGJGrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:47:53 -0400
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <46931ECB.2060601@qumranet.com>
References: <11838994974161-git-send-email-avi@qumranet.com>
	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>
	 <20070708134850.GB22911@elte.hu>
	 <1183937563.6005.365.camel@localhost.localdomain>
	 <4691D82F.3030401@qumranet.com>
	 <1184029745.6005.402.camel@localhost.localdomain>
	 <46931ECB.2060601@qumranet.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 16:47:35 +1000
Message-Id: <1184050055.6005.523.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 08:53 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> > No; this is a "I'm doing something magic and need to know before someone
> > else takes the CPU".  Almost by definition, you cannot have two of them
> > at the same time.  Let someone else try that if and when...
> 
> Why can't you have two of them?  Say I'm writing a module to utilize
> branch recording to be able to debug a process in reverse (of course
> that doesn't really need sched hooks; let's pretend it does).  Why can't
> I debug a process that uses kvm?
>
> More importantly, now the two subsystems have to know about each other
> so they don't step on each other's toes.

Exactly, if we have two at the same time, they need to know about each
other.  Providing infrastructure which lets them avoid thinking about it
is the wrong direction.

> > But KVM-specific code in the scheduler is just wrong, and I think we all
> > know that.
> 
> Even if I eradicate all mention of kvm from the patch, it's still kvm
> specific.  kvm at least is sensitive to the exact point where we switch
> in (it wants interrupts enabled) and it expects certain parameters to
> the callbacks.  If $new_abuser needs other conditions or parameters,
> which is quite likely IMO as it will most likely have to do with
> hardware, then we will need to update the hooks anyway.

If it's not general, then this whole approach is wrong: put it in
arch/*/kernel/process.c:__switch_to and finish_arch_switch.  The
congruent case which comes to mind is lazy FPU handling.

Which brings us to the question: why do you want interrupts enabled?

Cheers,
Rusty.

