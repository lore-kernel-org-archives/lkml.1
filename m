Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYKMQUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYKMQUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYKMQUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:20:43 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:47246 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYKMQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:20:43 -0500
Message-ID: <491C53CF.3010208@linux.vnet.ibm.com>
Date: Thu, 13 Nov 2008 21:50:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: Hirokazu Takahashi <taka@valinux.co.jp>
CC: kamezawa.hiroyu@jp.fujitsu.com, Paul Menage <menage@google.com>,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org, fernando@oss.ntt.co.jp,
       xemul@openvz.org
Subject: Re: [dm-devel] Re: [PATCH 0/8] I/O bandwidth controller and BIO tracking
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp> <20081113153019.cc50d42c.kamezawa.hiroyu@jp.fujitsu.com> <20081113.162623.74628639.taka@valinux.co.jp>
In-Reply-To: <20081113.162623.74628639.taka@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirokazu Takahashi wrote:
> Hi, Kamezawa-san,
> 
> This patch makes the page_cgroup framework be able to be used even if
> the compile option of the cgroup memory controller is off.
> So bio-cgroup can use this framework without the memory controller.
> 
> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
> 
> diff -dupr linux-2.6.28-rc2.bc0/include/linux/memcontrol.h linux-2.6.28-rc2/include/linux/memcontrol.h
> --- linux-2.6.28-rc2.bc0/include/linux/memcontrol.h	2008-11-10 18:31:34.000000000 +0900
> +++ linux-2.6.28-rc2/include/linux/memcontrol.h	2008-11-11 13:51:42.000000000 +0900
> @@ -27,6 +27,9 @@ struct mm_struct;
> 
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> 
> +extern void __init_mem_page_cgroup(struct page_cgroup *pc);
> +#define  mem_cgroup_disabled() mem_cgroup_subsys.disabled
> +
>  extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
>  				gfp_t gfp_mask);
>  /* for swap handling */
> @@ -81,6 +84,15 @@ extern long mem_cgroup_calc_reclaim(stru
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct mem_cgroup;
> 
> +static inline void __init_mem_page_cgroup(struct page_cgroup *pc)
> +{
> +}
> +
> +static inline int mem_cgroup_disabled(void)
> +{
> +	return 1;
> +}
> +

With CONFIG_CGROUP_MEM_RES_CTLR not defined, page_cgroup init routines will just
return, is that what bio page_cgroup needs?

-- 
	Balbir
