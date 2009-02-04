Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZBDIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZBDIfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZBDIfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:35:34 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:43227 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZBDIfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:35:32 -0500
Date: Wed, 4 Feb 2009 14:05:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, heiko.carstens@de.ibm.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] use __GFP_NOWARN in page cgroup allocation
Message-ID: <20090204083524.GJ4456@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090204170944.c93772d2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090204170944.c93772d2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-04 17:09:44]:

> This was recommended in
> "kmalloc-return-null-instead-of-link-failure.patch added to -mm tree" thread
> in the last month.
> Thanks,
> -Kame
> =
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> page_cgroup's page allocation at init/memory hotplug uses kmalloc() and
> vmalloc(). If kmalloc() failes, vmalloc() is used.
> 
> This is because vmalloc() is very limited resource on 32bit systems.
> We want to use kmalloc() first.
> 
> But in this kind of call, __GFP_NOWARN should be specified.
> 
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: mmotm-2.6.29-Feb03/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.29-Feb03.orig/mm/page_cgroup.c
> +++ mmotm-2.6.29-Feb03/mm/page_cgroup.c
> @@ -114,7 +114,8 @@ static int __init_refok init_section_pag
>  		nid = page_to_nid(pfn_to_page(pfn));
>  		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
>  		if (slab_is_available()) {
> -			base = kmalloc_node(table_size, GFP_KERNEL, nid);
> +			base = kmalloc_node(table_size,
> +					GFP_KERNEL | __GFP_NOWARN, nid);

Thanks for getting to this.

>  			if (!base)
>  				base = vmalloc_node(table_size, nid);
>  		} else {

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


-- 
	Balbir
