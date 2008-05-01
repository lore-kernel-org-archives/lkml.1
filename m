Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYEAOwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYEAOwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYEAOvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:51:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48824 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEAOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:51:52 -0400
Subject: Re: powerpc boot regression
From: Badari Pulavarty <pbadari@gmail.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com, akpm@linux-foundation.org,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
In-Reply-To: <20080501051304.GM20457@bakeyournoodle.com>
References: <20080429.231241.221824292.davem@davemloft.net>
	 <20080501051304.GM20457@bakeyournoodle.com>
Content-Type: text/plain
Date: Thu, 01 May 2008 07:51:47 -0700
Message-Id: <1209653507.27240.7.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-01 at 15:13 +1000, Tony Breeds wrote:
> On Tue, Apr 29, 2008 at 11:12:41PM -0700, David Miller wrote:
> > 
> > This commit causes bootup failures on sparc64:
> > 
> > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> > Date:   Mon Apr 28 02:13:33 2008 -0700
> > 
> >     memory hotplug: allocate usemap on the section with pgdat
> 
> 
> <snip>
> 
> We're seeing a boot failure on powerpc.  git bisect points the problem
> at this commit.   However reverting just this one comitt doesn't fix the
> regression.  I also needed to revert
> 04753278769f3b6c3b79a080edb52f21d83bf6e2 (memory hotplug: register
> section/node id to free")
> 
> Problem seen on power4, power5 and ps3.

I don't see the problem on my power5 machine. Can you send the
config ? Is CONFIG_SPARSEMEM_VMEMMAP enabled ?

Please let me know.

Thanks,
Badari



> 
> If the fix isn't trivial, can we get that patch series reverted?
> 
> FWIW a boot looks like:
> zImage starting: loaded at 0x00400000 (sp: 0x02f5fea0)
> Allocating 0xa2d4c8 bytes for kernel ...
> OF version = 'IBM,SF240_332'
> gunzipping (0x01400000 <- 0x00407000:0x0079aa5d)...done 0x9a8ee0 bytes
> 
> Linux/PowerPC load: root=/dev/sdc3 ro
> Finalizing device tree... using OF tree (promptr=02039a68)
> OF stdout device is: /vdevice/vty@30000000
> Hypertas detected, assuming LPAR !
> command line: root=/dev/sdc3 ro
> memory layout at init:
>   alloc_bottom : 0000000001e32000
>   alloc_top    : 0000000008000000
>   alloc_top_hi : 0000000080000000
>   rmo_top      : 0000000008000000
>   ram_top      : 0000000080000000
> Looking for displays
> instantiating rtas at 0x00000000076a1000 ... done
> 0000000000000000 : boot cpu     0000000000000000
> copying OF device tree ...
> Building dt strings...
> Building dt structure...
> Device tree strings 0x0000000001e33000 -> 0x0000000001e3417c
> Device tree struct  0x0000000001e35000 -> 0x0000000001e3d000
> Calling quiesce ...
> returning from prom_init
> Crash kernel location must be 0x2000000
> Reserving 0MB of memory at 32MB for crashkernel (System RAM: 2048MB)
> Using pSeries machine description
> console [udbg0] enabled
> Partition configured for 20 cpus.
> CPU maps initialized for 2 threads per core
> Starting Linux PPC64 #52 SMP Thu May 1 14:04:46 EST 2008
> -----------------------------------------------------
> ppc64_pft_size                = 0x19
> physicalMemorySize            = 0x80000000
> htab_hash_mask                = 0x3ffff
> -----------------------------------------------------
> Initializing cgroup subsys cpuset
> Linux version 2.6.25 (tony@Sprygo) (gcc version 4.0.4 20060507 (prerelease) (Debian 4.0.3-3)) #52 SMP Thu May 1 14:04:46 EST 2008
> [boot]0012 Setup Arch
> sparse_early_usemap_alloc: allocation failed
> <snip 127 more>
> EEH: No capable adapters found
> PPC64 nvram contains 7168 bytes
> Zone PFN ranges:
>   DMA             0 ->   524288
>   Normal     524288 ->   524288
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   524288
> [boot]0015 Setup Done
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517120
> Kernel command line: root=/dev/sdc3 ro
> [boot]0020 XICS Init
> [boot]0021 XICS Done
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> clocksource: timebase mult[1545815] shift[22] registered
> Console: colour dummy device 80x25
> console handover: boot [udbg0] -> real [hvc0]
> Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Unable to handle kernel paging request for data at address 0xcf00000000030858
> Faulting instruction address: 0xc0000000000c4530
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 pSeries
> Modules linked in:
> NIP: c0000000000c4530 LR: c0000000007e8790 CTR: 80000000001af404
> REGS: c000000000987ae0 TRAP: 0300   Not tainted  (2.6.25)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000088  XER: 20000002
> DAR: cf00000000030858, DSISR: 0000000040010000
> TASK = c000000000862650[0] 'swapper' THREAD: c000000000984000 CPU: 0
> GPR00: 0000000020000000 c000000000987d60 c000000000981f18 cf00000000030858 
> GPR04: 0000000000000000 0000000000000001 0000000000000000 c0000000009f2a68 
> GPR08: c0000000009f2a58 00000000000001b8 0000000000000000 cf00000000030858 
> GPR12: 0000000000004000 c0000000009ae400 0000000000000000 0000000000000000 
> GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000001 
> GPR20: c00000007ffe8000 0000000000080000 0000000000000001 c0000000009f2848 
> GPR24: cf00000000030200 0000000040000000 0000000000000dc0 000000000000001d 
> GPR28: ffffffffe0000000 cf00000000030890 c0000000008e5088 0000000000000dde 
> NIP [c0000000000c4530] .__free_pages_bootmem+0xc/0xa8
> LR [c0000000007e8790] .free_all_bootmem_core+0x140/0x218
> Call Trace:
> [c000000000987d60] [0000000001c0a438] 0x1c0a438 (unreliable)
> [c000000000987e40] [c0000000007d29c8] .mem_init+0x68/0x1b0
> [c000000000987ed0] [c0000000007c091c] .start_kernel+0x34c/0x45c
> [c000000000987f90] [c00000000000859c] .start_here_common+0x4c/0xb0
> Instruction dump:
> 780007c6 792907c6 7c630214 38000038 7863a302 7c6301d2 4d820020 7c634a14 
> 4bffffa0 7c862379 7c6b1b78 40820028 <e8030000> 39200000 7800a842 78005800 
> ---[ end trace 8640abe69a316dee ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> Rebooting in 180 seconds..
> 
> Yours Tony
> 
>   linux.conf.au    http://www.marchsouth.org/
>   Jan 19 - 24 2009 The Australian Linux Technical Conference!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

