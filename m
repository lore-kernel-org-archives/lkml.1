Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbXGHXdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbXGHXdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbXGHXdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:33:00 -0400
Received: from ozlabs.org ([203.10.76.45]:49571 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbXGHXc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:32:59 -0400
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070708134850.GB22911@elte.hu>
References: <11838994974161-git-send-email-avi@qumranet.com>
	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>
	 <20070708134850.GB22911@elte.hu>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 09:32:43 +1000
Message-Id: <1183937563.6005.365.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-08 at 15:48 +0200, Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
> 
> > >>+#ifdef CONFIG_SCHED_KVM
> > >>+static __read_mostly struct sched_kvm_hooks kvm_hooks;
> > >>+#endif
> > >
> > >please just add a current->put_vcpu() function pointer instead of 
> > >this hooks thing.
> > 
> > Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
> > The function pointers are common to all virtual machines.
> 
> well, this function pointer could then be reused by other virtual 
> machines as well, couldnt it? If the task struct overhead is a problem 
> (it really isnt, and it's dependent on CONFIG_KVM) then we could switch 
> it around to a notifier-alike mechanism.

OK, this patch is *ugly*.  Not that there's anything wrong with a patch
which says "I'm going to preempt you", but making it kvm-specific is
ugly.  ISTR times past where I wanted such a hook, although none spring
immediately into my pre-coffee brain.

I think a "struct preempt_ops *" and a "void *preempt_ops_data" inside
every task struct is a better idea.  Call the config option
PREEMPT_SCHED_HOOKS and now there's nothing kvm-specific about it...

Cheers,
Rusty.


