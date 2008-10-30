Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYJ3Uwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYJ3Uwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYJ3Uwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:52:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYJ3Uwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:52:45 -0400
Date: Thu, 30 Oct 2008 21:52:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: next-20081030: voyager compile busted
Message-ID: <20081030205230.GO27407@elte.hu>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au> <20081030180323.GA13399@x200.localdomain> <1225398287.19324.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225398287.19324.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-10-30 at 21:03 +0300, Alexey Dobriyan wrote:
> > On i386-voyager:
> > 
> >   Using /src/linux-1 as source for kernel
> >   GEN     /src/build/i386-voyager/Makefile
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   SYMLINK include/asm -> include/asm-x86
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/linux/compile.h
> >   CC      arch/x86/kernel/tsc.o
> > arch/x86/kernel/tsc.c: In function 'unsynchronized_tsc':
> > arch/x86/kernel/tsc.c:763: error: implicit declaration of function 'apic_is_clustered_box'
> > make[2]: *** [arch/x86/kernel/tsc.o] Error 1
> >   CC      arch/x86/kernel/cpu/addon_cpuid_features.o
> > arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> > arch/x86/kernel/cpu/addon_cpuid_features.c:120: error: implicit declaration of function 'phys_pkg_id'
> > make[3]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> > make[3]: Target `__build' not remade because of errors.
> > make[2]: *** [arch/x86/kernel/cpu] Error 2
> > make[2]: Target `__build' not remade because of errors.
> > make[1]: *** [arch/x86/kernel] Error 2
> >   CC      arch/x86/mach-voyager/setup.o
> > arch/x86/mach-voyager/setup.c: In function 'intr_init_hook':
> > arch/x86/mach-voyager/setup.c:30: error: implicit declaration of function 'smp_intr_init'
> > arch/x86/mach-voyager/setup.c: In function 'machine_specific_memory_setup':
> > arch/x86/mach-voyager/setup.c:65: warning: unused variable 'new_nr'
> > make[2]: *** [arch/x86/mach-voyager/setup.o] Error 1
> >   CC      arch/x86/mach-voyager/voyager_smp.o
> > arch/x86/mach-voyager/voyager_smp.c:67: error: conflicting types for 'phys_cpu_present_map'
> > arch/x86/include/asm/mpspec.h:143: error: previous declaration of 'phys_cpu_present_map' was here
> > arch/x86/mach-voyager/voyager_smp.c: In function 'start_secondary':
> > arch/x86/mach-voyager/voyager_smp.c:444: error: implicit declaration of function 'notify_cpu_starting'
> > arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_interrupt':
> > arch/x86/mach-voyager/voyager_smp.c:955: error: implicit declaration of function 'generic_smp_call_function_interrupt'
> > arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_single_interrupt':
> > arch/x86/mach-voyager/voyager_smp.c:963: error: implicit declaration of function 'generic_smp_call_function_single_interrupt'
> > make[2]: *** [arch/x86/mach-voyager/voyager_smp.o] Error 1
> > make[2]: Target `__build' not remade because of errors.
> > make[1]: *** [arch/x86/mach-voyager] Error 2
> 
> Yes ... present in the 2.6.28-rc as well.  I've got it all fixed up
> locally.
>
> This type of breakage is more or less expected given that I wait 
> until -rc1 for the tree to stop churning before trying to fix 
> voyager and the subarchitectures, and the fact that the current way 
> x86 is being developed tends to break them.

one problem is the number of x86/Voyager testboxes - how many of them 
is there in existence - one or two, all of them owned by you?

the other problem is that you are apparently checking whether 
x86/Voyager builds (boots?) at all only once every couple of months - 
once per kernel cycle or so. That obviously means you'll be affected 
by an accumulated set of bugs. Nobody else _can_ test it instead of 
you, because no other kernel hacker owns this hardware.

So ... the right long-term way out of this is to do what we did with 
all the other x86 subarchitectures: to convert Voyager into a generic 
platform, via extension of the x86_quirks interfaces. That way we can 
remove the remainder of the fragile "x86 subarchitecture" concept. 
(which should never have been added to begin with)

Would you be interested in helping us out with such a project? It 
would be a nice cleanup for sure.

	Ingo
