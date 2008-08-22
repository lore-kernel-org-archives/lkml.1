Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYHVFDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYHVFDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYHVFD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 01:03:28 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42407 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYHVFD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 01:03:27 -0400
Date: Fri, 22 Aug 2008 13:57:43 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>, ryov@valinux.co.jp,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH -mm 6/7] memcg:
 make-mapping-null-before-calling-uncharge.patch
Message-Id: <20080822135743.cc07f7de.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080820190702.616f4260.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820190702.616f4260.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -379,6 +377,15 @@ static void migrate_page_copy(struct pag
>  	ClearPagePrivate(page);
>  	set_page_private(page, 0);
>  	page->mapping = NULL;
You forget to remove this line :)

Thanks,
Daisuke Nishimura.

> +	/* page->mapping contains a flag for PageAnon() */
> +	if (PageAnon(page)) {
> +		/* This page is uncharged at try_to_unmap(). */
> +		page->mapping = NULL;
> +	} else {
> +		/* Obsolete file cache should be uncharged */
> +		page->mapping = NULL;
> +		mem_cgroup_uncharge_cache_page(page);
> +	}
>  
>  	/*
>  	 * If any waiters have accumulated on the new page then
> 
