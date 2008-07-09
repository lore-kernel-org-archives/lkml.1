Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYGIMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYGIMOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYGIMOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:14:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYGIMOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:14:09 -0400
Date: Wed, 9 Jul 2008 14:13:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant
	that takes printk arguments
Message-ID: <20080709121353.GC19060@elte.hu>
References: <20080708093800.274504ba@infradead.org> <20080709101348.GA30005@elte.hu> <20080709041956.0c52b2d9.akpm@linux-foundation.org> <20080709113703.GA11191@elte.hu> <20080709044613.2546034d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709044613.2546034d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Note that this situation is special: this is a patchset that has 
> > virtually no functionality side-effects, and hence can be done 100% 
> > correctly, i thought the atomic step was the right approach.
> > 
> > For anything semantically meaningful i too would do the spread-out 
> > gradual approach (and i'm presently doing that for a number of 
> > topics).
> > 
> > But if you'd like to do this the spread-out way then sure, and i 
> > will drop this tree. ( if you do that then please import the commits 
> > from tip/core/warn-API, i fixed a couple of of typos in the commit 
> > messages and did some merging and extensions as well. The tree also 
> > passed a fair amount of testing meanwhile as well. )
> > 
> > Anyway, your call.
> 
> Well I haven't got onto processing these patches in detail yet.  An 
> open questions is why the damn thing was resubmitted from scratch when 
> I've already merged it and fixed various rejects and had to fix 
> several bugs in it.  Do those rejects need to be re-fixed?  Were my 
> bugfixes folded back? I haven't looked yet.  I'll need to generate the 
> incremental diff and see what was done.
> 
> But if what you've merged was against mainline then it isn't terribly 
> useful.

i cross-ported it from the linux-next base to -git base and the conflict 
fallout was minimal, well below 5% or so. I.e. the patches change 
long-existent warnings that have not changed in linux-next either.

About 30% of the changes in this patchset affect subsystems that i 
co-maintain, still tip/core/warn-API did a pure, conflict-free git-merge 
when it was applied ontop of all these subsystem trees:

 commit 99eb83efbe2e3c12d26be22a032495ccddb36a2c
 Merge: de67579... c2e0195...
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Wed Jul 9 12:14:48 2008 +0200

     Merge branch 'core/warn-API'

Hence my suggestion that this should be maintained and forward ported to 
the end of the merge window, in a separate, standalone tree that is -git 
based.

Anyway, no strong feelings, it's your call.

	Ingo
