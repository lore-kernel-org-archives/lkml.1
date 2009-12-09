Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZLINwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZLINwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZLINv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:51:59 -0500
Received: from [83.170.124.135] ([83.170.124.135]:50520 "EHLO
	pluto.daelnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZLINv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:51:58 -0500
Message-ID: <4B1FAB80.3020907@cybus.co.uk>
Date: Wed, 09 Dec 2009 13:52:00 +0000
From: Jonathan Miles <jon@cybus.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David John <davidjon@xenontk.org>,
       penberg@cs.helsinki.fi
Subject: Re: OOM kernel behaviour - 2.6.32
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home> <4B14E8A2.4020500@cybus.co.uk> <alpine.DEB.2.00.0912010949400.8841@router.home> <4B155B4A.9050405@cybus.co.uk> <4B1972B6.1060408@cybus.co.uk>
In-Reply-To: <4B1972B6.1060408@cybus.co.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020809030900040700060902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809030900040700060902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/12/09 20:36 Jonathan Miles said the following:

> Everything is fine having compiled straight 2.6.32. I watched the cache
> being reclaimed with top as I used more and more RAM and didn't see the
> OOM killer being invoked. So it was either a problem with 2.6.31 or with
> whatever Ubuntu did to make the .deb.

Having said that, on the 6th day of running straight 2.6.32, I just saw
the OOM killer invoked when ~1.1GB out of 2GB RAM was being used by the
page cache... which killed my Visual Paradigm (java) process. I've
attached the kernel debug output - is there anything obvious in there as
to why the page cache couldn't be reclaimed, or is this a bug?

Regards,

-- 
Jonathan Miles <jon@cybus.co.uk>
http://www.linkedin.com/in/jonmiles


--------------020809030900040700060902
Content-Type: text/plain;
 name="OOM3_2.6.32.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="OOM3_2.6.32.txt"

[170894.081464] vmware-vmx invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
[170894.081475] vmware-vmx cpuset=/ mems_allowed=0
[170894.081493] Pid: 4925, comm: vmware-vmx Not tainted 2.6.32 #2
[170894.081498] Call Trace:
[170894.081525]  [<c01b6b4a>] oom_kill_process+0x9a/0x280
[170894.081533]  [<c01b7174>] ? select_bad_process+0xa4/0xe0
[170894.081541]  [<c01b7201>] __out_of_memory+0x51/0xa0
[170894.081558]  [<c01b72a3>] out_of_memory+0x53/0xb0
[170894.081566]  [<c01b9a77>] __alloc_pages_nodemask+0x587/0x5a0
[170894.081587]  [<c01cf2be>] handle_mm_fault+0x70e/0x910
[170894.081597]  [<c05735a8>] do_page_fault+0x148/0x380
[170894.081604]  [<c0573460>] ? do_page_fault+0x0/0x380
[170894.081621]  [<c057160e>] error_code+0x66/0x6c
[170894.081628]  [<c0573460>] ? do_page_fault+0x0/0x380
[170894.081637]  [<c031b2e2>] ? copy_to_user+0x112/0x120
[170894.081656]  [<c0206748>] seq_read+0x258/0x3a0
[170894.081664]  [<c02064f0>] ? seq_read+0x0/0x3a0
[170894.081682]  [<c022e102>] proc_reg_read+0x62/0x90
[170894.081692]  [<c01ed2b7>] vfs_read+0x97/0x190
[170894.081699]  [<c022e0a0>] ? proc_reg_read+0x0/0x90
[170894.081716]  [<c01ed8bd>] sys_read+0x3d/0x70
[170894.081724]  [<c0103054>] sysenter_do_call+0x12/0x28
[170894.081730] Mem-Info:
[170894.081734] DMA per-cpu:
[170894.081748] CPU    0: hi:    0, btch:   1 usd:   0
[170894.081753] CPU    1: hi:    0, btch:   1 usd:   0
[170894.081757] Normal per-cpu:
[170894.081761] CPU    0: hi:  186, btch:  31 usd: 153
[170894.081776] CPU    1: hi:  186, btch:  31 usd: 178
[170894.081780] HighMem per-cpu:
[170894.081784] CPU    0: hi:  186, btch:  31 usd: 170
[170894.081789] CPU    1: hi:  186, btch:  31 usd: 144
[170894.081810] active_anon:202321 inactive_anon:89757 isolated_anon:0
[170894.081813]  active_file:85728 inactive_file:97318 isolated_file:64
[170894.081815]  unevictable:0 dirty:0 writeback:0 unstable:0
[170894.081818]  free:12160 slab_reclaimable:4066 slab_unreclaimable:4830
[170894.081820]  mapped:89313 shmem:104033 pagetables:1532 bounce:0
[170894.081845] DMA free:8012kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:152kB inactive_file:272kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15852kB mlocked:0kB dirty:0kB writeback:0kB mapped:124kB shmem:0kB slab_reclaimable:112kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:4kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:672 all_unreclaimable? yes
[170894.081858] lowmem_reserve[]: 0 865 2007 2007
[170894.081887] Normal free:40188kB min:3728kB low:4660kB high:5592kB active_anon:73432kB inactive_anon:111652kB active_file:266728kB inactive_file:312828kB unevictable:0kB isolated(anon):0kB isolated(file):256kB present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:292984kB shmem:134060kB slab_reclaimable:16152kB slab_unreclaimable:19312kB kernel_stack:2824kB pagetables:856kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:952032 all_unreclaimable? no
[170894.081911] lowmem_reserve[]: 0 0 9134 9134
[170894.081939] HighMem free:440kB min:512kB low:1740kB high:2972kB active_anon:735852kB inactive_anon:247376kB active_file:76032kB inactive_file:76172kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1169244kB mlocked:0kB dirty:0kB writeback:0kB mapped:64144kB shmem:282072kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:5268kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:230880 all_unreclaimable? yes
[170894.081952] lowmem_reserve[]: 0 0 0 0
[170894.081970] DMA: 35*4kB 32*8kB 30*16kB 27*32kB 10*64kB 8*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8012kB
[170894.082002] Normal: 1847*4kB 1698*8kB 813*16kB 62*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 40188kB
[170894.082033] HighMem: 108*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 440kB
[170894.082064] 287143 total pagecache pages
[170894.082068] 0 pages in swap cache
[170894.082073] Swap cache stats: add 0, delete 0, find 0/0
[170894.082077] Free swap  = 0kB
[170894.082080] Total swap = 0kB
[170894.103415] 521939 pages RAM
[170894.103419] 294613 pages HighMem
[170894.103433] 8828 pages reserved
[170894.103437] 343455 pages shared
[170894.103440] 285143 pages non-shared
[170894.103447] Out of memory: kill process 14265 (sh) score 1864137 or a child
[170894.103464] Killed process 14301 (java)

--------------020809030900040700060902--
