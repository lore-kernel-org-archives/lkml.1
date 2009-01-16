Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZAPEci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZAPEci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZAPEc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:32:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54742 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbZAPEc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:32:27 -0500
Date: Fri, 16 Jan 2009 13:31:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>
Subject: Re: [BUGFIX][PATCH] memcg: get/put parents at create/free
Message-Id: <20090116133121.2f50d71d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090116132253.69cf80ea.nishimura@mxp.nes.nec.co.jp>
References: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
	<20090114175121.275ecd59.nishimura@mxp.nes.nec.co.jp>
	<7602a77a9fc6b1e8757468048fde749a.squirrel@webmail-b.css.fujitsu.com>
	<20090115100330.37d89d3d.nishimura@mxp.nes.nec.co.jp>
	<20090115110044.3a863af8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115111420.8559bdb3.nishimura@mxp.nes.nec.co.jp>
	<20090115133814.a52460fa.nishimura@mxp.nes.nec.co.jp>
	<20090115164537.d402e95f.nishimura@mxp.nes.nec.co.jp>
	<20090115165453.271848d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115171315.965da4e3.nishimura@mxp.nes.nec.co.jp>
	<20090115172336.0ed780bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115175131.9542ae59.nishimura@mxp.nes.nec.co.jp>
	<20090115181056.74a938d5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090116105009.7cabac46.nishimura@mxp.nes.nec.co.jp>
	<20090116132253.69cf80ea.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 13:22:53 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> This is a fix for memcg-get-put-parents-at-create-free.patch.
> 

Thank you, I'll test. 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Andrew suggested that it's strange to add a little helper function for get(),
> while put() is open-code.
> 
> This patch also adds a few comments.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  mm/memcontrol.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 45e1b51..92790e4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -203,7 +203,6 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
>  static void mem_cgroup_get(struct mem_cgroup *mem);
>  static void mem_cgroup_put(struct mem_cgroup *mem);
>  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
> -static void mem_cgroup_get_parent(struct mem_cgroup *mem);
>  
>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>  					 struct page_cgroup *pc,
> @@ -2195,6 +2194,9 @@ static void mem_cgroup_put(struct mem_cgroup *mem)
>  	}
>  }
>  
> +/*
> + * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
> + */
>  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem)
>  {
>  	if (!mem->res.parent)
> @@ -2202,14 +2204,6 @@ static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem)
>  	return mem_cgroup_from_res_counter(mem->res.parent, res);
>  }
>  
> -static void mem_cgroup_get_parent(struct mem_cgroup *mem)
> -{
> -	struct mem_cgroup *parent = parent_mem_cgroup(mem);
> -
> -	if (parent)
> -		mem_cgroup_get(parent);
> -}
> -
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  static void __init enable_swap_cgroup(void)
>  {
> @@ -2247,6 +2241,13 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  	if (parent && parent->use_hierarchy) {
>  		res_counter_init(&mem->res, &parent->res);
>  		res_counter_init(&mem->memsw, &parent->memsw);
> +		/*
> +		 * We increment refcnt of the parent to ensure that we can
> +		 * safely access it on res_counter_charge/uncharge.
> +		 * This refcnt will be decremented when freeing this
> +		 * mem_cgroup(see mem_cgroup_put).
> +		 */
> +		mem_cgroup_get(parent);
>  	} else {
>  		res_counter_init(&mem->res, NULL);
>  		res_counter_init(&mem->memsw, NULL);
> @@ -2257,7 +2258,6 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  	if (parent)
>  		mem->swappiness = get_swappiness(parent);
>  	atomic_set(&mem->refcnt, 1);
> -	mem_cgroup_get_parent(mem);
>  	return &mem->css;
>  free_out:
>  	__mem_cgroup_free(mem);
> 

