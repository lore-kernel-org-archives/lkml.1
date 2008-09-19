Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYISU2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYISU2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYISU2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:28:32 -0400
Received: from xenotime.net ([66.160.160.81]:54412 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754362AbYISU2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:28:30 -0400
Date: Fri, 19 Sep 2008 13:28:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: linux-next: Tree for September 16 (cpustr.h)
Message-Id: <20080919132822.9abc014f.rdunlap@xenotime.net>
In-Reply-To: <48D01B99.3040908@zytor.com>
References: <20080916173415.14012569.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0809161147320.32267@shark.he.net>
	<48D01B99.3040908@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__19_Sep_2008_13_28_22_-0700_hswt8MnpZCy+gBjQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Fri__19_Sep_2008_13_28_22_-0700_hswt8MnpZCy+gBjQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 Sep 2008 13:48:25 -0700 H. Peter Anvin wrote:

> Randy.Dunlap wrote:
> > I'm seeing lots of gcc warnings from the generated cpustr.h file, like so:
> > 
> >   arch/x86/boot/mkcpustr > arch/x86/boot/cpustr.h
> >   gcc -Wp,-MD,arch/x86/boot/.cpu.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/rdunlap/linsrc/linux-next-20080916/include -I/home/rdunlap/linsrc/linux-next-20080916/arch/x86/include -include include/linux/autoconf.h -I/home/rdunlap/linsrc/linux-next-20080916/arch/x86/boot -Iarch/x86/boot -I/home/rdunlap/linsrc/linux-next-20080916/include -Iinclude -I/home/rdunlap/linsrc/linux-next-20080916/include2 -Iinclude2  -I/home/rdunlap/linsrc/linux-next-20080916/include  -I/home/rdunlap/linsrc/linux-next-20080916/arch/x86/include -include include/linux/autoconf.h -g -Os -D_SETUP -D__KERNEL__ -Wall -Wstrict-prototypes -march=i386 -mregparm=3 -include /home/rdunlap/linsrc/linux-next-20080916/arch/x86/boot/code16gcc.h -fno-strict-aliasing -fomit-frame-pointer -ffreestanding -fno-unit-at-a-time -fno-stack-protector -mpreferred-stack-boundary=2 -m32 -D__BIG_KERNEL__  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(cpu)"
>   -D"KBUILD_MODNAME=KBUILD_STR(cpu)" -D"DEBUG_HASH=3" -D"DEBUG_HASH2=23" -c -o arch/x86/boot/cpu.o /home/rdunlap/linsrc/linux-next-20080916/arch/x86/boot/cpu.c
> > cc1: warning: hex escape sequence out of range
> > 
> > 
> > The ending lines of cpustr.h include hex strings like "\x111".
> > gcc complains about these.  If I change them to "\x011" (e.g.), there
> > is no warning.
> > 
> 
> Yes, there is a patch that adds a 9th cpuflags word, which this code 
> doesn't handle.  The warning is real, there is an #error in mkcpustr.c 
> which is supposed to trigger, but doesn't because of a typo:
> 
> #if NCAPFLAGS > 8
> # error "Need to adjust the boot code handling of CPUID strings"
> #endif
> 
> (The actual variable is called NCAPINTS.)
> 
> Attached is a completely untested patch for this problem.

That builds cleanly and the produced cpustr.h output file looks good to me.
It's attached for your checking.

---
~Randy

--Multipart=_Fri__19_Sep_2008_13_28_22_-0700_hswt8MnpZCy+gBjQ
Content-Type: text/x-chdr;
 name="cpustr.h"
Content-Disposition: attachment;
 filename="cpustr.h"
Content-Transfer-Encoding: 7bit

static const char x86_cap_strs[] = 
#if REQUIRED_MASK0 & (1 << 0)
	"\x00\x00""fpu\0"
#endif
#if REQUIRED_MASK0 & (1 << 1)
	"\x00\x01""vme\0"
#endif
#if REQUIRED_MASK0 & (1 << 2)
	"\x00\x02""de\0"
#endif
#if REQUIRED_MASK0 & (1 << 3)
	"\x00\x03""pse\0"
#endif
#if REQUIRED_MASK0 & (1 << 4)
	"\x00\x04""tsc\0"
#endif
#if REQUIRED_MASK0 & (1 << 5)
	"\x00\x05""msr\0"
#endif
#if REQUIRED_MASK0 & (1 << 6)
	"\x00\x06""pae\0"
#endif
#if REQUIRED_MASK0 & (1 << 7)
	"\x00\x07""mce\0"
#endif
#if REQUIRED_MASK0 & (1 << 8)
	"\x00\x08""cx8\0"
#endif
#if REQUIRED_MASK0 & (1 << 9)
	"\x00\x09""apic\0"
#endif
#if REQUIRED_MASK0 & (1 << 11)
	"\x00\x0b""sep\0"
#endif
#if REQUIRED_MASK0 & (1 << 12)
	"\x00\x0c""mtrr\0"
#endif
#if REQUIRED_MASK0 & (1 << 13)
	"\x00\x0d""pge\0"
#endif
#if REQUIRED_MASK0 & (1 << 14)
	"\x00\x0e""mca\0"
#endif
#if REQUIRED_MASK0 & (1 << 15)
	"\x00\x0f""cmov\0"
#endif
#if REQUIRED_MASK0 & (1 << 16)
	"\x00\x10""pat\0"
#endif
#if REQUIRED_MASK0 & (1 << 17)
	"\x00\x11""pse36\0"
#endif
#if REQUIRED_MASK0 & (1 << 18)
	"\x00\x12""pn\0"
#endif
#if REQUIRED_MASK0 & (1 << 19)
	"\x00\x13""clflush\0"
#endif
#if REQUIRED_MASK0 & (1 << 21)
	"\x00\x15""dts\0"
#endif
#if REQUIRED_MASK0 & (1 << 22)
	"\x00\x16""acpi\0"
#endif
#if REQUIRED_MASK0 & (1 << 23)
	"\x00\x17""mmx\0"
#endif
#if REQUIRED_MASK0 & (1 << 24)
	"\x00\x18""fxsr\0"
#endif
#if REQUIRED_MASK0 & (1 << 25)
	"\x00\x19""sse\0"
#endif
#if REQUIRED_MASK0 & (1 << 26)
	"\x00\x1a""sse2\0"
#endif
#if REQUIRED_MASK0 & (1 << 27)
	"\x00\x1b""ss\0"
#endif
#if REQUIRED_MASK0 & (1 << 28)
	"\x00\x1c""ht\0"
#endif
#if REQUIRED_MASK0 & (1 << 29)
	"\x00\x1d""tm\0"
#endif
#if REQUIRED_MASK0 & (1 << 30)
	"\x00\x1e""ia64\0"
#endif
#if REQUIRED_MASK0 & (1 << 31)
	"\x00\x1f""pbe\0"
#endif
#if REQUIRED_MASK1 & (1 << 11)
	"\x01\x0b""syscall\0"
#endif
#if REQUIRED_MASK1 & (1 << 19)
	"\x01\x13""mp\0"
#endif
#if REQUIRED_MASK1 & (1 << 20)
	"\x01\x14""nx\0"
#endif
#if REQUIRED_MASK1 & (1 << 22)
	"\x01\x16""mmxext\0"
#endif
#if REQUIRED_MASK1 & (1 << 25)
	"\x01\x19""fxsr_opt\0"
#endif
#if REQUIRED_MASK1 & (1 << 26)
	"\x01\x1a""pdpe1gb\0"
#endif
#if REQUIRED_MASK1 & (1 << 27)
	"\x01\x1b""rdtscp\0"
#endif
#if REQUIRED_MASK1 & (1 << 29)
	"\x01\x1d""lm\0"
#endif
#if REQUIRED_MASK1 & (1 << 30)
	"\x01\x1e""3dnowext\0"
#endif
#if REQUIRED_MASK1 & (1 << 31)
	"\x01\x1f""3dnow\0"
#endif
#if REQUIRED_MASK2 & (1 << 0)
	"\x02\x00""recovery\0"
#endif
#if REQUIRED_MASK2 & (1 << 1)
	"\x02\x01""longrun\0"
#endif
#if REQUIRED_MASK2 & (1 << 3)
	"\x02\x03""lrti\0"
#endif
#if REQUIRED_MASK3 & (1 << 0)
	"\x03\x00""cxmmx\0"
#endif
#if REQUIRED_MASK3 & (1 << 1)
	"\x03\x01""k6_mtrr\0"
#endif
#if REQUIRED_MASK3 & (1 << 2)
	"\x03\x02""cyrix_arr\0"
#endif
#if REQUIRED_MASK3 & (1 << 3)
	"\x03\x03""centaur_mcr\0"
#endif
#if REQUIRED_MASK3 & (1 << 8)
	"\x03\x08""constant_tsc\0"
#endif
#if REQUIRED_MASK3 & (1 << 9)
	"\x03\x09""up\0"
#endif
#if REQUIRED_MASK3 & (1 << 11)
	"\x03\x0b""arch_perfmon\0"
#endif
#if REQUIRED_MASK3 & (1 << 12)
	"\x03\x0c""pebs\0"
#endif
#if REQUIRED_MASK3 & (1 << 13)
	"\x03\x0d""bts\0"
#endif
#if REQUIRED_MASK3 & (1 << 16)
	"\x03\x10""rep_good\0"
#endif
#if REQUIRED_MASK3 & (1 << 20)
	"\x03\x14""nopl\0"
#endif
#if REQUIRED_MASK3 & (1 << 21)
	"\x03\x15""xtopology\0"
#endif
#if REQUIRED_MASK4 & (1 << 0)
	"\x04\x00""pni\0"
#endif
#if REQUIRED_MASK4 & (1 << 1)
	"\x04\x01""pclmulqdq\0"
#endif
#if REQUIRED_MASK4 & (1 << 2)
	"\x04\x02""dtes64\0"
#endif
#if REQUIRED_MASK4 & (1 << 3)
	"\x04\x03""monitor\0"
#endif
#if REQUIRED_MASK4 & (1 << 4)
	"\x04\x04""ds_cpl\0"
#endif
#if REQUIRED_MASK4 & (1 << 5)
	"\x04\x05""vmx\0"
#endif
#if REQUIRED_MASK4 & (1 << 6)
	"\x04\x06""smx\0"
#endif
#if REQUIRED_MASK4 & (1 << 7)
	"\x04\x07""est\0"
#endif
#if REQUIRED_MASK4 & (1 << 8)
	"\x04\x08""tm2\0"
#endif
#if REQUIRED_MASK4 & (1 << 9)
	"\x04\x09""ssse3\0"
#endif
#if REQUIRED_MASK4 & (1 << 10)
	"\x04\x0a""cid\0"
#endif
#if REQUIRED_MASK4 & (1 << 12)
	"\x04\x0c""fma\0"
#endif
#if REQUIRED_MASK4 & (1 << 13)
	"\x04\x0d""cx16\0"
#endif
#if REQUIRED_MASK4 & (1 << 14)
	"\x04\x0e""xtpr\0"
#endif
#if REQUIRED_MASK4 & (1 << 15)
	"\x04\x0f""pdcm\0"
#endif
#if REQUIRED_MASK4 & (1 << 18)
	"\x04\x12""dca\0"
#endif
#if REQUIRED_MASK4 & (1 << 19)
	"\x04\x13""sse4_1\0"
#endif
#if REQUIRED_MASK4 & (1 << 20)
	"\x04\x14""sse4_2\0"
#endif
#if REQUIRED_MASK4 & (1 << 21)
	"\x04\x15""x2apic\0"
#endif
#if REQUIRED_MASK4 & (1 << 25)
	"\x04\x19""aes\0"
#endif
#if REQUIRED_MASK4 & (1 << 26)
	"\x04\x1a""xsave\0"
#endif
#if REQUIRED_MASK4 & (1 << 28)
	"\x04\x1c""avx\0"
#endif
#if REQUIRED_MASK5 & (1 << 2)
	"\x05\x02""rng\0"
#endif
#if REQUIRED_MASK5 & (1 << 3)
	"\x05\x03""rng_en\0"
#endif
#if REQUIRED_MASK5 & (1 << 6)
	"\x05\x06""ace\0"
#endif
#if REQUIRED_MASK5 & (1 << 7)
	"\x05\x07""ace_en\0"
#endif
#if REQUIRED_MASK5 & (1 << 8)
	"\x05\x08""ace2\0"
#endif
#if REQUIRED_MASK5 & (1 << 9)
	"\x05\x09""ace2_en\0"
#endif
#if REQUIRED_MASK5 & (1 << 10)
	"\x05\x0a""phe\0"
#endif
#if REQUIRED_MASK5 & (1 << 11)
	"\x05\x0b""phe_en\0"
#endif
#if REQUIRED_MASK5 & (1 << 12)
	"\x05\x0c""pmm\0"
#endif
#if REQUIRED_MASK5 & (1 << 13)
	"\x05\x0d""pmm_en\0"
#endif
#if REQUIRED_MASK6 & (1 << 0)
	"\x06\x00""lahf_lm\0"
#endif
#if REQUIRED_MASK6 & (1 << 1)
	"\x06\x01""cmp_legacy\0"
#endif
#if REQUIRED_MASK6 & (1 << 2)
	"\x06\x02""svm\0"
#endif
#if REQUIRED_MASK6 & (1 << 3)
	"\x06\x03""extapic\0"
#endif
#if REQUIRED_MASK6 & (1 << 4)
	"\x06\x04""cr8_legacy\0"
#endif
#if REQUIRED_MASK6 & (1 << 5)
	"\x06\x05""abm\0"
#endif
#if REQUIRED_MASK6 & (1 << 6)
	"\x06\x06""sse4a\0"
#endif
#if REQUIRED_MASK6 & (1 << 7)
	"\x06\x07""misalignsse\0"
#endif
#if REQUIRED_MASK6 & (1 << 8)
	"\x06\x08""3dnowprefetch\0"
#endif
#if REQUIRED_MASK6 & (1 << 9)
	"\x06\x09""osvw\0"
#endif
#if REQUIRED_MASK6 & (1 << 10)
	"\x06\x0a""ibs\0"
#endif
#if REQUIRED_MASK6 & (1 << 11)
	"\x06\x0b""sse5\0"
#endif
#if REQUIRED_MASK6 & (1 << 12)
	"\x06\x0c""skinit\0"
#endif
#if REQUIRED_MASK6 & (1 << 13)
	"\x06\x0d""wdt\0"
#endif
#if REQUIRED_MASK7 & (1 << 0)
	"\x07\x00""ida\0"
#endif
#if REQUIRED_MASK8 & (1 << 0)
	"\x08\x00""tpr_shadow\0"
#endif
#if REQUIRED_MASK8 & (1 << 1)
	"\x08\x01""vnmi\0"
#endif
#if REQUIRED_MASK8 & (1 << 2)
	"\x08\x02""flexpriority\0"
#endif
#if REQUIRED_MASK8 & (1 << 3)
	"\x08\x03""ept\0"
#endif
#if REQUIRED_MASK8 & (1 << 4)
	"\x08\x04""vpid\0"
#endif
	"\x08\x1f"""
	;

--Multipart=_Fri__19_Sep_2008_13_28_22_-0700_hswt8MnpZCy+gBjQ--
