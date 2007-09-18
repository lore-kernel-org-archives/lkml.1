Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbXIRHCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbXIRHCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 03:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXIRHCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 03:02:08 -0400
Received: from mail.dgt.com.pl ([195.117.141.2]:39053 "EHLO dgt.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbXIRHCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 03:02:07 -0400
DGT-Virus-Scanned: amavisd-new at dgt.com.pl
Message-ID: <46EF77D8.3090808@dgt.com.pl>
Date: Tue, 18 Sep 2007 09:01:44 +0200
From: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); pl-PL; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Intel-Quad on GA-P35-S3 motherboard with 4*2GB
References: <46EA4B50.7040904@dgt.com.pl> <20070914131859.GC5386@csclub.uwaterloo.ca>
In-Reply-To: <20070914131859.GC5386@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What does your mtrr look like?  How about dmesg?  Might be the stupid
> mtrr setup some bioses have been doing on intel chips where it would do:
> 4GB range at 4GB
> 1GB range at 8GB
> 512MB range at 9GB
> 256MB range at 9.5GB
> etc.
>
> And then it runs out of entries (which pisses of X).
>
> The simple solution would have been to assign an 8GB range at 4GB or
> maybe a 4GB range at 4GB and a 2GB range at 8GB to cover all the ram.
> Without the mtrr coverage you get no caching of that memory which makes
> use that that section of memory slow.  To make the system useable there
> is code in the kernel to discard any memory the BIOS didn't correctly
> cover with an mtrr cachable entry.
>
>
>   
I have  2.6.22.6 kernel

First MTRR looks good for me.
Why it was rejected?
And how to force using it?

here are more details

[root@kromblack ~]# cat /proc/mtrr
reg00: base=0x100000000 (4096MB), size=8192MB: write-back, count=1
reg01: base=0x280000000 (10240MB), size=2048MB: uncachable, count=1
reg02: base=0x260000000 (9728MB), size= 512MB: uncachable, count=1
reg03: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg04: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg05: base=0xa0000000 (2560MB), size= 512MB: uncachable, count=1
reg06: base=0x9ff00000 (2559MB), size=   1MB: write-through, count=1

[root@kromblack ~]# dmesg|grep mtrr
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.


and other interesting dmesg fragments:

Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 655072) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
end_pfn_map = 2097152
DMI 2.4 present.
ACPI: RSDP 000F6F10, 0014 (r0 GBT   )
ACPI: RSDT 9FEE3040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP 9FEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT 9FEE3180, 4A88 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS 9FEE0000, 0040
ACPI: HPET 9FEE7D80, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG 9FEE7E00, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC 9FEE7C80, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: SSDT 9FEE7E80, 015C (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
ACPI: SSDT 9FEE8430, 0275 (r1  PmRef    CpuPm     3000 INTL 20040311)
No NUMA configuration found
Faking a node at 0000000000000000-0000000200000000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 655072) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000200000000
Zone PFN ranges:
 DMA             0 ->     4096
 DMA32        4096 ->  1048576
 Normal    1048576 ->  2097152
early_node_map[3] active PFN ranges
   0:        0 ->      159
   0:      256 ->   655072
   0:  1048576 ->  2097152
On node 0 totalpages: 1703551
 DMA zone: 56 pages used for memmap
 DMA zone: 1125 pages reserved
 DMA zone: 2818 pages, LIFO batch:0
 DMA32 zone: 14280 pages used for memmap
 DMA32 zone: 636696 pages, LIFO batch:31
 Normal zone: 14336 pages used for memmap
 Normal zone: 1034240 pages, LIFO batch:31


ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 
0000000000100000
swsusp: Registered nosave memory region: 000000009fee0000 - 
000000009fee3000
swsusp: Registered nosave memory region: 000000009fee3000 - 
000000009fef0000
swsusp: Registered nosave memory region: 000000009fef0000 - 
000000009ff00000
swsusp: Registered nosave memory region: 000000009ff00000 - 
00000000c0000000
swsusp: Registered nosave memory region: 00000000c0000000 - 
00000000c4000000
swsusp: Registered nosave memory region: 00000000c4000000 - 
00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 
0000000100000000
Allocating PCI resources starting at c8000000 (gap: c4000000:3ac00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36744 bytes of per cpu data
Built 1 zonelists.  Total pages: 1673754






