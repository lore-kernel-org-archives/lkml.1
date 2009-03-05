Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZCEWme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZCEWme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCEWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:42:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbZCEWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:42:24 -0500
Date: Thu, 5 Mar 2009 14:42:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hannes Eder <hannes@hanneseder.net>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH v2 15/15] NULL noise: mm/memcontrol.c
Message-Id: <20090305144210.e40ef501.akpm@linux-foundation.org>
In-Reply-To: <20090305191839.30062.91081.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	<20090305191839.30062.91081.stgit@f10box.hanneseder.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Mar 2009 20:18:44 +0100
Hannes Eder <hannes@hanneseder.net> wrote:

> Fix this sparse warning:
>   mm/memcontrol.c:1637:32: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> v2: other subject, as suggested by Al Viro
> 
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8e4be9c..09d6650 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1634,7 +1634,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
>  		pc = list_entry(list->prev, struct page_cgroup, lru);
>  		if (busy == pc) {
>  			list_move(&pc->lru, list);
> -			busy = 0;
> +			busy = NULL;
>  			spin_unlock_irqrestore(&zone->lru_lock, flags);
>  			continue;
>  		}

I have to say that I wish sparse didn't do this.  Initialising a
pointer with literal zero is perfectly clear and is idiomatic C.

