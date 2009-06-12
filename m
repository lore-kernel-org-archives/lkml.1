Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbZFLJKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbZFLJKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZFLJKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:10:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbZFLJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:10:11 -0400
Date: Fri, 12 Jun 2009 11:10:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
	suspending
Message-ID: <20090612091002.GA32052@elte.hu>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> index 3964d3c..6387c19 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1548,6 +1548,20 @@ new_slab:
>  		goto load_freelist;
>  	}
>  
> +	/*
> +	 * Lets not wait if we're booting up or suspending even if the user
> +	 * asks for it.
> +	 */
> +	if (system_state != SYSTEM_RUNNING)
> +		gfpflags &= ~__GFP_WAIT;

Hiding that bug like that is not particularly clean IMO. We should 
not let system_state hacks spread like that.

We emit a debug warning but dont crash, so all should be fine and 
the culprits can then be fixed, right?

	Ingo
