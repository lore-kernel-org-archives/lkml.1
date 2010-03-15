Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab0COAIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 20:08:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38748 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427Ab0COAIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 20:08:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 15 Mar 2010 09:04:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [patch] memcontrol: fix potential null deref
Message-Id: <20100315090451.ebd0ea2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100313145621.GA3569@bicker>
References: <20100313145621.GA3569@bicker>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010 17:56:21 +0300
Dan Carpenter <error27@gmail.com> wrote:

> There was a potential null deref introduced in:
> c62b1a3b31b5 memcg: use generic percpu instead of private implementation
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7973b52..e1e0996 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3691,8 +3691,10 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>  	else
>  		mem = vmalloc(size);
>  
> -	if (mem)
> -		memset(mem, 0, size);
> +	if (!mem)
> +		return NULL;
> +
> +	memset(mem, 0, size);
>  	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
>  	if (!mem->stat) {
>  		if (size < PAGE_SIZE)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

