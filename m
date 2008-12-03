Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYLCHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYLCHD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYLCHDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:03:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57864 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYLCHDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:03:17 -0500
Date: Wed, 3 Dec 2008 16:02:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + memcg-swapout-refcnt-fix.patch added to -mm tree
Message-Id: <20081203160223.4352fe86.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200812030557.mB35vDnD028931@imap1.linux-foundation.org>
References: <200812030557.mB35vDnD028931@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 21:57:13 -0800
akpm@linux-foundation.org wrote:

> ------------------------------------------------------
> Subject: memcg: swapout refcnt fix
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

no changes.
-Kame

> css's refcnt is dropped before end of following access.
> Hold it until end of access.
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memcontrol.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff -puN mm/memcontrol.c~memcg-swapout-refcnt-fix mm/memcontrol.c
> --- a/mm/memcontrol.c~memcg-swapout-refcnt-fix
> +++ a/mm/memcontrol.c
> @@ -1171,7 +1171,9 @@ __mem_cgroup_uncharge_common(struct page
>  	mz = page_cgroup_zoneinfo(pc);
>  	unlock_page_cgroup(pc);
>  
> -	css_put(&mem->css);
> +	/* at swapout, this memcg will be accessed to record to swap */
> +	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
> +		css_put(&mem->css);
>  
>  	return mem;
>  
> @@ -1212,6 +1214,8 @@ void mem_cgroup_uncharge_swapcache(struc
>  		swap_cgroup_record(ent, memcg);
>  		mem_cgroup_get(memcg);
>  	}
> +	if (memcg)
> +		css_put(&memcg->css);
>  }
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> _
> 
> Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are
> 
> vmscan-evict-streaming-io-first.patch
> mm-gup-persist-for-write-permission.patch
> mm-wp-lock-page-before-deciding-cow.patch
> mm-reuse_swap_page-replaces-can_share_swap_page.patch
> mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
> mm-try_to_unuse-check-removing-right-swap.patch
> mm-remove-try_to_munlock-from-vmscan.patch
> mm-remove-gfp_mask-from-add_to_swap.patch
> mm-add-add_to_swap-stub.patch
> mm-optimize-get_scan_ratio-for-no-swap.patch
> memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
> swapfile-swapon-needs-larger-size-type.patch
> swapfile-remove-swp_active-mask.patch
> swapfile-remove-surplus-whitespace.patch
> swapfile-remove-v0-swap-space-message.patch
> swapfile-rearrange-scan-and-swap_info.patch
> swapfile-swapon-use-discard-trim.patch
> swapfile-swap-allocation-use-discard.patch
> swapfile-swapon-randomize-if-nonrot.patch
> swapfile-swap-allocation-cycle-if-nonrot.patch
> swapfile-change-discard-pgoff_t-to-sector_t.patch
> swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
> swapfile-let-others-seed-random.patch
> cgroups-make-cgroup-config-a-submenu.patch
> cgroups-documentation-updates.patch
> cgroups-remove-some-redundant-null-checks.patch
> ns_cgroup-remove-unused-spinlock.patch
> memcg-fix-a-typo-in-kconfig.patch
> cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
> cgroups-fix-cgroup_iter_next-bug.patch
> cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
> cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
> cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
> cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
> cgroups-make-root_list-contains-active-hierarchies-only.patch
> cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
> cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
> devcgroup-use-list_for_each_entry_rcu.patch
> memcg-introduce-charge-commit-cancel-style-of-functions.patch
> memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
> memcg-fix-gfp_mask-of-callers-of-charge.patch
> memcg-simple-migration-handling.patch
> memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
> memcg-move-all-acccounts-to-parent-at-rmdir.patch
> memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
> memcg-new-force_empty-to-free-pages-under-group.patch
> memcg-new-force_empty-to-free-pages-under-group-fix.patch
> memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
> memcg-handle-swap-caches.patch
> memcg-handle-swap-caches-build-fix.patch
> memcg-memswap-controller-kconfig.patch
> memcg-swap-cgroup-for-remembering-usage.patch
> memcg-memswap-controller-core.patch
> memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
> memcg-memswap-controller-core-swapcache-fixes.patch
> memcg-synchronized-lru.patch
> memcg-add-mem_cgroup_disabled.patch
> memcg-add-mem_cgroup_disabled-fix.patch
> memory-cgroup-hierarchy-documentation-v4.patch
> memory-cgroup-resource-counters-for-hierarchy-v4.patch
> memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
> memory-cgroup-hierarchical-reclaim-v4.patch
> memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
> memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
> memory-cgroup-hierarchy-feature-selector-v4.patch
> memory-cgroup-hierarchy-feature-selector-v4-fix.patch
> memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
> memcg-avoid-unnecessary-system-wide-oom-killer.patch
> memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
> memcg-fix-reclaim-result-checks.patch
> memcg-revert-gfp-mask-fix.patch
> memcg-check-group-leader-fix.patch
> memcg-memoryswap-controller-fix-limit-check.patch
> memcg-swapout-refcnt-fix.patch
> memcg-hierarchy-avoid-unnecessary-reclaim.patch
> inactive_anon_is_low-move-to-vmscan.patch
> mm-introduce-zone_reclaim-struct.patch
> mm-add-zone-nr_pages-helper-function.patch
> mm-make-get_scan_ratio-safe-for-memcg.patch
> memcg-add-null-check-to-page_cgroup_zoneinfo.patch
> memcg-add-inactive_anon_is_low.patch
> memcg-add-mem_cgroup_zone_nr_pages.patch
> memcg-add-zone_reclaim_stat.patch
> memcg-remove-mem_cgroup_cal_reclaim.patch
> memcg-show-reclaim-stat.patch
> memcg-rename-scan-global-lru.patch
> memcg-protect-prev_priority.patch
> memcg-swappiness.patch
> memcg-explain-details-and-test-document.patch
> cpuset-rcu_read_lock-to-protect-task_cs.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

