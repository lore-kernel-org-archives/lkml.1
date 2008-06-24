Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbYFXPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbYFXPRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbYFXPR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:17:26 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758930AbYFXPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:17:24 -0400
Date: Tue, 24 Jun 2008 10:17:15 -0500
From: Robin Holt <holt@sgi.com>
To: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BISECT] Boot failure on ia64.
Message-ID: <20080624151715.GN10062@sgi.com>
References: <20080624123014.GJ10123@sgi.com> <20080624150851.GA3599@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624150851.GA3599@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not tried your patch yet.  Actually just read the email.
Jack Steiner did point out that booting with force_pal_cache_flush on
the command line will get it to boot.

I will try your patch shortly and send you output.

Thanks,
Robin


On Tue, Jun 24, 2008 at 09:08:51AM -0600, Alex Chiang wrote:
> Hi Robin,
> 
> * Robin Holt <holt@sgi.com>:
> > I bisected to this commit 3463a93def55c309f3c0d0a8aaf216be3be42d64
> > 
> > 3463a93def55c309f3c0d0a8aaf216be3be42d64 is first bad commit
> > commit 3463a93def55c309f3c0d0a8aaf216be3be42d64
> > Author: Alex Chiang <achiang@hp.com>
> > Date:   Wed Jun 11 17:29:27 2008 -0600
> > 
> >     [IA64] Update check_sal_cache_flush to use platform_send_ipi()
> > ...
> > 
> > This fails to boot on any sn2 ia64 with the sn2_defconfig.
> > 
> > Here is the output from that boot.
> > 
> > fs0:\efi\SuSE> elilo net0:holt/v1 root=/dev/sda7 console=ttySG0
> > ELILO
> > Uncompressing Linux... done
> > Linux version 2.6.26-rc5-00223-g3463a93 (holt@attica) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #14 SMP Tue Jun 24 07:27:34 CDT 2008
> > EFI v1.10 by INTEL: SALsystab=0x6002c25f10 ACPI 2.0=0x6002c26000
> > console [sn_sal0] enabled
> > ACPI: RSDP 6002C26000, 0024 (r2    SGI)
> > ACPI: XSDT 6002C297F0, 0044 (r1    SGI  XSDTSN2    10001           7C)
> > ACPI: APIC 6002C26870, 032C (r1    SGI  APICSN2    10001            1)
> > ACPI: SRAT 6002C26BB0, 06B0 (r1    SGI  SRATSN2    10001            1)
> > ACPI: SLIT 6002C27270, 012C (r1    SGI  SLITSN2    10001            1)
> > ACPI: FACP 6002C27400, 00F4 (r3    SGI  FACPSN2    30001            1)
> > ACPI: DSDT 6002C2AAF0, 0024 (r2    SGI  DSDTSN2    20001          AAC)
> > ACPI: FACS 6002C273B0, 0040
> > Number of logical nodes in system = 16
> > Number of memory chunks in system = 16
> > SAL 3.2: SGI SN2 version 1.50
> > SAL Platform features: ITC_Drift
> > SAL: AP wakeup using external interrupt vector 0x12
> > Unable to handle kernel NULL pointer dereference (address 00000000000044b8)
> > swapper[0]: Oops 8813272891392 [1]
> > Modules linked in:
> > 
> > Pid: 0, CPU 0, comm:              swapper
> > psr : 00001010084a2010 ifs : 8000000000000491 ip  : [<a000000100087020>]    Not tainted (2.6.26-rc5-00223-g3463a93)
> > ip is at sn2_send_IPI+0x80/0x240
> > unat: 0000000000000000 pfs : 0000000000000491 rsc : 0000000000000003
> > rnat: 000000000000afc8 bsps: 000000000001003e pr  : 65691ba55aa68599
> > ldrs: 0000000000000000 ccv : 0000000000ff03ff fpsr: 0009804c8a70433f
> > csd : 0000000000000000 ssd : 0000000000000000
> > b0  : a000000100942870 b6  : 00000000ff5423b0 b7  : e000000001fffc00
> > f6  : 1003e0000000000000000 f7  : 1003e0000000000000001
> > f8  : 1003e0000000000000000 f9  : 1003e0000000000000000
> > f10 : 100068fffffffff700000 f11 : 1003e0000000000000090
> > r1  : a000000100e8bd10 r2  : 00000000000044b8 r3  : 0000000000000000
> > r8  : 0000000000000000 r9  : 0000000000000000 r10 : ffffffffffff6298
> > r11 : 0000000000000000 r12 : a000000100adfc30 r13 : a000000100ad0000
> > r14 : 0000000000000000 r15 : e000006003106298 r16 : e000006003110000
> > r17 : a000000100d0dce8 r18 : a000000100d0dce8 r19 : a000000100d0dce8
> > r20 : 0000000000000000 r21 : ffffffffffff0420 r22 : 0000000000000800
> > r23 : 0000000000000007 r24 : e0000060030b0000 r25 : 000000000004ffff
> > r26 : a00000010097c460 r27 : e0000060030b0010 r28 : e0000060030b0000
> > r29 : e0000060030b0020 r30 : 0000000000000000 r31 : 00000000000007ff
> > Unable to handle kernel NULL pointer dereference (address 0000000000000000)
> > swapper[0]: Oops 8813272891392 [2]
> > Modules linked in:
> > 
> > Pid: 0, CPU 0, comm:              swapper
> > psr : 0000101008022018 ifs : 800000000000038c ip  : [<a000000100175b30>]    Not tainted (2.6.26-rc5-00223-g3463a93)
> > ip is at kmem_cache_alloc+0x70/0x180
> > unat: 0000000000000000 pfs : 0000000000000610 rsc : 0000000000000003
> > rnat: 0000000000000000 bsps: 0000000000000000 pr  : 65691ba55aa69aa5
> > ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
> > csd : 0000000000000000 ssd : 0000000000000000
> > b0  : a000000100040bc0 b6  : a000000100040e00 b7  : a00000010000b730
> > f6  : 1003e45b3373c16c02344 f7  : 1003e9e3779b97f4a7c16
> > f8  : 1003e0a00000010001426 f9  : 10006c7fffffffd73ea5c
> > f10 : 100068fffffffff700000 f11 : 1003e0000000000000090
> > r1  : a000000100e8bd10 r2  : a000000100bae950 r3  : a000000100bac860
> > r8  : 0000000000000000 r9  : 0000000000000000 r10 : a000000100ad0c54
> > r11 : 0000000000000000 r12 : a000000100adf100 r13 : a000000100ad0000
> > r14 : 0000000000000014 r15 : a000000100adf190 r16 : a000000100adf198
> > r17 : a000000100ca1480 r18 : a000000100adf17c r19 : a000000100adf170
> > r20 : 0000000000000000 r21 : 0000000000000000 r22 : a000000100adf170
> > r23 : a000000100adf174 r24 : 000000000000000c r25 : a000000100adf180
> > r26 : a000000100adf174 r27 : 0000000000000000 r28 : 0000000000000000
> > r29 : a000000100adf178 r30 : 000000007fffffff r31 : 000000000000000c
> 
> Here's the disassembly of sn2_send_IPI:
> 
> (gdb) disass sn2_send_IPI
> Dump of assembler code for function sn2_send_IPI:
> 0xa000000100633f80 <sn2_send_IPI+0>:    [MMI]       alloc r39=ar.pfs,17,9,0
> 0xa000000100633f81 <sn2_send_IPI+1>:                adds r12=-160,r12
> 0xa000000100633f82 <sn2_send_IPI+2>:                mov r38=b0
> 0xa000000100633f90 <sn2_send_IPI+16>:   [MMI]       addl r19=-1557544,r1
> 0xa000000100633f91 <sn2_send_IPI+17>:               mov r40=r1
> 0xa000000100633f92 <sn2_send_IPI+18>:               sxt4 r20=r32
> 0xa000000100633fa0 <sn2_send_IPI+32>:   [MMI]       mov r21=-64480
> 0xa000000100633fa1 <sn2_send_IPI+33>:               nop.m 0x0
> 0xa000000100633fa2 <sn2_send_IPI+34>:               mov r10=-33312
> 0xa000000100633fb0 <sn2_send_IPI+48>:   [MMI]       nop.m 0x0;;
> 0xa000000100633fb1 <sn2_send_IPI+49>:               ld8 r16=[r21]
> 0xa000000100633fb2 <sn2_send_IPI+50>:               shladd r8=r20,2,r0
> 0xa000000100633fc0 <sn2_send_IPI+64>:   [MII]       mov r18=r19
> 0xa000000100633fc1 <sn2_send_IPI+65>:               adds r41=48,r12;;
> 0xa000000100633fc2 <sn2_send_IPI+66>:               add r17=r8,r18;;
> 0xa000000100633fd0 <sn2_send_IPI+80>:   [MII]       ld4.acq r11=[r17]
> 0xa000000100633fd1 <sn2_send_IPI+81>:               nop.i 0x0;;
> 0xa000000100633fd2 <sn2_send_IPI+82>:               sxt4 r37=r11;;
> 0xa000000100633fe0 <sn2_send_IPI+96>:   [MMI]       add r15=r10,r16;;
> 0xa000000100633fe1 <sn2_send_IPI+97>:               ld8 r9=[r15]
> 0xa000000100633fe2 <sn2_send_IPI+98>:               nop.i 0x0;;
> 0xa000000100633ff0 <sn2_send_IPI+112>:  [MII]       nop.m 0x0
> 0xa000000100633ff1 <sn2_send_IPI+113>:              add r3=r8,r9;;
> 0xa000000100633ff2 <sn2_send_IPI+114>:              addl r2=17592,r3;;
> 0xa000000100634000 <sn2_send_IPI+128>:  [MMI]       ld2 r3=[r2];;
> 
> Looks like we're dying on this access above ^^
> 
> 0xa000000100634001 <sn2_send_IPI+129>:              nop.m 0x0
> 0xa000000100634002 <sn2_send_IPI+130>:              sxt2 r14=r3;;
> 0xa000000100634010 <sn2_send_IPI+144>:  [MIB]       mov r32=r14
> 0xa000000100634011 <sn2_send_IPI+145>:              cmp4.eq p7,p6=-1,r14
> 
> My guess something bad is happening when we try this:
> 
> 	nasid = cpuid_to_nasid(cpuid);
> 
> And include/asm-ia64/sn/sn_cpuid.h says:
> 
> #define cpuid_to_nasid(cpuid)           (sn_nodepda->phys_cpuid[cpuid].nasid)
> 
> Are we calling sn2_send_IPI too early? Do we have to do some sort
> of special initialization before sn_nodepda is valid? It all
> *looks* like we should be fine because we do
> 
> 	cpu_init()
> 	platform_cpu_init()
> 	sn_cpu_init()
> 
> Before calling check_sal_cache_flush()... Very curious.
> 
> Can you try the debug patch included below?
> 
> Thanks.
> 
> /ac
> 
> diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
> index bb1d249..a6a0be5 100644
> --- a/arch/ia64/sn/kernel/setup.c
> +++ b/arch/ia64/sn/kernel/setup.c
> @@ -627,13 +627,18 @@ void __cpuinit sn_cpu_init(void)
>  			nodepdaindr[i]->phys_cpuid[cpuid].nasid = nasid;
>  			nodepdaindr[i]->phys_cpuid[cpuid].slice = slice;
>  			nodepdaindr[i]->phys_cpuid[cpuid].subnode = subnode;
> +			printk(KERN_INFO "nodepdaindr[%d]->phys_cpuid[%d] - nasid %d slice %d subnode %d\n", i, cpuid, nasid, slice, subnode);
>  		}
>  	}
>  
>  	cnode = nasid_to_cnodeid(nasid);
>  
> +	printk(KERN_INFO "cnode %d\n", cnode);
> +
>  	sn_nodepda = nodepdaindr[cnode];
>  
> +	printk(KERN_INFO "sn_nodepda 0x%p\n", sn_nodepda);
> +
>  	pda->led_address =
>  	    (typeof(pda->led_address)) (LED0 + (slice << LED_CPU_SHIFT));
>  	pda->led_state = LED_ALWAYS_SET;
