Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZABJXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZABJXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZABJXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:23:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZABJXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:23:13 -0500
Date: Fri, 2 Jan 2009 10:22:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       William Irwin <wli@holomorphy.com>
Subject: Re: [patch 2/3] mm: hugetlb -- get rid of redundant if operation
Message-ID: <20090102092221.GA1975@elte.hu>
References: <20090102082717.810810508@gmail.com>> <495dd169.0405560a.0ebf.ffff938c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495dd169.0405560a.0ebf.ffff938c@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Cc:-ed.

patch looks correct to me.

Reviewed-by: Ingo Molnar <mingo@elte.hu>

	Ingo

* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> At this point we already know that 'addr' is not NULL
> so get rid of redundant 'if'. Probably gcc eliminate it
> by optimization pass.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: William Irwin <wli@holomorphy.com>
> ---
>  mm/hugetlb.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6.git/mm/hugetlb.c
> ===================================================================
> --- linux-2.6.git.orig/mm/hugetlb.c
> +++ linux-2.6.git/mm/hugetlb.c
> @@ -991,8 +991,7 @@ __attribute__((weak)) int alloc_bootmem_
>  			 * puts them into the mem_map).
>  			 */
>  			m = addr;
> -			if (m)
> -				goto found;
> +			goto found;
>  		}
>  		hstate_next_node(h);
>  		nr_nodes--;
> 
> -- 
