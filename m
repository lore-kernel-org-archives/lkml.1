Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbZBSRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbZBSRES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZBSRED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:04:03 -0500
Received: from rosi.naasa.net ([212.8.0.13]:43386 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZBSREB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:04:01 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Frans Pop <elendil@planet.nl>
Subject: Re: cpuinfo shows wrong MHz value
Date: Thu, 19 Feb 2009 18:03:54 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <200902142217.51655.jplatte@naasa.net> <200902182054.38840.jplatte@naasa.net> <200902182205.47737.elendil@planet.nl>
In-Reply-To: <200902182205.47737.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902191803.55347.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. Februar 2009 schrieb Frans Pop:

> commit ed9cbcd40004904dbe61ccc16d6106a7de38c998
> Author: Zhao Yakui <yakui.zhao@intel.com>
> Date:   Tue Nov 20 14:20:21 2007 -0500
>     Revert "speedstep-lib.c: fix frequency multiplier for Pentium4 models
> 0&1"
>
> That would exactly explain the factor 8 of the error.

Yes, looks like thats the reason.

> Do you have a line like the following in your debug output?
>     P4 - FSB %u kHz; Multiplier %u; Speed %u kHz\n
> If so, what does it say for .24 and .28?

There is no such message in the log.

> Can you please provide the output of 'x86info -a' (as root) after loading
> the cpuid module?

Here it is:

x86info v1.21.  Dave Jones 2001-2007
Feedback to <davej@redhat.com>.

Found 1 CPU
--------------------------------------------------------------------------
eax in: 0x00000000, eax = 00000002 ebx = 756e6547 ecx = 6c65746e edx = 
49656e69
eax in: 0x00000001, eax = 00000f12 ebx = 00010808 ecx = 00000000 edx = 
3febfbff
eax in: 0x00000002, eax = 665b5001 ebx = 00000000 ecx = 00000000 edx = 
007a7040

eax in: 0x80000000, eax = 80000004 ebx = 00000000 ecx = 00000000 edx = 
00000000
eax in: 0x80000001, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 
00000000
eax in: 0x80000002, eax = 20202020 ebx = 20202020 ecx = 20202020 edx = 
6e492020
eax in: 0x80000003, eax = 286c6574 ebx = 50202952 ecx = 69746e65 edx = 
52286d75
eax in: 0x80000004, eax = 20342029 ebx = 20555043 ecx = 30362e31 edx = 
007a4847

Family: 15 Model: 1 Stepping: 2 Type: 0 Brand: 8
CPU Model: Pentium 4 (Willamette) [D0] Original OEM
Processor name string: Intel(R) Pentium(R) 4 CPU 1.60GHz

Feature flags:
 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 
clflsh ds acpi mmx fxsr sse sse2 ss ht tm
Extended feature flags:


Pentium 4 specific MSRs:
IA32_PLATFORM_ID=0008000000000000
System bus in order queue depth=12
MSR_EBC_FREQUENCY_ID=000000008201ff00
IA32_BIOS_SIGN_ID=0000002e00000000
Processor serial number is enabled
Fast string enable is set
x87 FPU Fopcode compatability mode is unset
Thermal monitor enable is set
Split lock disable is unset
L3 cache disable is set
Performance monitoring is available
Suppress lock enable is unset
Prefetch queue disable is unset
FERR# Interrupt reporting enable is unset
Branch trace storage unavailable is unset
Precise Event Based Sampling Unavailable is unset

Cache info
 Instruction trace cache: 12K uOps, 8-way associative.
 L1 Data cache: 8KB, sectored, 4-way associative. 64 byte line size.
 L2 unified cache: 256KB, sectored, 8-way associative. 64 byte line size.
TLB info
 Instruction TLB: 4K, 2MB or 4MB pages, fully associative, 64 entries.
 Data TLB: 4KB or 4MB pages, fully associative, 64 entries.

Number of reporting banks : 4

Number of extended MC registers : 12


Bank: 0 (0x400)
MC0CTL:    00000000 00000000 00000000 00000000
           00000000 00000000 11111111 11111111
MC0STATUS: 00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
MC0ADDR:   00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000

Bank: 1 (0x404)
MC1CTL:    00000000 00000000 00000000 00000000
           00000000 00000011 10000000 00000000
MC1STATUS: 00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
MC1ADDR:   00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000

Bank: 2 (0x408)
MC2CTL:    00000000 00000000 00000000 00000000
           00000000 00000000 00000000 10000000
MC2STATUS: 00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
MC2ADDR:   Couldn't read MSR 0x40a

Bank: 3 (0x40c)
MC3CTL:    00000000 00000000 00000000 00000000
           00000000 00000000 00000000 01111110
MC3STATUS: 00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
MC3ADDR:   00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000

The physical package supports 1 logical processors

Microcode version: 0x000000000000002e

Connector type: Socket423 (PGA423 Socket)

Datasheet: http://developer.intel.com/design/pentium4/datashts/24919805.pdf
Errata: http://developer.intel.com/design/pentium4/specupdt/249199.htm

MTRR registers:
MTRRcap (0xfe): 0x0000000000000508
MTRRphysBase0 (0x200): 0x0000000000000006
MTRRphysMask0 (0x201): 0x0000000fc0000800
MTRRphysBase1 (0x202): 0x0000000000000000
MTRRphysMask1 (0x203): 0x0000000000000000
MTRRphysBase2 (0x204): 0x0000000000000000
MTRRphysMask2 (0x205): 0x0000000000000000
MTRRphysBase3 (0x206): 0x0000000000000000
MTRRphysMask3 (0x207): 0x0000000000000000
MTRRphysBase4 (0x208): 0x0000000000000000
MTRRphysMask4 (0x209): 0x0000000000000000
MTRRphysBase5 (0x20a): 0x0000000000000000
MTRRphysMask5 (0x20b): 0x0000000000000000
MTRRphysBase6 (0x20c): 0x0000000000000000
MTRRphysMask6 (0x20d): 0x0000000000000000
MTRRphysBase7 (0x20e): 0x0000000000000000
MTRRphysMask7 (0x20f): 0x0000000000000000
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0000000000000000
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0505050505050505
MTRRfix4K_E8000 0x26d: 0x0505050505050505
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00


1.60GHz processor (estimate).

best regards and thank you for your help
Jörg
