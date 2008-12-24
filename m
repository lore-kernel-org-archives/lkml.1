Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbYLXH4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYLXH4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 02:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYLXHzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 02:55:55 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:39785 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYLXHzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 02:55:53 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Wed, 24 Dec 2008 13:25:49 +0530
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812241325.49404.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a ppc machine booting linux-2.6.28-rc9 with crashkernel=256M@32M boot 
parameter causes the kernel to panic while booting.  Following are the console 
messages...

=================================
<snip>
...
Calling quiesce ...
returning from prom_init
Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
Phyp-dump disabled at boot time
Using pSeries machine description
Using 1TB segments
Found initrd at 0xc000000000e00000:0xc0000000015ab50c
console [udbg0] enabled
Partition configured for 4 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #3 SMP Mon Dec 22 02:16:31 CST 2008
-----------------------------------------------------
ppc64_pft_size                = 0x1a
physicalMemorySize            = 0x100000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.28-rc9-1-ppc64 (root@rulerlp10) (gcc version 4.3.2 
[gcc-4_3-branch revision 141291] (SUSE Linux) ) #3 SMP Mon Dec 22 02:16:31 CST 
2008
[boot]0012 Setup Arch
------------[ cut here ]------------
kernel BUG at mm/bootmem.c:279!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in:
NIP: c000000000747538 LR: c000000000731d1c CTR: c000000000730cf4
REGS: c000000000993a00 TRAP: 0700   Not tainted  (2.6.28-rc9-1-ppc64)
MSR: 8000000000021032 <ME,IR,DR>  CR: 24002082  XER: 00000001
TASK = c0000000008dfaa0[0] 'swapper' THREAD: c000000000990000 CPU: 0
GPR00: 0000000000000001 c000000000993c80 c00000000098a768 c0000000007664d0
GPR04: 00000000000001f7 0000000000001001 0000000000000001 0000000000000000
GPR08: 0000000000000000 0000000000000000 c0000000008dd6c0 0000000000000000
GPR12: 0000000024002088 c000000000a52c00 c000000000763990 c00000000067f735
GPR16: 00000000034638c8 0000000000000000 c000000000993d98 c000000000993d90
GPR20: c000000000993da0 c000000000c32bc8 c000000001f78800 c000000000000000
GPR24: 0000000000000004 0000000010087800 0000000000000000 0000000000000001
GPR28: 00000000000001f7 0000000000001001 c000000000910cb0 c0000000007664d0
NIP [c000000000747538] .mark_bootmem_node+0xa8/0x120
LR [c000000000731d1c] .do_init_bootmem+0xc1c/0xd58
Call Trace:
[c000000000993c80] [c000000000993d20] init_thread_union+0x3d20/0x4000 
(unreliable)
[c000000000993d20] [c000000000731d1c] .do_init_bootmem+0xc1c/0xd58
[c000000000993e40] [c0000000007267f0] .setup_arch+0x1a4/0x21c
[c000000000993ee0] [c000000000720868] .start_kernel+0xdc/0x56c
[c000000000993f90] [c0000000000083b8] .start_here_common+0x1c/0x64
Instruction dump:
7ca501d2 4bda924d 60000000 e93f0000 7c09e010 7c000110 7c0000d0 0b000000
e81f0008 7c1d0010 7c000110 7c0000d0 <0b000000> 2fbb0000 7ca9e850 7c89e050
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------[ cut here ]------------
Badness at kernel/smp.c:333
NIP: c0000000000b9384 LR: c0000000000b96ac CTR: 0000000000136f8c
REGS: c000000000992eb0 TRAP: 0700   Tainted: G      D     (2.6.28-rc9-1-ppc64)
MSR: 8000000000021032 <ME,IR,DR>  CR: 28002084  XER: 00000001
TASK = c0000000008dfaa0[0] 'swapper' THREAD: c000000000990000 CPU: 0
GPR00: 0000000000000001 c000000000993130 c00000000098a768 0000000000000001
GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000028002082 c000000000a52c00 c000000000763990 c00000000067f735
GPR16: 00000000034638c8 0000000000000000 c000000000993d98 c000000000993d90
GPR20: c000000000993da0 c000000000c32bc8 c000000001f78800 0000000000000000
GPR24: c000000000926320 0000000000000000 0000000000000000 0000000000000000
GPR28: 0000000000000000 0000000000000000 c00000000090f4f8 c000000000af8380
NIP [c0000000000b9384] .smp_call_function_mask+0x6c/0x2f4
LR [c0000000000b96ac] .smp_call_function+0xa0/0xcc
Call Trace:
[c000000000993130] [c0000000009931d0] init_thread_union+0x31d0/0x4000 
(unreliable)
[c000000000993420] [c0000000000b96ac] .smp_call_function+0xa0/0xcc
[c000000000993530] [c00000000002ce0c] .smp_send_stop+0x24/0x3c
[c0000000009935b0] [c0000000004f0658] .panic+0x98/0x198
[c000000000993640] [c00000000008fe18] .do_exit+0xa0/0x900
[c000000000993730] [c000000000027984] .die+0x274/0x278
[c0000000009937d0] [c000000000027c78] ._exception+0x88/0x20c
[c000000000993990] [c000000000004f8c] program_check_common+0x10c/0x180
--- Exception: 700 at .mark_bootmem_node+0xa8/0x120
    LR = .do_init_bootmem+0xc1c/0xd58
[c000000000993c80] [c000000000993d20] init_thread_union+0x3d20/0x4000 
(unreliable)
[c000000000993d20] [c000000000731d1c] .do_init_bootmem+0xc1c/0xd58
[c000000000993e40] [c0000000007267f0] .setup_arch+0x1a4/0x21c
[c000000000993ee0] [c000000000720868] .start_kernel+0xdc/0x56c
[c000000000993f90] [c0000000000083b8] .start_here_common+0x1c/0x64
Instruction dump:
eae103a8 eb4103b6 f8810328 f8a10330 f8c10338 f8e10340 f9010348 f9210350
f9410358 880d01da 7c000074 7800d182 <0b000000> 3b8100d8 a3ad000a e89e8028
Rebooting in 180 seconds..                                         
=================================



When booted with crashkernel=224M@32M or any memory size less than this, the 
system boots properly. The following was the observation.. 
The system comes up with two nodes (0-256M and 256M-4GB).  The crashkernel 
memory reservation spans across these two nodes.  The 
mark_reserved_regions_for_nid() in arch/powerpc/mm/numa.c resizes the reserved 
part of the memory within it as...
...
...
            if (end_pfn > node_ar.end_pfn)
                reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
                    - (start_pfn << PAGE_SHIFT);


but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of end 

    end = PFN_UP(physaddr + size);

This causes end to get a value past the last page in the 0-256M node.  Again 
when reserve_bootmem_node() returns,  mark_reserved_regions_for_nid() loops 
around to set the rest of the crashkernel memory in the next node as reserved.  
It references NODE_DATA(node_ar.nid) and this causes another 'Oops: kernel 
access of bad area' problem. The following changes made the system to boot 
with any amount of crashkernel memory size.


Fix code for reserved memory spanning across nodes

Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
---

--- linux-2.6.28-rc9//arch/powerpc/mm/numa.c.orig	2008-12-22 
04:23:24.000000000 -0600
+++ linux-2.6.28-rc9/arch/powerpc/mm/numa.c	2008-12-22 04:24:25.000000000 -0600
@@ -995,10 +995,11 @@ void __init do_init_bootmem(void)
 				  start_pfn, end_pfn);
 
 		free_bootmem_with_active_regions(nid, end_pfn);
+	}
+
+	for_each_online_node(nid) {
 		/*
-		 * Be very careful about moving this around.  Future
-		 * calls to careful_allocation() depend on this getting
-		 * done correctly.
+		 * Be very careful about moving this around.
 		 */
 		mark_reserved_regions_for_nid(nid);
 		sparse_memory_present_with_active_regions(nid);
--- linux-2.6.28-rc9/mm/bootmem.c.orig	2008-12-19 10:49:24.000000000 -0600
+++ linux-2.6.28-rc9/mm/bootmem.c	2008-12-19 10:49:33.000000000 -0600
@@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
 				 unsigned long size, int flags)
 {
 	unsigned long start, end;
+	bootmem_data_t *bdata = pgdat->bdata;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
+	if (end > bdata->node_low_pfn)
+		end = bdata->node_low_pfn;
+
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
 }

