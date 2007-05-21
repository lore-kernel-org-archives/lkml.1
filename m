Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXEUMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXEUMVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXEUMVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:21:15 -0400
Received: from holomorphy.com ([66.93.40.71]:48367 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbXEUMVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:21:15 -0400
Date: Mon, 21 May 2007 05:16:34 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: that page count overflow thing
Message-ID: <20070521121634.GM19966@holomorphy.com>
References: <20070519.152649.102577495.davem@davemloft.net> <20070521113747.GK19966@holomorphy.com> <20070521.045031.45180781.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521.045031.45180781.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: William Lee Irwin III <wli@holomorphy.com>
> Date: Mon, 21 May 2007 04:37:47 -0700
>> This could be awkward with allocation requirements. How about an
>> open-addressed hash table? It can be made so large as to never
>> need to expand in advance with a very small constant factor space
>> overhead.

On Mon, May 21, 2007 at 04:50:31AM -0700, David Miller wrote:
> I was just thinking of a normal hash table with entries that
> looked simply like:
> struct page_big_count_hash {
>        struct page_big_count_hash *next; /* or list_head or hlist_head etc. */
>        struct page *key;
>        atomic64_t count;
> };

I guess that could work with a static pool of hashtable elements like
mm/highmem.c uses, but the pointer links seem like such a waste of space.
It'll work, so no big deal. Maybe converting mm/highmem.c to hashing by
open addressing would be a simplification. Not worth disturbing working
code, though.


-- wli
