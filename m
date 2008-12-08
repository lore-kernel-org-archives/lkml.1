Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYLHQmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYLHQmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYLHQmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:42:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65429 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYLHQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:42:10 -0500
Date: Mon, 8 Dec 2008 11:42:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Blechmann <tim@klingt.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RT] avoid preemption in memory controller code
In-Reply-To: <1228746854-23875-1-git-send-email-tim@klingt.org>
Message-ID: <alpine.DEB.1.10.0812081138470.26257@gandalf.stny.rr.com>
References: <1228746854-23875-1-git-send-email-tim@klingt.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tim,

On Mon, 8 Dec 2008, Tim Blechmann wrote:

> the lru_lock of struct mem_group_per_zone is used to avoid preemption
> during the __mem_cgroup_stat_add_safe function.
> therefore, a raw_spinlock_t should be used.

What is the reason that this must avoid preemption? Is there another
way to solve this? I rather not just add a raw spinlock if we can
help it.

-- Steve

> 
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
> -- 
> 1.5.6.3
> 
> 
> 
