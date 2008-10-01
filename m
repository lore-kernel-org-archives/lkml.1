Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYJAVRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYJAVRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYJAVR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:17:26 -0400
Received: from gw.goop.org ([64.81.55.164]:44429 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYJAVRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:17:25 -0400
Message-ID: <48E3E8DE.1080602@goop.org>
Date: Wed, 01 Oct 2008 14:17:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: akataria@vmware.com
CC: "avi@redhat.com" <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and	Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1>
In-Reply-To: <1222894878.9381.63.camel@alok-dev1>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 1. Kernel complexity : Just thinking about the complexity that this will
> put in the kernel to handle these multiple ABI signatures and scanning
> all of these leaf block's is difficult to digest.
>   

The scanning for the signatures is trivial; it's not a significant 
amount of code.  Actually implementing them is a different matter, but 
that's the same regardless of where they are placed or how they're 
discovered.  After discovery its the same either way: there's a leaf 
base with offsets from it.

> 2. Divergence in the interface provided by the hypervisors  : 
> 	The reason we brought up a flat hierarchy is because we think we should
> be moving towards a approach where the guest code doesn't diverge too
> much when running under different hypervisors. That is the guest
> essentially does the same thing if its running on say Xen or VMware.
>   

I guess, but the bulk of the uses of this stuff are going to be 
hypervisor-specific.  You're hard-pressed to come up with any other 
generic uses beyond tsc.  In general, if a hypervisor is going to put 
something in a special cpuid leaf, its because there's no other good way 
to represent it.  Generic things are generally going to appear as an 
emulated piece of the virtualized platform, in ACPI, DMI, a 
hardware-defined cpuid leaf, etc...

> 3. Is their a need to do all this over engineering : 
> 	Aren't we over engineering a simple interface over here. The point is,
> there are right now 256 cpuid leafs do we realistically think we are
> ever going to exhaust all these leafs. We are really surprised to know
> that people may think this space is small enough. It would be
> interesting to know what all use you might want to put cpuid for.
>   

Look, if you want to propose a way to use that cpuid space in a 
reasonably flexible way that allows it to be used as the need arises, 
then we can talk about it.  But I think your proposal is a poor way to 
achieve those ends

If you want blessing for something that you've already implemented and 
shipped, well, you don't need anyone's blessing for that.

    J
