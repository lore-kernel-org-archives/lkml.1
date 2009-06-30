Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZF3TDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZF3TDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZF3TDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:03:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZF3TDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:03:07 -0400
Date: Tue, 30 Jun 2009 22:03:07 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090630190307.GE8122@redhat.com>
References: <20090629132926.GB20289@redhat.com> <m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com> <m1eit1acxl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eit1acxl.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 09:44:54AM -0700, Eric W. Biederman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> 
> > On Tue, Jun 30, 2009 at 02:24:05AM -0700, Eric W. Biederman wrote:
> >> Gleb Natapov <gleb@redhat.com> writes:
> >> 
> >> > KVM would like to provide x2APIC interface to a guest without emulating
> >> > interrupt remapping device. The reason KVM prefers guest to use x2APIC
> >> > is that x2APIC interface is better virtualizable and provides better
> >> > performance than mmio xAPIC interface:
> >> >
> >> > - msr exits are faster than mmio (no page table walk, emulation)
> >> > - no need to read back ICR to look at the busy bit
> >> > - one 64 bit ICR write instead of two 32 bit writes
> >> > - shared code with the Hyper-V paravirt interface
> >> >     
> >> > Included patch changes x2APIC enabling logic to enable it even if IR
> >> > initialization failed, but kernel runs under KVM and no apic id is
> >> > greater than 255 (if there is one spec requires BIOS to move to x2apic
> >> > mode before starting an OS).
> >> 
> >> 
> >> How common is hotplug hardware in kvm?  In particular hotplug cpus?
> >> 
> > It works for Linux guests.
> 
> >
> >> To support that seriously you need interrupt remapping.
> >> 
> > Can you explain why?
> 
> Because ioapics don't fully function according to spec,
> and the interrupt code on the hotplug path is a horrible
> terrible broken hack for ioapics.
> 
Considering that interrupt remapping is fairly new feature
are you saying that hotplug (pci and cpu) on x86 is a horrible
hack on Linux?

> It is better than nothing but it certainly is not something
> I would expect to work all of the time.
> 
Because of horrible code or non-complaint ioapic implementation out
there? If later this is not a big issue for KVM.

> Interrupt remapping is the one case where we have hardware
> that works according to spec and that works reasonably well.
> 
I am sure when there was only one ioapic implementation in existence
it worked according to a spec (and if not spec was changed :)) Give
interrupt remapping some time and than we will see how above statement
holds.

--
			Gleb.
