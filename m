Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZLYDOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZLYDOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 22:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZLYDOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 22:14:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42953 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZLYDOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 22:14:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "A. Boulan" <arnaud.boulan@libertysurf.fr>
Subject: Re: OOM killer unexpectedly called with kernel 2.6.32
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <200912250042.43312.arnaud.boulan@libertysurf.fr>
References: <200912250042.43312.arnaud.boulan@libertysurf.fr>
Message-Id: <20091225121335.AA7E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Dec 2009 12:14:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> 
> When using kernel version 2.6.32.2 I have  a problem where the kernel calls the OOM killer
> although there are still plenty of RAM and swap available.
> 
> I am able to easily reproduce the problem when there is a huge background file tansfer between
> 2 disks (cp -a of several Gigabytes), and then starting a few applications. In less than a minute
> the kernel starts killing random processes (firefox, kmail, kdesktop, etc), although there is still
> free (or buffers/cache) memory and the swap is not used at all...
> 
> I do not reproduce this problem when using kernel 2.6.31.8 (compiled with the same compiler, 
> and with the same userspace)
> 
> I have no idea what could cause this problem. Any help will be appreciated.
> Regards,
> 
> Arnaud
> 
> (please CC me for any reply, i'm not subscribed to the list)
> 
> 
> Dec 24 18:16:03 picchu kernel: X invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
> Dec 24 18:16:03 picchu kernel: X cpuset=/ mems_allowed=0
> Dec 24 18:16:03 picchu kernel: Pid: 10719, comm: X Not tainted 2.6.32.2 #1
> Dec 24 18:16:03 picchu kernel: Call Trace:
> Dec 24 18:16:03 picchu kernel: [<ffffffff8106d513>] ? cpuset_print_task_mems_allowed+0x8d/0x98
> Dec 24 18:16:03 picchu kernel: [<ffffffff8108166c>] oom_kill_process+0x82/0x241
> Dec 24 18:16:03 picchu kernel: [<ffffffff81052014>] ? ktime_get_ts+0xb1/0xbe
> Dec 24 18:16:03 picchu kernel: [<ffffffff81081cfb>] __out_of_memory+0x134/0x14b
> Dec 24 18:16:03 picchu kernel: [<ffffffff81081dff>] pagefault_out_of_memory+0x55/0x7a
> Dec 24 18:16:03 picchu kernel: [<ffffffff8102594e>] mm_fault_error+0x3b/0xf6
> Dec 24 18:16:03 picchu kernel: [<ffffffff81093639>] ? handle_mm_fault+0x359/0x6a4
> Dec 24 18:16:03 picchu kernel: [<ffffffff81025b9d>] do_page_fault+0x194/0x1e3
> Dec 24 18:16:03 picchu kernel: [<ffffffff813aed1f>] page_fault+0x1f/0x30
> Dec 24 18:16:03 picchu kernel: Mem-Info:
> Dec 24 18:16:03 picchu kernel: DMA per-cpu:
> Dec 24 18:16:03 picchu kernel: CPU    0: hi:    0, btch:   1 usd:   0
> Dec 24 18:16:03 picchu kernel: CPU    1: hi:    0, btch:   1 usd:   0
> Dec 24 18:16:03 picchu kernel: DMA32 per-cpu:
> Dec 24 18:16:03 picchu kernel: CPU    0: hi:  186, btch:  31 usd: 165
> Dec 24 18:16:03 picchu kernel: CPU    1: hi:  186, btch:  31 usd:  64
> Dec 24 18:16:03 picchu kernel: active_anon:155933 inactive_anon:54013 isolated_anon:0
> Dec 24 18:16:03 picchu kernel: active_file:122843 inactive_file:129683 isolated_file:35
> Dec 24 18:16:03 picchu kernel: unevictable:464 dirty:20768 writeback:18186 unstable:0
> Dec 24 18:16:03 picchu kernel: free:3398 slab_reclaimable:22778 slab_unreclaimable:8060
> Dec 24 18:16:03 picchu kernel: mapped:19607 shmem:63182 pagetables:8230 bounce:0
> Dec 24 18:16:03 picchu kernel: DMA free:8004kB min:40kB low:48kB high:60kB active_anon:120kB inactive_anon:340kB active_file:1384kB inactive
> _file:3672kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15368kB mlocked:0kB dirty:0kB writeback:0kB mapped:52kB shmem:0kB
>  slab_reclaimable:2300kB slab_unreclaimable:4kB kernel_stack:8kB pagetables:100kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
> all_unreclaimable? no
> Dec 24 18:16:03 picchu kernel: lowmem_reserve[]: 0 1993 1993 1993
> Dec 24 18:16:03 picchu kernel: DMA32 free:5588kB min:5692kB low:7112kB high:8536kB active_anon:623612kB inactive_anon:215712kB active_file:4
> 89988kB inactive_file:515060kB unevictable:1856kB isolated(anon):0kB isolated(file):140kB present:2041776kB mlocked:1856kB dirty:83072kB wri
> teback:72744kB mapped:78376kB shmem:252728kB slab_reclaimable:88812kB slab_unreclaimable:32236kB kernel_stack:2416kB pagetables:32820kB unst
> able:0kB bounce:0kB writeback_tmp:0kB pages_scanned:192 all_unreclaimable? no
> Dec 24 18:16:03 picchu kernel: lowmem_reserve[]: 0 0 0 0
> Dec 24 18:16:03 picchu kernel: DMA: 15*4kB 3*8kB 41*16kB 49*32kB 31*64kB 13*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 8004kB
> Dec 24 18:16:03 picchu kernel: DMA32: 1129*4kB 14*8kB 8*16kB 2*32kB 0*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 5588kB
> Dec 24 18:16:03 picchu kernel: 316114 total pagecache pages
> Dec 24 18:16:03 picchu kernel: 0 pages in swap cache
> Dec 24 18:16:03 picchu kernel: Swap cache stats: add 11, delete 11, find 1/3
> Dec 24 18:16:03 picchu kernel: Free swap  = 2048248kB
> Dec 24 18:16:03 picchu kernel: Total swap = 2048248kB
> Dec 24 18:16:03 picchu kernel: 521616 pages RAM
> Dec 24 18:16:03 picchu kernel: 9625 pages reserved
> Dec 24 18:16:03 picchu kernel: 382065 pages shared
> Dec 24 18:16:03 picchu kernel: 296585 pages non-shared
> Dec 24 18:16:03 picchu kernel: Out of memory: kill process 3418 (kdesktop) score 967315 or a child
> Dec 24 18:16:03 picchu kernel: Killed process 14144 (firefox)
> 

We've seen similar issue recently. can you please try following patch?


-----------------------------------------------------------
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

When do_nonlinear_fault() realizes that the page table must have been
corrupted for it to have been called, it does print_bad_pte() and returns
...  VM_FAULT_OOM, which is hard to understand.

It made some sense when I did it for 2.6.15, when do_page_fault() just
killed the current process; but nowadays it lets the OOM killer decide who
to kill - so page table corruption in one process would be liable to kill
another.

Change it to return VM_FAULT_SIGBUS instead: that doesn't guarantee that
the process will be killed, but is good enough for such a rare
abnormality, accompanied as it is by the "BUG: Bad page map" message.

And recent HWPOISON work has copied that code into do_swap_page(), when it
finds an impossible swap entry: fix that to VM_FAULT_SIGBUS too.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-sigbus-instead-of-abusing-oom mm/memory.c
--- a/mm/memory.c~mm-sigbus-instead-of-abusing-oom
+++ a/mm/memory.c
@@ -2527,7 +2527,7 @@ static int do_swap_page(struct mm_struct
 			ret = VM_FAULT_HWPOISON;
 		} else {
 			print_bad_pte(vma, address, orig_pte, NULL);
-			ret = VM_FAULT_OOM;
+			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
 	}
@@ -2923,7 +2923,7 @@ static int do_nonlinear_fault(struct mm_
 		 * Page table corrupted: show pte and kill process.
 		 */
 		print_bad_pte(vma, address, orig_pte, NULL);
-		return VM_FAULT_OOM;
+		return VM_FAULT_SIGBUS;
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);
_




