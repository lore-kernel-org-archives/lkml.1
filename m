Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZDUDEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZDUDEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZDUDDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:03:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44333 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZDUDDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:03:47 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 04/25] Check only once if the zonelist is suitable for the allocation
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
In-Reply-To: <1240266011-11140-5-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-5-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421120258.F122.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 12:03:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -restart:
> -	z = zonelist->_zonerefs;  /* the list of zones suitable for gfp_mask */
> -
> +	/* the list of zones suitable for gfp_mask */
> +	z = zonelist->_zonerefs;
>  	if (unlikely(!z->zone)) {
>  		/*
>  		 * Happens if we have an empty zonelist as a result of
> @@ -1497,6 +1496,7 @@ restart:
>  		return NULL;
>  	}
>  
> +restart:
>  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
>  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
>  	if (page)

looks good.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


