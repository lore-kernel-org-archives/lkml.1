Return-Path: <linux-kernel-owner+w=401wt.eu-S1767621AbXCIXIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767621AbXCIXIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767623AbXCIXIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:08:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767621AbXCIXIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:08:21 -0500
Date: Sat, 10 Mar 2007 00:02:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309230249.GA31295@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <20070309221046.GV10574@sequoia.sous-sol.org> <20070309222435.GB24341@elte.hu> <20070309224640.GW10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309224640.GW10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> > ok, sure, how about the one i mentioned: long-term i'd like to have 
> > a paravirt model where the guest does not store /any/ page tables - 
> > all paging is managed by the hypervisor. The guest has a vma tree, 
> > but otherwise it does not process pagefaults, has no concept of a 
> > pte (if in paravirt mode), has no concept of kernel page tables 
> > either: there are hypercalls to allocate/free guest-kernel memory, 
> > etc. This needs some (serious) MM surgery but it's doable and it's 
> > interesting as well. How would you map this to the VMI backend?
> 
> Sounds a lot like a userspace process.  My immediate thought is, why 
> not use containers, a more natural fit.  [...]

easy: in my model the hypervisor is isolated from the guest kernel. In 
the container model it is not. [ This is a basic quality requirement for 
virtualization: a guest kernel does not get to read any hypervisor 
crypto keys to HD-DVD smut! ;-) ]

> [...] But if you have _any_ hope of booting this kernel on native 
> hardware when it's not running under a hypervisor then I'd expect the 
> same pv_ops interfaces that allow it to run on native would allow VMI 
> to build and handle the shadow (since you'd have taken it out of the 
> kernel).  Heh, so in order to run this on native we had to add 
> fork/mmap pv ops?  I agree it might be interesting, but it's still not 
> clear that it's useful w/out some code to back it up, and see the 
> value.

progress ;-) But yes, some /really/ high-level pv_ops would be needed.

[ in the end we might be able to simplify it down to a single hook! That 
  would be: run_native_image / run_guest_image ;-) ]

seriously, most of the body of x86 kernel code is in filesystems, VFS, 
networking, scheduler and the core kernel - much of which can be shared 
between native and guest. The MM is a significant and very central 
chunk, but it is less than 3% of the total codesize.

	Ingo
