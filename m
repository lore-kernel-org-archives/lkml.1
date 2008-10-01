Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYJAVKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYJAVKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYJAVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:09:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:60487 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYJAVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:09:54 -0400
Message-ID: <48E3E6DF.8060400@codemonkey.ws>
Date: Wed, 01 Oct 2008 16:08:47 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <1222894878.9381.63.camel@alok-dev1>
In-Reply-To: <1222894878.9381.63.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> On Wed, 2008-10-01 at 11:04 -0700, Jeremy Fitzhardinge wrote:
>   
> 2. Divergence in the interface provided by the hypervisors  : 
> 	The reason we brought up a flat hierarchy is because we think we should
> be moving towards a approach where the guest code doesn't diverge too
> much when running under different hypervisors. That is the guest
> essentially does the same thing if its running on say Xen or VMware.
>
> This design IMO, will take us a step backward to  what we already have
> seen with para virt ops. Each hypervisor (mostly) defines its own cpuid
> block, the guest correspondingly needs to have code to handle each of
> these cpuid blocks, with these blocks will mostly being exclusive.
>   

What's wrong with what we have in paravirt_ops?  Just agreeing on CPUID 
doesn't help very much.  You still need a mechanism for doing hypercalls 
to implement anything meaningful.  We aren't going to agree on a 
hypercall mechanism.  KVM uses direct hypercall instructions, Xen uses a 
hypercall page, VMware uses VMI, Hyper-V uses MSR writes.  We all have 
already defined the hypercall namespace in a certain way.

We've already gone down the road of trying to make standard paravirtual 
interfaces (via virtio).  No one was sufficiently interested in 
collaborating.  I don't see why other paravirtualizations are going to 
be much different.

Regards,

Anthony Liguori
