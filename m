Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYLEIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYLEIR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYLEIRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:17:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbYLEIRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:17:17 -0500
Date: Fri, 05 Dec 2008 00:17:17 -0800 (PST)
Message-Id: <20081205.001717.216522767.davem@davemloft.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205081137.GB2030@elte.hu>
References: <1228464216.18899.18.camel@twins>
	<20081205.000716.40104924.davem@davemloft.net>
	<20081205081137.GB2030@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 09:11:37 +0100

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Fri, 05 Dec 2008 09:03:36 +0100
> > 
> > > On Fri, 2008-12-05 at 18:57 +1100, Paul Mackerras wrote:
> > > > Peter Zijlstra writes:
> > > > 
> > > > > So, while most people would not consider two consecutive read() ops to
> > > > > be close or near the same time, due to preemption and such, that is
> > > > > taken away by the fact that the counters are task local time based - so
> > > > > preemption doesn't affect thing. Right?
> > > > 
> > > > I'm sorry, I don't follow the argument here.  What do you mean by
> > > > "task local time based"?
> > > 
> > > time only flows when the task is running.
> > 
> > These things aren't measuring time, or even just cycles, they are 
> > measuring things like L2 cache misses, cpu cycles, and other similar 
> > kinds of events.
> > 
> > So these counters are going to measure all of the damn crap assosciated 
> > with doing the read() call as well as the real work the task does.
> 
> that's wrong, look at the example we posted - see it pasted below.

It's still too simple to be useful.

There are so many aspects other than the immediate PC that monitoring
tasks want to inspect when a counter overflows.
