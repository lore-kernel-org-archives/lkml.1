Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYI3AgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYI3AgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYI3AgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:36:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYI3AgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:36:11 -0400
Message-ID: <48E17363.7060103@zytor.com>
Date: Mon, 29 Sep 2008 17:31:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>	 <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>	 <48E1437D.7080606@zytor.com>  <48E1486C.3060306@goop.org> <1222733523.30247.91.camel@alok-dev1>
In-Reply-To: <1222733523.30247.91.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Sure, some leaves have been defined already, but it's not too late to
> try to go the generic route for the remaining leaves.
> The longer we wait to come to a consensus on generic leaves, the more
> contention we will have.  So let's try to address it now.  
> 

We don't have a quorum to create a consensus, since we only have a 
subset of the relevant parties present.

We can get away with that if we agree on a standard that includes 
postive definition.

> 1. This solution really bloats the kernel, below are few observations

You have no basis for that assertion.

> i)  What happens if two ABI signature blocks define a cpuid leaf which
> have similar semantics, how does the kernel handle this ?

We already have this situation in a number of places.  The answer is 
generally that there is one form that the kernel prefer over another (in 
CPUID space, leaf 80000006 over leaf 2, for example) because it is 
better designed/more reliable/mode complete.

> ii) Also, think about a case where a hypervisor supports 2 such ABI
> blocks - which have cpuid leafs with similar semantics - and decides to
> implement one of those and not the other leaf. How does the kernel
> handle this ?

The standard way to handle that in CPUID space is to leave the 
unimplemented leaf as zero.

> I do understand that there are ways to handle this in the kernel but at
> the cost of just making the kernel more and more complicated for such
> corner cases.

The complexity is relatively minor.

> 2. Also as a side note, what you are proposing just breaks down the
> problem in to sub-problems, i.e we still need to make sure that the
> individual cpuid leafs in the "block of leaves" are still generic. Also
> we may still have situations where hypervisor "A" wants to define a
> subset of cpuid block X, hypervisor B had defined.

It gives individual sub-APIs positive identification.  This is similar 
to PCI capabilities, for example.

> 3. All in all, the end result of doing this would be that each
> hypervisor defines its own signature block forgetting about what the
> other hypervisor is doing. This is hardly generalizing this space.
> 
> Seriously, if we want to generalize this in the current situation, how
> about doing this ? 
> 
> 1. Have 0x40000000 as the hypervisor signature leaf.
> 2. Have 0x40000001-0x4000000F as the hypervisor specific leafs.
> 3. 0x40000010 - 0x400000FF as the generic space. 
> Use the non-zero meaning defined semantics for this generic space. 

As I said, I don't think we have any kind of quorum to declare such a 
"standard", and we'll see violations with failures as a result.

	-hpa
