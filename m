Return-Path: <linux-kernel-owner+w=401wt.eu-S1764488AbYCDNMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764488AbYCDNMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYCDNMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:12:31 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40342 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbYCDNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:12:30 -0500
Message-ID: <47CD4AB3.3080409@linux.vnet.ibm.com>
Date: Tue, 04 Mar 2008 18:42:19 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] 2.6.25-rc3-mm1 kernel panic while bootup on powerpc ()
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.25-rc3-mm1 kernel panics while bootup on power box. The machine booted up
without the panic on the third attempt, but badness call trace were seen while running
tests

1) The kernel panic on first attempt

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc00000000000cb2c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c00000000000cb2c LR: c00000000000caf8 CTR: 0000000000000226
REGS: c00000000068f360 TRAP: 0300   Not tainted  (2.6.25-rc3-mm1-autotest)
MSR: 8000000000001032 <ME,IR,DR>  CR: 28000024  XER: 20000001
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c0000000005c8590[0] 'swapper' THREAD: c00000000068c000 CPU: 0
GPR00: c00000000068f5e0 c00000000068f5e0 c00000000068e690 0000000000000000 
GPR04: 00000000000035e0 000000000087264e c000000008011280 c000000000594000 
GPR08: c0000000005c9300 0000000000000000 c000000000591090 c00000000068c000 
GPR12: 8000000000009032 c0000000005c9300 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000008000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 000000000000007f 0000000000018000 
GPR24: 0000000000000001 0000000000000080 0000000000000018 0000000000000000 
GPR28: 0000000000000c00 c000000000588988 c000000000639be8 c000000008001c00 
NIP [c00000000000cb2c] .do_IRQ+0x74/0x1c4
LR [c00000000000caf8] .do_IRQ+0x40/0x1c4
Call Trace:
[c00000000068f5e0] [c00000000000caf8] .do_IRQ+0x40/0x1c4 (unreliable)
[c00000000068f680] [c000000000004790] hardware_interrupt_entry+0x18/0x1c
--- Exception: 501 at .memset+0x70/0xfc
    LR = .__alloc_bootmem_core+0x39c/0x3dc
[c00000000068f970] [c00000000068fa10] init_thread_union+0x3a10/0x4000 (unreliable)
[c00000000068fa30] [c00000000057237c] .__alloc_bootmem_node+0x38/0x8c
[c00000000068fad0] [c0000000003c477c] .zone_wait_table_init+0x74/0x108
[c00000000068fb60] [c0000000003d9058] .init_currently_empty_zone+0x40/0x11c
[c00000000068fc00] [c0000000003d94c8] .free_area_init_node+0x394/0x3fc
[c00000000068fcf0] [c00000000057314c] .free_area_init_nodes+0x2d8/0x364
[c00000000068fd90] [c00000000056682c] .paging_init+0x40/0x58
[c00000000068fe40] [c00000000055ba34] .setup_arch+0x20c/0x240
[c00000000068fee0] [c000000000552690] .start_kernel+0xdc/0x414
[c00000000068ff90] [c000000000008594] .start_here_common+0x54/0xc0
Instruction dump:
7c200b78 780404a0 2ba408ff 41bd001c e87e80a8 3884ff00 48058d21 60000000 
480054cd 60000000 e93e80b0 e92900b8 <e8090000> f8410028 e9690010 e8490008 

2) The kernel panic on second attempt

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc00000000000cb2c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c00000000000cb2c LR: c00000000000caf8 CTR: 0000000000014a99
REGS: c00000000068f410 TRAP: 0300   Not tainted  (2.6.25-rc3-mm1-autotest)
MSR: 8000000000001032 <ME,IR,DR>  CR: 28000044  XER: 00000001
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c0000000005c8590[0] 'swapper' THREAD: c00000000068c000 CPU: 0
GPR00: c00000000068f690 c00000000068f690 c00000000068e690 0000000000000000 
GPR04: 0000000000003690 0000000000537672 c000000001ad59c0 c000000000594000 
GPR08: c0000000005c9300 0000000000000000 c000000000591090 c00000000068c000 
GPR12: 8000000000009032 c0000000005c9300 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000230000 0000000000000000 0000000000ffffff 0000000001000000 
GPR24: 0000000000001000 0000000001000000 0000000000001000 0000000000000000 
GPR28: 0000000000000000 c0000000005889c8 c000000000639be8 c000000001000000 
NIP [c00000000000cb2c] .do_IRQ+0x74/0x1c4
LR [c00000000000caf8] .do_IRQ+0x40/0x1c4
Call Trace:
[c00000000068f690] [c00000000000caf8] .do_IRQ+0x40/0x1c4 (unreliable)
[c00000000068f730] [c000000000004790] hardware_interrupt_entry+0x18/0x1c
--- Exception: 501 at .memset+0x80/0xfc
    LR = .__alloc_bootmem_core+0x39c/0x3dc
[c00000000068fa20] [c000000000641a78] sysctl_pernet_ops+0x108e0/0x1d6e0 (unreliable)
[c00000000068fae0] [c00000000057237c] .__alloc_bootmem_node+0x38/0x8c
[c00000000068fb80] [c0000000003c48dc] .__earlyonly_bootmem_alloc+0x24/0x3c
[c00000000068fc00] [c0000000003d885c] .vmemmap_populate+0x7c/0xf4
[c00000000068fc90] [c0000000003d9b6c] .sparse_mem_map_populate+0x38/0x64
[c00000000068fd10] [c000000000573ec4] .sparse_early_mem_map_alloc+0x54/0x98
[c00000000068fda0] [c000000000573f70] .sparse_init+0x68/0x148
[c00000000068fe40] [c00000000055b9ec] .setup_arch+0x1c4/0x240
[c00000000068fee0] [c000000000552690] .start_kernel+0xdc/0x414
[c00000000068ff90] [c000000000008594] .start_here_common+0x54/0xc0
Instruction dump:
7c200b78 780404a0 2ba408ff 41bd001c e87e80a8 3884ff00 48058d21 60000000 
480054cd 60000000 e93e80b0 e92900b8 <e8090000> f8410028 e9690010 e8490008 

3) Third attempt kernel booted up but had the following call trace 264 times while running
test

Badness at include/linux/gfp.h:110
NIP: c0000000000b4ff0 LR: c0000000000b4fa0 CTR: c00000000019cdb4
REGS: c000000009edf250 TRAP: 0700   Not tainted  (2.6.25-rc3-mm1-autotest)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 22024042  XER: 20000003
TASK = c000000009062140[548] 'kjournald' THREAD: c000000009edc000 CPU: 0
NIP [c0000000000b4ff0] .get_page_from_freelist+0x29c/0x898
LR [c0000000000b4fa0] .get_page_from_freelist+0x24c/0x898
Call Trace:
[c000000009edf5f0] [c0000000000b56e4] .__alloc_pages_internal+0xf8/0x470
[c000000009edf6e0] [c0000000000e0458] .kmem_getpages+0x8c/0x194
[c000000009edf770] [c0000000000e1050] .fallback_alloc+0x194/0x254
[c000000009edf820] [c0000000000e14b0] .kmem_cache_alloc+0xd8/0x144
[c000000009edf8c0] [c0000000001fe0f8] .radix_tree_preload+0x50/0xd4
[c000000009edf960] [c0000000000ad048] .add_to_page_cache+0x38/0x12c
[c000000009edfa00] [c0000000000ad158] .add_to_page_cache_lru+0x1c/0x4c
[c000000009edfa90] [c0000000000add58] .find_or_create_page+0x60/0xa8
[c000000009edfb30] [c00000000011e478] .__getblk+0x140/0x310
[c000000009edfc00] [c0000000001b78c4] .journal_get_descriptor_buffer+0x44/0xd8
[c000000009edfca0] [c0000000001b236c] .journal_commit_transaction+0x948/0x1590
[c000000009edfe00] [c0000000001b585c] .kjournald+0xf4/0x2ac
[c000000009edff00] [c00000000007ff4c] .kthread+0x84/0xd0
[c000000009edff90] [c000000000028900] .kernel_thread+0x4c/0x68
Instruction dump:
7dc57378 48009575 60000000 2fa30000 419e0490 56c902d8 3c000018 7dd907b4 
7ad2c7e2 7f890000 7c000026 5400fffe <0b000000> e93e8128 3b000000 80090000 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
