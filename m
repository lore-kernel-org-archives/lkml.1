Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZALLrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZALLrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZALLrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:47:11 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41767 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZALLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:47:08 -0500
Date: Mon, 12 Jan 2009 17:09:14 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, mel@csn.ul.ie
Subject: [BUG] 2.6.29-rc1 - Badness at kernel/sched.c:4440 with
	CONFIG_DEBUG_PREEMPT
Message-ID: <20090112113914.GC8409@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	While booting up 2.6.29-rc1 kernel on powerpc machine, Kernel
Badness warning is seen, when compiled with CONFIG_DEBUG_PREEMPT=y

[boot]0012 Setup Arch
PCI host bridge /pci@800000020000200  ranges:
  IO 0x00003dffe01f0000..0x00003dffe01fffff -> 0x00000000000f0000
 MEM 0x00003c0000000000..0x00003c007fffffff -> 0x0000000080000000 
PCI host bridge /pci@800000020000201  ranges:
  IO 0x00003dffe02f0000..0x00003dffe02fffff -> 0x00000000000f0000
 MEM 0x00003c0080000000..0x00003c00ffffffff -> 0x0000000080000000 
PCI host bridge /pci@800000020000202  ranges:
  IO 0x00003dffe03f0000..0x00003dffe03fffff -> 0x00000000000f0000
 MEM 0x00003c0100000000..0x00003c017fffffff -> 0x0000000080000000 
PCI host bridge /pci@800000020000203  ranges:
  IO 0x00003dffe04f0000..0x00003dffe04fffff -> 0x00000000000f0000
 MEM 0x00003c0180000000..0x00003c01ffffffff -> 0x0000000080000000 
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 15360 bytes
Zone PFN ranges:
  DMA      0x00000000 -> 0x000eb000
  Normal   0x000eb000 -> 0x000eb000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    1: 0x00000000 -> 0x00008000
    0: 0x00008000 -> 0x00078000
    1: 0x00078000 -> 0x000eb000
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 943128
Policy zone: DMA
Kernel command line: console=hvc0 root=LABEL=/ autobench_args: root=/dev/sda5 ABAT:1231758168 
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
clocksource: timebase mult[7d0000] shift[22] registered
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [hvc0]
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
------------[ cut here ]------------
Badness at kernel/sched.c:4440
NIP: c000000000508f6c LR: c000000000508f50 CTR: c000000000052ff0
REGS: c00000000ffffc10 TRAP: 0700   Not tainted  (2.6.29-rc1-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28000042  XER: 00000004
TASK = c00000000076cba0[0] 'swapper' THREAD: c000000000854000 CPU: 0
GPR00: 0000000000000000 c00000000ffffe90 c0000000008562b0 0000000000000001 
GPR04: 0000000000000000 00000000fffedb0a 0000000000000100 0000000000000100 
GPR08: 0000000000200200 c0000000009320b8 c000000000756520 c0000000008d39b8 
GPR12: 0000000048000044 c000000000897300 0000000000000000 0000000002100000 
GPR16: c000000000633670 c000000000631e70 0000000000000000 00000000002bc000 
GPR20: 0000000002820c80 c000000000720c80 0000000002820ef0 c000000000720ef0 
GPR24: 0000000002c00000 0000000002820c80 c000000000857bd0 0000000000000000 
GPR28: c000000000854100 c00000000fffc000 c0000000007e8288 0000000000000000 
NIP [c000000000508f6c] .sub_preempt_count+0x6c/0xdc
LR [c000000000508f50] .sub_preempt_count+0x50/0xdc
Call Trace:
[c00000000ffffe90] [c00000000ffffea0] 0xc00000000ffffea0 (unreliable)
[c00000000fffff10] [c00000000005e73c] ._local_bh_enable+0x94/0xac
[c00000000fffff90] [c000000000025e94] .call_do_softirq+0x14/0x24
[c0000000008579a0] [c00000000000cbd4] .do_softirq+0x98/0x100
[c000000000857a40] [c00000000005eeb0] .irq_exit+0x60/0xc8
[c000000000857ac0] [c00000000002322c] .timer_interrupt+0x118/0x15c
[c000000000857b60] [c000000000003700] decrementer_common+0x100/0x180
--- Exception: 901 at .vfs_caches_init_early+0x84/0xb4
    LR = .vfs_caches_init_early+0x54/0xb4
[c000000000857ee0] [c0000000006e98a4] .start_kernel+0x31c/0x450
[c000000000857f90] [c000000000008368] .start_here_common+0x1c/0x34
Instruction dump:
54000ffe 7c004850 7f801800 40bc0074 4bd794a5 60000000 2fa30000 419e0070 
e93e8418 80090000 2f800000 409e0060 <0fe00000> 48000058 79200620 2fa00000 
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 3754756k/3850240k available (7380k kernel code, 112644k reserved, 1148k data, 749k bss, 304k init)
SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=8, Nodes=16
Calibrating delay loop... 1021.95 BogoMIPS (lpj=2043904)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct

git-bisect start
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git-bisect good 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
# bad: [2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git-bisect bad 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f
# bad: [5ed1836814d908f45cafde0e79cb85314ab9d41d] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect bad 5ed1836814d908f45cafde0e79cb85314ab9d41d
# good: [54a696bd07c14d3b1192d03ce7269bc59b45209a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git-bisect good 54a696bd07c14d3b1192d03ce7269bc59b45209a
# good: [fc10af8e658936f7b2bddd077f7ddcbe1eddc066] vcan: whitespace fixes
git-bisect good fc10af8e658936f7b2bddd077f7ddcbe1eddc066
# bad: [6de71484cf9561edb45224f659a9db38b6056d5e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6
git-bisect bad 6de71484cf9561edb45224f659a9db38b6056d5e
# good: [3c92ec8ae91ecf59d88c798301833d7cf83f2179] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc
git-bisect good 3c92ec8ae91ecf59d88c798301833d7cf83f2179
# bad: [179475a3b46f86e2d06f83e2312218ac3f0cf3a7] Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad 179475a3b46f86e2d06f83e2312218ac3f0cf3a7
# bad: [cc37d3d20604f3759d269247b022616f710aa52d] Merge branch 'core/futexes' into core/core
git-bisect bad cc37d3d20604f3759d269247b022616f710aa52d
# bad: [7918baa555140989eeee1270f48533987d48fdba] mutex: __used is needed for function referenced only from inline asm
git-bisect bad 7918baa555140989eeee1270f48533987d48fdba
# good: [30742d5c2277c325fb0e9d2d817d55a19995fe8f] Revert "lockdep: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set"
git-bisect good 30742d5c2277c325fb0e9d2d817d55a19995fe8f
# bad: [c7e78cff6b7518212247fb20b1dc6411540dc9af] lockstat: contend with points
git-bisect bad c7e78cff6b7518212247fb20b1dc6411540dc9af
# good: [9b9b181ce53ef387dfe3df9316bbc641fca13d51] Merge commit 'v2.6.27-rc7' into core/locking
git-bisect good 9b9b181ce53ef387dfe3df9316bbc641fca13d51
# bad: [7317d7b87edb41a9135e30be1ec3f7ef817c53dd] sched: improve preempt debugging
git-bisect bad 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
# good: [6918bc5c830e890681eabb3c6cb6b8d117a52d14] lockstat: fixup signed division
git-bisect good 6918bc5c830e890681eabb3c6cb6b8d117a52d14


kernel warning is not seen after reverting the patch.

commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
Author: Nick Piggin <nickpiggin@yahoo.com.au>
Date:   Tue Sep 30 20:50:27 2008 +1000

    sched: improve preempt debugging
    
    This patch helped me out with a problem I recently had....
    
    Basically, when the kernel lock is held, then preempt_count underflow does not
    get detected until it is released which may be a long time (and arbitrarily,
    eg at different points it may be rescheduled). If the bkl is released at
    schedule, the resulting output is actually fairly cryptic...
    
    With any other lock that elevates preempt_count, it is illegal to schedule
    under it (which would get found pretty quickly). bkl allows scheduling with
    preempt_count elevated, which makes underflows hard to debug.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 9889080..ec3bd1f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4305,7 +4305,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
