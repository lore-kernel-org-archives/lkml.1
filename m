Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbXIROU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbXIROU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXIROUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:20:49 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44175 "EHLO
	caffeine.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbXIROUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:20:48 -0400
Date: Tue, 18 Sep 2007 10:20:47 -0400
To: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel-Quad on GA-P35-S3 motherboard with 4*2GB
Message-ID: <20070918142047.GF5386@csclub.uwaterloo.ca>
References: <46EA4B50.7040904@dgt.com.pl> <20070914131859.GC5386@csclub.uwaterloo.ca> <46EF77D8.3090808@dgt.com.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EF77D8.3090808@dgt.com.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 09:01:44AM +0200, Wojciech Kromer wrote:
> I have  2.6.22.6 kernel
> 
> First MTRR looks good for me.
> Why it was rejected?
> And how to force using it?
> 
> here are more details
> 
> [root@kromblack ~]# cat /proc/mtrr
> reg00: base=0x100000000 (4096MB), size=8192MB: write-back, count=1
> reg01: base=0x280000000 (10240MB), size=2048MB: uncachable, count=1
> reg02: base=0x260000000 (9728MB), size= 512MB: uncachable, count=1
> reg03: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg04: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg05: base=0xa0000000 (2560MB), size= 512MB: uncachable, count=1
> reg06: base=0x9ff00000 (2559MB), size=   1MB: write-through, count=1

So first it says there is 8GB ram at 4GB.  Then it deletes the top 2GB
of that and then another 512MB.  So now there is 5.5GB at 4GB.  It then
says there is 4GB at 0GB, then deletes the top 1GB of that, and then
another 512MB, leaving 2.5GB at 0GB.  So overall that sounds like 8GB
total.  It also seems that if it had mapped 2GB at 0GB and 6GB at 4GB
the MTRR would have been a heck of a lot simpler (but a 32bit OS would
have had 512MB less ram of course).

> [root@kromblack ~]# dmesg|grep mtrr
> mtrr: your CPUs had inconsistent variable MTRR settings
> mtrr: probably your BIOS does not setup all CPUs.
> mtrr: corrected configuration.

Now that does sound odd.  How many CPUs does the machine have?

> and other interesting dmesg fragments:
> 
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> Entering add_active_range(0, 256, 655072) 1 entries of 3200 used
> Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
> end_pfn_map = 2097152
> DMI 2.4 present.
> ACPI: RSDP 000F6F10, 0014 (r0 GBT   )
> ACPI: RSDT 9FEE3040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
> ACPI: FACP 9FEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
> ACPI: DSDT 9FEE3180, 4A88 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
> ACPI: FACS 9FEE0000, 0040
> ACPI: HPET 9FEE7D80, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
> ACPI: MCFG 9FEE7E00, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
> ACPI: APIC 9FEE7C80, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
> ACPI: SSDT 9FEE7E80, 015C (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
> ACPI: SSDT 9FEE8430, 0275 (r1  PmRef    CpuPm     3000 INTL 20040311)
> No NUMA configuration found
> Faking a node at 0000000000000000-0000000200000000
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> Entering add_active_range(0, 256, 655072) 1 entries of 3200 used
> Entering add_active_range(0, 1048576, 2097152) 2 entries of 3200 used
> Bootmem setup node 0 0000000000000000-0000000200000000
> Zone PFN ranges:
> DMA             0 ->     4096
> DMA32        4096 ->  1048576
> Normal    1048576 ->  2097152
> early_node_map[3] active PFN ranges
>   0:        0 ->      159
>   0:      256 ->   655072
>   0:  1048576 ->  2097152
> On node 0 totalpages: 1703551
> DMA zone: 56 pages used for memmap
> DMA zone: 1125 pages reserved
> DMA zone: 2818 pages, LIFO batch:0
> DMA32 zone: 14280 pages used for memmap
> DMA32 zone: 636696 pages, LIFO batch:31
> Normal zone: 14336 pages used for memmap
> Normal zone: 1034240 pages, LIFO batch:31
> 
> 
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> swsusp: Registered nosave memory region: 000000000009f000 - 
> 00000000000a0000
> swsusp: Registered nosave memory region: 00000000000a0000 - 
> 00000000000f0000
> swsusp: Registered nosave memory region: 00000000000f0000 - 
> 0000000000100000
> swsusp: Registered nosave memory region: 000000009fee0000 - 
> 000000009fee3000
> swsusp: Registered nosave memory region: 000000009fee3000 - 
> 000000009fef0000
> swsusp: Registered nosave memory region: 000000009fef0000 - 
> 000000009ff00000
> swsusp: Registered nosave memory region: 000000009ff00000 - 
> 00000000c0000000
> swsusp: Registered nosave memory region: 00000000c0000000 - 
> 00000000c4000000
> swsusp: Registered nosave memory region: 00000000c4000000 - 
> 00000000fec00000
> swsusp: Registered nosave memory region: 00000000fec00000 - 
> 0000000100000000
> Allocating PCI resources starting at c8000000 (gap: c4000000:3ac00000)
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 36744 bytes of per cpu data
> Built 1 zonelists.  Total pages: 1673754

So what does the dmesg say about the memory table it got from the bios?
That is the e820 table.

--
Len Sorensen
