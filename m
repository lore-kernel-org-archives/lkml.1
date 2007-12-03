Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXLCIqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXLCIqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXLCIqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:46:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXLCIqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:46:16 -0500
Date: Mon, 3 Dec 2007 09:45:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071203084557.GA13156@elte.hu>
References: <1196155985.25646.31.camel@ymzhang> <200711301429.15664.nickpiggin@yahoo.com.au> <20071130100845.GB2201@elte.hu> <200712031527.57129.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712031527.57129.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 30 November 2007 21:08, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > Haven't we been asking JVMs to use futexes or posix locking for years
> > > and years now? [...]
> >
> > i'm curious, with what JVM was it tested and where's the source so i 
> > can fix their locking for them? Can the problem be reproduced with:
> 
> Sure, but why shouldn't the compat behaviour be the default, and the 
> sysctl go away?
> 
> It makes older JVMs work better, it is slightly closer to the old 
> behaviour, and it is arguably a less surprising result.

as far as desktop apps such as firefox goes, the exact opposite is true. 
We had two choices basically: either a "more agressive" yield than 
before or a "less agressive" yield. Desktop apps were reported to hurt 
from a "more agressive" yield (firefox for example gets some pretty bad 
delays), so we defaulted to the less agressive method. (and we defaulted 
to that in v2.6.23 already) Really, in this sense volanomark is another 
test like dbench - we care about it but not unconditionally and in this 
case it's a really silly API use that is at the center of the problem. 
Talking about the default alone will not bring us forward, but we can 
certainly add helpers to identify SCHED_OTHER::yield tasks - a once per 
bootup warning perhaps?

	Ingo
