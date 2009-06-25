Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZFYJ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZFYJ5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZFYJ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:57:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:36449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZFYJ5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:57:30 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
 suspending
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20090625043432.GA23949@wotan.suse.de>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090619145913.GA1389@ucw.cz> <1245450449.16880.10.camel@pasglop>
	 <20090619232336.GA2442@elf.ucw.cz> <1245455409.16880.15.camel@pasglop>
	 <20090620002817.GA2524@elf.ucw.cz> <1245463809.16880.18.camel@pasglop>
	 <20090621061847.GB1474@ucw.cz> <1245576665.16880.24.camel@pasglop>
	 <20090625043432.GA23949@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 19:56:33 +1000
Message-Id: <1245923793.22312.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe so. Masking off __GFP_WAIT up in slab and page allocator
> isn't really needed though (or necessarily a good idea to throw
> out that information far from where it is used).
> 
> Checking for suspend active and avoiding writeout from reclaim
> for example might be a better idea.

Ah ok. Yes, I agree. I'm not familiar with those code path and
so masking gfp here sounded like the easier solution but you may well be
right here :-)
 
> > So yes, just applying the mask would help, but wouldn't completely fix
> > it unless we also find a way to synchronize.
> 
> You could potentially use srcu or something like that in page
> reclaim in order to have a way to be able to kick everyone
> out. page reclaim entry/exit from the page allocator isn't such
> a fastpath though, so even a simple mutex or something may be
> possible.

Ok. Well, I'll leave that to the suspend/resume folks for now, as I'm
way too busy at the moment to give that a serious look, but thanks for
the pointer.

Cheers,
Ben.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

