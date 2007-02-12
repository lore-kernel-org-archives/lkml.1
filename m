Return-Path: <linux-kernel-owner+w=401wt.eu-S964843AbXBLKff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbXBLKff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964849AbXBLKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:35:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:58953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbXBLKfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:35:34 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to x86_64
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
	<11712214703522-git-send-email-mathieu.desnoyers@polymtl.ca>
From: Andi Kleen <ak@suse.de>
Date: 12 Feb 2007 12:35:47 +0100
In-Reply-To: <11712214703522-git-send-email-mathieu.desnoyers@polymtl.ca>
Message-ID: <p737iunhalo.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
>  
>  /**
> @@ -402,7 +405,7 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
>   */
>  #define atomic_add_unless(v, a, u)				\
>  ({								\
> -	int c, old;						\
> +	__typeof__((v)->counter) c, old;			\

This change seems useless. Please drop.

In general you should enforce atomic_t vs atomic64_t types on x86, otherwise
people will write code that won't compile on other architectures 
that have truly different implementations.

I would suggest using inlines.

-Andi
