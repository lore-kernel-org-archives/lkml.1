Return-Path: <linux-kernel-owner+w=401wt.eu-S1767521AbXCITwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767521AbXCITwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767525AbXCITwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:52:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46292 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767521AbXCITwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:52:19 -0500
Date: Fri, 9 Mar 2007 11:51:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
In-Reply-To: <20070309192420.GA27747@elte.hu>
Message-ID: <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org>
References: <20070309180230.GA17988@elte.hu>
 <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
 <20070309192420.GA27747@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Ingo Molnar wrote:
> 
> Unfortunately i still dont see where i'm wrong, and i'm really trying to 
> understand your argument. Is your argument that as long as an ABI (VMI) 
> is never directly used but only used via wrapper functions 
> (paravirt_ops)

No.

My argument is utternly and *purely* that you've been confusing the 
discussion by using the wrong terms, and as a result, you've been 
discussing things that aren't *relevant*.

You haven't been saying anything constructive.

For example, here's a *constructive* thing you could have said, and never 
actually did:

 - paravirt_op->write_apic should not exist

   anything that needs to write to the apic should ether

    (a) have been caught much earlier in the paravirt stack, ie it's a 
	"disable interrupt" kind of operation, and should never even have 
	gotten to the APIC write in the first place, but been handled by 
	the paravirtualized handler.
    (b) just be emulated as an APIC write (and if the emulation isn't good 
	enough, screw it)

In other words, to be *constructive*, you need to point out particular 
and practical problem spots, instead of just ranting about any 
"paravirtualized ABI".

Of *course* there is an ABI at some point behind any API. Why do you harp 
on that? It's irrelevant. Any API will always end up being instantiated 
into a binary thing at some point, and that binary thing will have to work 
with some particular version of a hardware/infrastructure combination, but 
that has *nothing* to do with anything.

The x86 instruction set is an ABI. Our API's eventually tend to be 
compiled to something like that ABI, and yes, some ABI's may not be able 
to do certain things. For example, on the 32-bit x86 ABI, there are no 
interfaces for address space identifiers, and the wrappers become a no-op 
that just don't do anything, and if you want fast context switches between 
two contexts, you're screwed.

Similarly, maybe the VMI ABI doesn't allow for something that the kernel 
wants to do efficiently. Big deal. What relevance does that have to do 
with anything, except the fact that if true, the VMWare people are 
screwed? It's *their* problem.

So please

 - point out things that are badly done. I agree that apic_write() simply 
   shouldn't be an ABI point at all. But do so *directly* without some 
   ranting about other things that aren't relevant. Your "1400 hooks" rant 
   was pointless - there aren't 1400 hooks at all. There are 1400 
   call-sites, but that's like saying that the "mov" operation is a bad 
   instruction, because there are 5 million mov instructions in the 
   kernel.

 - Realize that if VMI has problems, it's not *your* problem, or even the
   kernels problem. It's purely a VMI problem. I don't understand why you 
   care, or why you think we should care.

 - and I guess we can also stop cc'ing me in the first place. I don't even 
   think virtualization is very interesting. I'd much rather flame people 
   about bad taste in more important areas ;)

Thanks,

				Linus
