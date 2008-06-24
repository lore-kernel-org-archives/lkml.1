Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYFXPfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYFXPfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYFXPeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:34:50 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:26485 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760841AbYFXPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:34:48 -0400
Date: Tue, 24 Jun 2008 09:34:47 -0600
From: Alex Chiang <achiang@hp.com>
To: Robin Holt <holt@sgi.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [BISECT] Boot failure on ia64.
Message-ID: <20080624153447.GC3599@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
	tony.luck@intel.com, linux-kernel@vger.kernel.org
References: <20080624123014.GJ10123@sgi.com> <20080624150851.GA3599@ldl.fc.hp.com> <20080624152620.GP10062@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624152620.GP10062@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robin Holt <holt@sgi.com>:
> Here is the output.  This is from a different boot, but it does look the
> same.

Hrm, that's odd. There's no debug output at all. Did you apply
the patch?

> Robin
> 
> fs0:\efi\SuSE> elilo net0:holt/v1 root=/dev/sda7
> ELILO
> Uncompressing Linux... done
> Initializing cgroup subsys cpuset
> Linux version 2.6.26-rc7-holt-00051-g62786b9-dirty (holt@attica) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #19 SMP Tue Jun 24 10:22:55 CDT 2008

Ok, -dirty -- sorry, I believe you. :)

So that tells me we're not calling sn_cpu_init()? That's not what
the code says should be happening...

The lack of output kinda makes sense, since the oops looks like
it's coming from trying to access an uninitialized sn_nodepda,
but I'm really confused as to why, since we should have
initialized it before check_sal_cache_flush().

Anyone at SGI with more of a clue than me? (before I start digging
in depth)

Thanks.

/ac

> EFI v1.10 by INTEL: SALsystab=0x6002c25f10 ACPI 2.0=0x6002c26000
> console [sn_sal0] enabled
> ACPI: RSDP 6002C26000, 0024 (r2    SGI)
> ACPI: XSDT 6002C297F0, 0044 (r1    SGI  XSDTSN2    10001           7C)
> ACPI: APIC 6002C26870, 032C (r1    SGI  APICSN2    10001            1)
> ACPI: SRAT 6002C26BB0, 06B0 (r1    SGI  SRATSN2    10001            1)
> ACPI: SLIT 6002C27270, 012C (r1    SGI  SLITSN2    10001            1)
> ACPI: FACP 6002C27400, 00F4 (r3    SGI  FACPSN2    30001            1)
> ACPI: DSDT 6002C2AAF0, 0024 (r2    SGI  DSDTSN2    20001          AAC)
> ACPI: FACS 6002C273B0, 0040
> Number of logical nodes in system = 16
> Number of memory chunks in system = 16
> SAL 3.2: SGI SN2 version 1.50
> SAL Platform features: ITC_Drift
> SAL: AP wakeup using external interrupt vector 0x12
> Unable to handle kernel NULL pointer dereference (address 00000000000044b8)
> swapper[0]: Oops 8813272891392 [1]
> Modules linked in:
> 
> Pid: 0, CPU 0, comm:              swapper
> psr : 00001010084a2010 ifs : 8000000000000491 ip  : [<a000000100087020>]    Not tainted (2.6.26-rc7-holt-00051-g62786b9-dirty)
> ip is at sn2_send_IPI+0x80/0x240
> unat: 0000000000000000 pfs : 0000000000000491 rsc : 0000000000000003
> rnat: 000000000000afc8 bsps: 000000000001003e pr  : 65691ba55aa68599
> ldrs: 0000000000000000 ccv : 0000000000ff03ff fpsr: 0009804c8a70433f
> csd : 0000000000000000 ssd : 0000000000000000
> b0  : a0000001009529b0 b6  : 00000000ff5423b0 b7  : e000000001fffc00
> f6  : 1003e0000000000000000 f7  : 1003e0000000000000001
> f8  : 1003e0000000000000000 f9  : 1003e0000000000000000
> f10 : 100068fffffffff700000 f11 : 1003e0000000000000090
> r1  : a000000100e9d010 r2  : 00000000000044b8 r3  : 0000000000000000
> r8  : 0000000000000000 r9  : 0000000000000000 r10 : ffffffffffff6298
> r11 : 0000000000000000 r12 : a000000100aefc30 r13 : a000000100ae0000
> r14 : 0000000000000000 r15 : e000006003106298 r16 : e000006003110000
> r17 : a000000100d1f3e8 r18 : a000000100d1f3e8 r19 : a000000100d1f3e8
> r20 : 0000000000000000 r21 : ffffffffffff0420 r22 : 0000000000000800
> r23 : 0000000000000007 r24 : e0000060030b0000 r25 : 000000000004ffff
> r26 : a00000010098d440 r27 : e0000060030b0010 r28 : e0000060030b0000
> r29 : e0000060030b0020 r30 : 0000000000000000 r31 : 00000000000007ff
> Unable to handle kernel NULL pointer dereference (address 0000000000000000)
> swapper[0]: Oops 8813272891392 [2]
> Modules linked in:
> 
> Pid: 0, CPU 0, comm:              swapper
> psr : 0000101008022018 ifs : 800000000000038c ip  : [<a000000100182e30>]    Not tainted (2.6.26-rc7-holt-00051-g62786b9-dirty)
> ip is at kmem_cache_alloc+0x70/0x180
> unat: 0000000000000000 pfs : 0000000000000610 rsc : 0000000000000003
> rnat: 0000000000000000 bsps: 0000000000000000 pr  : 65691ba55aa69aa5
> ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
> csd : 0000000000000000 ssd : 0000000000000000
> b0  : a000000100040bc0 b6  : a000000100040e00 b7  : a00000010000b730
> f6  : 1003e45b3373c16c02344 f7  : 1003e9e3779b97f4a7c16
> f8  : 1003e0a00000010001426 f9  : 10006c7fffffffd73ea5c
> f10 : 100068fffffffff700000 f11 : 1003e0000000000000090
> r1  : a000000100e9d010 r2  : a000000100bbe950 r3  : a000000100bbc860
> r8  : 0000000000000000 r9  : 0000000000000000 r10 : a000000100ae0cf4
> r11 : 0000000000000000 r12 : a000000100aef100 r13 : a000000100ae0000
> r14 : 0000000000000014 r15 : a000000100aef190 r16 : a000000100aef198
> r17 : a000000100cb3e50 r18 : a000000100aef17c r19 : a000000100aef170
> r20 : 0000000000000000 r21 : 0000000000000000 r22 : a000000100aef170
> r23 : a000000100aef174 r24 : 000000000000000c r25 : a000000100aef180
> r26 : a000000100aef174 r27 : 0000000000000000 r28 : 0000000000000000
> r29 : a000000100aef178 r30 : 000000007fffffff r31 : 000000000000000c
> 
