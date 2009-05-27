Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbZE0Rc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbZE0Rc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZE0Rcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:32:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbZE0Rct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:32:49 -0400
Message-ID: <4A1D7935.10000@redhat.com>
Date: Wed, 27 May 2009 13:32:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [rfc][patch] swap: virtual swap readahead
References: <1243436746-2698-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1243436746-2698-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:

> This patch makes swap-in base its readaround window on the virtual
> proximity of pages in the faulting VMA, as an indicator for pages
> needed in the near future, while still taking physical locality of
> swap slots into account.
> 
> This has the advantage of reading in big batches when the LRU order
> matches the swap slot order while automatically throttling readahead
> when the system is thrashing and swap slots are no longer nicely
> grouped by LRU order.

This is a nice simple implementation of proper
swapin readahead.  The performance results are
surprisingly good.

I suspect the performance oddity you see with
single-process qsbench might be due to qsbench
having a weird access pattern that just happens
to benefit from getting pages back into memory
in LRU order - not something that I expect to
be common, so not a concern.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Rik van Riel <riel@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>
