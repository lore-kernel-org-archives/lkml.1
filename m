Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbXLCJhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbXLCJhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXLCJhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:37:43 -0500
Received: from mga10.intel.com ([192.55.52.92]:13272 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbXLCJhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,243,1194249600"; 
   d="scan'208";a="221944644"
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200712032017.19661.nickpiggin@yahoo.com.au>
References: <1196155985.25646.31.camel@ymzhang>
	 <200712031527.57129.nickpiggin@yahoo.com.au>
	 <20071203084557.GA13156@elte.hu>
	 <200712032017.19661.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Mon, 03 Dec 2007 17:35:07 +0800
Message-Id: <1196674507.25646.134.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 20:17 +1100, Nick Piggin wrote:
> On Monday 03 December 2007 19:45, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Friday 30 November 2007 21:08, Ingo Molnar wrote:
> > > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > > Haven't we been asking JVMs to use futexes or posix locking for years
> > > > > and years now? [...]
> > > >
> > > > i'm curious, with what JVM was it tested and where's the source so i
> > > > can fix their locking for them? Can the problem be reproduced with:
> > >
> > > Sure, but why shouldn't the compat behaviour be the default, and the
> > > sysctl go away?
> > >
> > > It makes older JVMs work better, it is slightly closer to the old
> > > behaviour, and it is arguably a less surprising result.
> >
> > as far as desktop apps such as firefox goes, the exact opposite is true.
> > We had two choices basically: either a "more agressive" yield than
> > before or a "less agressive" yield. Desktop apps were reported to hurt
> > from a "more agressive" yield (firefox for example gets some pretty bad
> > delays), so we defaulted to the less agressive method. (and we defaulted
> > to that in v2.6.23 already)
> 
> Yeah, I doubt the 2.6.23 scheduler will be usable for distros though...
> 
> 
> > Really, in this sense volanomark is another 
> > test like dbench - we care about it but not unconditionally and in this
> > case it's a really silly API use that is at the center of the problem.
> 
> Sure, but do you whether _real_ java server applications are OK?
I did a simple check of openjvm source codes and garbage collecter calls
Thread.yield. It really has much impact on both Jrockit and openJVM although
the regression percentage is different.
