Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXDUI31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXDUI31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030339AbXDUI31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:29:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030358AbXDUI30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:29:26 -0400
Date: Sat, 21 Apr 2007 01:28:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] introduce HIGH_ORDER delineating easily reclaimable
 orders
Message-Id: <20070421012843.f5a814eb.akpm@linux-foundation.org>
In-Reply-To: <cc3c22ba296c3d75cd7bd66747fb08c0@pinky>
References: <exportbomb.1177081388@pinky>
	<cc3c22ba296c3d75cd7bd66747fb08c0@pinky>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 16:04:36 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> The memory allocator treats lower order (order <= 3) and higher order
> (order >= 4) allocations in slightly different ways.  As lower orders
> are much more likely to be available and also more likely to be
> simply reclaimed it is deemed reasonable to wait longer for those.
> Lumpy reclaim also changes behaviour at this same boundary, more
> agressivly targetting pages in reclaim at higher order.
> 
> This patch removes all these magical numbers and replaces with
> with a constant HIGH_ORDER.

oh, there we go.

It would have been better to have patched page_alloc.c independently, then
to have used HIGH_ORDER in "lumpy: increase pressure at the end of the inactive
list".

The name HIGH_ORDER is a bit squidgy.  I'm not sure what would be better though.
PAGE_ALLOC_CLUSTER_MAX?

It'd be interesting to turn this into a runtime tunable, perhaps.
