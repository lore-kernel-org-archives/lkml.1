Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZAIA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZAIA7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZAIA7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:59:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbZAIA7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:59:01 -0500
Message-ID: <4966A117.9030201@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 08:57:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       menage@google.com
Subject: Re: [RFC][PATCH 1/4] memcg: fix for mem_cgroup_get_reclaim_stat_from_page
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp> <20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2996b8..62e69d8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -559,6 +559,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
>  		return NULL;
>  
>  	pc = lookup_page_cgroup(page);
> +	smp_rmb();

It is better to add a comment to explain this smp_rmb. I think it's recommended
that every memory barrier has a comment.

> +	if (!PageCgroupUsed(pc))
> +		return NULL;
> +
>  	mz = page_cgroup_zoneinfo(pc);
>  	if (!mz)
>  		return NULL;
> 
> 
