Return-Path: <linux-kernel-owner+w=401wt.eu-S1767584AbXCIWr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767584AbXCIWr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbXCIWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:47:26 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:48963 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933413AbXCIWrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:47:25 -0500
Date: Fri, 9 Mar 2007 14:46:40 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309224640.GW10574@sequoia.sous-sol.org>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <20070309221046.GV10574@sequoia.sous-sol.org> <20070309222435.GB24341@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309222435.GB24341@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> * Chris Wright <chrisw@sous-sol.org> wrote:
> > i'm not really one to argue on behalf of VMI, but i don't think it's 
> > as dire make it out. [...]
> 
> hey, that's what i thought when i helped do the vDSO, until i got 
> slapped with cold reality called "CONFIG_COMPAT_VDSO". I'm a bit more 
> careful about ABIs since then =B-)

heh, once bitten twice shy, or however that goes ;-)

> > [...] the VMI is client code of pv_ops, and as the kernel changes that 
> > client code will simply have to adapt.  of course there are 
> > theoretical limitations, but let's keep it grounded to practical 
> > reality. the whole premise is evolution.  so throw out specific 
> > issues, and let's adapt rather than fall deep into theoretical 
> > rhetoric.
> 
> ok, sure, how about the one i mentioned: long-term i'd like to have a 
> paravirt model where the guest does not store /any/ page tables - all 
> paging is managed by the hypervisor. The guest has a vma tree, but 
> otherwise it does not process pagefaults, has no concept of a pte (if in 
> paravirt mode), has no concept of kernel page tables either: there are 
> hypercalls to allocate/free guest-kernel memory, etc. This needs some 
> (serious) MM surgery but it's doable and it's interesting as well. How 
> would you map this to the VMI backend?

Sounds a lot like a userspace process.  My immediate thought is, why
not use containers, a more natural fit.  But if you have _any_ hope
of booting this kernel on native hardware when it's not running under
a hypervisor then I'd expect the same pv_ops interfaces that allow it
to run on native would allow VMI to build and handle the shadow (since
you'd have taken it out of the kernel).  Heh, so in order to run this on
native we had to add fork/mmap pv ops?  I agree it might be interesting,
but it's still not clear that it's useful w/out some code to back it up,
and see the value.

thanks,
-chris
