Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbZDUGhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbZDUGhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZDUGhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:37:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52669 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZDUGha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:37:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 06/25] Move check for disabled anti-fragmentation out of fastpath
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-7-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-7-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421153702.F12D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 15:37:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -50,9 +50,6 @@ extern int page_group_by_mobility_disabled;
>  
>  static inline int get_pageblock_migratetype(struct page *page)
>  {
> -	if (unlikely(page_group_by_mobility_disabled))
> -		return MIGRATE_UNMOVABLE;
> -
>  	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
>  }
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 13b4d11..c8465d0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -172,6 +172,10 @@ int page_group_by_mobility_disabled __read_mostly;
>  
>  static void set_pageblock_migratetype(struct page *page, int migratetype)
>  {
> +
> +	if (unlikely(page_group_by_mobility_disabled))
> +		migratetype = MIGRATE_UNMOVABLE;
> +
>  	set_pageblock_flags_group(page, (unsigned long)migratetype,
>  					PB_migrate, PB_migrate_end);

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




