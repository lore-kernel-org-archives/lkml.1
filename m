Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYFFOU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYFFOU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYFFOUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:20:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41892 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbYFFOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:20:14 -0400
Subject: Re: [patch 3/7] mm: speculative page references
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080605094825.699347000@nick.local0.net>
References: <20080605094300.295184000@nick.local0.net>
	 <20080605094825.699347000@nick.local0.net>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 16:20:04 +0200
Message-Id: <1212762004.23439.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 19:43 +1000, npiggin@suse.de wrote:
> plain text document attachment (mm-speculative-get_page-hugh.patch)

> +static inline int page_cache_get_speculative(struct page *page)
> +{
> +	VM_BUG_ON(in_interrupt());
> +
> +#ifndef CONFIG_SMP
> +# ifdef CONFIG_PREEMPT
> +	VM_BUG_ON(!in_atomic());
> +# endif
> +	/*
> +	 * Preempt must be disabled here - we rely on rcu_read_lock doing
> +	 * this for us.

Preemptible RCU is already in the tree, so I guess you'll have to
explcitly disable preemption if you require it.


