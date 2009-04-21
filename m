Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZDUIKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZDUIKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZDUII0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:08:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51948 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZDUIIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:08:24 -0400
Subject: Re: [PATCH 25/25] Use a pre-calculated value instead of
 num_online_nodes() in fast paths
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-26-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-26-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 11:08:20 +0300
Message-Id: <1240301300.771.58.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:20 +0100, Mel Gorman wrote:
> diff --git a/mm/slab.c b/mm/slab.c
> index 1c680e8..41d1343 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3579,7 +3579,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
>  	 * variable to skip the call, which is mostly likely to be present in
>  	 * the cache.
>  	 */
> -	if (numa_platform && cache_free_alien(cachep, objp))
> +	if (numa_platform > 1 && cache_free_alien(cachep, objp))
>  		return;

This doesn't look right. I assume you meant "nr_online_nodes > 1" here?
If so, please go ahead and remove "numa_platform" completely.


