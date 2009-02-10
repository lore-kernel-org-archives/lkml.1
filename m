Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZBJWIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZBJWIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZBJWHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:07:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569AbZBJWHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:07:51 -0500
Date: Tue, 10 Feb 2009 14:06:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com,
       riel@redhat.com, wli@movementarian.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: initialize sc->nr_reclaimed properly take2
Message-Id: <20090210140637.902e4dcc.akpm@linux-foundation.org>
In-Reply-To: <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210213502.7007.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com>
	<20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 21:58:04 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1665,6 +1665,7 @@ unsigned long try_to_free_pages(struct z
>  								gfp_t gfp_mask)
>  {
>  	struct scan_control sc = {
> +		.nr_reclaimed = 0,
>  		.gfp_mask = gfp_mask,
>  		.may_writepage = !laptop_mode,
>  		.swap_cluster_max = SWAP_CLUSTER_MAX,
> @@ -1686,6 +1687,7 @@ unsigned long try_to_free_mem_cgroup_pag
>  					   unsigned int swappiness)
>  {
>  	struct scan_control sc = {
> +		.nr_reclaimed = 0,
>  		.may_writepage = !laptop_mode,
>  		.may_swap = 1,
>  		.swap_cluster_max = SWAP_CLUSTER_MAX,
> @@ -2245,6 +2247,7 @@ static int __zone_reclaim(struct zone *z
>  	struct reclaim_state reclaim_state;
>  	int priority;
>  	struct scan_control sc = {
> +		.nr_reclaimed = 0,
>  		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
>  		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
>  		.swap_cluster_max = max_t(unsigned long, nr_pages,

Confused.  The compiler already initialises any unmentioned fields to zero,
so this patch has no effect.

