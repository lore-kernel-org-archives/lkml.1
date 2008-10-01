Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYJAVXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYJAVXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYJAVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:23:37 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34587 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbYJAVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:23:35 -0400
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and
	Linux.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <48E3E6DF.8060400@codemonkey.ws>
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org>
	 <1222894878.9381.63.camel@alok-dev1>  <48E3E6DF.8060400@codemonkey.ws>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 01 Oct 2008 14:23:35 -0700
Message-Id: <1222896215.9381.79.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 14:08 -0700, Anthony Liguori wrote:
> Alok Kataria wrote:
> > On Wed, 2008-10-01 at 11:04 -0700, Jeremy Fitzhardinge wrote:
> >
> > 2. Divergence in the interface provided by the hypervisors  :
> >       The reason we brought up a flat hierarchy is because we think we should
> > be moving towards a approach where the guest code doesn't diverge too
> > much when running under different hypervisors. That is the guest
> > essentially does the same thing if its running on say Xen or VMware.
> >
> > This design IMO, will take us a step backward to  what we already have
> > seen with para virt ops. Each hypervisor (mostly) defines its own cpuid
> > block, the guest correspondingly needs to have code to handle each of
> > these cpuid blocks, with these blocks will mostly being exclusive.
> >
> 
> What's wrong with what we have in paravirt_ops? 

Your explanation below answers the question you raised, the problem
being we need to have support for each of these different hypercall
mechanisms in the kernel. 
I understand that this was the correct thing to do at that moment. 
But do we want to go the same way again for CPUID when we can make it
generic (flat enough) for anybody to use it in the same manner and
expose a generic interface to the kernel.

>  Just agreeing on CPUID
> doesn't help very much. 
Yeah, nobody is removing any of the paravirt ops support.

>  You still need a mechanism for doing hypercalls
> to implement anything meaningful.  We aren't going to agree on a
> hypercall mechanism.  KVM uses direct hypercall instructions, Xen uses a
> hypercall page, VMware uses VMI, Hyper-V uses MSR writes.  We all have
> already defined the hypercall namespace in a certain way.

Thanks,
Alok


