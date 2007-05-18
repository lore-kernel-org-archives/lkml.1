Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbXERSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbXERSVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXERSVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:21:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35235 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752854AbXERSVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:21:13 -0400
Date: Fri, 18 May 2007 11:21:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] MM : alloc_large_system_hash() can free some memory for
 non power-of-two bucketsize
In-Reply-To: <20070518115454.d3e32f4d.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0705181118530.11881@schroedinger.engr.sgi.com>
References: <20070518115454.d3e32f4d.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Eric Dumazet wrote:

>  			table = (void*) __get_free_pages(GFP_ATOMIC, order);

ATOMIC? Is there some reason why we need atomic here?

> +			/*
> +			 * If bucketsize is not a power-of-two, we may free
> +			 * some pages at the end of hash table.
> +			 */
> +			if (table) {
> +				unsigned long alloc_end = (unsigned long)table +
> +						(PAGE_SIZE << order);
> +				unsigned long used = (unsigned long)table +
> +						PAGE_ALIGN(size);
> +				while (used < alloc_end) {
> +					free_page(used);

Isnt this going to interfere with the kernel_map_pages debug stuff?

