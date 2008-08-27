Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYH0Rwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYH0Rwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYH0Rw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:52:29 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45977 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214AbYH0Rw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:52:27 -0400
Message-ID: <48B5944C.8090409@linux.vnet.ibm.com>
Date: Wed, 27 Aug 2008 23:22:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for August 26 - Badness at kernel/notifier.c:25
References: <20080826184008.6be39f19.sfr@canb.auug.org.au> <48B44B2D.8070809@linux.vnet.ibm.com> <48B46610.1010809@linux.intel.com> <48B53695.3020703@linux.vnet.ibm.com> <48B55B16.7060804@linux.intel.com>
In-Reply-To: <48B55B16.7060804@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Kamalesh Babulal wrote:
>> Thanks for reference of the patch, After replacing the patch with the latest 
>> one above on the powerpc, the warning still remains
>>
>> Badness at kernel/notifier.c:86
> 
> sadly you have something going on that doesn't list the modules loaded etc...
> 
> is this during boot or way later?
> (because if it's the later, you might be hitting a legitimate bug ;-)
> 
>> NIP: c000000000081470 LR: c000000000081494 CTR: c00000000005a2d0
>> REGS: c0000021ce0bfaf0 TRAP: 0700   Not tainted  (2.6.27-rc4-next-20080826-autotest)
>> MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 24008042  XER: 00000005
>> TASK = c0000015de080000[1] 'swapper' THREAD: c0000021ce0bc000 CPU: 0
>> GPR00: c000000000081494 c0000021ce0bfd70 c00000000081e940 c000000000749c38 
>> GPR04: 0000000000000003 0000000000000001 ffffffffffffffff c0000021ce0bfe90 
>> GPR08: ffffffffffffffff ffffffffffffffff c0000000004fd9f0 c0000000004fd9f0 
>> GPR12: 0000000024000042 c00000000089c300 0000000002307ef0 c0000000006332a0 
>> GPR16: c000000000631f28 c000000000633388 00000000018bf8b0 0000000002700000 
>> GPR20: c00000000070b07c c000000000707ef0 c000000000708160 c000000000631c58 
>> GPR24: 0000000000000003 0000000000000001 c0000021ce0bfe90 0000000000000000 
>> GPR28: ffffffffffffffff c000000000749c20 c0000000007bf338 c000000000749c38 
>> NIP [c000000000081470] .notifier_call_chain+0x70/0x140
>> LR [c000000000081494] .notifier_call_chain+0x94/0x140
>> Call Trace:
>> [c0000021ce0bfd70] [c000000000081494] .notifier_call_chain+0x94/0x140 (unreliable)
>> [c0000021ce0bfe20] [c0000000004fe3fc] .cpu_up+0x10c/0x200
>> [c0000021ce0bfee0] [c0000000006cdcc0] .kernel_init+0x1b0/0x440
>> [c0000021ce0bff90] [c0000000000299cc] .kernel_thread+0x4c/0x68
>> Instruction dump:
>> e8630000 2fa30000 419e00f0 2fa60000 419e00e8 2e270000 7c7f1b78 3b600000 
>> 48000028 60000000 60000000 60000000 <0fe00000> 2fbd0000 2f3c0000 7fbfeb78 
>>
This is during the bootup
Welcome to yaboot version 1.3.12
Enter "help" to get some basic usage information
boot: autotest
Please wait, loading kernel...
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded at 02700000, size: 846 Kbytes
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: root=/dev/sda6 console=hvc0 IDENT=1219851195 
memory layout at init:
  alloc_bottom : 00000000027d4000
  alloc_top    : 0000000008000000
  alloc_top_hi : 0000000100000000
  rmo_top      : 0000000008000000
  ram_top      : 0000000100000000
Looking for displays
instantiating rtas at 0x00000000076a1000 ... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000002... done
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x00000000028d5000 -> 0x00000000028d637a
Device tree struct  0x00000000028d7000 -> 0x00000000028df000
Calling quiesce ...
returning from prom_init
Using pSeries machine description
Found initrd at 0xc000000002700000:0xc0000000027d3800
console [udbg0] enabled
Partition configured for 4 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Wed Aug 27 11:25:24 EDT 2008
-----------------------------------------------------
ppc64_pft_size                = 0x1a
physicalMemorySize            = 0x100000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Linux version 2.6.27-rc4-next-20080826-autotest (root@gekko-lp1.ltc.austin.ibm.com) (gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #1 SMP Wed Aug 27 11:25:24 EDT 2008
[boot]0012 Setup Arch
PCI host bridge /pci@800000020000002  ranges:
  IO 0x000003fe00600000..0x000003fe006fffff -> 0x0000000000000000
 MEM 0x0000040100000000..0x000004017fffffff -> 0x0000000080000000 
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 7168 bytes
Zone PFN ranges:
  DMA      0x00000000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00100000
[boot]0015 Setup Done
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1034240
Policy zone: DMA
Kernel command line: root=/dev/sda6 console=hvc0 IDENT=1219851195 
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: timebase mult[10cd746] shift[22] registered
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
freeing bootmem node 0
Memory: 4101404k/4194304k available (7536k kernel code, 92900k reserved, 1108k data, 604k bss, 300k init)
SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=16
Calibrating delay loop... 475.13 BogoMIPS (lpj=950272)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
------------[ cut here ]------------
Badness at kernel/notifier.c:86
NIP: c00000000050228c LR: c000000000502274 CTR: c000000000054ffc
REGS: c0000000fe06bb10 TRAP: 0700   Not tainted  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 44000082  XER: 00000004
TASK = c0000000fe060000[1] 'swapper' THREAD: c0000000fe068000 CPU: 0
GPR00: c000000000502274 c0000000fe06bd90 c000000000873748 c000000000791220 
GPR04: 0000000000000003 0000000000000001 ffffffffffffffff c0000000fe06beb0 
GPR08: c0000000005075cc c00000000077e0c8 c0000000005075cc c0000000fe068000 
GPR12: c0000000008f8300 c0000000008f8300 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000230000 0000000000000000 00000000000d3800 4000000001c00000 
GPR24: 0000000000000003 0000000000000001 c0000000fe06beb0 0000000000000000 
GPR28: ffffffffffffffff c000000000791208 c00000000080bdc0 c000000000791220 
NIP [c00000000050228c] .notifier_call_chain+0x8c/0x138
LR [c000000000502274] .notifier_call_chain+0x74/0x138
Call Trace:
[c0000000fe06bd90] [c000000000502274] .notifier_call_chain+0x74/0x138 (unreliable)
[c0000000fe06be40] [c000000000507ea0] .cpu_up+0xec/0x204
[c0000000fe06bf00] [c000000000711c58] .kernel_init+0x158/0x384
[c0000000fe06bf90] [c0000000000269a4] .kernel_thread+0x4c/0x68
Instruction dump:
7d2b0038 2c0b0000 418200a4 e87f0000 ebbf0008 4bb6eaf1 60000000 7f04c378 
7f25cb78 2fa30000 7fe3fb78 409e0010 <0fe00000> 7fbfeb78 48000050 e93f0000 
------------[ cut here ]------------
Badness at kernel/notifier.c:86
.
.
.
<snip Badness at kernel/notifier.c:86 9 times>
.
.
.
------------[ cut here ]------------
Badness at kernel/notifier.c:86
NIP: c00000000050228c LR: c000000000502274 CTR: 80000000001af404
REGS: c0000000fe06bb10 TRAP: 0700   Tainted: G        W  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 42000022  XER: 00000004
TASK = c0000000fe060000[1] 'swapper' THREAD: c0000000fe068000 CPU: 0
GPR00: c000000000502274 c0000000fe06bd90 c000000000873748 c000000000791220 
GPR04: 0000000000000002 0000000000000001 ffffffffffffffff 0000000000000000 
GPR08: c0000000005075cc c00000000077e0c8 c0000000005075cc c0000000fe068000 
GPR12: 0000000000004000 c0000000008f8300 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000230000 <1>Unable to handle kernel paging request for data at address 0xffffffffffffffe8
Faulting instruction address: 0xc000000000077fa0
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c000000000077fa0 LR: c000000000077f84 CTR: c000000000066110
REGS: c00000000fff7af0 TRAP: 0300   Tainted: G        W  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28000044  XER: 00000000
DAR: ffffffffffffffe8, DSISR: 0000000040010000
TASK = c0000000fe061160[0] 'swapper' THREAD: c0000000fe080000 CPU: 1
GPR00: c000000000077f84 c00000000fff7d70 c000000000873748 c0000000009b0b70 
GPR04: 0000000000000018 0000000000000002 0000000000000000 c000000000759088 
GPR08: c00000000088a380 0000000000000000 0000000000000056 c00000000088a380 
GPR12: 0000000048000044 c0000000008f8500 0000000000000000 000000000796a428 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000003 
GPR24: 0000000000000001 c0000000009b0c18 c0000000009b0b70 0000000000000000 
GPR28: 0000000000000001 c00000000088a188 c00000000080c168 ffffffffffffffc0 
NIP [c000000000077fa0] .run_hrtimer_pending+0x4c/0x1c0
LR [c000000000077f84] .run_hrtimer_pending+0x30/0x1c0
Call Trace:
[c00000000fff7d70] [c000000000077f84] .run_hrtimer_pending+0x30/0x1c0 (unreliable)
[c00000000fff7e20] [c00000000006614c] .run_timer_softirq+0x3c/0x288
[c00000000fff7ef0] [c00000000005f9b4] .__do_softirq+0xac/0x16c
[c00000000fff7f90] [c0000000000267e8] .call_do_softirq+0x14/0x24
[c0000000fe0839b0] [c00000000000cd58] .do_softirq+0x94/0x104
[c0000000fe083a50] [c00000000005fb84] .irq_exit+0x70/0xcc
[c0000000fe083ad0] [c00000000002352c] .timer_interrupt+0xe0/0x10c
[c0000000fe083b60] [c000000000003700] decrementer_common+0x100/0x180
--- Exception: 901 at .raw_local_irq_restore+0x3c/0x40
    LR = .cpu_idle+0x12c/0x200
[c0000000fe083e50] [c000000000012fa8] .cpu_idle+0x120/0x200 (unreliable)
[c0000000fe083ed0] [c000000000509e34] .start_secondary+0x364/0x3a0
[c0000000fe083f90] [c000000000008364] .start_secondary_prolog+0xc/0x10
Instruction dump:
fbe1fff8 3b3a00a8 f8010010 f821ff51 48487a05 60000000 eb7a00a8 7fbbc800 
419e012c 3bfbffc0 38a00002 38c00000 <e89f0028> 7fe3fb78 ebbf0020 4bfff925 
Kernel panic - not syncing: Fatal exception in interrupt
Call Trace:
[c00000000fff7810] [c0000000000114b0] .show_stack+0x6c/0x194 (unreliable)
[c00000000fff78c0] [c000000000058994] .panic+0x74/0x1cc
[c00000000fff7950] [c000000000024a84] .die+0x248/0x28c
[c00000000fff7a00] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff7a80] [c000000000005218] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .run_hrtimer_pending+0x4c/0x1c0
    LR = .run_hrtimer_pending+0x30/0x1c0
[c00000000fff7e20] [c00000000006614c] .run_timer_softirq+0x3c/0x288
[c00000000fff7ef0] [c00000000005f9b4] .__do_softirq+0xac/0x16c
[c00000000fff7f90] [c0000000000267e8] .call_do_softirq+0x14/0x24
[c0000000fe0839b0] [c00000000000cd58] .do_softirq+0x94/0x104
[c0000000fe083a50] [c00000000005fb84] .irq_exit+0x70/0xcc
[c0000000fe083ad0] [c00000000002352c] .timer_interrupt+0xe0/0x10c
[c0000000fe083b60] [c000000000003700] decrementer_common+0x100/0x180
--- Exception: 901 at .raw_local_irq_restore+0x3c/0x40
    LR = .cpu_idle+0x12c/0x200
[c0000000fe083e50] [c000000000012fa8] .cpu_idle+0x120/0x200 (unreliable)
[c0000000fe083ed0] [c000000000509e34] .start_secondary+0x364/0x3a0
[c0000000fe083f90] [c000000000008364] .start_secondary_prolog+0xc/0x10
------------[ cut here ]------------
Badness at kernel/smp.c:290
NIP: c00000000008595c LR: c000000000085b3c CTR: 0000000000000000
REGS: c00000000fff7410 TRAP: 0700   Tainted: G      D W  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000021032 <ME,IR,DR>  CR: 22000024  XER: 00000000
TASK = c0000000fe061160[0] 'swapper' THREAD: c0000000fe080000 CPU: 1
f2e10] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff2e90] [c000000000005218] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .kmem_cache_alloc+0x44/0xdc
    LR = .smp_call_function_single+0xbc/0x118
[c00000000fff3180] [c000000000085960] .smp_call_function_mask+0x60/0x208 (unreliable)
[c00000000fff3220] [c00000000008587c] .smp_call_function_single+0xbc/0x118
[c00000000fff3310] [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
[c00000000fff3440] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff34c0] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff3540] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff35d0] [c000000000024a84] .die+0x248/0x28c
[c00000000fff3680] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff3700] [c000000000005218] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .kmem_cache_alloc+0x44/0xdc
    LR = .smp_call_function_single+0xbc/0x118
[c00000000fff39f0] [c000000000085960] .smp_call_function_mask+0x60/0x208 (unreliable)
[c00000000fff3a90] [c00000000008587c] .smp_call_function_single+0xbc/0x118
[c00000000fff3b80] [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
[c00000000fff3cb0] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff3d30] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff3db0] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff3e40] [c000000000024a84] .die+0x248/0x28c
[c00000000fff3ef0] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff3f70] [c000000000005218] handle_page_fault+0x3c/0x5c
------------[ cut here ]------------
Badness at kernel/smp.c:290
NIP: c00000000008595c LR: c000000000085b3c CTR: 0000000000000000
REGS: c00000000fff2820 TRAP: 0700   Tainted: G      D W  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000021032 <ME,IR,DR>  CR: 22000024  XER: 00000000
TASK = c0000000fe061160[0] 'swapper' THREAD: c0000000fe080000 CPU: 1
GPR00: 0000000000000001 c00000000fff2aa0 c000000000873748 0000000000000003 
GPR04: 0000000000000000 c000000000828930 0000000000000000 0000000000000000 
GPR08: c00000000fff4260 0000000000000000 0000000000000001 0000000000000001 
GPR12: 0000000022000082 c0000000008f8500 0000000000000000 000000000796a428 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000003 
GPR24: 0000000000000001 000000000000000b 0000000000000000 c000000000828930 
GPR28: 0000000000000000 c0000000006626b0 c00000000080d0e8 0000000000000000 
NIP [c00000000008595c] .smp_call_function_mask+0x5c/0x208
LR [c000000000085b3c] .smp_call_function+0x34/0x48
Call Trace:
[c00000000fff2aa0] [c000000000059cdc] .try_acquire_console_sem+0x1c/0x5c (unreliable)
[c00000000fff2bd0] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff2c50] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff2cd0] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff2d60] [c000000000024a84] .die+0x248/0x28c
[c00000000fff2e10] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff2e90] [c000000000005218] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .kmem_cache_alloc+0x44/0xdc
    LR = .smp_call_function_single+0xbc/0x118
[c00000000fff3180] [c000000000085960] .smp_call_function_mask+0x60/0x208 (unreliable)
[c00000000fff3220] [c00000000008587c] .smp_call_function_single+0xbc/0x118
[c00000000fff3310] [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
[c00000000fff3440] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff34c0] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff3540] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff35d0] [c000000000024a84] .die+0x248/0x28c
[c00000000fff3680] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff3700] [c000000000005218] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .kmem_cache_alloc+0x44/0xdc
    LR = .smp_call_function_single+0xbc/0x118
[c00000000fff39f0] [c000000000085960] .smp_call_function_mask+0x60/0x208 (unreliable)
[c00000000fff3a90] [c00000000008587c] .smp_call_function_single+0xbc/0x118
[c00000000fff3b80] [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
[c00000000fff3cb0] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff3d30] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff3db0] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff3e40] [c000000000024a84] .die+0x248/0x28c
[c00000000fff3ef0] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff3f70] [c000000000005218] handle_page_fault+0x3c/0x5c
Instruction dump:
7cfc3b78 f821fed1 60000000 60000000 e8010000 f8610160 f8810168 f82100e8 
f80100e0 880d01da 21200000 7c090114 <0b000000> a14d000a e93e8040 38a100c0 
------------[ cut here ]------------
Badness at kernel/smp.c:216
NIP: c00000000008580c LR: c000000000085a0c CTR: 0000000000000000
REGS: c00000000fff2730 TRAP: 0700   Tainted: G      D W  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000021032 <ME,IR,DR>  CR: 42000028  XER: 00000000
TASK = c0000000fe061160[0] 'swapper' THREAD: c0000000fe080000 CPU: 1
GPR00: 0000000000000001 c00000000fff29b0 c000000000873748 0000000000000000 
GPR04: c000000000828930 0000000000000000 0000000000000000 0000000000000000 
GPR08: c00000000fff2c00 0000000000000001 0000000000000040 0000000000000000 
GPR12: 0000000022000082 c0000000008f8500 0000000000000000 000000000796a428 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000003 
GPR24: 0000000000000001 000000000000000b 0000000000000000 c000000000828930 
GPR28: 0000000000000000 c000000000828930 c00000000080d0e8 0000000000000000 
NIP [c00000000008580c] .smp_call_function_single+0x4c/0x118
LR [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
Call Trace:
[c00000000fff29b0] [c000000000934368] printk_buf+0x0/0x400 (unreliable)
[c00000000fff2aa0] [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
[c00000000fff2bd0] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff2c50] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff2cd0] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff2d60] [c000000000024a84] .die+0x248/0x28c
[c00000000fff2e10] [c00000000002c7b0] .bad_page_fault+0xb8/0xd4
[c00000000fff2e90] [c000000000005218] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .kmem_cache_alloc+0x44/0xdc
    LR = .smp_call_function_single+0xbc/0x118
[c00000000fff3180] [c000000000085960] .smp_call_function_mask+0x60/0x208 (unreliable)
[c00000000fff3220] [c00000000008587c] .smp_call_function_single+0xbc/0x118
[c00000000fff3310] [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
[c00000000fff3440] [c000000000085b3c] .smp_call_function+0x34/0x48
[c00000000fff34c0] [c000000000028848] .smp_send_stop+0x24/0x3c
[c00000000fff3540] [c0000000000589b4] .panic+0x94/0x1cc
[c00000000fff35d0] [c000000000024a84] .die+0x248000000000000001 0000000000000040 0000000000000000 
GPR12: 0000000022000082 c0000000008f8500 0000000000000000 000000000796a428 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000003 
GPR24: 0000000000000001 000000000000000b 0000000000000000 c000000000828930 
GPR28: 0000000000000000 c000000000828930 c00000000080d0e8 0000000000000000 
NIP [c00000000008580c] .smp_call_function_single+0x4c/0x118
LR [c000000000085a0c] .smp_call_function_mask+0x10c/0x208
Call Trace:
Instruction dump:
7c9d2378 f8010010 f821ff11 7cbc2b78 e8010000 f82100b8 f80100b0 60000000 
a12d000a 880d01da 21600000 7c0b0114 <0b000000> 7f834800 409e0050 38000000 
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0000000000e35b8
Oops: Kernel access of bad area, sig: 11 [#27]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in:
NIP: c0000000000e35b8 LR: c00000000008587c CTR: 0000000000000000
REGS: c00000000ffe99e0 TRAP: 0300   Tainted: G      D W  (2.6.27-rc4-next-20080826-autotest)
MSR: 8000000000001032 <ME,IR,DR>  CR: 42000022  XER: 00000000
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c0000000fe061160[0] 'swapper' THREAD: c0000000fe080000 CPU: 1
GPR00: c00000000008587c c00000000ffe9c60 c000000000873748 c0000000008ec630 
GPR04: 0000000000000020 ffffffffffffffff c00000000008587c 0000000000000000 
GPR08: c00000000ffe9f50 0000000000000000 0000000000000040 0000000000000000 
GPR12: 0000000022000082 c0000000008f8500 0000000000000000 000000000796a428 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000003 
GPR24: 0000000000000001 000000000000000b 0000000000000000 0000000000000020 
GPR28: 0000000000000000 0000000000000000 c00000000080d0e8 0000000000000000 
NIP [c0000000000e35b8] .kmem_cache_alloc+0x44/0xdc
LR [c00000000008587c] .smp_call_function_single+0xbc/0x118
Call Trace:
Instruction dump:
7c9b2378 f8010010 f821ff61 39200000 8bad01da 992d01da 7cc802a6 a12d000a 
38a0ffff 79291f24 7d291a14 e9290188 <e8090000> 7d274b78 83890018 2fa00000 
Kernel panic - not syncing: Fatal exception in interrupt
Call Trace:
.
.
<snip>
The Badness at kernel/smp.c:290 and Badness at kernel/smp.c:216 goes on in an loop.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
