Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYLIBOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYLIBOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 20:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYLIBOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 20:14:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56044 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbYLIBOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 20:14:45 -0500
Message-ID: <493DC628.5060900@cn.fujitsu.com>
Date: Tue, 09 Dec 2008 09:13:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [RT] avoid preemption in memory controller code
References: <1228746854-23875-1-git-send-email-tim@klingt.org>
In-Reply-To: <1228746854-23875-1-git-send-email-tim@klingt.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Tim Blechmann wrote:
> the lru_lock of struct mem_group_per_zone is used to avoid preemption
> during the __mem_cgroup_stat_add_safe function.
> therefore, a raw_spinlock_t should be used.
> 

FYI, this lru_lock no longer exists in -mm tree. The following patch
removes that lock:

	http://marc.info/?l=linux-mm&m=122665814801979&w=2

> Signed-off-by: Tim Blechmann <tim@klingt.org>
> ---
>  mm/memcontrol.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 517f945..8661732 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -95,9 +95,9 @@ enum mem_cgroup_zstat_index {
>  
>  struct mem_cgroup_per_zone {
>  	/*
> -	 * spin_lock to protect the per cgroup LRU
> +	 * raw_spin_lock to protect the per cgroup LRU
>  	 */
> -	spinlock_t		lru_lock;
> +	raw_spinlock_t		lru_lock;
>  	struct list_head	active_list;
>  	struct list_head	inactive_list;
>  	unsigned long count[NR_MEM_CGROUP_ZSTAT];


