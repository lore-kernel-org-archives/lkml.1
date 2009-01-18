Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbZARP2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbZARP2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762902AbZARP2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:28:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:56492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759726AbZARP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:28:20 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232287718.12958.8.camel@marge.simson.net>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232287718.12958.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 16:28:11 +0100
Message-Id: <1232292491.5204.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 15:08 +0100, Mike Galbraith wrote:
> On Sat, 2009-01-17 at 13:00 +0100, Peter Zijlstra wrote:
> > On Sat, 2009-01-17 at 11:34 +0100, Mike Galbraith wrote:
> > > > Right, how about we flip the 'initial' case in place_entity() for !
> > > > nr_exclusive wakeups.
> > > 
> > > Wouldn't that be more drastic than sleep denial?
> > 
> > Strictly speaking that DEBIT thing is valid for each wakeup, IIRC we
> > restricted it to clone() only because that was where we could actually
> > observe these latency spikes using a fork-bomb.
> > 
> > This reduces the latency hits to around 400ms, which is about right for
> > the given load.
> 
> Disregarding the startup landmine for the moment, maybe we should put a
> buddy slice knob in the user's hands, so they can tune latency, along
> with a full on/off switch for those who care not one whit about
> scalability.

I'm not particularly fond of that idea because it only helps for this
particular workload where any one task isn't actually running for very
long.

If however your workload consists of cpu hogs, each will run for the
full wakeup preemption 'slice' you now see these buddy pairs do.

Also, buddies really work for throughput, so I don't particularly fancy
weakening them below what a normal cpu-hog can already do.

