Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbXLCEAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbXLCEAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 23:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXLCD7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 22:59:52 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22445 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbXLCD7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 22:59:50 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47537F2E.2070204@am.sony.com>
Date: Sun, 02 Dec 2007 19:59:42 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Milton Miller <miltonm@bga.com>
Subject: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2007 03:59:47.0276 (UTC) FILETIME=[F1F818C0:01C83560]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm finding that recently kexec'ed kernels on PS3 will
panic on startup.  It seems the trouble was introduced
with the ppc64 SPARSEMEM_VMEMMAP support.  The problem
is the same when starting either new or old kernels:

2.6.24 -> 2.6.23 ok
2.6.24 -> 2.6.23 panic
2.6.24 -> 2.6.24 panic

These are the commits that seem to introduce the problem:

  d29eff7bca60c9ee401d691d4562a4abca8de543 ppc64: SPARSEMEM_VMEMMAP suppor
  8f6aac419bd590f535fb110875a51f7db2b62b5b Generic Virtual Memmap support for SPARSEMEM


Below is a startup dump.  Any help in finding the problem
would be appreciated.

-Geoff



ps3_mm_add_memory:317: start_addr 740320000000h, start_pfn 740320000h, nr_pages 17000h
<4>swapper: page allocation failure. order:12, mode:0x80d0
Call Trace:
[c000000006047820] [c00000000000e700] .show_stack+0x68/0x1b0 (unreliable)
[c0000000060478c0] [c000000000089eb4] .__alloc_pages+0x358/0x3ac
[c0000000060479b0] [c0000000000a3964] .vmemmap_alloc_block+0x6c/0xf4
[c000000006047a40] [c000000000026544] .vmemmap_populate+0x74/0x100
[c000000006047ae0] [c0000000000a385c] .sparse_mem_map_populate+0x38/0x5c
[c000000006047b70] [c0000000000a36e4] .sparse_add_one_section+0x64/0x128
[c000000006047c20] [c0000000000aa74c] .__add_pages+0xac/0x18c
[c000000006047cd0] [c000000000025fd4] .arch_add_memory+0x44/0x60
[c000000006047d60] [c0000000000aa5b0] .add_memory+0xd4/0x124
[c000000006047e00] [c000000000452544] .ps3_mm_add_memory+0x8c/0x108
[c000000006047ea0] [c0000000004417c4] .kernel_init+0x1f4/0x3b8
[c000000006047f90] [c000000000021d88] .kernel_thread+0x4c/0x68
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:   0   Cold: hi:   14, btch:   3 usd:   0
CPU    1: Hot: hi:   42, btch:   7 usd:   0   Cold: hi:   14, btch:   3 usd:   0
Active:0 inactive:0 dirty:0 writeback:0 unstable:0
 free:18094 slab:122 mapped:0 pagetables:0 bounce:0
DMA free:72376kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:129280kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 8*4kB 5*8kB 5*16kB 7*32kB 3*64kB 5*128kB 4*256kB 3*512kB 5*1024kB 3*2048kB 4*4096kB 5*8192kB 0*16384kB = 72376kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
32768 pages of RAM
10403 reserved pages
0 pages shared
0 pages swap cached
<1>Unable to handle kernel paging request for data at address 0xcf0001960b000010
<1>Faulting instruction address: 0xc000000000087340
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2 PS3
Modules linked in:
NIP: c000000000087340 LR: c00000000008733c CTR: 0000000000000000
REGS: c000000006047900 TRAP: 0300   Not tainted  (2.6.24-rc3-ps3-linux-dev-g91428d55-dirty)
MSR: 8000000000008032 <EE,IR,DR>  CR: 22004444  XER: 00000000
DAR: cf0001960b000010, DSISR: 0000000042000000
TASK = c000000006041080[1] 'swapper' THREAD: c000000006044000 CPU: 1
<6>GPR00: 0000000000000000 c000000006047b80 c00000000052b410 c000000006001b40
<6>GPR04: 0000000000000001 0000000000000003 0000000000000008 0000000000000000
<6>GPR08: 0000000000000002 cf0001960b000008 c000000006051240 0000000000000003
<6>GPR12: 0000000000000003 c000000000484080 00000000100d0000 0000000000bc5000
<6>GPR16: 0000000007fff000 0000000000000001 00000000100a0000 00000000100d0000
<6>GPR20: 0000000000000000 00000000100df628 00000000100df458 00000000100df678
<6>GPR24: 0000000000740336 c000000000492c00 0000000000000000 0000000000000001
<6>GPR28: 0000000740325000 0000000740324924 c0000000004ce9a8 cf0001960affffe0
NIP [c000000000087340] .memmap_init_zone+0xf0/0x134
LR [c00000000008733c] .memmap_init_zone+0xec/0x134
Call Trace:
[c000000006047b80] [c0000000001da530] .add_memory_block+0xd8/0x108 (unreliable)
[c000000006047c20] [c0000000000aa7ac] .__add_pages+0x10c/0x18c
[c000000006047cd0] [c000000000025fd4] .arch_add_memory+0x44/0x60
[c000000006047d60] [c0000000000aa5b0] .add_memory+0xd4/0x124
[c000000006047e00] [c000000000452544] .ps3_mm_add_memory+0x8c/0x108
[c000000006047ea0] [c0000000004417c4] .kernel_init+0x1f4/0x3b8
[c000000006047f90] [c000000000021d88] .kernel_thread+0x4c/0x68
Instruction dump:
901f000c 38000400 7d20f8a8 7d290378 7d20f9ad 40a2fff4 7ba00521 7fe3fb78
38800002 41820008 4bffff0d 393f0028 <f9290008> f93f0028 3bbd0001 3bff0038
<0>Kernel panic - not syncing: Attempted to kill init!

