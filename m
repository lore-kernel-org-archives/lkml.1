Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYJ3UZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYJ3UZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYJ3UYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:24:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51534 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbYJ3UYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:24:53 -0400
Subject: Re: next-20081030: voyager compile busted
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20081030180323.GA13399@x200.localdomain>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au>
	 <20081030180323.GA13399@x200.localdomain>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 15:24:47 -0500
Message-Id: <1225398287.19324.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 21:03 +0300, Alexey Dobriyan wrote:
> On i386-voyager:
> 
>   Using /src/linux-1 as source for kernel
>   GEN     /src/build/i386-voyager/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      arch/x86/kernel/tsc.o
> arch/x86/kernel/tsc.c: In function 'unsynchronized_tsc':
> arch/x86/kernel/tsc.c:763: error: implicit declaration of function 'apic_is_clustered_box'
> make[2]: *** [arch/x86/kernel/tsc.o] Error 1
>   CC      arch/x86/kernel/cpu/addon_cpuid_features.o
> arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> arch/x86/kernel/cpu/addon_cpuid_features.c:120: error: implicit declaration of function 'phys_pkg_id'
> make[3]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> make[3]: Target `__build' not remade because of errors.
> make[2]: *** [arch/x86/kernel/cpu] Error 2
> make[2]: Target `__build' not remade because of errors.
> make[1]: *** [arch/x86/kernel] Error 2
>   CC      arch/x86/mach-voyager/setup.o
> arch/x86/mach-voyager/setup.c: In function 'intr_init_hook':
> arch/x86/mach-voyager/setup.c:30: error: implicit declaration of function 'smp_intr_init'
> arch/x86/mach-voyager/setup.c: In function 'machine_specific_memory_setup':
> arch/x86/mach-voyager/setup.c:65: warning: unused variable 'new_nr'
> make[2]: *** [arch/x86/mach-voyager/setup.o] Error 1
>   CC      arch/x86/mach-voyager/voyager_smp.o
> arch/x86/mach-voyager/voyager_smp.c:67: error: conflicting types for 'phys_cpu_present_map'
> arch/x86/include/asm/mpspec.h:143: error: previous declaration of 'phys_cpu_present_map' was here
> arch/x86/mach-voyager/voyager_smp.c: In function 'start_secondary':
> arch/x86/mach-voyager/voyager_smp.c:444: error: implicit declaration of function 'notify_cpu_starting'
> arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_interrupt':
> arch/x86/mach-voyager/voyager_smp.c:955: error: implicit declaration of function 'generic_smp_call_function_interrupt'
> arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_single_interrupt':
> arch/x86/mach-voyager/voyager_smp.c:963: error: implicit declaration of function 'generic_smp_call_function_single_interrupt'
> make[2]: *** [arch/x86/mach-voyager/voyager_smp.o] Error 1
> make[2]: Target `__build' not remade because of errors.
> make[1]: *** [arch/x86/mach-voyager] Error 2

Yes ... present in the 2.6.28-rc as well.  I've got it all fixed up
locally.

This type of breakage is more or less expected given that I wait until
-rc1 for the tree to stop churning before trying to fix voyager and the
subarchitectures, and the fact that the current way x86 is being
developed tends to break them.

James


