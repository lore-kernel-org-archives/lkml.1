Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYLJFJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYLJFJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYLJFJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:09:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:55153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYLJFJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:09:40 -0500
Date: Wed, 10 Dec 2008 06:09:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-ID: <20081210050938.GF8434@wotan.suse.de>
References: <20081129195357.813D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081208205842.53F8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081208220016.53FB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <493D82A6.9070104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493D82A6.9070104@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 03:25:10PM -0500, Rik van Riel wrote:
> KOSAKI Motohiro wrote:
> 
> >+	for (o = order; o < MAX_ORDER; o++) {
> >+		if (z->free_area[o].nr_free)
> >+			return 1;
> 
> Since page breakup and coalescing always manipulates .nr_free,
> I wonder if it would make sense to pack the nr_free variables
> in their own cache line(s), so we have fewer cache misses when
> going through zone_watermark_ok() ?

For order-0 allocations, they should not be touched at all. For
higher order allocations in performance critical paths, we should
try to fix those to use order-0 ;)

