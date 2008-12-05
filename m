Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYLEIH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYLEIH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYLEIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:07:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53245
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYLEIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:07:16 -0500
Date: Fri, 05 Dec 2008 00:07:16 -0800 (PST)
Message-Id: <20081205.000716.40104924.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <1228464216.18899.18.camel@twins>
References: <1228461385.18899.13.camel@twins>
	<18744.57057.243817.407691@cargo.ozlabs.ibm.com>
	<1228464216.18899.18.camel@twins>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 05 Dec 2008 09:03:36 +0100

> On Fri, 2008-12-05 at 18:57 +1100, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > So, while most people would not consider two consecutive read() ops to
> > > be close or near the same time, due to preemption and such, that is
> > > taken away by the fact that the counters are task local time based - so
> > > preemption doesn't affect thing. Right?
> > 
> > I'm sorry, I don't follow the argument here.  What do you mean by
> > "task local time based"?
> 
> time only flows when the task is running.

These things aren't measuring time, or even just cycles, they
are measuring things like L2 cache misses, cpu cycles, and
other similar kinds of events.

So these counters are going to measure all of the damn crap
assosciated with doing the read() call as well as the real work
the task does.

That's not useful to people.
