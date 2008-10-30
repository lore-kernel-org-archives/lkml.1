Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYJ3VH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYJ3VH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYJ3VHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:07:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbYJ3VHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:07:19 -0400
Date: Thu, 30 Oct 2008 22:07:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: next-20081030: voyager compile busted
Message-ID: <20081030210704.GA25665@elte.hu>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au> <20081030180323.GA13399@x200.localdomain> <1225398287.19324.1.camel@localhost.localdomain> <20081030205230.GO27407@elte.hu> <1225400283.19324.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225400283.19324.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-10-30 at 21:52 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Thu, 2008-10-30 at 21:03 +0300, Alexey Dobriyan wrote:
> > > > On i386-voyager:
> > > > 
> > > >   Using /src/linux-1 as source for kernel
> > > >   GEN     /src/build/i386-voyager/Makefile
> > > >   CHK     include/linux/version.h
> > > >   CHK     include/linux/utsrelease.h
> > > >   SYMLINK include/asm -> include/asm-x86
> > > >   CALL    scripts/checksyscalls.sh
> > > >   CHK     include/linux/compile.h
> > > >   CC      arch/x86/kernel/tsc.o
> > > > arch/x86/kernel/tsc.c: In function 'unsynchronized_tsc':
> > > > arch/x86/kernel/tsc.c:763: error: implicit declaration of function 'apic_is_clustered_box'
> > > > make[2]: *** [arch/x86/kernel/tsc.o] Error 1
> > > >   CC      arch/x86/kernel/cpu/addon_cpuid_features.o
> > > > arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> > > > arch/x86/kernel/cpu/addon_cpuid_features.c:120: error: implicit declaration of function 'phys_pkg_id'
> > > > make[3]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> > > > make[3]: Target `__build' not remade because of errors.
> > > > make[2]: *** [arch/x86/kernel/cpu] Error 2
> > > > make[2]: Target `__build' not remade because of errors.
> > > > make[1]: *** [arch/x86/kernel] Error 2
> > > >   CC      arch/x86/mach-voyager/setup.o
> > > > arch/x86/mach-voyager/setup.c: In function 'intr_init_hook':
> > > > arch/x86/mach-voyager/setup.c:30: error: implicit declaration of function 'smp_intr_init'
> > > > arch/x86/mach-voyager/setup.c: In function 'machine_specific_memory_setup':
> > > > arch/x86/mach-voyager/setup.c:65: warning: unused variable 'new_nr'
> > > > make[2]: *** [arch/x86/mach-voyager/setup.o] Error 1
> > > >   CC      arch/x86/mach-voyager/voyager_smp.o
> > > > arch/x86/mach-voyager/voyager_smp.c:67: error: conflicting types for 'phys_cpu_present_map'
> > > > arch/x86/include/asm/mpspec.h:143: error: previous declaration of 'phys_cpu_present_map' was here
> > > > arch/x86/mach-voyager/voyager_smp.c: In function 'start_secondary':
> > > > arch/x86/mach-voyager/voyager_smp.c:444: error: implicit declaration of function 'notify_cpu_starting'
> > > > arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_interrupt':
> > > > arch/x86/mach-voyager/voyager_smp.c:955: error: implicit declaration of function 'generic_smp_call_function_interrupt'
> > > > arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_single_interrupt':
> > > > arch/x86/mach-voyager/voyager_smp.c:963: error: implicit declaration of function 'generic_smp_call_function_single_interrupt'
> > > > make[2]: *** [arch/x86/mach-voyager/voyager_smp.o] Error 1
> > > > make[2]: Target `__build' not remade because of errors.
> > > > make[1]: *** [arch/x86/mach-voyager] Error 2
> > > 
> > > Yes ... present in the 2.6.28-rc as well.  I've got it all fixed up
> > > locally.
> > >
> > > This type of breakage is more or less expected given that I wait 
> > > until -rc1 for the tree to stop churning before trying to fix 
> > > voyager and the subarchitectures, and the fact that the current way 
> > > x86 is being developed tends to break them.
> > 
> > one problem is the number of x86/Voyager testboxes - how many of them 
> > is there in existence - one or two, all of them owned by you?
> > 
> > the other problem is that you are apparently checking whether 
> > x86/Voyager builds (boots?) at all only once every couple of months - 
> > once per kernel cycle or so. That obviously means you'll be affected 
> > by an accumulated set of bugs. Nobody else _can_ test it instead of 
> > you, because no other kernel hacker owns this hardware.
> > 
> > So ... the right long-term way out of this is to do what we did with 
> > all the other x86 subarchitectures: to convert Voyager into a generic 
> > platform, via extension of the x86_quirks interfaces. That way we can 
> > remove the remainder of the fragile "x86 subarchitecture" concept. 
> > (which should never have been added to begin with)
> > 
> > Would you be interested in helping us out with such a project? It 
> > would be a nice cleanup for sure.
> 
> Sure, I'd be interested in looking into that.
> 
> However, it won't help the problems since they're mostly compile 
> breakages caused by tampering with the HAL API for x86 and not 
> seeing that this affects various subarches. [...]

it would fix that problem largely because we'd no longer have such 
'HAL API' - we'd have runtime differences and function pointers.

> [...]  Moving voyager to a quirk wouldn't fix that problem.

btw., Voyager would not be a "quirk" (putting it that way looks a bit 
derogatory perhaps) - instead it would be a regular x86 platform, with 
a couple of quirk handlers to handle Voyager specialities.

Look at how CONFIG_X86_VISWS works today for example: that option only 
activates the quirk handlers - and a VISWS bzImage will boot fine on a 
regular PC. This is a far more powerful way of handling x86 hardware 
deviations than a full build-time thing. It makes it also far easier 
to test - while we cannot test the _quirks_, we can easily test the 
build and still boot it on regular PCs. (which makes it far more 
likely for people to enable this option)

This principle was followed for all the x86 subarchitectures we've 
converted already: visws and numaq is done, rdc3210 is basically there 
already. (waiting for generic gpio bits to complete that fully - but 
rdc otherwise has no differences from the generic arch code)

Voyager is certainly one of the most complex subarch cases, hence was 
it left last :-)

	Ingo
