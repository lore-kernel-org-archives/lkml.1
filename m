Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYLDJJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYLDJJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYLDJJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:09:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbYLDJJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:09:16 -0500
Date: Thu, 4 Dec 2008 10:09:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
       Dan =?iso-8859-1?B?Tm/p?= <dpn@isomerica.net>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
Message-ID: <20081204090900.GI32594@elte.hu>
References: <20081125064357.5a4f1420@tuna> <20081126072625.GH6291@disturbed> <1227711779.4454.184.camel@twins> <20081126213454.GI6291@disturbed> <1227773115.4454.1208.camel@twins> <1228377618.19569.949.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228377618.19569.949.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2008-11-27 at 09:05 +0100, Peter Zijlstra wrote:
> > On Thu, 2008-11-27 at 08:34 +1100, Dave Chinner wrote:
> > > Is changing the lock class dynamically possible/allowed?
> > 
> > Currently, no, but I'll see what I can do, it requires a bit of trickery
> > to make that happen..
> > 
> > I'll let you know when I've sorted that out.
> 
> Ok, that wasn't hard at all..
> 
> Dave, Christoph, can you have a play with this and post this patch along
> with a potential user - I think it best if we don't merge this without
> at least one user in tree :-)
> 
> ---
> Subject: lockdep: change a held lock's class
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Dec 04 08:34:56 CET 2008
> 
> Impact: introduce new lockdep API
> 
> Allow to change a held lock's class. Basically the same as the existing
> code to change a subclass therefore reuse all that.
> 
> The XFS code will be able to use this to annotate their inode locking.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/lockdep.h |   12 ++++++++++--
>  kernel/lockdep.c        |   24 +++++++++---------------
>  2 files changed, 19 insertions(+), 17 deletions(-)

i've applied it to tip/core/locking, but it's just a new API without 
really disturbing the current code - but it would be nice to know whether 
it solves the XFS annotation problems.

	Ingo
