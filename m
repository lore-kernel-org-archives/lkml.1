Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbZDHF2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbZDHF2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbZDHF1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:27:51 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40235 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbZDHF1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:27:51 -0400
Date: Wed, 8 Apr 2009 10:57:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg remove warning at DEBUG_VM=off
Message-ID: <20090408052715.GX7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090408142042.3fb62eea.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-08 14:20:42]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> This is against 2.6.30-rc1. (maybe no problem against mmotm.)
> 
> ==
> Fix warning as
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c:318: warning: ?$B!Fmem_cgroup_is_obsolete?$B!G defined but not used
> 
> This is called only from VM_BUG_ON().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: linux-2.6.30-rc1/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.30-rc1.orig/mm/memcontrol.c
> +++ linux-2.6.30-rc1/mm/memcontrol.c
> @@ -314,13 +314,14 @@ static struct mem_cgroup *try_get_mem_cg
>  	return mem;
>  }
> 
> +#ifdef CONFIG_DEBUG_VM
>  static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
>  {
>  	if (!mem)
>  		return true;
>  	return css_is_removed(&mem->css);
>  }
> -
> +#endif

Can we change the code to use

        VM_BUG_ON(!mem || css_is_removed(&mem->css));

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
