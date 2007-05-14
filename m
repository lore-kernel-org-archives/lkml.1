Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbXENPv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbXENPv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXENPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:51:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34479 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077AbXENPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:51:50 -0400
Date: Mon, 14 May 2007 08:51:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/5] mm: slab allocation fairness
In-Reply-To: <20070514133212.399158218@chello.nl>
Message-ID: <Pine.LNX.4.64.0705140850540.10442@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> <20070514133212.399158218@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> @@ -3182,13 +3192,13 @@ static inline void *____cache_alloc(stru
>  	check_irq_off();
>  
>  	ac = cpu_cache_get(cachep);
> -	if (likely(ac->avail)) {
> +	if (likely(ac->avail) && !slab_insufficient_rank(cachep, rank)) {
>  		STATS_INC_ALLOCHIT(cachep);
>  		ac->touched = 1;

Hotpath modifications.

