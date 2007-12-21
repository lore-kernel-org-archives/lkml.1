Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXLUM1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXLUM1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXLUM1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:27:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbXLUM07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:26:59 -0500
Date: Fri, 21 Dec 2007 13:26:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071221122628.GA18002@elte.hu>
References: <1197049846.1645.68.camel@localhost.localdomain> <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221120908.GA15926@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Christoph Lameter <clameter@sgi.com> wrote:
> 
> > Hmmmm... Some tests here on an 8p 8G machine:
> 
> > In an extreme case (boot with slub_min_order=9 to get huge page sized 
> > slabs) SLUB can win against SLAB:
> > 
> > N=10 Time: 0.338	Minimally faster
> > N=20 Time: 0.560	10% faster
> > N=50 Time: 1.353	15% faster
> 
> what's up with this regression? There's been absolutely no activity 
> about it in the last 8 days: upstream still regresses, -mm still 
> regresses and there are no patches posted for testing.
> 
> being able to utilize order-0 pages was supposed to be one of the big 
> plusses of SLUB, so booting with _2MB_ sized slabs cannot be seriously 
> the "fix", right?

and this is not the only regression:

    http://lkml.org/lkml/2007/10/4/290

_6%_ TPC-C regression. That's _a lot_ in TPC-C terms.

and just like in this case there were very clear profiles posted. I 
proffer, reading back the whole thread, that if you fix hackbench you 
have fixed TPC-C as well.

So i believe you should either send some sensible fixes _NOW_, or admit 
that the "no queues" NIH nonsense of SLUB doesnt work and do an edible, 
incremental patchset against SLAB to bring in the debuggability features 
of SLUB without killing SLAB's performance. (And fix the NUMA alien 
cache problem along the lines suggested before - perhaps initially by 
making 'noaliencache' the default bootup option.) And we obviously must 
revert the default in 2.6.24 to SLAB as well.

	Ingo
