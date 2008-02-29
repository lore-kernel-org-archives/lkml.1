Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbYB2Oro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbYB2Oro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbYB2Orf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:47:35 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29699 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181AbYB2Orf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:47:35 -0500
Subject: Re: [patch 17/21] non-reclaimable mlocked pages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: minchan Kim <barrioskmc@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <44c63dc40802282055q508af6ccsb0e8ac3fb5e67d24@mail.gmail.com>
References: <20080228192908.126720629@redhat.com>
	 <20080228192929.453373535@redhat.com>
	 <44c63dc40802282055q508af6ccsb0e8ac3fb5e67d24@mail.gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 29 Feb 2008 09:47:44 -0500
Message-Id: <1204296464.5311.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 13:55 +0900, minchan Kim wrote:
>         Index: linux-2.6.25-rc2-mm1/mm/page_alloc.c
>         ===================================================================
>         --- linux-2.6.25-rc2-mm1.orig/mm/page_alloc.c   2008-02-28
>         12:47:36.000000000 -0500
>         +++ linux-2.6.25-rc2-mm1/mm/page_alloc.c        2008-02-28
>         12:49:02.000000000 -0500
>         @@ -257,6 +257,7 @@ static void bad_page(struct page *page)
>                                1 << PG_swapcache |
>                                1 << PG_writeback |
>                                1 << PG_swapbacked |
>         +                       1 << PG_mlocked |
>                                1 << PG_buddy );
>                set_page_count(page, 0);
>                reset_page_mapcount(page);
>  
> It would be compile error unless CONFIG_NORECLAIM_MLOCK is defined.  
> 
> 
>         
>         @@ -656,7 +662,9 @@ static int prep_new_page(struct page *pa
>         
>                page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1
>         << PG_readahead |
>                                1 << PG_referenced | 1 << PG_arch_1 |
>         -                       1 << PG_owner_priv_1 | 1 <<
>         PG_mappedtodisk);
>         +                       1 << PG_owner_priv_1 | 1 <<
>         PG_mappedtodisk |
>         +//TODO take care of it here, for now.
>         +                       1 << PG_mlocked );
>                set_page_private(page, 0);
>                set_page_refcounted(page);
>  
> ditto 

Well, it will be a compile error for 32-bit systems, so we need to fix
it.   PG_mlocked is unconditionally defined/reserved when (BITS_PER_LONG
> 32).

Thanks,
Lee
> 

