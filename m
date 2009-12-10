Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbZLJRzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbZLJRzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbZLJRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:55:49 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46374 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760871AbZLJRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:55:48 -0500
Date: Thu, 10 Dec 2009 11:55:25 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 3/5] counting swap ents per mm
In-Reply-To: <20091210165911.97850977.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912101153130.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com> <20091210165911.97850977.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:

> Index: mmotm-2.6.32-Dec8/mm/rmap.c
> ===================================================================
> --- mmotm-2.6.32-Dec8.orig/mm/rmap.c
> +++ mmotm-2.6.32-Dec8/mm/rmap.c
> @@ -814,7 +814,7 @@ int try_to_unmap_one(struct page *page,
>  	update_hiwater_rss(mm);
>
>  	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> -		if (PageAnon(page))
> +		if (PageAnon(page)) /* Not increments swapents counter */
>  			dec_mm_counter(mm, MM_ANONPAGES);

Remove comment. Its not helping.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


