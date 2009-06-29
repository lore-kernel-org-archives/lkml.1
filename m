Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZF2KeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZF2KeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZF2KeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:34:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54526 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZF2KeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:34:06 -0400
Date: Mon, 29 Jun 2009 13:33:58 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       kvm@vger.kernel.org, avi@redhat.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v2] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629103358.GX20289@redhat.com>
References: <20090629100837.GW20289@redhat.com> <20090629102235.GA15372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629102235.GA15372@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 12:22:35PM +0200, Ingo Molnar wrote:
> 
> * Gleb Natapov <gleb@redhat.com> wrote:
> 
> > KVM would like to provide x2APIC interface to a guest without emulating
> > interrupt remapping device. The reason KVM prefers guest to use x2APIC
> > is that x2APIC interface is better virtualizable and provides better
> > performance than mmio xAPIC interface:
> > 
> > - msr exits are faster than mmio (no page table walk, emulation)
> > - no need to read back ICR to look at the busy bit
> > - one 64 bit ICR write instead of two 32 bit writes
> > - shared code with the Hyper-V paravirt interface
> > 
> > Included patch changes x2APIC enabling logic to enable it even if IR
> > initialization failed, but kernel runs under KVM and no apic id is
> > greater than 255 (if there is one spec requires BIOS to move to x2apic
> > mode before starting an OS).
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > ---
> > 
> > v2:
> >   Add help message to Kconfig
> >   Force physical mode if IR is not available.
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index d1430ef..3e5b6ea 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -260,12 +260,15 @@ config SMP
> >  
> >  config X86_X2APIC
> >  	bool "Support x2apic"
> > -	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
> > +	depends on X86_LOCAL_APIC && X86_64
> 
> Have you tried to build this with X86_X2APIC set but INTR_REMAP 
> disabled?
> 
Yes. I notice that X86_X2APIC depends on INTR_REMAP when I did it.

--
			Gleb.
