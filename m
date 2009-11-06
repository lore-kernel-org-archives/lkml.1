Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZKFI4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZKFI4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZKFI4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:56:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46019 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbZKFI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:56:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 17:54:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 1/2] memcg : rename index to short name
Message-Id: <20091106175409.14ae09fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Before touching percpu counters on memcg, rename status to be short name.
Current too long name is my mistake, sorry.

By this, a change around percpu statistics can be in a line.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   70 ++++++++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 37 deletions(-)

Index: mmotm-2.6.32-Nov2/mm/memcontrol.c
===================================================================
--- mmotm-2.6.32-Nov2.orig/mm/memcontrol.c
+++ mmotm-2.6.32-Nov2/mm/memcontrol.c
@@ -65,19 +65,19 @@ enum mem_cgroup_stat_index {
 	/*
 	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
 	 */
-	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
-	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
-	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
-	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
-	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
-	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
-	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
+	MEMCG_NR_CACHE, 	   /* # of pages charged as cache */
+	MEMCG_NR_RSS,	   /* # of pages charged as anon rss */
+	MEMCG_NR_FILE_MAPPED,  /* # of pages charged as file rss */
+	MEMCG_PGPGIN,	/* # of pages paged in */
+	MEMCG_PGPGOUT,	/* # of pages paged out */
+	MEMCG_EVENTS,	/* sum of pagein + pageout for internal use */
+	MEMCG_NR_SWAP, /* # of pages, swapped out */
 
-	MEM_CGROUP_STAT_NSTATS,
+	MEMCG_STAT_NSTATS,
 };
 
 struct mem_cgroup_stat_cpu {
-	s64 count[MEM_CGROUP_STAT_NSTATS];
+	s64 count[MEMCG_STAT_NSTATS];
 } ____cacheline_aligned_in_smp;
 
 struct mem_cgroup_stat {
@@ -121,8 +121,8 @@ static s64 mem_cgroup_local_usage(struct
 {
 	s64 ret;
 
-	ret = mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_CACHE);
-	ret += mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_RSS);
+	ret = mem_cgroup_read_stat(stat, MEMCG_NR_CACHE);
+	ret += mem_cgroup_read_stat(stat, MEMCG_NR_RSS);
 	return ret;
 }
 
@@ -376,9 +376,9 @@ static bool mem_cgroup_soft_limit_check(
 
 	cpu = get_cpu();
 	cpustat = &mem->stat.cpustat[cpu];
-	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
+	val = __mem_cgroup_stat_read_local(cpustat, MEMCG_EVENTS);
 	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
-		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
+		__mem_cgroup_stat_reset_safe(cpustat, MEMCG_EVENTS);
 		ret = true;
 	}
 	put_cpu();
@@ -486,7 +486,7 @@ static void mem_cgroup_swap_statistics(s
 	int cpu = get_cpu();
 
 	cpustat = &stat->cpustat[cpu];
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SWAPOUT, val);
+	__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_SWAP, val);
 	put_cpu();
 }
 
@@ -501,17 +501,15 @@ static void mem_cgroup_charge_statistics
 
 	cpustat = &stat->cpustat[cpu];
 	if (PageCgroupCache(pc))
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_CACHE, val);
+		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_CACHE, val);
 	else
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS, val);
+		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_RSS, val);
 
 	if (charge)
-		__mem_cgroup_stat_add_safe(cpustat,
-				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
+		__mem_cgroup_stat_add_safe(cpustat, MEMCG_PGPGIN, 1);
 	else
-		__mem_cgroup_stat_add_safe(cpustat,
-				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
+		__mem_cgroup_stat_add_safe(cpustat, MEMCG_PGPGOUT, 1);
+	__mem_cgroup_stat_add_safe(cpustat, MEMCG_EVENTS, 1);
 	put_cpu();
 }
 
@@ -1254,7 +1252,7 @@ void mem_cgroup_update_file_mapped(struc
 	stat = &mem->stat;
 	cpustat = &stat->cpustat[cpu];
 
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED, val);
+	__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, val);
 done:
 	unlock_page_cgroup(pc);
 }
@@ -1656,14 +1654,12 @@ static int mem_cgroup_move_account(struc
 		/* Update mapped_file data for mem_cgroup "from" */
 		stat = &from->stat;
 		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
-						-1);
+		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, -1);
 
 		/* Update mapped_file data for mem_cgroup "to" */
 		stat = &to->stat;
 		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
-						1);
+		__mem_cgroup_stat_add_safe(cpustat, MEMCG_NR_FILE_MAPPED, 1);
 	}
 
 	if (do_swap_account && !mem_cgroup_is_root(from))
@@ -2746,10 +2742,10 @@ static u64 mem_cgroup_read(struct cgroup
 	case _MEM:
 		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
 			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_CACHE, &idx_val);
+				MEMCG_NR_CACHE, &idx_val);
 			val = idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_RSS, &idx_val);
+				MEMCG_NR_RSS, &idx_val);
 			val += idx_val;
 			val <<= PAGE_SHIFT;
 		} else
@@ -2758,13 +2754,13 @@ static u64 mem_cgroup_read(struct cgroup
 	case _MEMSWAP:
 		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
 			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_CACHE, &idx_val);
+				MEMCG_NR_CACHE, &idx_val);
 			val = idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_RSS, &idx_val);
+				MEMCG_NR_RSS, &idx_val);
 			val += idx_val;
 			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+				MEMCG_NR_SWAP, &idx_val);
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->memsw, name);
@@ -2924,18 +2920,18 @@ static int mem_cgroup_get_local_stat(str
 	s64 val;
 
 	/* per cpu stat */
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_CACHE);
+	val = mem_cgroup_read_stat(&mem->stat, MEMCG_NR_CACHE);
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
+	val = mem_cgroup_read_stat(&mem->stat, MEMCG_NR_RSS);
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_FILE_MAPPED);
+	val = mem_cgroup_read_stat(&mem->stat, MEMCG_NR_FILE_MAPPED);
 	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
+	val = mem_cgroup_read_stat(&mem->stat, MEMCG_PGPGIN);
 	s->stat[MCS_PGPGIN] += val;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
+	val = mem_cgroup_read_stat(&mem->stat, MEMCG_PGPGOUT);
 	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
-		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
+		val = mem_cgroup_read_stat(&mem->stat, MEMCG_NR_SWAP);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
 

