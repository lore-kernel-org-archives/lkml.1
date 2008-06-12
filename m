Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYFLXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYFLXc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYFLXcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:32:46 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:52034 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbYFLXcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type:from;
        b=JIbv1KRiPhtygHzuycjwl0/SL4OmCXXmv92UIBkoqFH68bA9+h3mX3KH6MV5YKA/4Y
         lXXC93Qdt0g7Gi3Qk2MFjBm1Tc/9iFsKEDNxUpUyFLkGP5sE9vgv18XMIk+MZqTRrEJR
         cIhRgCuwNHqUG2M+F95u4uf6v2FVK6dNuhHvU=
Date: Fri, 13 Jun 2008 00:32:34 +0100 (BST)
X-X-Sender: bb3081@gamma
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Daniel Walker <dwalker@mvista.com>,
       Hua Zhong <hzhong@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.26-rc5-mm3
In-Reply-To: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.0806130006490.14928@gamma>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Byron Bradley <byron.bbradley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like x86 and ARM both fail to boot if PROFILE_LIKELY, FTRACE and 
DYNAMIC_FTRACE are selected. If any one of those three are disabled it 
boots (or fails in some other way which I'm looking at now). The serial 
console output from both machines when they fail to boot is below, let me 
know if there is any other information I can provide.

ARM (Marvell Orion 5x):
<5>Linux version 2.6.26-rc5-mm3-dirty (bb3081@gamma) (gcc version 4.2.0 20070413 (prerelease) (CodeSourcery Sourcery G++ Lite 2007q1-21)) #24 PREEMPT Thu Jun 12 23:39:12 BST 2008
CPU: Feroceon [41069260] revision 0 (ARMv5TEJ), cr=a0053177
Machine: QNAP TS-109/TS-209
<4>Clearing invalid memory bank 0KB@0xffffffff
<4>Clearing invalid memory bank 0KB@0xffffffff
<4>Clearing invalid memory bank 0KB@0xffffffff
<4>Ignoring unrecognised tag 0x00000000
<4>Ignoring unrecognised tag 0x00000000
<4>Ignoring unrecognised tag 0x00000000
<4>Ignoring unrecognised tag 0x41000403
Memory policy: ECC disabled, Data cache writeback
<7>On node 0 totalpages: 32768
<7>Node 0 memmap at 0xc05df000 size 1048576 first pfn 0xc05df000
<7>free_area_init_node: node 0, pgdat c0529680, node_mem_map c05df000
<7>  DMA zone: 32512 pages, LIFO batch:7
CPU0: D VIVT write-back cache
CPU0: I cache: 32768 bytes, associativity 1, 32 byte lines, 1024 sets
CPU0: D cache: 32768 bytes, associativity 1, 32 byte lines, 1024 sets
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
<5>Kernel command line: console=ttyS0,115200n8 root=/dev/nfs nfsroot=192.168.2.53:/stuff/debian ip=dhcp
PID hash table entries: 512 (order: 9, 2048 bytes)
Console: colour dummy device 80x30
<6>Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
<6>Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
<6>Memory: 128MB = 128MB total
<5>Memory: 123776KB available (5016K code, 799K data, 160K init)
<6>SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
<7>Calibrating delay loop... 331.77 BogoMIPS (lpj=1658880)
Mount-cache hash table entries: 512
<6>CPU: Testing write buffer coherency: ok

x86 (AMD Athlon):
Linux version 2.6.26-rc5-mm3-dirty (bb3081@gamma) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #6 Thu Jun 12 23:53:18 BST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
 BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
last_pfn = 131056 max_arch_pfn = 1048576
0MB HIGHMEM available.
511MB LOWMEM available.
  mapped low ram: 0 - 01400000
  low ram: 00f7a000 - 1fff0000
  bootmap 00f7a000 - 00f7e000
  early res: 0 [0-fff] BIOS data page
  early res: 1 [100000-f74657] TEXT DATA BSS
  early res: 2 [f75000-f79fff] INIT_PG_TABLE
  early res: 3 [9f800-fffff] BIOS reserved
  early res: 4 [f7a000-f7dfff] BOOTMAP
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131056
  HighMem    131056 ->   131056
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   131056
DMI 2.2 present.
ACPI: RSDP 000F7950, 0014 (r0 Nvidia)
ACPI: RSDT 1FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 1FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 1FFF30C0, 4C22 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 1FFF0000, 0040
ACPI: APIC 1FFF7D00, 006E (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129935
Kernel command line: console=ttyS0,115200 root=/dev/nfs nfsroot=192.168.2.53:/stuff/debian-amd ip=dhcp BOOT_IMAGE=linux.amd
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1102.525 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 504184k/524224k available (8084k kernel code, 19476k reserved, 2784k data, 436k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
      .init : 0xc0ba0000 - 0xc0c0d000   ( 436 kB)
      .data : 0xc08e53f1 - 0xc0b9d418   (2784 kB)
      .text : 0xc0100000 - 0xc08e53f1   (8084 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 2207.88 BogoMIPS (lpj=11039440)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm)  stepping 00
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 804 Objects with 77 Devices 276 Methods 35 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
ACPI: setting ELCR to 0200 (from 1c28)
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
gcov: version magic: 0x3430322a
net_namespace: 324 bytes


Cheers,

-- 
Byron Bradley
