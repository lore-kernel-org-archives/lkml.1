Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZLAJ5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZLAJ5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZLAJ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:57:51 -0500
Received: from [83.170.124.135] ([83.170.124.135]:59792 "EHLO
	pluto.daelnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZLAJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:57:50 -0500
Message-ID: <4B14E8A2.4020500@cybus.co.uk>
Date: Tue, 01 Dec 2009 09:57:54 +0000
From: Jonathan Miles <jon@cybus.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOM kernel behaviour
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home>
In-Reply-To: <alpine.DEB.2.00.0911301253410.18682@router.home>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030801040905000201000900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030801040905000201000900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 30/11/09 18:57 Christoph Lameter said the following:
> On Mon, 30 Nov 2009, Jonathan Miles wrote:
> 
>> I'm running kernel 2.6.31.
> 
> Are you using a 32 bit kernel?

Yep, it's the stock 32-bit x86 kernel from Ubuntu...

  2.6.31-14-generic #48-Ubuntu SMP Fri Oct 16 14:04:26 UTC 2009 i686
    GNU/Linux

... but I could compile in a mainline version, if anyone thinks it would
make a difference. I suspect this is a general issue, though.

> Disabling swap means that the kernel cannot swap out anonymous pages. Thus
> the chance of OOMs conditions is increased.

Yep, that's what I intended. I want to tune my workstation so that it
doesn't need to use swap. With my workload you can assume that nearly
all processes are loaded for a reason and that at some point I want to
use any one of them *now*.

> In order to find the reason for the OOM (which has not much to do with
> memory, the kernel has been unable to reclaim memmory for some reason)
> you need to look at the debug output that the kernel generates.

I've attached a good example which shows Xorg invoking the OOM killer
when the page-cache is using ~1.3GB out of 2GB. My understanding from
reading linux-mm.org is that the kernel actually prefers to swap than
reclaim from the page-cache... is this accurate? However, what if there
is no swap, or it's configured not to use it? Should the kernel then try
to reclaim instead?

Thanks,

Jon

--------------030801040905000201000900
Content-Type: text/plain;
 name="OOM1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="OOM1.txt"

[19233.280568] Xorg invoked oom-killer: gfp_mask=0x201da, order=0, oomkilladj=0
[19233.280574] Xorg cpuset=/ mems_allowed=0
[19233.280588] Pid: 1143, comm: Xorg Not tainted 2.6.31-14-generic #48-Ubuntu
[19233.280591] Call Trace:
[19233.280602]  [<c01b5a0f>] oom_kill_process+0x9f/0x250
[19233.280606]  [<c01b601e>] ? select_bad_process+0xbe/0xf0
[19233.280619]  [<c01b60a1>] __out_of_memory+0x51/0xa0
[19233.280623]  [<c01b6143>] out_of_memory+0x53/0xb0
[19233.280627]  [<c01b83fe>] __alloc_pages_slowpath+0x42e/0x480
[19233.280631]  [<c01b855f>] __alloc_pages_nodemask+0x10f/0x120
[19233.280634]  [<c01b3d03>] __read_cache_page+0x43/0xc0
[19233.280638]  [<c01c2ec0>] ? shmem_readpage+0x0/0x40
[19233.280651]  [<c01c2ec0>] ? shmem_readpage+0x0/0x40
[19233.280655]  [<c01b45c7>] read_cache_page_async+0x27/0xd0
[19233.280696]  [<f824f0e4>] ? i915_gem_object_get_pages+0x54/0x130 [i915]
[19233.280700]  [<c01b4682>] read_cache_page+0x12/0x60
[19233.280727]  [<f824f126>] i915_gem_object_get_pages+0x96/0x130 [i915]
[19233.280751]  [<f8250e2e>] i915_gem_object_bind_to_gtt+0x14e/0x270 [i915]
[19233.280765]  [<f82510a5>] i915_gem_object_pin+0x155/0x190 [i915]
[19233.280798]  [<f814768b>] ? drm_gem_object_lookup+0x3b/0x50 [drm]
[19233.280824]  [<f8251824>] i915_gem_object_pin_and_relocate+0x34/0x340 [i915]
[19233.280850]  [<f814768b>] ? drm_gem_object_lookup+0x3b/0x50 [drm]
[19233.280876]  [<f8252717>] i915_gem_execbuffer+0x467/0xc80 [i915]
[19233.280890]  [<f824f9ea>] ? i915_gem_object_set_to_gtt_domain+0x4a/0x80 [i915]
[19233.280917]  [<f81466c0>] drm_ioctl+0x180/0x360 [drm]
[19233.280943]  [<f82522b0>] ? i915_gem_execbuffer+0x0/0xc80 [i915]
[19233.280947]  [<c01caa6b>] ? __do_fault+0x3b/0x470
[19233.280955]  [<c01f4cf3>] vfs_ioctl+0x73/0x90
[19233.280969]  [<c01f4fc1>] do_vfs_ioctl+0x71/0x310
[19233.280972]  [<c01f52bf>] sys_ioctl+0x5f/0x80
[19233.280976]  [<c010336c>] syscall_call+0x7/0xb
[19233.280978] Mem-Info:
[19233.280980] DMA per-cpu:
[19233.280983] CPU    0: hi:    0, btch:   1 usd:   0
[19233.280985] CPU    1: hi:    0, btch:   1 usd:   0
[19233.280987] Normal per-cpu:
[19233.280989] CPU    0: hi:  186, btch:  31 usd: 157
[19233.281001] CPU    1: hi:  186, btch:  31 usd:  45
[19233.281003] HighMem per-cpu:
[19233.281005] CPU    0: hi:  186, btch:  31 usd:  72
[19233.281008] CPU    1: hi:  186, btch:  31 usd:  36
[19233.281012] Active_anon:186856 active_file:115555 inactive_anon:55504
[19233.281013]  inactive_file:115834 unevictable:0 dirty:0 writeback:0 unstable:0
[19233.281015]  free:12178 slab:8264 mapped:72156 pagetables:2716 bounce:0
[19233.281019] DMA free:8076kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:144kB inactive_file:396kB unevictable:0kB present:15852kB pages_scanned:768 all_unreclaimable? yes
[19233.281033] lowmem_reserve[]: 0 865 2007 2007
[19233.281040] Normal free:40140kB min:3728kB low:4660kB high:5592kB active_anon:253552kB inactive_anon:54412kB active_file:223304kB inactive_file:223696kB unevictable:0kB present:885944kB pages_scanned:653856 all_unreclaimable? no
[19233.281044] lowmem_reserve[]: 0 0 9134 9134
[19233.281050] HighMem free:496kB min:512kB low:1740kB high:2972kB active_anon:493872kB inactive_anon:167604kB active_file:238772kB inactive_file:239244kB unevictable:0kB present:1169244kB pages_scanned:950176 all_unreclaimable? no
[19233.281064] lowmem_reserve[]: 0 0 0 0
[19233.281068] DMA: 3*4kB 2*8kB 3*16kB 2*32kB 4*64kB 2*128kB 3*256kB 1*512kB 2*1024kB 0*2048kB 1*4096kB = 8076kB
[19233.281079] Normal: 745*4kB 273*8kB 660*16kB 337*32kB 93*64kB 10*128kB 7*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 40140kB
[19233.281100] HighMem: 36*4kB 40*8kB 2*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 496kB
[19233.281111] 337345 total pagecache pages
[19233.281112] 0 pages in swap cache
[19233.281115] Swap cache stats: add 0, delete 0, find 0/0
[19233.281126] Free swap  = 0kB
[19233.281128] Total swap = 0kB
[19233.292981] 521939 pages RAM
[19233.292984] 294613 pages HighMem
[19233.292986] 8809 pages reserved
[19233.292987] 376103 pages shared
[19233.292989] 268322 pages non-shared
[19233.293002] Out of memory: kill process 19652 (vmware-vmx) score 202986 or a child
[19233.293080] Killed process 19652 (vmware-vmx)


--------------030801040905000201000900--
