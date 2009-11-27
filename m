Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZK0TZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZK0TZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZK0TZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:25:37 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40244 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZK0TZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:25:36 -0500
Date: Fri, 27 Nov 2009 13:25:06 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC][PATCH 4/4] vmscan: vmscan don't use pcp list
In-Reply-To: <20091127091920.A7D5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911271322450.27110@router.home>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com> <20091127091920.A7D5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, KOSAKI Motohiro wrote:

> patch series, but Christoph mentioned simple bypass pcp instead.
> I made it. I'd hear Christoph and Mel's mention.

Ah. good.

> +		kmemcheck_free_shadow(page, 0);
> +
> +		if (PageAnon(page))
> +			page->mapping = NULL;
> +		if (free_pages_check(page)) {
> +			/* orphan this page. */
> +			list_del(&page->lru);
> +			continue;
> +		}
> +		if (!PageHighMem(page)) {
> +			debug_check_no_locks_freed(page_address(page),
> +						   PAGE_SIZE);
> +			debug_check_no_obj_freed(page_address(page), PAGE_SIZE);
> +		}
> +		arch_free_page(page, 0);
> +		kernel_map_pages(page, 1, 0);
> +
> +		local_irq_save(flags);
> +		if (unlikely(wasMlocked))
> +			free_page_mlock(page);
> +		local_irq_restore(flags);

The above looks like it should be generic logic that is used elsewhere?
Create a common function?


Rest looks good to me...

