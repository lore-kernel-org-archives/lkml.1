Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYJ3VWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYJ3VWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbYJ3VVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:21:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:63034 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbYJ3VVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LZuWyej/8R3GrhoSPZ9UweUFbEGqB5z9bYNTDjaS4ZWLdATAkqSFWovLxGkA9M+/k8
         v6c6oEHcsm7dZ2K6j7aySGHpUZvVcKbHJwTez5uVXYhrBNjAcTXPfnxTbIDDaPkD0JuF
         ti+bRYs8CxlEnAzHiOG0rKaFNACyvqxk8yzRk=
Date: Fri, 31 Oct 2008 00:24:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: next-20081030: voyager compile busted
Message-ID: <20081030212455.GA14580@x200.localdomain>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au> <20081030180323.GA13399@x200.localdomain> <1225398287.19324.1.camel@localhost.localdomain> <20081030205230.GO27407@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030205230.GO27407@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 09:52:30PM +0100, Ingo Molnar wrote:
> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Thu, 2008-10-30 at 21:03 +0300, Alexey Dobriyan wrote:
> > > On i386-voyager:
> > > 
> > >   Using /src/linux-1 as source for kernel
> > >   GEN     /src/build/i386-voyager/Makefile
> > >   CHK     include/linux/version.h
> > >   CHK     include/linux/utsrelease.h
> > >   SYMLINK include/asm -> include/asm-x86
> > >   CALL    scripts/checksyscalls.sh
> > >   CHK     include/linux/compile.h
> > >   CC      arch/x86/kernel/tsc.o
> > > arch/x86/kernel/tsc.c: In function 'unsynchronized_tsc':
> > > arch/x86/kernel/tsc.c:763: error: implicit declaration of function 'apic_is_clustered_box'
> > > make[2]: *** [arch/x86/kernel/tsc.o] Error 1
> > >   CC      arch/x86/kernel/cpu/addon_cpuid_features.o
> > > arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> > > arch/x86/kernel/cpu/addon_cpuid_features.c:120: error: implicit declaration of function 'phys_pkg_id'
> > > make[3]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> > > make[3]: Target `__build' not remade because of errors.
> > > make[2]: *** [arch/x86/kernel/cpu] Error 2
> > > make[2]: Target `__build' not remade because of errors.
> > > make[1]: *** [arch/x86/kernel] Error 2
> > >   CC      arch/x86/mach-voyager/setup.o
> > > arch/x86/mach-voyager/setup.c: In function 'intr_init_hook':
> > > arch/x86/mach-voyager/setup.c:30: error: implicit declaration of function 'smp_intr_init'
> > > arch/x86/mach-voyager/setup.c: In function 'machine_specific_memory_setup':
> > > arch/x86/mach-voyager/setup.c:65: warning: unused variable 'new_nr'
> > > make[2]: *** [arch/x86/mach-voyager/setup.o] Error 1
> > >   CC      arch/x86/mach-voyager/voyager_smp.o
> > > arch/x86/mach-voyager/voyager_smp.c:67: error: conflicting types for 'phys_cpu_present_map'
> > > arch/x86/include/asm/mpspec.h:143: error: previous declaration of 'phys_cpu_present_map' was here
> > > arch/x86/mach-voyager/voyager_smp.c: In function 'start_secondary':
> > > arch/x86/mach-voyager/voyager_smp.c:444: error: implicit declaration of function 'notify_cpu_starting'
> > > arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_interrupt':
> > > arch/x86/mach-voyager/voyager_smp.c:955: error: implicit declaration of function 'generic_smp_call_function_interrupt'
> > > arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_single_interrupt':
> > > arch/x86/mach-voyager/voyager_smp.c:963: error: implicit declaration of function 'generic_smp_call_function_single_interrupt'
> > > make[2]: *** [arch/x86/mach-voyager/voyager_smp.o] Error 1
> > > make[2]: Target `__build' not remade because of errors.
> > > make[1]: *** [arch/x86/mach-voyager] Error 2

> Would you be interested in helping us out with such a project? It 
> would be a nice cleanup for sure.

Meanwhile, voyager compilation can be tested with the following
KCONFIG_ALLCONFIG file (suppy CROSS_COMPILE if necessary):

	CONFIG_X86_VOYAGER=y
	# CONFIG_PCI is not set

	make ARCH=i386 KCONFIG_ALLCONFIG=... allmodconfig
	make ARCH=i386
