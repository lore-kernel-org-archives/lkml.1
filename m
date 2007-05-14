Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXENBI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXENBI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 21:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbXENBIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 21:08:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:33527 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXENBIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 21:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=brDveGJcOgVclFpAhOoM7SBw47Dn8eIGUtfJlTTGYFoH9w/vbet6PUOEPj6U2FfO72bBnH2iKTK7VzLmkDvbG4I2hQyRtfULhqZRISjFLqd7oU/MOkU6NZfjyXtjZUIdqUzfIe47wdVIua/A7ATWxBMsG6w28e2fiTfGeO0VXvI=
Message-ID: <d45a3acc0705131808g65a74250t6791ce96a4cb1324@mail.gmail.com>
Date: Mon, 14 May 2007 11:08:20 +1000
From: "andrew hendry" <andrew.hendry@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, forgot to CC mailing list last time.

build errors from make randconfig

# CONFIG_SMP is not set
CONFIG_X86_VOYAGER=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

arch/i386/kernel/built-in.o: In function `vic_sys_interrupt':
(.text+0x2770): undefined reference to `smp_vic_sys_interrupt'
arch/i386/kernel/built-in.o: In function `vic_cmn_interrupt':
(.text+0x27a8): undefined reference to `smp_vic_cmn_interrupt'
arch/i386/kernel/built-in.o: In function `vic_cpi_interrupt':
(.text+0x27e0): undefined reference to `smp_vic_cpi_interrupt'
arch/i386/kernel/built-in.o: In function `qic_timer_interrupt':
(.text+0x2818): undefined reference to `smp_qic_timer_interrupt'
arch/i386/kernel/built-in.o: In function `qic_invalidate_interrupt':
(.text+0x2850): undefined reference to `smp_qic_invalidate_interrupt'
arch/i386/kernel/built-in.o: In function `qic_reschedule_interrupt':
(.text+0x2888): undefined reference to `smp_qic_reschedule_interrupt'
arch/i386/kernel/built-in.o: In function `qic_enable_irq_interrupt':
(.text+0x28c0): undefined reference to `smp_qic_enable_irq_interrupt'
arch/i386/kernel/built-in.o: In function `qic_call_function_interrupt':
(.text+0x28f8): undefined reference to `smp_qic_call_function_interrupt'
arch/i386/kernel/built-in.o: In function `setup_bootmem_allocator':
(.init.text+0x58a): undefined reference to `find_smp_config'
arch/i386/mach-voyager/built-in.o: In function `voyager_power_off':
(.text+0x18f): undefined reference to `voyager_cat_power_off'
arch/i386/mach-voyager/built-in.o: In function `thread':
voyager_thread.c:(.text+0x3b8): undefined reference to `voyager_status'
voyager_thread.c:(.text+0x405): undefined reference to `voyager_status'
voyager_thread.c:(.text+0x418): undefined reference to `voyager_cat_psi'
voyager_thread.c:(.text+0x452): undefined reference to `voyager_status'
voyager_thread.c:(.text+0x46c): undefined reference to `voyager_status'

CONFIG_SMP=y
CONFIG_X86_VOYAGER=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

arch/i386/kernel/built-in.o: In function `msr_read':
msr.c:(.text+0xa614): undefined reference to `smp_call_function_single'
arch/i386/kernel/built-in.o: In function `msr_write':
msr.c:(.text+0xa710): undefined reference to `smp_call_function_single'
arch/i386/kernel/built-in.o: In function `cpuid_read':
cpuid.c:(.text+0xa8d0): undefined reference to `smp_call_function_single'
arch/i386/lib/built-in.o: In function `wrmsr_on_cpu':
(.text+0x63): undefined reference to `smp_call_function_single'
arch/i386/lib/built-in.o: In function `rdmsr_on_cpu':
(.text+0xb6): undefined reference to `smp_call_function_single'
make: *** [.tmp_vmlinux1] Error 1

CONFIG_SMP=y
CONFIG_X86_VOYAGER=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

arch/i386/lib/built-in.o: In function `wrmsr_on_cpu':
(.text+0x63): undefined reference to `smp_call_function_single'
arch/i386/lib/built-in.o: In function `rdmsr_on_cpu':
(.text+0xb6): undefined reference to `smp_call_function_single'


On 5/13/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Ok, the merge window has closed, and 2.6.22-rc1 is out there.
>
> The diffstat and shortlogs are way too big to fit under the kernel mailing
> list limits, and the changes are all over the place. Almost seven thousand
> files changed, and that's not double-counting the files that got moved
> around.
>
> Architecture updates, drivers, filesystems, networking, security, build
> scripts, reorganizations, cleanups.. You name it, it's there.
>
> You want a new firewire stack? We've got it. New wireless networking
> infrastructure? Check. New infiniband drivers? Digital video drivers? A
> totally new CPU architecture (blackfin)? Check, check, check.
>
> That said, I think (and certainly hope) that this will not be nearly as
> painful as the big fundamental timer changes for 2.6.21, and while there
> are some pretty core changes there (like the new SLUB allocator, which
> hopefully will end up replacing both SLAB and SLOB), it feels pretty
> solid, and not as scary as ripping the carpet from under the timer
> infrastructure.
>
> So give it a good testing. We'll see how the regression tracking ends up
> working, but in order to actually track that, we want people actively
> testing -rc1 and making good reports!
>
>                 Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
