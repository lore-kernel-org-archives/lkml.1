Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbYD1Tjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbYD1Tjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934403AbYD1TjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:39:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59890 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934141AbYD1TjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:39:07 -0400
Date: Mon, 28 Apr 2008 12:39:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] mm: Avoid putting a bad page back on the LRU
In-Reply-To: <20080428192358.GB14629@sgi.com>
Message-ID: <Pine.LNX.4.64.0804281238080.30548@schroedinger.engr.sgi.com>
References: <20080428192358.GB14629@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Russ Anderson wrote:

> +#if (BITS_PER_LONG > 32)
> +#define PageMemError(page)	test_bit(PG_memerror, &(page)->flags)
> +#define SetPageMemError(page)	set_bit(PG_memerror, &(page)->flags)
> +#define ClearPageMemError(page)	clear_bit(PG_memerror, &(page)->flags)
> +#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> +			 1 << PG_buddy | 1 << PG_writeback | \
> +			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
> +			 1UL << PG_memerror)
> +#else
> +#define PageMemError(page)	0
> +#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> +			 1 << PG_buddy | 1 << PG_writeback | \
> +			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
> +#endif
> +#define PAGE_FLAGS_RECLAIM	(PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
> +#define PAGE_FLAGS_RESERVE	(PAGE_FLAGS | 1 << PG_reserved)
> +#define PAGE_FLAGS_DIRTY	(PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
> +

All the PAGE_FLAGS_xx things could be in a separate cleanup patch. Also 
note that the way page flags are defined may change soon.

