Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZFYEmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZFYEmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZFYElx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:41:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:44665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZFYElw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:41:52 -0400
Date: Thu, 25 Jun 2009 06:41:55 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or suspending
Message-ID: <20090625044155.GC23949@wotan.suse.de>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI> <20090612091002.GA32052@elte.hu> <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com> <20090612100756.GA25185@elte.hu> <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com> <1244805060.7172.126.camel@pasglop> <1244806440.30512.51.camel@penberg-laptop> <20090612083005.56336219.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612083005.56336219.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 08:30:05AM -0700, Andrew Morton wrote:
> On Fri, 12 Jun 2009 14:34:00 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > +static gfp_t slab_gfp_mask __read_mostly = __GFP_BITS_MASK & ~__GFP_WAIT;
> 
> It'd be safer and saner to disable __GFP_FS and __GFP_IO as well. 
> Having either of those flags set without __GFP_WAIT is a somewhat
> self-contradictory thing and there might be code under reclaim which
> assumes that __GFP_FS|__GFP_IO implies __GFP_WAIT.
> 
> <wonders why mempool_alloc() didn't clear __GFP_FS>

Maybe we never get there if __GFP_WAIT is clear? It would be neater
if it did clear __GFP_FS, though...

