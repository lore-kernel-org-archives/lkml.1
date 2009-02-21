Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZBUQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZBUQih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZBUQi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:38:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36029 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZBUQi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:38:28 -0500
Message-ID: <49A02D08.7040509@cs.helsinki.fi>
Date: Sat, 21 Feb 2009 18:34:16 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] kmemcheck: add hooks for the page allocator
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com> <1235223364-2097-5-git-send-email-vegard.nossum@gmail.com>
In-Reply-To: <1235223364-2097-5-git-send-email-vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> This adds support for tracking the initializedness of memory that
> was allocated with the page allocator. Highmem requests are not
> tracked.
> 
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> +void kmemcheck_pagealloc_alloc(struct page *page, unsigned int order,
> +			       gfp_t gfpflags)
> +{
> +	int pages;
> +
> +	if (gfpflags & (__GFP_HIGHMEM | __GFP_NOTRACK))
> +		return;
> +
> +	pages = 1 << order;
> +
> +	/*
> +	 * NOTE: We choose to track GFP_ZERO pages too; in fact, they
> +	 * can become uninitialized by copying uninitialized memory
> +	 * into them.
> +	 */
> +
> +	/* XXX: Can use zone->node for node? */
> +	kmemcheck_alloc_shadow(page, order, gfpflags, -1);

Yes, you can.
