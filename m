Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZIYJlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZIYJlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZIYJlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:41:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZIYJlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:41:20 -0400
Message-ID: <4ABC8F50.2030006@zytor.com>
Date: Fri, 25 Sep 2009 02:37:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, Jeff Dike <jdike@addtoit.com>,
       Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ARCH=x86 patch
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am confused, because I could have sworn I had tested this combination 
already, but having applied Jeff's UM fix and then David's ARCH=x86 
patch on top of that, I now find that all the 32-bit builds crap out 
when building on a 64-bit platform, due to asm-offsets.c being compiled 
with -m64 rather than -m32.

One possibility is that this is a toolchain difference, since I ran the 
previous tests on a Fedora 11 workstation, and I did this test tonight 
on a Fedora 10 laptop.

This happens both with unmodified patches on top of the current 
tip/x86/kbuild branch, and on top of linus/master with appropriate 
updates to Jeff's patch to deal with CPPFLAGS_vmlinux.lds having moved 
around inside the UML tree.

I probably won't have time myself to debug this before Linus has to 
close the merge window, but I'm willing to ask for a late pull for this 
given that it's build infrastructure only and the scheduling weirdness 
introduced by LinuxCon/LPC.

Error below.

	-hpa


   gcc -Wp,-MD,arch/x86/kernel/.asm-offsets.s.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-redhat-linux/4.3.2/include -Iinclude -Iinclude2 
-I/home/hpa/kernel/linux-2.6-tip/include 
-I/home/hpa/kernel/linux-2.6-tip/arch/x86/include -include 
include/linux/autoconf.h  -I/home/hpa/kernel/linux-2.6-tip/. -I. 
-D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs 
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration 
-Wno-format-security -fno-delete-null-pointer-checks -m64 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Os -fno-omit-frame-pointer -fno-optimize-sibling-calls -pg 
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow 
-fprofile-arcs -ftest-coverage   -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)" 
-D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -D"DEBUG_HASH=16" 
-D"DEBUG_HASH2=7" -fverbose-asm -S -o arch/x86/kernel/asm-offsets.s 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets.c 

In file included from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/percpu.h:45, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/current.h:5, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/processor.h:15, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic_32.h:6, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic.h:2, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/crypto.h:20, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:7, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets.c:2: 

/home/hpa/kernel/linux-2.6-tip/include/linux/kernel.h:184: warning: 
conflicting types for built-in function ‘snprintf’
/home/hpa/kernel/linux-2.6-tip/include/linux/kernel.h:186: warning: 
conflicting types for built-in function ‘vsnprintf’
In file included from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string.h:2, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/string.h:21, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/bitmap.h:8, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/cpumask.h:142, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:49, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/irqflags.h:55, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/irqflags.h:57, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/system.h:11, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/processor.h:17, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic_32.h:6, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic.h:2, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/crypto.h:20, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:7, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets.c:2: 

/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string_32.h:12: 
warning: conflicting types for built-in function ‘strncpy’
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string_32.h:18: 
warning: conflicting types for built-in function ‘strncat’
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string_32.h:24: 
warning: conflicting types for built-in function ‘strncmp’
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string_32.h:30: 
warning: conflicting types for built-in function ‘strlen’
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string_32.h:196: 
warning: conflicting types for built-in function ‘memmove’
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/string_32.h:201: 
warning: conflicting types for built-in function ‘memchr’
In file included from 
/home/hpa/kernel/linux-2.6-tip/include/linux/bitmap.h:8, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/cpumask.h:142, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:49, 

                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/irqflags.h:55, 

                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/irqflags.h:57,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/system.h:11,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/processor.h:17,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic_32.h:6,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic.h:2,
                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/crypto.h:20,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:7,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets.c:2:
/home/hpa/kernel/linux-2.6-tip/include/linux/string.h:54: warning: 
conflicting types for built-in function ‘strncasecmp’
/home/hpa/kernel/linux-2.6-tip/include/linux/string.h:82: warning: 
conflicting types for built-in function ‘strspn’
/home/hpa/kernel/linux-2.6-tip/include/linux/string.h:85: warning: 
conflicting types for built-in function ‘strcspn’
/home/hpa/kernel/linux-2.6-tip/include/linux/string.h:101: warning: 
conflicting types for built-in function ‘__builtin_memcmp’
In file included from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/irqflags.h:55,
                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/irqflags.h:57,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/system.h:11,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/processor.h:17,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic_32.h:6,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/atomic.h:2,
                  from 
/home/hpa/kernel/linux-2.6-tip/include/linux/crypto.h:20,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:7,
                  from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets.c:2:
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h: In 
function ‘__cpuid’:
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:725: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:725: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:725: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:725: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h: In 
function ‘write_gdt_entry’:
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:992: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:992: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h: In 
function ‘ptep_modify_prot_commit’:
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:1230: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:1230: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h: In 
function ‘set_pte_at’:
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:1251: 
warning: cast from pointer to integer of different size
/home/hpa/kernel/linux-2.6-tip/arch/x86/include/asm/paravirt.h:1251: 
warning: cast from pointer to integer of different size
In file included from 
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets.c:2:
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c: In 
function ‘foo’:
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:76: 
error: ‘struct pt_regs’ has no member named ‘ds’
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:77: 
error: ‘struct pt_regs’ has no member named ‘es’
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:78: 
error: ‘struct pt_regs’ has no member named ‘fs’
/home/hpa/kernel/linux-2.6-tip/arch/x86/kernel/asm-offsets_32.c:79: 
error: ‘struct pt_regs’ has no member named ‘gs’
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2
