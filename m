Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXENWBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXENWBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXENWAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:00:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909AbXENWAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:00:50 -0400
Date: Mon, 14 May 2007 15:00:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ck@vds.kolivas.org
Subject: Re: [PATCH] mm: swap prefetch more improvements
Message-Id: <20070514150032.d3ef6bb1.akpm@linux-foundation.org>
In-Reply-To: <200705141050.55038.kernel@kolivas.org>
References: <200705141050.55038.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 10:50:54 +1000
Con Kolivas <kernel@kolivas.org> wrote:

> akpm, please queue on top of "mm: swap prefetch improvements"
> 
> ---
> Failed radix_tree_insert wasn't being handled leaving stale kmem.
> 
> The list should be iterated over in the reverse order when prefetching.
> 
> Make the yield within kprefetchd stronger through the use of cond_resched.

hm.

> 
> -		might_sleep();
> -		if (!prefetch_suitable())
> +		/* Yield to anything else running */
> +		if (cond_resched() || !prefetch_suitable())
>  			goto out_unlocked;

So if cond_resched() happened to schedule away, we terminate this
swap-tricking attempt.  It's not possible to determine the reasons for this
from the code or from the changelog (==bad).

How come?

